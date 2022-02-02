import 'package:fish_redux/fish_redux.dart';
import 'adapter.dart';

import 'effect.dart';
import 'state.dart';
import 'view.dart';

class RecommendationComponent extends Component<RecommendationState> {
  RecommendationComponent()
      : super(
          effect: buildEffect(),
          view: buildView,
          dependencies: Dependencies<RecommendationState>(
              adapter:
                  NoneConn<RecommendationState>() + RecommendationAdapter(),
              slots: <String, Dependent<RecommendationState>>{}),
        );
}
