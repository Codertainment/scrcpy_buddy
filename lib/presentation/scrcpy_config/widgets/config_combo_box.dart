import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';

import 'dropdown_placeholder.dart';

class ConfigComboBox extends StatelessWidget {
  final ScrcpyCliArgument<String> cliArgument;
  final ProfilesState state;

  const ConfigComboBox({super.key, required this.state, required this.cliArgument});

  @override
  Widget build(BuildContext context) {
    return ComboBox<String>(
      value: state.getFor(cliArgument),
      placeholder: const DropdownPlaceholder(),
      items: cliArgument.values!
          .map((mode) {
            return ComboBoxItem<String>(value: mode, child: Text(mode));
          })
          .toList(growable: false),
      onChanged: (newValue) => _onChanged(context, newValue),
    );
  }

  void _onChanged(BuildContext context, String? newValue) =>
      context.read<ProfilesBloc>().add(UpdateProfileArgEvent(cliArgument, newValue));
}
