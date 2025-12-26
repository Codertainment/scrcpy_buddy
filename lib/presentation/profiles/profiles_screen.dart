import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/extension/context_extension.dart';
import 'package:scrcpy_buddy/presentation/profiles/profile_name_dialog.dart';
import 'package:scrcpy_buddy/presentation/profiles/widgets/profile_list_tile.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/presentation/widgets/dialogs.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends AppModuleState<ProfilesScreen> {
  @override
  String get module => 'profiles';

  late final _profilesBloc = context.read<ProfilesBloc>();
  final _selectedProfiles = <int>{};

  Future<void> _showDeleteConfirmationDialog() async {
    final profilesToDelete = _selectedProfiles.isNotEmpty
        ? _selectedProfiles
        : _profilesBloc.state.allProfiles.map((profile) => profile.id).toSet();
    final shouldDelete = await showDangerActionConfirmationDialog(
      context,
      titleKey: 'profiles.multipleDeleteDialog.title',
      message: translatedText(
        key: 'multipleDeleteDialog.message',
        translationParams: {'count': profilesToDelete.length.toString()},
      ),
      actionKey: 'profiles.delete',
    );
    if (shouldDelete == true) {
      _profilesBloc.add(DeleteMultipleProfilesEvent(_selectedProfiles));
    }
  }

  Future<void> _showCreateProfileDialog() async {
    final newProfileName = await showProfileNameDialog(context: context);
    if (newProfileName != null) {
      _profilesBloc.add(CreateProfileEvent(newProfileName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilesBloc, ProfilesState>(
      listener: (_, state) {
        final selectedProfilesToClear = _selectedProfiles.difference(
          state.allProfiles.map((profile) => profile.id).toSet(),
        );
        for (final profileId in selectedProfilesToClear) {
          _selectedProfiles.remove(profileId);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: .end,
            children: [
              Row(
                children: [
                  Button(
                    onPressed: _showCreateProfileDialog,
                    child: Row(
                      children: [
                        WindowsIcon(WindowsIcons.add),
                        const SizedBox(width: 8),
                        Text(translatedText(key: 'create')),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith((states) {
                        if (states.isDisabled) {
                          return context.theme.resources.accentFillColorDisabled;
                        } else if (states.isPressed) {
                          return Colors.red.tertiaryBrushFor(context.theme.brightness);
                        } else if (states.isHovered) {
                          return Colors.red.secondaryBrushFor(context.theme.brightness);
                        } else {
                          return Colors.red.defaultBrushFor(context.theme.brightness);
                        }
                      }),
                    ),
                    onPressed: _showDeleteConfirmationDialog,
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        WindowsIcon(WindowsIcons.delete),
                        const SizedBox(width: 8),
                        Text(translatedText(key: _selectedProfiles.isNotEmpty ? 'deleteSelected' : 'deleteAll')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: state.allProfiles
                      .map(
                        (profile) => ProfileListTile(
                          profile: profile,
                          isSelected: _selectedProfiles.contains(profile.id),
                          onSelectionChange: (isSelected) {
                            if (isSelected == true) {
                              setState(() => _selectedProfiles.add(profile.id));
                            } else if (isSelected == false && _selectedProfiles.contains(profile.id)) {
                              setState(() => _selectedProfiles.remove(profile.id));
                            }
                          },
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
