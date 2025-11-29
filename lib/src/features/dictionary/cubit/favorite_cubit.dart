import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/database/database_helper.dart';
import 'package:arabist_v2_app/src/features/dictionary/data/models/word_model.dart';

class FavoritesCubit extends Cubit<List<WordModel>> {
  final DatabaseHelper _databaseHelper;

  FavoritesCubit(this._databaseHelper) : super([]);

  Future<void> loadFavorites() async {
    try {
      final favorites = await _databaseHelper.loadFavorites();
      emit(favorites);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> refresh() async {
    await loadFavorites();
  }
}