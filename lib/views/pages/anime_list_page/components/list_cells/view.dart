import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/taiyaki_image.dart';
import '../../../../widgets/taiyaki_size.dart';
import '../../action.dart';
import 'state.dart';

Widget buildView(
    ListCellState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
      onTap: () =>
          dispatch(AnimeListActionCreator.moveToDetail(state.model!.id)),
      child: Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Row(children: [
            TaiyakiImage(
                url: state.model?.coverImage,
                width: TaiyakiSize.width * 0.2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(state.model!.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                        maxLines: 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${state.model!.progress} / ${(state.model?.totalEpisodes ?? '??')}'),
                              if (state.model!.score != null &&
                                  state.model!.score != 0.0)
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.orange),
                                    Text(state.model!.score!
                                        .toStringAsFixed(0))
                                  ],
                                )
                            ],
                          ),
                          if (state.model?.totalEpisodes != null)
                            LinearProgressIndicator(
                              value: (state.model!.progress) /
                                  state.model!.totalEpisodes!,
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ])));
}
