# Search Feature Implementation

## Planning
- [x] Explore codebase: models, routes, widgets, Bloc patterns, translations
- [/] Write implementation plan
- [ ] Get user approval on plan

## Execution
- [x] Create `SearchResult` model
- [x] Create `SearchBloc` (event, state, bloc)
- [/] Create `SearchWidget` (using `AutoSuggestBox`)
- [/] Integrate `SearchWidget` into `HomeScreen` app bar
- [/] Create `HighlightProvider` `InheritedWidget`
- [ ] Update `routes.dart` to wrap screens with `HighlightProvider`
- [ ] Update `ConfigItem` to read from `HighlightProvider`
- [ ] Update `ConfigItemBase` to support highlighting + auto-scroll
- [ ] Add search-related translations to `en.json`
- [ ] Register `SearchBloc` in `main.dart`

## Verification
- [ ] App builds successfully
- [ ] Manual testing / user verification
