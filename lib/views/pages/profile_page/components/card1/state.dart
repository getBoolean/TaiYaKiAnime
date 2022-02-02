import 'package:fish_redux/fish_redux.dart';
import '../../../../../models/taiyaki/user.dart';
import '../../../../../utils/misc.dart';
import '../../state.dart';

class Card1State implements Cloneable<Card1State> {
  UserModel? user;

  @override
  Card1State clone() {
    return Card1State()..user = user;
  }
}

class Card1Connector extends ConnOp<ProfileState, Card1State> {
  @override
  Card1State get(ProfileState state) {
    final subState = Card1State().clone();
    subState.user = mapTrackerToUser(state.tracker!);
    return subState;
  }
}
