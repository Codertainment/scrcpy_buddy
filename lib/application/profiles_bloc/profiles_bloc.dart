import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:scrcpy_buddy/application/app_settings.dart';
import 'package:scrcpy_buddy/application/model/profile.dart';
import 'package:scrcpy_buddy/application/model/scrcpy/scrcpy_cli_argument.dart';
import 'package:scrcpy_buddy/objectbox.g.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

typedef _Emitter = Emitter<ProfilesState>;

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  ProfilesBloc(AppSettings settings, this._profileBox, this._allArgs)
    : super(
        ProfilesState(
          allProfiles: _profileBox.getAll(),
          currentProfile: _profileBox.getAll().firstOrNull ?? Profile(),
          allArgs: _allArgs,
        ),
      ) {
    _currentProfile = state.currentProfile;
    _isLastUsedProfileDefault = settings.isLastUsedProfileDefault;
    _defaultProfileId = settings.defaultProfileId;
    on<InitializeProfilesEvent>((event, emit) => _initialize(emit));
    on<CreateProfileEvent>(_createProfile);
    on<RenameProfileEvent>(_renameProfile);
    on<UpdateProfileArgEvent>(_updateArg);
    on<DeleteMultipleProfilesEvent>(_deleteMultipleProfiles);
    on<SwitchCurrentProfileEvent>(_switchCurrentProfile);
  }

  final Map<String, ScrcpyCliArgument> _allArgs;
  final Box<Profile> _profileBox;
  late Profile _currentProfile;
  late final Preference<bool> _isLastUsedProfileDefault;
  late final Preference<int> _defaultProfileId;

  void _initialize(_Emitter emit) {
    final defaultProfileId = _defaultProfileId.getValue();
    final allProfiles = _profileBox.getAll();
    if (defaultProfileId == -1) {
      _currentProfile = allProfiles.firstOrNull ?? Profile();
    } else {
      _currentProfile =
          allProfiles.where((profile) => profile.id == defaultProfileId).firstOrNull ??
          allProfiles.firstOrNull ??
          Profile();
    }
    _emit(emit);
  }

  void _createProfile(CreateProfileEvent event, _Emitter emit) {
    final newProfile = Profile()..name = event.name;
    _profileBox.put(newProfile);
    _currentProfile = newProfile;
    _emit(emit);
  }

  void _renameProfile(RenameProfileEvent event, _Emitter emit) {
    final originalProfile = _profileBox.get(event.profileId);
    final newProfile = originalProfile?.copyWith(name: event.newName);
    if (newProfile != null) {
      _profileBox.put(newProfile);
      _currentProfile = newProfile;
    }
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

  void _deleteMultipleProfiles(DeleteMultipleProfilesEvent event, _Emitter emit) {
    for (final profileId in event.profileIds) {
      _profileBox.remove(profileId);
    }
    // if current profile is being deleted, reset to first / new profile
    if (event.profileIds.contains(_currentProfile.id)) {
      _currentProfile = _profileBox.getAll().firstOrNull ?? Profile();
    }
    _emit(emit);
  }

  void _switchCurrentProfile(SwitchCurrentProfileEvent event, _Emitter emit) {
    _currentProfile = event.newProfile;
    _emit(emit);
  }

  void _emit(_Emitter emit) {
    _checkAndUpdateDefaultProfileId();
    final allProfiles = _profileBox.getAll();
    emit(ProfilesState(allProfiles: allProfiles, currentProfile: _currentProfile, allArgs: _allArgs));
  }

  void _checkAndUpdateDefaultProfileId() {
    if (_isLastUsedProfileDefault.getValue()) {
      _defaultProfileId.setValue(_currentProfile.id);
    }
  }
}
