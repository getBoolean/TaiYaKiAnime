import 'package:flutter/material.dart';
import '../../models/taiyaki/detail_database.dart';
import 'taiyaki_size.dart';

class DetailBottomSheet extends StatelessWidget {
  final VoidCallback eraseLink;
  final IndividualSettingsModel individualSettingsModel;

  const DetailBottomSheet(
      {Key? key,
      required this.eraseLink,
      required this.individualSettingsModel})
      : super(key: key);

  final TextStyle _title =
      const TextStyle(fontWeight: FontWeight.w700, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TaiyakiSize.height * 0.25,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Material(
                  child: Text('Auto sync this anime', style: _title),
                ),
                Material(
                    child: Switch(
                        value: individualSettingsModel.autoSync,
                        onChanged: (val) {}))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: eraseLink,
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Text(
                  'Remove saved link',
                  style: _title,
                )),
          )
        ],
      ),
    );
  }
}
