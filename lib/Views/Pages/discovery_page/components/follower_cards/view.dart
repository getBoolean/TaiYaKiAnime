import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../../Widgets/TaiyakiSize.dart';

import 'state.dart';

Widget buildView(
    FollowerCardsState state, Dispatch dispatch, ViewService viewService) {
  final _adapter = viewService.buildAdapter();
  final TextStyle title = TextStyle(
      fontWeight: FontWeight.w600, fontSize: TaiyakiSize.height * 0.03);
  return SizedBox(
    height: TaiyakiSize.height * 0.28,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Recent Activities', style: title),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              key: const PageStorageKey('follower_activities'),
              scrollDirection: Axis.horizontal,
              itemBuilder: _adapter.itemBuilder,
              itemCount: _adapter.itemCount,
            ),
          ),
        )
      ],
    ),
  );
}
