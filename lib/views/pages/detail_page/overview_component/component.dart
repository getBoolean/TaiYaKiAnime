import 'package:fish_redux/fish_redux.dart';

import 'characters_component/component.dart';
import 'characters_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class OverviewComponent extends Component<OverviewState> {
  OverviewComponent()
      : super(
          shouldUpdate: (o, n) => o.synopsisExpanded != n.synopsisExpanded,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<OverviewState>(
              adapter: null,
              slots: <String, Dependent<OverviewState>>{
                'characters_component':
                    CharactersConnector() + CharactersComponent(),
              }),
        );
}
