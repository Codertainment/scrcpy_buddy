import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/model/profile.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/profiles/profile_name_dialog.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';

class ProfileListTile extends StatefulWidget {
  final Profile profile;
  final bool isSelected;
  final void Function(bool? newSelection) onSelectionChange;

  const ProfileListTile({super.key, required this.profile, required this.isSelected, required this.onSelectionChange});

  @override
  State<ProfileListTile> createState() => _ProfileListTileState();
}

class _ProfileListTileState extends AppModuleState<ProfileListTile> {
  late final _profilesBloc = context.read<ProfilesBloc>();

  @override
  String get module => 'profiles';

  Future<void> _showRenameDialog() async {
    final newProfileName = await showProfileNameDialog(context: context, mode: .edit, name: widget.profile.name);
    if (newProfileName != null) {
      _profilesBloc.add(RenameProfileEvent(widget.profile.id, newProfileName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      selected: widget.isSelected,
      selectionMode: .multiple,
      onSelectionChange: widget.onSelectionChange,
      title: Text(widget.profile.name ?? translatedText(key: 'default')),
      trailing: SizedBox(
        width: 130,
        child: Align(
          alignment: .centerRight,
          child: CommandBar(
            primaryItems: [
              CommandBarButton(
                icon: WindowsIcon(WindowsIcons.rename),
                label: Text(translatedText(key: 'rename')),
                onPressed: _showRenameDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
