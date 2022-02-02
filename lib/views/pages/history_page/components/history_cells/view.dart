import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/taiyaki_image.dart';
import '../../../../widgets/taiyaki_size.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    HistoryCellsState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () => dispatch(HistoryCellsActionCreator.onAction()),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
          height: TaiyakiSize.height * 0.17,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TaiyakiImage(
              url: state.historyModel?.coverImage,
              width: TaiyakiSize.height * 0.12,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.historyModel!.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                    maxLines: 2,
                  ),
                  Row(children: [
                    Text(state.historyModel!.sourceName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w200, fontSize: 13)),
                    // Text(/),
                  ])
                ],
              ),
            ))
          ])),
    ),
  );
}
