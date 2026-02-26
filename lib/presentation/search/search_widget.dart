import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/model/search_result.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/search/bloc/search_bloc.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final _searchBloc = context.read<SearchBloc>();
  final _controller = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _searchBloc.add(InitializeSearch((key) => FlutterI18n.translate(context, key)));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelected(SearchResult result) {
    _controller.clear();
    _searchBloc.add(ClearSearch());
    context.go(result.route, extra: result.label);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final items = state is SearchLoaded ? state.results : <SearchResult>[];
        return SizedBox(
          width: 280,
          child: AutoSuggestBox<SearchResult>(
            controller: _controller,
            placeholder: FlutterI18n.translate(context, 'search.placeholder'),
            items: items
                .map(
                  (result) => AutoSuggestBoxItem<SearchResult>(
                    value: result,
                    label: result.title,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(result.title, style: context.typography.bodyStrong),
                          const SizedBox(height: 2),
                          Text(
                            result.description,
                            style: context.typography.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            result.argument,
                            style: context.typography.caption?.copyWith(
                              fontFamily: 'monospace',
                              color: context.theme.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
            onChanged: (text, reason) {
              if (reason == TextChangedReason.userInput) {
                _searchBloc.add(UpdateSearchQuery(text));
              }
            },
            onSelected: (item) {
              if (item.value != null) {
                _onSelected(item.value!);
              }
            },
            noResultsFoundBuilder: (context) => state is SearchLoaded && state.query.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(FlutterI18n.translate(context, 'search.noResults'), style: context.typography.caption),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
