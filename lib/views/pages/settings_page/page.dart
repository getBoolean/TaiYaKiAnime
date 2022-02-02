import 'package:fish_redux/fish_redux.dart';

import 'components/customization_component/component.dart';
import 'components/customization_component/state.dart';
import 'components/general_component/component.dart';
import 'components/general_component/state.dart';
import 'components/notification_component/component.dart';
import 'components/notification_component/state.dart';
import 'components/trackers_component/component.dart';
import 'components/trackers_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SettingsPage extends Page<SettingsState, Map<String, dynamic>> {
  SettingsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<SettingsState>(
              adapter: null,
              slots: <String, Dependent<SettingsState>>{
                'trackers':
                    SettingsTrackersConnector() + SettingsTrackersComponent(),
                'general':
                    GeneralComponentConnector() + GeneralComponentComponent(),
                'notification': NotificationSettingConnector() +
                    NotificationSettingsComponent(),
                'customization': CustomizationSettingConnector() +
                    CustomizationSettingComponent(),
              }),
          middleware: <Middleware<SettingsState>>[],
        );
}
