part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  const SearchInitial();

  @override
  List<Object?> get props => [];
}

final class SearchLoaded extends SearchState {
  final String query;
  final List<SearchResult> results;

  const SearchLoaded({required this.query, required this.results});

  @override
  List<Object?> get props => [query, results];
}
