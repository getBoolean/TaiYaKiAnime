import 'package:auto_size_text/auto_size_text.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../../Utils/strings.dart';
import '../../../../Widgets/TaiyakiSize.dart';
import '../../../../Widgets/taiyaki_image.dart';
import '../../action.dart';
import 'state.dart';

Widget buildView(
    QueueCellState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () =>
        dispatch(VideoActionCreator.setSimklEpisode(state.simklEpisodeModel!)),
    child: SizedBox(
        width: TaiyakiSize.width * 0.92,
        child: Card(
            child: Row(
          children: [
            TaiyakiImage(
              height: TaiyakiSize.height * 0.17,
              url: simklThumbnailGen(state.simklEpisodeModel?.thumbnail),
              width: TaiyakiSize.width * 0.35,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Episode ${state.simklEpisodeModel!.episode}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300)),
                            if (state.isPlaying)
                              const Icon(Icons.play_arrow_rounded,
                                  color: Colors.green, size: 15)
                          ],
                        ),
                      ),
                      AutoSizeText(
                        state.simklEpisodeModel!.title,
                        maxLines: 3,
                      ),
                    ]),
              ),
            )
          ],
        ))),
  );
}
