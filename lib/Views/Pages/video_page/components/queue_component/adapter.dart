import 'package:fish_redux/fish_redux.dart';
import '../queue_cell/component.dart';

import 'state.dart';

class QueueAdapter extends SourceFlowAdapter<QueueState> {
  QueueAdapter()
      : super(pool: <String, Component<Object>>{
          'queue_list_cell': QueueCellComponent(),
        });
}
