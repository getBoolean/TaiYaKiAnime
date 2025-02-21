import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../models/simkl/models.dart';
import '../../models/taiyaki/detail_database.dart';
import '../../models/taiyaki/trackers.dart';
import '../../services/sources/index.dart';
import '../../utils/strings.dart';
import '../pages/discovery_page/action.dart';
import 'taiyaki_notification_handler.dart';

class BackgroundTasks {
  static void backgroundFetchHeadlessTask(HeadlessTask task) async {
    void registerCheck() {
      if (Hive.isAdapterRegistered(1) == false) {
        Hive.registerAdapter(DetailDatabaseModelAdapter());
      }
      if (Hive.isAdapterRegistered(2) == false) {
        Hive.registerAdapter(LastWatchingModelAdapter());
      }
      if (Hive.isAdapterRegistered(3) == false) {
        Hive.registerAdapter(ThirdPartyBundleIdsAdapter());
      }
      if (Hive.isAdapterRegistered(4) == false) {
        Hive.registerAdapter(HistoryModelAdapter());
      }
      if (Hive.isAdapterRegistered(5) == false) {
        Hive.registerAdapter(SimklEpisodeModelAdapter());
      }
      if (Hive.isAdapterRegistered(6) == false) {
        Hive.registerAdapter(IndividualSettingsModelAdapter());
      }
    }

    final String taskId = task.taskId;
    final bool isTimeout = task.timeout;
    if (isTimeout) {
      // This task has exceeded its allowed running-time.
      // You must stop what you're doing and immediately .finish(taskId)
      debugPrint('[BackgroundFetch] Headless task timed-out: $taskId');
      BackgroundFetch.finish(taskId);
      await Hive.close();
      return;
    }
    debugPrint('[BackgroundFetch] Headless event received.');

    await Hive.initFlutter().then((value) {
      registerCheck();
      Hive.openBox<DetailDatabaseModel>(kHiveDetailBox).whenComplete(() =>
          BackgroundTasks()
              ._fetchForNewEpisodes(taskId)
              .whenComplete(() => Hive.close()));
    });
    await Hive.close();
    BackgroundFetch.finish(taskId);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static Future<void> init() async {
    await BackgroundFetch.registerHeadlessTask(
        BackgroundTasks.backgroundFetchHeadlessTask);
    final BackgroundFetchConfig _config = BackgroundFetchConfig(
      minimumFetchInterval: 60,
      enableHeadless: true,
      startOnBoot: true,
      stopOnTerminate: false,
    );
    await BackgroundFetch.configure(
        _config, BackgroundTasks()._fetchForNewEpisodes);
  }

  Future<void> _fetchForNewEpisodes(String taskID) async {
    final _box = Hive.box<DetailDatabaseModel>(kHiveDetailBox)
        .values
        .where((element) => (element.isFollowing ?? false) == true);

    for (var episodes in _box) {
      debugPrint(
          'Looking for new episodes: ${episodes.title}, has: ${episodes.episodeCount} episodes');
      final int _count = await nameToSourceBase(episodes.sourceName!)
          .getTotalEpisodesAvailable(episodes.link!);

      if ((episodes.episodeCount ?? 0) < _count) {
        debugPrint('new episode for: ${episodes.title}, found: $_count');
        final bigPicture = await _downloadAndSaveFile(
            episodes.coverImage, '${episodes.title}_big_picture.jpg');
        final BigPictureStyleInformation _bigPictureStyleInformation =
            BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicture),
          hideExpandedLargeIcon: true,
          contentTitle: episodes.title,
          summaryText:
              'Episode $_count is ready to watch on ${episodes.sourceName}',
        );
        if (episodes.ids.anilist != null) {
          NotificationHandler.showNotification(
              NotificationData(
                  message:
                      'Episode $_count is ready to watch on ${episodes.sourceName}',
                  title: episodes.title,
                  animeID: episodes.ids.anilist!),
              _bigPictureStyleInformation,
              attachment: IOSNotificationAttachment(bigPicture));

          episodes =
              episodes.copyWith(episodeCount: _count, notification: true);
          await Hive.box<DetailDatabaseModel>(kHiveDetailBox)
              .put(episodes.ids.anilist, episodes);
        }
      }
    }

    BackgroundFetch.finish(taskID);
  }
}
