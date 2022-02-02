import 'package:animator/animator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import '../../../models/taiyaki/settings.dart';
import '../../../models/taiyaki/user.dart';
import '../../../store/global_settings_store/global_settings_action.dart';
import '../../../store/global_settings_store/global_settings_state.dart';
import '../../../store/global_settings_store/global_settings_store.dart';
import '../../../store/global_user_store/global_user_state.dart';
import '../../../store/global_user_store/global_user_store.dart';

class OnboardingState
    implements
        GlobalUserBaseState,
        GlobalSettingsBaseState,
        Cloneable<OnboardingState> {
  final animeKey = AnimatorKey();

  PageController? pageController;

  @override
  OnboardingState clone() {
    return OnboardingState()..pageController = pageController;
  }

  @override
  AppSettingsModel get appSettings =>
      GlobalSettingsStore.store.getState().appSettings;

  @override
  set appSettings(AppSettingsModel _appSettings) {
    GlobalSettingsStore.store
        .dispatch(GlobalSettingsActionCreator.onUpdateSettings(_appSettings));
    // appSettings = _appSettings;
  }

  @override
  UserModel? anilistUser = GlobalUserStore.store.getState().anilistUser;

  @override
  UserModel? myanimelistUser = GlobalUserStore.store.getState().myanimelistUser;

  @override
  UserModel? simklUser = GlobalUserStore.store.getState().simklUser;
}

OnboardingState initState(Map<String, dynamic> args) {
  return OnboardingState();
}
