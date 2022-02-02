import 'package:fish_redux/fish_redux.dart';
import 'cells/component.dart';
import 'state.dart';

class RecommendationAdapter extends SourceFlowAdapter<RecommendationState> {
  RecommendationAdapter()
      : super(pool: <String, Component<Object>>{
          'recommendation_cells': RecommendationCellsComponent(),
        });
}
