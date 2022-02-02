import 'package:fish_redux/fish_redux.dart';
import '../../state.dart';

class NotificationSettingsState
    implements Cloneable<NotificationSettingsState> {
  @override
  NotificationSettingsState clone() {
    return NotificationSettingsState();
  }
}

class NotificationSettingConnector
    extends ConnOp<SettingsState, NotificationSettingsState> {
  @override
  NotificationSettingsState get(SettingsState state) {
    final subState = NotificationSettingsState().clone();
    return subState;
  }
}
