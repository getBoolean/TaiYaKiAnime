import 'package:fish_redux/fish_redux.dart';

import '../../../models/anilist/models.dart';
import '../../../models/myanimelist/models.dart';
import '../../../models/simkl/models.dart';
import '../../../models/taiyaki/detail_database.dart';

//TODO replace with your own action
enum DetailAction {
  action,
  updateAnilistData,
  updateSimklData,
  updateMALEntryData,
  updateDetailDatabase,
  fetchLocalDatabase,
  fetchSimklEpisodes,
  initTempDatabase,
  updateSimklEpisodes,
  updateCovers,
  showSnack,
  showBottomSheet,
  fetchTrackers,
  switchCovers,
}

class SnackDetail {
  final String message;
  final bool isError;

  SnackDetail({required this.message, this.isError = false});
}

class DetailActionCreator {
  static Action onAction() {
    return const Action(DetailAction.action);
  }

  static Action updateCovers(String image) {
    return Action(DetailAction.updateCovers, payload: image);
  }

  static Action switchCovers() {
    return const Action(DetailAction.switchCovers);
  }

  static Action onUpdateSimklData(SimklNode node) {
    return Action(DetailAction.updateSimklData, payload: node);
  }

  static Action fetchTrackers() {
    return const Action(DetailAction.fetchTrackers);
  }

  static Action showBottomSheet() {
    return const Action(DetailAction.showBottomSheet);
  }

  static Action showSnackMessage(SnackDetail snack) {
    return Action(DetailAction.showSnack, payload: snack);
  }

  static Action updateSimklEpisodes(List<SimklEpisodeModel> episodes) {
    return Action(DetailAction.updateSimklEpisodes, payload: episodes);
  }

  static Action initTempDatabase() {
    return const Action(DetailAction.initTempDatabase);
  }

  static Action fetchSimklEpisodes(String link) {
    return Action(DetailAction.fetchSimklEpisodes, payload: link);
  }

  static Action fetchDetailDatabase() {
    return const Action(DetailAction.fetchLocalDatabase);
  }

  static Action updateAnilistData(AnilistNode data) {
    return Action(DetailAction.updateAnilistData, payload: data);
  }

  static Action udpateDetailDatabase(DetailDatabaseModel data) {
    return Action(DetailAction.updateDetailDatabase, payload: data);
  }

  static Action updateMALEntryData(MyAnimeListEntryModel data) {
    return Action(DetailAction.updateMALEntryData, payload: data);
  }
}
