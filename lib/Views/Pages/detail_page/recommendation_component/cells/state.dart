import 'package:fish_redux/fish_redux.dart';
import '../../../../../Models/Anilist/models.dart';

class RecommendationCellsState implements Cloneable<RecommendationCellsState> {
  AnilistNode? media;

  RecommendationCellsState({this.media});

  @override
  RecommendationCellsState clone() {
    return RecommendationCellsState()..media = media;
  }
}
