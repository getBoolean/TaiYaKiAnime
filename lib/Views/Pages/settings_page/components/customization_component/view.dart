import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../../Utils/misc.dart';
import '../../../../Widgets/TaiyakiSize.dart';
import '../../action.dart';
import 'state.dart';

Widget buildView(CustomizationSettingState state, Dispatch dispatch,
    ViewService viewService) {
  return Scaffold(
    body: ListView(
      children: [
        SwitchListTile.adaptive(
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.border_color),
            value: state.appSettingsModel!.isDarkMode,
            onChanged: (val) => dispatch(SettingsActionCreator.onUpdateSetting(
                state.appSettingsModel!.copyWith(isDarkMode: val)))),
        const ListTile(
          title: Text('Accent'),
          leading: Icon(Icons.edit_outlined),
        ),
        SizedBox(
          height: TaiyakiSize.height * 0.15,
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: taiyakiAccentColors.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: () => dispatch(SettingsActionCreator.onUpdateSetting(
                      state.appSettingsModel!
                          .copyWith(accent: taiyakiAccentColors[index]))),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          Color(int.parse('0xff${taiyakiAccentColors[index]}')),
                    ),
                  )),
            ),
          ),
        )
      ],
    ),
  );
}
