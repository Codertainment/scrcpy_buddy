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

class DeleteProfileEvent extends ProfilesEvent {
  final int id;

  const DeleteProfileEvent(this.id);

  @override
  List<Object?> get props => [id];
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
