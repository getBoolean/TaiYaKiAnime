import 'package:fish_redux/fish_redux.dart';
import '../../models/taiyaki/settings.dart';

enum GlobalSettingsAction { updateSettings }

class GlobalSettingsActionCreator {
  static Action onUpdateSettings(AppSettingsModel model) {
    return Action(GlobalSettingsAction.updateSettings, payload: model);
  }
}
