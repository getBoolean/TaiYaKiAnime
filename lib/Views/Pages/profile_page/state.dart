import 'package:fish_redux/fish_redux.dart';
import '../../../Models/Anilist/models.dart';
import '../../../Models/Taiyaki/Sync.dart';
import '../../../Models/Taiyaki/Trackers.dart';
import '../../../Services/API/Anilist+API.dart';
import '../../../Services/API/MyAnimeList+API.dart';
import '../../../Services/API/SIMKL+API.dart';
import '../../../Store/GlobalUserStore/GlobalUserStore.dart';
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
