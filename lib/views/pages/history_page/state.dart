import 'package:fish_redux/fish_redux.dart';
import '../../../models/taiyaki/detail_database.dart';
import 'components/history_cells/state.dart';

class HistoryState extends ImmutableSource implements Cloneable<HistoryState> {
  List<HistoryModel> historyItems = [];

  @override
  HistoryState clone() {
    return HistoryState()..historyItems = historyItems;
  }

  @override
  Object getItemData(int index) {
    final _item = historyItems[index];
    return HistoryCellsState(historyModel: _item);
  }

  @override
  String getItemType(int index) {
    return 'history_cell';
  }

  @override
  int get itemCount => historyItems.length;

  @override
  ImmutableSource setItemData(int index, Object data) {
    // TODO: implement setItemData
    throw UnimplementedError();
  }
}

HistoryState initState(Map<String, dynamic> args) {
  return HistoryState();
}
