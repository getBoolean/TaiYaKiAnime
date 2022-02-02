import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/taiyaki_image.dart';
import '../../../../widgets/taiyaki_size.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(RecommendationCellsState state, Dispatch dispatch,
    ViewService viewService) {
  return GestureDetector(
    onTap: () => dispatch(RecommendationCellsActionCreator.onAction()),
    child: Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaiyakiImage(
            url: state.media!.coverImage,
            height: TaiyakiSize.height * 0.22,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              state.media!.title,
              maxLines: 3,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    ),
  );
}
