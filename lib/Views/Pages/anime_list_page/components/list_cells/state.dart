import 'package:fish_redux/fish_redux.dart';
import '../../../../../Models/Taiyaki/Sync.dart';

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
