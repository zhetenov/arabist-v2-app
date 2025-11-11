part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchEmpty extends SearchState {}

class SearchLoaded extends SearchState {
  final List<WordModel> words;
  SearchLoaded(this.words);

  @override
  List<Object?> get props => [words];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
