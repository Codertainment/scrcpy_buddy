import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/model/profile.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/objectbox.g.dart';

part 'profiles_event.dart';

part 'profiles_state.dart';

typedef _Emitter = Emitter<ProfilesState>;

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc(this._profileBox, this._allArgs)
    : super(
        ProfilesState(
          allProfiles: _profileBox.getAll(),
          currentProfile: _profileBox.getAll().firstOrNull ?? Profile(),
          allArgs: _allArgs,
        ),
      ) {
    _currentProfile = state.currentProfile;
    on<InitializeProfilesEvent>((event, emit) => _emit(emit));
    on<CreateProfileEvent>(_createProfile);
    on<UpdateProfileArgEvent>(_updateArg);
    on<DeleteProfileEvent>(_deleteProfile);
    on<SwitchCurrentProfileEvent>(_switchCurrentProfile);
  }

  final Map<String, ScrcpyCliArgument> _allArgs;
  final Box<Profile> _profileBox;
  late Profile _currentProfile;

  void _createProfile(CreateProfileEvent event, _Emitter emit) {
    final newProfile = Profile()..name = event.name;
    _profileBox.put(newProfile);
    _currentProfile = newProfile;
    _emit(emit);
  }

  void _updateArg(UpdateProfileArgEvent event, _Emitter emit) {
    final newArgs = {..._currentProfile.args};
    if (event.value == null) {
      newArgs.remove(event.arg.label);
    } else {
      newArgs[event.arg.label] = event.value;
    }
    final newProfile = _currentProfile.copyWith(args: newArgs);
    _profileBox.put(newProfile);
    _currentProfile = newProfile;
    _emit(emit);
  }

  void _deleteProfile(DeleteProfileEvent event, _Emitter emit) {
    _profileBox.remove(event.id);
    // if current profile is being deleted, reset to first / new profile
    if (_currentProfile.id == event.id) {
      _currentProfile = _profileBox.getAll().firstOrNull ?? Profile();
    }
    _emit(emit);
  }

  void _switchCurrentProfile(SwitchCurrentProfileEvent event, _Emitter emit) {
    _currentProfile = event.newProfile;
    _emit(emit);
  }

  void _emit(_Emitter emit) {
    final allProfiles = _profileBox.getAll();
    /*if (kDebugMode) {
      print(
        "emitting profiles state. allProfiles: $allProfiles\t currentProfile: $_currentProfile\tallArgs: $_allArgs",
      );
    }*/
    emit(ProfilesState(allProfiles: allProfiles, currentProfile: _currentProfile, allArgs: _allArgs));
  }
}
