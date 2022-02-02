import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../models/taiyaki/settings.dart';
import '../../../models/taiyaki/trackers.dart';
import '../../../models/taiyaki/user.dart';
import '../../../store/global_settings_store/global_settings_action.dart';
import '../../../store/global_settings_store/global_settings_state.dart';
import '../../../store/global_settings_store/global_settings_store.dart';
import '../../../store/global_user_store/global_user_action.dart';
import '../../../store/global_user_store/global_user_state.dart';
import '../../../store/global_user_store/global_user_store.dart';

class SettingsState
    implements
        GlobalUserBaseState,
        GlobalSettingsBaseState,
        Cloneable<SettingsState> {
  final List<Tab> tabs = [
    const Tab(text: 'General'),
    const Tab(text: 'Customization'),
    const Tab(text: 'Notifications'),
    const Tab(
      text: 'Trackers',
    ),
  ];

  @override
  SettingsState clone() {
    return SettingsState();
  }

  @override
  UserModel? get anilistUser => GlobalUserStore.store.getState().anilistUser;

  @override
  UserModel? get myanimelistUser =>
      GlobalUserStore.store.getState().myanimelistUser;

  @override
  UserModel? get simklUser => GlobalUserStore.store.getState().simklUser;

  @override
  set anilistUser(UserModel? _anilistUser) {
    if (_anilistUser != null) {
      GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUser(
          UpdateModel(
              model: _anilistUser, tracker: ThirdPartyTrackersEnum.anilist)));
    }
  }

  @override
  set myanimelistUser(UserModel? _myanimelistUser) {
    debugPrint('myanimelist');
    if (_myanimelistUser != null) {
      GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUser(
          UpdateModel(
              model: _myanimelistUser,
              tracker: ThirdPartyTrackersEnum.myanimelist)));
    }
  }

  @override
  set simklUser(UserModel? _simklUser) {
    if (_simklUser != null) {
      GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUser(
          UpdateModel(
              model: _simklUser, tracker: ThirdPartyTrackersEnum.simkl)));
    }
  }

  @override
  AppSettingsModel get appSettings =>
      GlobalSettingsStore.store.getState().appSettings;

  @override
  set appSettings(AppSettingsModel _appSettings) {
    GlobalSettingsStore.store
        .dispatch(GlobalSettingsActionCreator.onUpdateSettings(_appSettings));
  }
}

SettingsState initState(Map<String, dynamic> args) {
  return SettingsState();
}
