import 'package:fish_redux/fish_redux.dart';
import '../../../../../models/taiyaki/settings.dart';
import '../../state.dart';

class OnboardingPage2State implements Cloneable<OnboardingPage2State> {
  AppSettingsModel? appSettingsModel;

  @override
  OnboardingPage2State clone() {
    return OnboardingPage2State()..appSettingsModel = appSettingsModel;
  }
}

class OnboardPage2Connector
    extends ConnOp<OnboardingState, OnboardingPage2State> {
  @override
  OnboardingPage2State get(OnboardingState state) {
    final subState = OnboardingPage2State().clone();
    subState.appSettingsModel = state.appSettings;
    return subState;
  }

  @override
  void set(OnboardingState state, OnboardingPage2State subState) {
    state.appSettings = subState.appSettingsModel!;
  }
}
