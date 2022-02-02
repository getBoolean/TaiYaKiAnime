import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import '../../action.dart';

import 'state.dart';

Widget buildView(
    GeneralComponentState state, Dispatch dispatch, ViewService viewService) {
  final _settings = state.appSettingsModel!;

  return Scaffold(
    body: ListView(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Blur spoilers'),
          secondary: const Icon(Icons.blur_circular),
          subtitle: const Text('Blur out unwatched episodes'),
          value: _settings.blurSpoilers,
          onChanged: (val) {
            debugPrint('the value $val');
            dispatch(SettingsActionCreator.onUpdateSetting(
                _settings.copyWith(blurSpoilers: val)));
          },
        ),
        SwitchListTile.adaptive(
          title: const Text('Auto play next episode'),
          value: _settings.autoChange100,
          onChanged: (val) => dispatch(SettingsActionCreator.onUpdateSetting(
              _settings.copyWith(autoChange100: val))),
          secondary: const Icon(Icons.queue_play_next),
          subtitle:
              const Text('Change to the next episode when the current one finishes'),
        ),
      ],
    ),
  );
}
