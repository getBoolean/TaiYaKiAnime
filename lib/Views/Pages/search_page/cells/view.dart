import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/SearchTile.dart';
import '../../../Widgets/TaiyakiSize.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SearchCellsState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    width: double.infinity,
    height: TaiyakiSize.height * 0.25,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    child: SearchTile(
      node: state.media!,
      onTap: () => dispatch(SearchCellsActionCreator.onAction()),
    ),
  );
}
