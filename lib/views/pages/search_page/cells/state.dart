import 'package:fish_redux/fish_redux.dart';
import '../../../../models/anilist/models.dart';

class SearchCellsState implements Cloneable<SearchCellsState> {
  AnilistNode? media;

  SearchCellsState({this.media});

  @override
  SearchCellsState clone() {
    return SearchCellsState()..media = media;
  }
}
