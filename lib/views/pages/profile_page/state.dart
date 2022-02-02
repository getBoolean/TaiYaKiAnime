import 'package:fish_redux/fish_redux.dart';
import '../../../models/anilist/models.dart';
import '../../../models/taiyaki/sync.dart';
import '../../../models/taiyaki/trackers.dart';
import '../../../services/api/anilist_plus_api.dart';
import '../../../services/api/myanimelist_plus_api.dart';
import '../../../services/api/simkl_plus_api.dart';
import '../../../store/global_user_store/global_user_store.dart';
import 'page.dart';

class ProfileState implements Cloneable<ProfileState> {
  ThirdPartyTrackersEnum? tracker;
  List<AnimeListModel> data = [];

  AnilistViewerStats? anilistStats;

  @override
  ProfileState clone() {
    return ProfileState()
      ..tracker = tracker
      ..anilistStats = anilistStats
      ..data = data;
  }
}

ProfileState initState(ProfilePageArguments args) {
  List<AnimeListModel> _data;
  switch (args.tracker) {
    case ThirdPartyTrackersEnum.anilist:
      _data = GlobalUserStore.store.getState().anilistUserList ?? [];
      AnilistAPI().getAnimeList();
      break;
    case ThirdPartyTrackersEnum.myanimelist:
      _data = GlobalUserStore.store.getState().myanimelistUserList ?? [];
      MyAnimeListAPI().getAnimeList();
      break;
    case ThirdPartyTrackersEnum.simkl:
      _data = GlobalUserStore.store.getState().simklUserList ?? [];
      SimklAPI().getAnimeList();
      break;
  }

  return ProfileState()
    ..tracker = args.tracker
    ..data = _data;
}
