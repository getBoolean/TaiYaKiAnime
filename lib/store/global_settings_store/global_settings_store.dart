import 'package:fish_redux/fish_redux.dart';

import 'global_settings_reducer.dart';
import 'global_settings_state.dart';

class GlobalSettingsStore {
  static Store<GlobalSettingsState>? _globalStore;

  static Store<GlobalSettingsState> get store => _globalStore ??=
      createStore<GlobalSettingsState>(GlobalSettingsState(), buildReducer());
}
