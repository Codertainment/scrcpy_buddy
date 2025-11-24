part of 'profiles_bloc.dart';

class ProfilesState extends Equatable {
  final List<Profile> allProfiles;
  final Profile currentProfile;
  final Map<String, ScrcpyCliArgument> _allArgs;

  // ignore: prefer_const_constructors_in_immutables
  ProfilesState({
    required this.allProfiles,
    required this.currentProfile,
    required Map<String, ScrcpyCliArgument> allArgs,
  }) : _allArgs = allArgs;

  dynamic getFor(ScrcpyCliArgument arg) {
    print("returning for $arg: ${currentProfile.args}");
    return currentProfile.args[arg.label];
  }

  List<String> toArgsList() => currentProfile.args.entries
      .map((entry) => MapEntry(_allArgs[entry.key], entry.value)) // map keys to arg instances
      .filter((entry) => entry.key != null) // filter out null keys
      .map((entry) => entry.key!.toArgs(entry.value)) // map each arg and value
      .flatten // flatten the list
      .toList(growable: false);

  @override
  List<Object?> get props => [allProfiles, currentProfile.id, currentProfile.name, ...currentProfile.args.entries];
}
