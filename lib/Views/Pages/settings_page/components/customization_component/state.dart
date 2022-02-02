import 'package:fish_redux/fish_redux.dart';
import '../../../../../Models/Taiyaki/Settings.dart';
import '../../state.dart';

class CustomizationSettingState
    implements Cloneable<CustomizationSettingState> {
  AppSettingsModel? appSettingsModel;

  @override
  CustomizationSettingState clone() {
    return CustomizationSettingState()..appSettingsModel = appSettingsModel;
  }
}

class CustomizationSettingConnector
    extends ConnOp<SettingsState, CustomizationSettingState> {
  @override
  CustomizationSettingState get(SettingsState state) {
    final subState = CustomizationSettingState().clone();
    subState.appSettingsModel = state.appSettings;
    return subState;
  }
}
