import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/application/model/search_result.dart';

part 'search_event.dart';
part 'search_state.dart';

typedef _Emitter = Emitter<SearchState>;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._allArgs) : super(const SearchInitial()) {
    on<InitializeSearch>(_onInitialize);
    on<UpdateSearchQuery>(_onUpdateQuery);
    on<ClearSearch>(_onClear);
  }

  final List<ScrcpyCliArgument> _allArgs;
  List<SearchResult> _allSearchItems = [];

  void _onInitialize(InitializeSearch event, _Emitter emit) {
    _allSearchItems = _allArgs
        .map((arg) {
          final category = arg.label.split('.').first;
          final route = SearchResult.routeForCategory(category);
          if (route == null) return null;

          final title = event.translate('config.${arg.label}.title');
          final description = event.translate('config.${arg.label}.description');

          return SearchResult(
            label: arg.label,
            title: title,
            description: description,
            argument: arg.argument,
            category: category,
            route: route,
          );
        })
        .whereType<SearchResult>()
        .toList(growable: false);

    emit(SearchLoaded(query: '', results: const []));
  }

  void _onUpdateQuery(UpdateSearchQuery event, _Emitter emit) {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchLoaded(query: '', results: const []));
      return;
    }

    final results = _allSearchItems.where((item) => item.matches(query)).toList(growable: false);
    emit(SearchLoaded(query: query, results: results));
  }

  void _onClear(ClearSearch event, _Emitter emit) {
    emit(SearchLoaded(query: '', results: const []));
  }
}
