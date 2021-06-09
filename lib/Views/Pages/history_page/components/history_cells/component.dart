import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HistoryCellsComponent extends Component<HistoryCellsState> {
  HistoryCellsComponent()
      : super(
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HistoryCellsState>(
                adapter: null,
                slots: <String, Dependent<HistoryCellsState>>{
                }),);

}
