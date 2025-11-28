import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';

class ConfigToggle extends StatelessWidget {
  final ScrcpyCliArgument<bool> cliArgument;
  final ProfilesState state;

  const ConfigToggle({super.key, required this.state, required this.cliArgument});

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      checked: state.getFor(cliArgument) ?? false,
      onChanged: (checked) => _onChanged(context, checked),
    );
  }

  void _onChanged(BuildContext context, bool? checked) =>
      context.read<ProfilesBloc>().add(UpdateProfileArgEvent(cliArgument, checked));
}
