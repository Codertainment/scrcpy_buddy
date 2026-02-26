# Search Feature for Scrcpy Config Options

Search across all available scrcpy CLI arguments from the app bar, navigate to the matching category screen, and highlight the selected option.

## Proposed Changes

### Search Model

#### [NEW] [search_result.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/application/model/search_result.dart)

A lightweight model holding data for each search result:

```dart
class SearchResult {
  final String label;        // e.g. "video.noVideo"
  final String title;        // translated title text
  final String description;  // translated description text
  final String argument;     // CLI arg, e.g. "--no-video"
  final String category;     // e.g. "video" — extracted from label.split('.').first
  final String route;        // e.g. "/scrcpyConfig.video" — resolved from category
}
```

A static helper `categoryToRoute` map will resolve category names to `AppRoute` constants.

---

### Search Bloc

Following the existing Bloc pattern (`DevicesBloc`): sealed event/state classes, `Equatable`, `part` files.

#### [NEW] [search_bloc.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/search/bloc/search_bloc.dart)

```
Events:
  - InitializeSearch       → builds the full searchable list from List<ScrcpyCliArgument> + translations
  - UpdateSearchQuery(q)   → filters the list, emits new results
  - ClearSearch            → resets query and results

States:
  - SearchInitial
  - SearchLoaded(query, results, allSearchItems)
```

- **`InitializeSearch`** iterates through all `ScrcpyCliArgument` instances (from `context.read<List<ScrcpyCliArgument>>()`), resolves their translated title and description via the translation keys (`config.<label>.title`, `config.<label>.description`), and builds `List<SearchResult>`.
- **`UpdateSearchQuery`** filters the pre-built list with case-insensitive matching on `title`, `description`, and `argument`.
- **`ClearSearch`** resets to empty results with an empty query.

#### [NEW] [search_event.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/search/bloc/search_event.dart)
#### [NEW] [search_state.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/search/bloc/search_state.dart)

---

### Search Widget

#### [NEW] [search_widget.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/search/search_widget.dart)

A self-contained stateful widget using fluent_ui's `AutoSuggestBox`:

- On text change → dispatches `UpdateSearchQuery` to `SearchBloc`
- Uses `BlocBuilder` to build suggestion items from `SearchLoaded.results`
- On suggestion selected → navigates via `context.push(result.route, extra: result.label)` and dispatches `ClearSearch`
- Each suggestion item displays: **title** (bold), description (secondary), and CLI argument (monospace)

---

### Home Screen Integration

#### [MODIFY] [home_screen.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/home/home_screen.dart)

- Add `SearchWidget` to the `NavigationAppBar.actions` row, before `ProfileButton`
- The `SearchBloc` will be provided from `main.dart`, so no Bloc creation needed here

---

### Bloc Registration

#### [MODIFY] [main.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/main.dart)

- Add `BlocProvider(create: (_) => SearchBloc(_argsInstances))` to the `MultiBlocProvider` list

---

### Highlight Architecture (InheritedWidget — zero category screen changes)

Instead of modifying all 9 category screens, the highlight label is provided through the widget tree via an `InheritedWidget`. `ConfigItem` reads it and self-resolves highlighting.

#### [NEW] [highlight_provider.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/scrcpy_config/widgets/highlight_provider.dart)

An `InheritedWidget` that carries an optional `highlightLabel` down the tree:

```dart
class HighlightProvider extends InheritedWidget {
  final String? highlightLabel;
  static String? of(BuildContext context) => ...;
}
```

#### [MODIFY] [routes.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/routes.dart)

- Each scrcpy config route's builder wraps its screen widget with `HighlightProvider`:

```dart
GoRoute(
  path: AppRoute.video,
  builder: (_, state) => HighlightProvider(
    highlightLabel: state.extra as String?,
    child: const VideoScreen(),
  ),
),
```

Category screen constructors remain unchanged (`const VideoScreen()` etc.).

#### [MODIFY] [config_item.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/scrcpy_config/widgets/config_item.dart)

- Reads `HighlightProvider.of(context)` and compares with `cliArgument.label`
- Passes `isHighlighted: true` to `ConfigItemBase` when matched

#### [MODIFY] [config_item_base.dart](file:///home/shripal17/Projects/scrcpy_buddy/lib/presentation/scrcpy_config/widgets/config_item_base.dart)

- Add optional `bool isHighlighted` parameter (default `false`)
- When `true`, apply a highlight background (e.g. `accentColor.withOpacity(0.1)`) that fades after ~2s
- Auto-scroll into view using `Scrollable.ensureVisible` on a post-frame callback

> [!TIP]
> This approach means **no changes to any of the 9 category screens**. The highlight flows through `HighlightProvider` → `ConfigItem` → `ConfigItemBase` automatically.

---

### Translations

#### [MODIFY] [en.json](file:///home/shripal17/Projects/scrcpy_buddy/assets/i18n/en.json)

Add a `"search"` section:
```json
"search": {
  "placeholder": "Search options...",
  "noResults": "No results found"
}
```

---

## Verification Plan

### Automated Tests

No existing automated widget/integration tests cover the Bloc or search flow. The existing tests in `test/` cover `description_parameterized_test` and `service/` only.

> [!NOTE]
> Unit tests for `SearchBloc` can be added if desired, but since the Bloc logic is essentially string filtering, and existing Blocs in the project don't have corresponding unit tests either, I'll follow the project convention and skip them unless you request otherwise.

### Manual Verification

1. **Build & run**: `flutter run -d linux` — app should launch without errors
2. **Search visible**: Verify the search box appears in the top app bar area
3. **Type a query**: Type a partial option name (e.g. "codec") — should show matching results from both Audio and Video categories
4. **CLI arg search**: Type a CLI argument (e.g. "--no-video") — should show the matching result
5. **Click a result**: Click "Disable video" — should navigate to the Video screen with that config item highlighted
6. **Highlight fades**: The highlight should visually stand out and then fade after ~2 seconds
7. **Clear search**: After navigating, the search box should be cleared
