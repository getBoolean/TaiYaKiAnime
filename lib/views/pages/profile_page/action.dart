import 'package:fish_redux/fish_redux.dart';
import '../../../models/anilist/models.dart';
import '../../../models/taiyaki/sync.dart';

//TODO replace with your own action
enum ProfileAction { action, updateStats, moveToList }

class ProfileActionCreator {
  static Action onAction() {
    return const Action(ProfileAction.action);
  }

  static Action moveToList(List<AnimeListModel> model) {
    return Action(ProfileAction.moveToList, payload: model);
  }

  static Action updateStats(AnilistViewerStats stats) {
    return Action(ProfileAction.updateStats, payload: stats);
  }
}
