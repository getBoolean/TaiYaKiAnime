import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../widgets/taiyaki_size.dart';

import 'state.dart';

Widget buildView(
    AnimeListState state, Dispatch dispatch, ViewService viewService) {
  final _adapter = viewService.buildAdapter();
  return Scaffold(
      appBar: AppBar(
          title: Text(
        state.list.first.status,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      )),
      body: ListView.builder(
        itemExtent: TaiyakiSize.height * 0.15,
        itemBuilder: _adapter.itemBuilder,
        itemCount: _adapter.itemCount,
      ));
}
