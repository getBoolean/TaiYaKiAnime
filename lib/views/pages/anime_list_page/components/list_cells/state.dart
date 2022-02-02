import 'package:fish_redux/fish_redux.dart';
import '../../../../../models/taiyaki/sync.dart';

class ListCellState implements Cloneable<ListCellState> {
  AnimeListModel? model;

  ListCellState({
    this.model,
  });

  @override
  ListCellState clone() {
    return ListCellState()..model = model;
  }
}
