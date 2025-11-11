import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final DictionaryRepositoryImpl repository;

  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await repository.search(query);
      if (results.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(results));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> toggleFavorite(WordModel word) async {
    final updated = !word.isChosen;
    await repository.toggleFavorite(word.id, updated);

    if (state is SearchLoaded) {
      final current = (state as SearchLoaded).words;
      final updatedList = current
          .map((w) => w.id == word.id ? w.copyWith(isChosen: updated) : w)
          .toList();
      emit(SearchLoaded(updatedList));
    }
  }
}
