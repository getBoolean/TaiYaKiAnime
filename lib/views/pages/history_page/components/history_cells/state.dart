import 'package:fish_redux/fish_redux.dart';
import '../../../../../models/taiyaki/detail_database.dart';

class HistoryCellsState implements Cloneable<HistoryCellsState> {
  HistoryModel? historyModel;

  HistoryCellsState({this.historyModel});

  @override
  HistoryCellsState clone() {
    return HistoryCellsState()..historyModel = historyModel;
  }
}
