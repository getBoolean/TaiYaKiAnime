import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/taiyaki_size.dart';

import 'state.dart';

Widget buildView(Card1State state, Dispatch dispatch, ViewService viewService) {
  return Card(
      margin: EdgeInsets.fromLTRB(8.0, TaiyakiSize.height * 0.08, 8.0, 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Transform.translate(
              offset: Offset(0, -TaiyakiSize.height * 0.06),
              child: CircleAvatar(
                  foregroundImage: state.user!.avatar != null
                      // ignore: unnecessary_cast
                      ? (NetworkImage(state.user!.avatar!) as ImageProvider)
                      : const AssetImage('assets/icon.png'),
                  radius: 50),
            ),
            Transform.translate(
              offset: Offset(0, -TaiyakiSize.height * 0.03),
              child: Column(
                children: [
                  Text(state.user!.username!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17)),
                ],
              ),
            ),
          ],
        ),
      ));
}
