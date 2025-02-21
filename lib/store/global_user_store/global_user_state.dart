import 'package:fish_redux/fish_redux.dart';
import '../../models/taiyaki/sync.dart';
import '../../models/taiyaki/user.dart';

abstract class GlobalUserBaseState {
  UserModel? anilistUser;
  UserModel? myanimelistUser;
  UserModel? simklUser;
}

class GlobalUserState
    implements GlobalUserBaseState, Cloneable<GlobalUserState> {
  bool passedOnboarding = false;

  @override
  UserModel? anilistUser;

  @override
  UserModel? myanimelistUser;

  @override
  UserModel? simklUser;

  List<AnimeListModel>? anilistUserList;
  List<AnimeListModel>? myanimelistUserList;
  List<AnimeListModel>? simklUserList;

  @override
  GlobalUserState clone() => GlobalUserState()
    ..anilistUser = anilistUser
    ..myanimelistUser = myanimelistUser
    ..simklUser = simklUser
    ..passedOnboarding = passedOnboarding
    ..anilistUserList = anilistUserList
    ..myanimelistUserList = myanimelistUserList
    ..simklUserList = simklUserList;
}
