import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:scrcpy_buddy/application/model/profile.dart';
import 'package:scrcpy_buddy/application/profiles_bloc/profiles_bloc.dart';
import 'package:scrcpy_buddy/presentation/profiles/profile_name_dialog.dart';
import 'package:scrcpy_buddy/presentation/widgets/app_widgets.dart';
import 'package:scrcpy_buddy/routes.dart';
import 'package:text_scroll/text_scroll.dart';

class ProfileButton extends AppStatelessWidget {
  const ProfileButton({super.key});

  @override
  String get module => 'home.profile';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesBloc, ProfilesState>(
      builder: (context, state) {
        return DropDownButton(
          title: _ProfileName(profile: state.currentProfile),
          items: [
            ...state.allProfiles
                .filter((profile) => profile.id != state.currentProfile.id)
                .map(
                  (profile) => MenuFlyoutItem(
                    onPressed: () => context.read<ProfilesBloc>().add(SwitchCurrentProfileEvent(profile)),
                    text: _ProfileName(profile: profile),
                  ),
                ),
            // only show separator if there are profiles shown in menu flyout
            if (state.allProfiles.length > 1) MenuFlyoutSeparator(),
            MenuFlyoutItem(
              leading: WindowsIcon(WindowsIcons.edit),
              text: Text(translatedText(context, key: 'manage')),
              onPressed: () => context.go(AppRoute.profiles),
            ),
            MenuFlyoutItem(
              leading: WindowsIcon(WindowsIcons.add),
              text: Text(translatedText(context, key: 'create')),
              onPressed: () => _createProfile(context),
            ),
          ],
        );
      },
    );
  }

  void _createProfile(BuildContext context) {
    // Allow menu flyout to close before triggering dialog
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showProfileNameDialog(context: context, mode: .create).then((newProfileName) {
        if (newProfileName != null) {
          context.read<ProfilesBloc>().add(CreateProfileEvent(newProfileName));
        }
      }),
    );
  }
}

class _ProfileName extends AppStatelessWidget {
  final Profile profile;

  const _ProfileName({required this.profile});

  @override
  String get module => 'home.profile';

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 120),
      child: TextScroll(
        getProfileName(context, profile),
        // Explicit ValueKey to ensure rebuild when profile changes (reset scroll animation)
        key: ValueKey(profile.id),
        mode: TextScrollMode.bouncing,
        velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
        delayBefore: Duration(milliseconds: 500),
        pauseOnBounce: Duration(seconds: 2),
        pauseBetween: Duration(seconds: 5),
      ),
    );
  }

  String getProfileName(BuildContext context, Profile profile) =>
      profile.name != null ? profile.name! : translatedText(context, key: 'default');
}
