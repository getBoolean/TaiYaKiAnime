import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../../../models/taiyaki/user.dart';
import '../../../../../services/api/anilist_plus_api.dart';
import '../../../../../services/api/myanimelist_plus_api.dart';
import '../../../../../services/api/simkl_plus_api.dart';
import '../../../../../store/global_user_store/global_user_store.dart';
import '../../../discovery_page/action.dart';
import '../../action.dart';

import 'state.dart';

Widget buildView(
    SettingsTrackersState state, Dispatch dispatch, ViewService viewService) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListView(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Auto sync at 75%'),
          value: state.appSettingsModel!.updateAt75,
          onChanged: (val) => dispatch(SettingsActionCreator.onUpdateSetting(
              state.appSettingsModel!.copyWith(updateAt75: val))),
          secondary: const Icon(Icons.sync),
          subtitle: const Text('Must be signed in to at least one tracker'),
        ),
        _TrackerCards(
            name: 'Anilist',
            model: GlobalUserStore.store.getState().anilistUser,
            onLogin: () => AnilistAPI()
                .login()
                .then((value) =>
                    dispatch(SettingsActionCreator.updateUserModel(value)))
                .whenComplete(() =>
                    dispatch(DiscoveryActionCreator.grabAnilistActivity())),
            onLogout: AnilistAPI().logout),
        _TrackerCards(
            name: 'MyAnimeList',
            model: state.myanimelistUser,
            onLogin: () => MyAnimeListAPI().login().then((value) =>
                dispatch(SettingsActionCreator.updateUserModel(value))),
            onLogout: MyAnimeListAPI().logout),
        _TrackerCards(
            name: 'SIMKL',
            model: state.simklUser,
            onLogin: () => SimklAPI().login().then((value) =>
                dispatch(SettingsActionCreator.updateUserModel(value))),
            onLogout: () {}),
      ],
    ),
  );
}

class _TrackerCards extends StatelessWidget {
  final String name;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final UserModel? model;

  const _TrackerCards(
      {required this.name,
      required this.onLogin,
      required this.onLogout,
      this.model});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = model != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 8.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.login,
                    color: isLoggedIn ? Colors.red : Colors.green,
                  ),
                  onPressed: isLoggedIn ? onLogout : onLogin,
                )
              ],
            ),
            Text(
              model?.username != null
                  ? 'Logged in as: ' + model!.username!
                  : 'Not logged in',
            ),
          ],
        ),
      ),
    );
  }
}
