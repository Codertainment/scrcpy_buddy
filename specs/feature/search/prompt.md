# Search implementation

Let's plan to implement searching for the available scrcpy config UI options.
Search functionality should support searching through all available scrcpy options/arguments.

Before you start implementing it, please let's discuss the scope of work.

## Technical Details

### Available arguments

- All classes are present in @lib/application/model/scrcpy/arguments/ , they are categorised by their folder name
- At runtime, instances of all those classes is accessible through flutter `BuildContext`, using `Provider`:

```dart
import 'package:provider/provider.dart';

// ...

late final _allArgs = context.read<List<ScrcpyCliArgument<dynamic>>>();

// ...
```

### Search UI

- Search widget needs to be added to @lib/presentation/home/home_screen.dart, probably creating a new dedicated widget
  for search makes sense, because it will be complex and have some logic. So we wouldn't want to pollute the home_screen
  code
- We are using `fluent_ui` dart package: https://pub.dev/packages/fluent_ui as our UI framework, it has an
  `AutoSuggestBox` widget to use here
- Search results should open inline, in the same screen as a dropdown

### Clicking on a search result

- Once the user clicks on a search result, they should be navigated to the particular category screen. Existing routes
  are available in @lib/routes.dart , relevant routes are on lines 22-30
- The selected search object's label should be passed onto the category screen as an argument through GoRouter
- The category screens are placed in @lib/presentation/scrcpy_config, e.g.
  @lib/presentation/scrcpy_config/video/video_screen.dart

### Highlighting the selected search on the category screen

- Once the user is navigated to the correct category screen, the searched option should get highlighted
- The relevant UI widget representing each option is @lib/presentation/scrcpy_config/widgets/config_item_base.dart
- Each category screen uses the `ConfigItemBase` widget, either directly (rarely), or through the most-commonly used
  wrapper `ConfigItem` widget (@lib/presentation/scrcpy_config/widgets/config_item.dart)

## More info about the setup

### Translations

- Translations are setup across the app using `flutter_i18n` lib.
- But, as each category screen extends the util `AppModuleState` or `AppStatelessWidget`, the translations are available
through the flutter `BuildContext`, like so:

| Stateful Widget (`AppModuleState`)             | Stateless Widget (`AppStatelessWidget`)                     |
|------------------------------------------------|-------------------------------------------------------------|
| `translatedText('translation_label_key_here')` | `context.translatedText(key: 'translation_label_key_here')` |

- Translation file: @assets/i18n/en.json
