import 'package:fish_redux/fish_redux.dart';
import '../follower_cells/component.dart';

import 'state.dart';

class FollowerCardsAdapter extends SourceFlowAdapter<FollowerCardsState> {
  FollowerCardsAdapter()
      : super(pool: <String, Component<Object>>{
          'follower_cells': FollowersCellsComponent(),
        });
}
