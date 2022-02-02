import 'package:fish_redux/fish_redux.dart';
import '../../../Models/Anilist/models.dart';
import '../../../Models/Taiyaki/DetailDatabase.dart';
import '../../../Models/Taiyaki/User.dart';
import '../../../Store/GlobalUserStore/GlobalUserState.dart';

class DiscoveryState implements GlobalUserBaseState, Cloneable<DiscoveryState> {
  List<AnilistNode>? trendingData;
  List<AnilistNode>? popularData;
  List<AnilistNode>? seasonalData;
  List<AnilistNode>? nextSeasonalData;
  List<AnilistNode>? justAddedData;
  List<AnilistFollowersActivityModel> activity = [];
  List<LastWatchingModel> continueItems = [];

  Exception? error;

  @override
  DiscoveryState clone() {
    return DiscoveryState()
      ..error = error
      ..activity = activity
      ..continueItems = continueItems
      ..nextSeasonalData = nextSeasonalData
      ..justAddedData = justAddedData
      ..trendingData = trendingData
      ..seasonalData = seasonalData
      ..popularData = popularData;
  }

  @override
  UserModel? anilistUser;

  @override
  UserModel? myanimelistUser;

  @override
  UserModel? simklUser;
}

DiscoveryState initState(Map<String, dynamic> args) {
  return DiscoveryState();
}
