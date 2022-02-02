import 'package:fish_redux/fish_redux.dart';

import 'global_user_reducer.dart';
import 'global_user_state.dart';

class GlobalUserStore {
  static Store<GlobalUserState>? _globalStore;

  static Store<GlobalUserState> get store => _globalStore ??=
      createStore<GlobalUserState>(GlobalUserState(), buildReducer());
}
