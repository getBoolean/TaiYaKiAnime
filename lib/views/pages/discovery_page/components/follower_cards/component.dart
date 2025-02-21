import 'package:fish_redux/fish_redux.dart';

import 'adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FollowerCardsComponent extends Component<FollowerCardsState> {
  FollowerCardsComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FollowerCardsState>(
              adapter: NoneConn<FollowerCardsState>() + FollowerCardsAdapter(),
              slots: <String, Dependent<FollowerCardsState>>{}),
        );
}
