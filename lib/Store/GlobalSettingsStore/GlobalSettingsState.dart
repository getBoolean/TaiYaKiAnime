import 'package:fish_redux/fish_redux.dart';
import '../../Models/Taiyaki/Settings.dart';

abstract class GlobalSettingsBaseState {
  AppSettingsModel appSettings = AppSettingsModel();
}

class GlobalSettingsState
    implements GlobalSettingsBaseState, Cloneable<GlobalSettingsState> {
  @override
  GlobalSettingsState clone() =>
      GlobalSettingsState()..appSettings = appSettings;

  @override
  AppSettingsModel appSettings = AppSettingsModel();
}
