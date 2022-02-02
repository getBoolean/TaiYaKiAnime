import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/anim_list_status_cards.dart';
import '../../../../widgets/taiyaki_size.dart';
import '../../action.dart';
import 'state.dart';

Widget buildView(Card2State state, Dispatch dispatch, ViewService viewService) {
  final _watchingList =
      state.animeList.where((element) => element.status == 'Watching');
  final _planningList =
      state.animeList.where((element) => element.status == 'Planning');
  final _completedList =
      state.animeList.where((element) => element.status == 'Completed');
  final _holdList =
      state.animeList.where((element) => element.status == 'On Hold');
  final _droppedList =
      state.animeList.where((element) => element.status == 'Dropped');

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Card(
        child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            height: TaiyakiSize.height * 0.32,
            width: TaiyakiSize.width * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Watch List',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                      Text('${state.animeList.length} total items')
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: state.animeList.isNotEmpty
                        ? ListView(scrollDirection: Axis.horizontal,
                            // itemExtent: TaiyakiSize.height * 0.25,
                            children: [
                                if (_watchingList.isNotEmpty)
                                  AnimeListStatusCards(
                                      statusName: 'Watching',
                                      onTap: () => dispatch(
                                          ProfileActionCreator.moveToList(
                                              _watchingList.toList())),
                                      data: _watchingList.toList()),
                                if (_planningList.isNotEmpty)
                                  AnimeListStatusCards(
                                      statusName: 'Planning',
                                      onTap: () => dispatch(
                                          ProfileActionCreator.moveToList(
                                              _planningList.toList())),
                                      data: _planningList.toList()),
                                if (_completedList.isNotEmpty)
                                  AnimeListStatusCards(
                                      onTap: () => dispatch(
                                          ProfileActionCreator.moveToList(
                                              _completedList.toList())),
                                      statusName: 'Completed',
                                      data: _completedList.toList()),
                                if (_holdList.isNotEmpty)
                                  AnimeListStatusCards(
                                      onTap: () => dispatch(
                                          ProfileActionCreator.moveToList(
                                              _holdList.toList())),
                                      statusName: 'On Hold',
                                      data: _holdList.toList()),
                                if (_droppedList.isNotEmpty)
                                  AnimeListStatusCards(
                                      onTap: () => dispatch(
                                          ProfileActionCreator.moveToList(
                                              _droppedList.toList())),
                                      statusName: 'Dropped',
                                      data: _droppedList.toList()),
                              ])
                        : const Center(
                            child: Text('There is no anime list to see here',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ))),
  );
}
