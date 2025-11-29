import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_arg.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/translation_extension.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_divider.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_item_base.dart';
import 'package:scrcpy_buddy/presentation/scrcpy_config/widgets/config_text_box.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class VirtualDisplayScreen extends StatefulWidget {
  const VirtualDisplayScreen({super.key});

  @override
  State<VirtualDisplayScreen> createState() => _VirtualDisplayScreenState();
}

class _VirtualDisplayScreenState extends AppModuleState<VirtualDisplayScreen> {
  @override
  String get module => 'config.virtualDisplay';

  late final _profilesBloc = context.read<ProfilesBloc>();
  final _newDisplay = NewDisplay();
  bool isEnabled = false;
  String? resolutionWidth;
  String? resolutionHeight;
  String? dpi;

  @override
  void initState() {
    super.initState();
    _onBlocStateChange(_profilesBloc.state);
  }

  void _onBlocStateChange(ProfilesState state) {
    final value = state.getFor<String>(_newDisplay);
    isEnabled = value != null;
    final split = value?.split("/");
    if (split?.length == 2) {
      dpi = split?[1];
    } else {
      dpi = null;
    }
    final resolution = value?.split("/")[0];
    if (resolution?.isNotEmpty == true) {
      final split = resolution!.split("x");
      resolutionWidth = split[0];
      resolutionHeight = split[1];
    } else {
      resolutionWidth = null;
      resolutionHeight = null;
    }
  }

  void _toggleEnabled(bool? checked) {
    UpdateProfileArgEvent<String> event;
    if (checked == true) {
      // put empty string for enabling
      event = UpdateProfileArgEvent(_newDisplay, "");
    } else {
      event = UpdateProfileArgEvent(_newDisplay, null);
    }
    _profilesBloc.add(event);
  }

  void _updateDpi(String? newDpi) {
    dpi = newDpi;
    if (dpi != null) {
      if (resolutionHeight?.isNotEmpty == true && resolutionWidth?.isNotEmpty == true) {
        _updateResolutionWithDPI();
      } else {
        _profilesBloc.add(UpdateProfileArgEvent(_newDisplay, "/$dpi"));
      }
    } else {
      if (resolutionHeight?.isNotEmpty == true && resolutionWidth?.isNotEmpty == true) {
        _updateResolutionWithDPI();
      } else {
        _toggleEnabled(isEnabled);
      }
    }
  }

  void _updateResolutionHeight(String? newHeight) {
    setState(() {
      if (newHeight?.isEmpty == true) {
        _clearResolution();
        return;
      }
      resolutionHeight = newHeight;
    });
    if (resolutionWidth?.isNotEmpty == true) {
      if (dpi != null) {
        _updateResolutionWithDPI();
      } else {
        _updateResolution();
      }
    }
  }

  void _updateResolutionWidth(String? newWidth) {
    setState(() {
      if (newWidth?.isEmpty == true) {
        _clearResolution();
        return;
      }
      resolutionWidth = newWidth;
    });
    if (resolutionHeight?.isNotEmpty == true) {
      if (dpi != null) {
        _updateResolutionWithDPI();
      } else {
        _updateResolution();
      }
    }
  }

  void _updateResolutionWithDPI() =>
      _profilesBloc.add(UpdateProfileArgEvent(_newDisplay, "${resolutionWidth}x$resolutionHeight/$dpi"));

  void _updateResolution() =>
      _profilesBloc.add(UpdateProfileArgEvent(_newDisplay, "${resolutionWidth}x$resolutionHeight"));

  void _clearResolution() {
    resolutionWidth = null;
    resolutionHeight = null;
    if (isEnabled) {
      _toggleEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<ProfilesBloc, ProfilesState>(
        listener: (context, state) {
          setState(() => _onBlocStateChange(state));
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                InfoBar(
                  title: Text(translatedText(key: 'infoBar.title')),
                  content: Text(translatedText(key: 'infoBar.description')),
                ),
                const SizedBox(height: 16),
                Card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConfigItemBase(
                        icon: WindowsIcons.explore_content,
                        titleKey: '${_newDisplay.label}.toggle.title',
                        descriptionKey: '${_newDisplay.label}.toggle.description',
                        arg: _newDisplay.argument,
                        child: ToggleSwitch(checked: isEnabled, onChanged: (checked) => _toggleEnabled(checked)),
                      ),
                      const ConfigDivider(),
                      ConfigItemBase(
                        icon: FluentIcons.full_screen,
                        titleKey: '${_newDisplay.label}.resolution.title',
                        descriptionKey: '${_newDisplay.label}.resolution.description',
                        defaultValueKey: '${_newDisplay.label}.resolution.default',
                        arg: _newDisplay.argument,
                        child: Row(
                          children: [
                            ConfigTextBox(
                              isDisabled: !isEnabled,
                              maxWidth: 90,
                              isNumberOnly: true,
                              placeholder: context.translatedText(key: 'config.${_newDisplay.label}.resolution.width'),
                              value: resolutionWidth,
                              onChanged: _updateResolutionWidth,
                            ),
                            const SizedBox(width: 4),
                            Text('x'),
                            const SizedBox(width: 4),
                            ConfigTextBox(
                              isDisabled: !isEnabled,
                              maxWidth: 90,
                              isNumberOnly: true,
                              placeholder: context.translatedText(key: 'config.${_newDisplay.label}.resolution.height'),
                              value: resolutionHeight,
                              onChanged: _updateResolutionHeight,
                            ),
                          ],
                        ),
                      ),
                      const ConfigDivider(),
                      ConfigItemBase(
                        icon: FluentIcons.image_pixel,
                        titleKey: '${_newDisplay.label}.dpi.title',
                        descriptionKey: '${_newDisplay.label}.dpi.description',
                        defaultValueKey: '${_newDisplay.label}.dpi.default',
                        arg: _newDisplay.argument,
                        child: ConfigTextBox(
                          isDisabled: !isEnabled,
                          isNumberOnly: true,
                          maxWidth: 90,
                          value: dpi,
                          onChanged: _updateDpi,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
