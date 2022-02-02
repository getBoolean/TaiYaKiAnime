import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../models/taiyaki/sync.dart';
import '../../models/taiyaki/trackers.dart';
import '../../services/api/anilist_plus_api.dart';
import '../../services/api/myanimelist_plus_api.dart';
import '../../services/api/simkl_plus_api.dart';

import 'taiyaki_size.dart';

class UpdatePage extends StatefulWidget {
  final int id;
  final ThirdPartyTrackersEnum? tracker;
  final ThirdPartyBundleIds? bulkIds;
  final SyncModel syncModel;

  final Function(SyncModel?) onUpdateAnilist;
  final Function(SyncModel?) onUpdateMAL;
  final Function(SyncModel?) onUpdateSimkl;

  const UpdatePage(
      {Key key = const ValueKey('update_page'),
      required this.id,
      this.tracker,
      this.bulkIds,
      required this.onUpdateAnilist,
      required this.onUpdateMAL,
      required this.onUpdateSimkl,
      required this.syncModel})
      : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late String currentStatus = widget.syncModel.status!;
  late int currentProgress = widget.syncModel.progress ?? 0;

  double? _score;

  @override
  void initState() {
    _score = (widget.syncModel.score ?? 0).toDouble();
    super.initState();
  }

  bool isUpdating = false;

  Future<void> _onUpdate(SyncModel syncModel) async {
    setState(() => isUpdating = true);
    if (widget.tracker == ThirdPartyTrackersEnum.anilist ||
        widget.bulkIds?.anilist != null) {
      final updatedModel = await AnilistAPI()
          .syncProgress(widget.bulkIds?.anilist ?? widget.id, syncModel);
      widget.onUpdateAnilist(updatedModel);
      // return updatedModel;
    }
    if (widget.tracker == ThirdPartyTrackersEnum.myanimelist ||
        widget.bulkIds?.myanimelist != null) {
      final updatedModel = await MyAnimeListAPI()
          .syncProgress(widget.bulkIds?.myanimelist ?? widget.id, syncModel);
      widget.onUpdateMAL(updatedModel);
      // return updatedModel;
    }
    if (widget.tracker == ThirdPartyTrackersEnum.simkl ||
        widget.bulkIds?.simkl != null) {
      final updatedModel = await SimklAPI()
          .syncProgress(widget.bulkIds?.simkl ?? widget.id, syncModel);
      widget.onUpdateSimkl(updatedModel);
    } else {
      return;
    }
    // throw new APIException(message: 'No valid tracker to update progress to');
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle subTitle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 21,
    );

    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status', style: subTitle),
                Text(widget.syncModel.status ?? 'Not in List'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        child: ChoiceChip(
                            selected: currentStatus == 'Watching',
                            onSelected: (value) =>
                                setState(() => currentStatus = 'Watching'),
                            label: const Text('Watching'))),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        child: ChoiceChip(
                            selected: currentStatus == 'Plan to Watch',
                            onSelected: (value) =>
                                setState(() => currentStatus = 'Plan to Watch'),
                            label: const Text('Plan to Watch'))),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        child: ChoiceChip(
                            selected: currentStatus == 'Completed',
                            onSelected: (value) {
                              setState(() {
                                currentStatus = 'Completed';
                                currentProgress =
                                    widget.syncModel.episodes ?? 12;
                              });
                            },
                            label: const Text('Completed'))),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        child: ChoiceChip(
                            selected: currentStatus == 'On Hold',
                            onSelected: (value) =>
                                setState(() => currentStatus = 'On Hold'),
                            label: const Text('On Hold'))),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 4.0),
                        child: ChoiceChip(
                            selected: currentStatus == 'Dropped',
                            onSelected: (value) =>
                                setState(() => currentStatus = 'Dropped'),
                            label: const Text('Dropped'))),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress', style: subTitle),
                Text('Episode ${widget.syncModel.progress ?? 0}')
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () => setState(() {
                      if (widget.syncModel.episodes == 0) {
                        currentProgress += 1;
                      } else if ((currentProgress + 1) <=
                          (widget.syncModel.episodes ?? double.infinity)) {
                        currentProgress += 1;
                      }
                    }),
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_upward, size: 24),
                    padding: const EdgeInsets.all(16),
                  ),
                  Text(
                      '$currentProgress / ${widget.syncModel.episodes ?? '??'}',
                      style: subTitle),
                  MaterialButton(
                    onPressed: () => setState(() {
                      if (currentProgress - 1 >= 0) currentProgress -= 1;
                    }),
                    color: Theme.of(context).colorScheme.secondaryVariant,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_downward, size: 24),
                    padding: const EdgeInsets.all(16),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Score', style: subTitle),
                Text(widget.syncModel.score.toString()),
              ],
            ),
            SfSlider(
              onChanged: (value) => setState(() => _score = value),
              value: _score,
              showDivisors: true,
              max: 10.0,
              min: 0.0,
              showTicks: true,
              labelFormatterCallback: (s, value) => s.ceil().toInt().toString(),
            ),
            SizedBox(
              height: TaiyakiSize.height * 0.3,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: TaiyakiSize.width * 0.9,
                height: TaiyakiSize.height * 0.06,
                child: ElevatedButton(
                    onPressed: isUpdating
                        ? null
                        : () {
                            _onUpdate(SyncModel(
                                    progress: currentProgress,
                                    status: currentStatus))
                                .then((value) =>
                                    setState(() => isUpdating = false))
                                .whenComplete(
                                    () => Navigator.of(context).pop());
                          },
                    child: Text(isUpdating ? 'Updating...' : 'Update',
                        style: const TextStyle(fontWeight: FontWeight.w600))),
              ),
            )
          ],
        ),
      )),
    );
  }
}
