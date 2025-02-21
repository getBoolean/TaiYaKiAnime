import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../models/taiyaki/trackers.dart';
import '../../../store/global_user_store/global_user_store.dart';
import '../../widgets/platform_scaffold.dart';
import '../../widgets/profile_list_cards.dart';
import '../../widgets/taiyaki_size.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    DiscoveryState state, Dispatch dispatch, ViewService viewService) {
  TaiyakiSize().setHeight = MediaQuery.of(viewService.context).size.height;
  TaiyakiSize().setWidth = MediaQuery.of(viewService.context).size.width;
  final _state = GlobalUserStore.store.getState();

  return PlatformScaffold(
    appBarTitle: 'Discovery',
    actions: [
      IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => dispatch(DiscoveryActionCreator.onAction())),
    ],
    child: ListView(
      children: [
        if (_state.simklUser != null ||
            _state.myanimelistUser != null ||
            _state.anilistUser != null)
          SizedBox(
            height: TaiyakiSize.height * 0.22,
            child: ListView(
                // itemExtent: TaiyakiSize.height * 0.23,
                scrollDirection: Axis.horizontal,
                children: [
                  if (GlobalUserStore.store.getState().anilistUser != null)
                    ProfileListCards(
                      tracker: ThirdPartyTrackersEnum.anilist,
                      userModel: GlobalUserStore.store.getState().anilistUser!,
                    ),
                  if (GlobalUserStore.store.getState().myanimelistUser != null)
                    ProfileListCards(
                      tracker: ThirdPartyTrackersEnum.myanimelist,
                      userModel:
                          GlobalUserStore.store.getState().myanimelistUser!,
                    ),
                  if (GlobalUserStore.store.getState().simklUser != null)
                    ProfileListCards(
                      tracker: ThirdPartyTrackersEnum.simkl,
                      userModel: GlobalUserStore.store.getState().simklUser!,
                    ),
                ]),
          ),
        viewService.buildComponent('trending_slot'),
        if (state.activity.isNotEmpty && state.anilistUser != null)
          viewService.buildComponent('activity_slot'),
        // viewService.buildComponent('seasonal_slot'),
        viewService.buildComponent('popular_slot'),
        // viewService.buildComponent('next_season_slot'),
        //  viewService.buildComponent('just_added_slot'),
        const SizedBox(height: 8),
      ],
    ),
  );
}
