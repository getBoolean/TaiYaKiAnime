import 'package:fish_redux/fish_redux.dart';
import '../cells/component.dart';
import 'state.dart';

class RowsAdapter extends SourceFlowAdapter<RowsState> {
  RowsAdapter()
      : super(pool: <String, Component<Object>>{
          'cells': DiscoveryRowCellsComponent(),
        });
}
