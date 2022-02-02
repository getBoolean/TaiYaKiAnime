import 'package:fish_redux/fish_redux.dart';
import '../../models/taiyaki/sync.dart';
import '../../models/taiyaki/trackers.dart';
import '../../models/taiyaki/user.dart';

class UpdateModel {
  final UserModel model;

  final ThirdPartyTrackersEnum tracker;

  UpdateModel({required this.model, required this.tracker});
}

enum GlobalUserAction { updateUser, onOnboarding, updateUserList, removeUser }

class GlobalUserActionCreator {
  static Action onUpdateUser(UpdateModel? model) {
    return Action(GlobalUserAction.updateUser, payload: model);
  }

  static Action removeUser(ThirdPartyTrackersEnum tracker) {
    return Action(GlobalUserAction.removeUser, payload: tracker);
  }

  static Action onUpdateUserList(
      List<AnimeListModel> model, ThirdPartyTrackersEnum tracker) {
    return Action(GlobalUserAction.updateUserList, payload: {tracker: model});
  }

  static Action onUpdateOnboarding() {
    return const Action(GlobalUserAction.onOnboarding);
  }
}
