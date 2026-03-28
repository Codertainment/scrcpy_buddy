import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/model/search_result.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/search/bloc/search_bloc.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends AppModuleState<SearchWidget> {
  late final _searchBloc = context.read<SearchBloc>();
  final _controller = TextEditingController();
  bool _initialized = false;

  @override
  String get module => 'home.search';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _searchBloc.add(InitializeSearch((key) => context.translatedText(key: key)));
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
    context.go("/scrcpyConfig.${result.category}", extra: result.label);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final items = state is SearchLoaded ? state.results : <SearchResult>[];
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: AutoSuggestBox<SearchResult>(
              controller: _controller,
              placeholder: translatedText(key: 'placeholder'),
              items: items
                  .map(
                    (result) => AutoSuggestBoxItem<SearchResult>(
                      value: result,
                      label:
                          "[${context.translatedText(key: "home.navigation.scrcpyConfig.${result.category}")}] ${result.title}",
                    ),
                  )
                  .toList(growable: false),
              onChanged: (text, reason) {
                switch (reason) {
                  case TextChangedReason.suggestionChosen:
                    _controller.clear();
                    break;
                  case TextChangedReason.userInput:
                    _searchBloc.add(UpdateSearchQuery(text));
                    break;
                  case TextChangedReason.cleared:
                    _searchBloc.add(ClearSearch());
                    break;
                }
              },
              onSelected: (item) {
                if (item.value != null) {
                  _onSelected(item.value!);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
