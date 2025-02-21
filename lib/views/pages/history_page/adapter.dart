import 'package:fish_redux/fish_redux.dart';
import 'components/history_cells/component.dart';

import 'state.dart';

class HistoryAdapter extends SourceFlowAdapter<HistoryState> {
  HistoryAdapter()
      : super(pool: <String, Component<Object>>{
          'history_cell': HistoryCellsComponent(),
        });
}
