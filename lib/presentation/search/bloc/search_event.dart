part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class InitializeSearch extends SearchEvent {
  final String Function(String key) translate;

  const InitializeSearch(this.translate);

  @override
  List<Object> get props => [];
}

final class UpdateSearchQuery extends SearchEvent {
  final String query;

  const UpdateSearchQuery(this.query);

  @override
  List<Object> get props => [query];
}

final class ClearSearch extends SearchEvent {}
