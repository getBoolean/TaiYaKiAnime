import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../../models/taiyaki/trackers.dart';
import '../../../../../services/api/anilist_plus_api.dart';
import '../../../../../services/api/myanimelist_plus_api.dart';
import '../../../../../services/api/simkl_plus_api.dart';
import '../../../../../store/global_user_store/global_user_store.dart';
import '../../../../../utils/misc.dart';
import '../../action.dart';
import 'state.dart';

Widget buildView(
    OnboardPage3State state, Dispatch dispatch, ViewService viewService) {
  const TextStyle _title = TextStyle(fontWeight: FontWeight.w800, fontSize: 26);
  const TextStyle _subTitle =
      TextStyle(fontWeight: FontWeight.w200, fontSize: 14, color: Colors.grey);

  final query = MediaQuery.of(viewService.context).size;

  return SafeArea(
    top: true,
    bottom: true,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 12.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Column(
          children: const [
            Text('Use a tracker?', style: _title),
            Text('You can also sign in later in Settings',
                style: _subTitle),
          ],
        ),
        SizedBox(
          height: query.height * 0.45,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: const [
              _TrackerBubbles(tracker: ThirdPartyTrackersEnum.anilist),
              _TrackerBubbles(tracker: ThirdPartyTrackersEnum.myanimelist),
              _TrackerBubbles(tracker: ThirdPartyTrackersEnum.simkl)
            ],
          ),
        ),
        SizedBox(
            height: query.height * 0.07,
            width: query.width * 0.9,
            child: ElevatedButton(
                onPressed: () =>
                    dispatch(OnboardingActionCreator.moveToPage(4)),
                child: const Text('Next'))),
      ]),
    ),
  );
}

class _TrackerBubbles extends StatefulWidget {
  final ThirdPartyTrackersEnum tracker;

  const _TrackerBubbles({Key? key, required this.tracker}) : super(key: key);

  @override
  __TrackerBubblesState createState() => __TrackerBubblesState();
}

class __TrackerBubblesState extends State<_TrackerBubbles> {
  __TrackerBubblesState();

  late final String _image;
  String? _avatar;
  String? _userName;

  @override
  void initState() {
    _image = mapTrackerToAsset(widget.tracker);
    _update();
    super.initState();
  }

  void _update() {
    switch (widget.tracker) {
      case ThirdPartyTrackersEnum.anilist:
        setState(() {
          _avatar = GlobalUserStore.store.getState().anilistUser?.avatar;
          _userName = GlobalUserStore.store.getState().anilistUser?.username;
        });
        break;
      case ThirdPartyTrackersEnum.myanimelist:
        setState(() {
          _avatar = GlobalUserStore.store.getState().myanimelistUser?.avatar;
          _userName =
              GlobalUserStore.store.getState().myanimelistUser?.username;
        });
        break;
      case ThirdPartyTrackersEnum.simkl:
        setState(() {
          _avatar = GlobalUserStore.store.getState().simklUser?.avatar;
          _userName = GlobalUserStore.store.getState().simklUser?.username;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_userName == null) {
          switch (widget.tracker) {
            case ThirdPartyTrackersEnum.anilist:
              AnilistAPI().login().whenComplete(() {
                AnilistAPI().getProfile().whenComplete(() => _update());
              });
              break;
            case ThirdPartyTrackersEnum.simkl:
              SimklAPI().login().whenComplete(
                  () => SimklAPI().getProfile().whenComplete(() => _update()));
              break;
            case ThirdPartyTrackersEnum.myanimelist:
              MyAnimeListAPI().login().whenComplete(() =>
                  MyAnimeListAPI().getProfile().whenComplete(() => _update()));
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: _avatar != null
                  // ignore: unnecessary_cast
                  ? (NetworkImage(_avatar!) as ImageProvider<Object>?)
                  : (AssetImage(_image)),
              radius: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(_userName ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
