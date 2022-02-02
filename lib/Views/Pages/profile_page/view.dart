import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../Models/Taiyaki/Trackers.dart';
import '../../../Utils/misc.dart';
import '../../Widgets/TaiyakiSize.dart';
import '../../Widgets/taiyaki_image.dart';

import 'state.dart';

Widget buildView(
    ProfileState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      body: CustomScrollView(slivers: [
    SliverAppBar(
      expandedHeight: TaiyakiSize.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
        background:
            TaiyakiImage(url: mapTrackerToUser(state.tracker!).background),
      ),
      pinned: true,
      stretch: true,
    ),
    SliverList(
        delegate: SliverChildListDelegate.fixed([
      viewService.buildComponent('card1'),
      viewService.buildComponent('card2'),
      if (state.tracker == ThirdPartyTrackersEnum.anilist &&
          state.anilistStats != null)
        viewService.buildComponent('card3'),
    ]))
  ]));
}
