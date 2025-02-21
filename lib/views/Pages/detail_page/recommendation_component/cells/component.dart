import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'state.dart';
import 'view.dart';

class RecommendationCellsComponent extends Component<RecommendationCellsState> {
  RecommendationCellsComponent()
      : super(
          view: buildView,
          effect: buildEffect(),
          dependencies: Dependencies<RecommendationCellsState>(
              adapter: null,
              slots: <String, Dependent<RecommendationCellsState>>{}),
        );
}
