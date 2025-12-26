part of 'profiles_bloc.dart';

sealed class ProfilesEvent extends Equatable {
  const ProfilesEvent();
}

class InitializeProfilesEvent extends ProfilesEvent {
  const InitializeProfilesEvent();

  @override
  List<Object?> get props => [];
}

class CreateProfileEvent extends ProfilesEvent {
  final String name;

  const CreateProfileEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class RenameProfileEvent extends ProfilesEvent {
  final int profileId;
  final String newName;

  const RenameProfileEvent(this.profileId, this.newName);

  @override
  List<Object?> get props => [profileId, newName];
}

class DeleteMultipleProfilesEvent extends ProfilesEvent {
  final Set<int> profileIds;

  const DeleteMultipleProfilesEvent(this.profileIds);

  @override
  List<Object?> get props => [profileIds];
}

class SwitchCurrentProfileEvent extends ProfilesEvent {
  final Profile newProfile;

  const SwitchCurrentProfileEvent(this.newProfile);

  @override
  List<Object?> get props => [newProfile];
}

class UpdateProfileArgEvent<V> extends ProfilesEvent {
  final ScrcpyCliArgument<V> arg;
  final V? value;

  const UpdateProfileArgEvent(this.arg, this.value);

  @override
  List<Object?> get props => [arg, value];
}
