import 'dart:async';
import 'dart:convert';

import 'package:dotenv/dotenv.dart' as dot_env;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/simkl/models.dart';
import 'models/taiyaki/detail_database.dart';
import 'models/taiyaki/settings.dart';
import 'models/taiyaki/trackers.dart';
import 'models/taiyaki/user.dart';
import 'services/api/anilist_plus_api.dart';
import 'services/api/myanimelist_plus_api.dart';
import 'services/api/simkl_plus_api.dart';
import 'store/global_settings_store/global_settings_action.dart';
import 'store/global_settings_store/global_settings_store.dart';
import 'store/global_user_store/global_user_action.dart';
import 'store/global_user_store/global_user_store.dart';
import 'utils/strings.dart';
import 'views/app.dart';
import 'views/widgets/taiyaki_background_tasks.dart';
import 'views/widgets/taiyaki_notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  dot_env.load();
  await _initApp();

  runApp(const CreateApp());
}

Future<void> _initApp() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  const _storage = FlutterSecureStorage();

  final _passedOnboarding = await _storage.read(key: 'onboarding');
  if (_passedOnboarding != null) {
    GlobalUserStore.store
        .dispatch(GlobalUserActionCreator.onUpdateOnboarding());
  }

  await Hive.initFlutter();

  final _anilist = await _storage.read(key: 'anilist');
  if (_anilist != null) {
    final UserModel _anilistUser = UserModel.fromJson(json.decode(_anilist));
    GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUser(
        UpdateModel(
            model: _anilistUser, tracker: ThirdPartyTrackersEnum.anilist)));
    await AnilistAPI().getProfile().whenComplete(() => AnilistAPI()
        .getAnimeList()
        .whenComplete(() => Timer(const Duration(minutes: 10),
            () async => AnilistAPI().getFollowersActivity())));
  }

  final _mal = await _storage.read(key: 'myanimelist');
  if (_mal != null) {
    final UserModel _malUser = UserModel.fromJson(json.decode(_mal));
    GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUser(
        UpdateModel(
            model: _malUser, tracker: ThirdPartyTrackersEnum.myanimelist)));
    await MyAnimeListAPI()
        .getProfile()
        .whenComplete(() => MyAnimeListAPI().getAnimeList());
  }

  final _simkl = await _storage.read(key: 'simkl');
  if (_simkl != null) {
    final UserModel _simklUser = UserModel.fromJson(json.decode(_simkl));
    GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUser(
        UpdateModel(model: _simklUser, tracker: ThirdPartyTrackersEnum.simkl)));
    await SimklAPI()
        .getProfile()
        .whenComplete(() => SimklAPI().getAnimeList());
  }

  Hive.registerAdapter(DetailDatabaseModelAdapter());
  Hive.registerAdapter(LastWatchingModelAdapter());
  Hive.registerAdapter(ThirdPartyBundleIdsAdapter());
  Hive.registerAdapter(HistoryModelAdapter());
  Hive.registerAdapter(SimklEpisodeModelAdapter());
  Hive.registerAdapter(IndividualSettingsModelAdapter());
  Hive.registerAdapter(AppSettingsModelAdapter());

  await Hive.openBox<HistoryModel>(kHiveHistoryBox);
  await Hive.openBox<DetailDatabaseModel>(kHiveDetailBox);

  await Hive.openBox<AppSettingsModel>(kHiveSettingsBox);

  final _settingsBox = Hive.box<AppSettingsModel>(kHiveSettingsBox);
  if (_settingsBox.isNotEmpty) {
    final AppSettingsModel? _settings = _settingsBox.get('settings');
    if (_settings != null) {
      GlobalSettingsStore.store
          .dispatch(GlobalSettingsActionCreator.onUpdateSettings(_settings));
    }
  }

  GlobalSettingsStore.store.observable().listen((event) async {
    await Hive.box<AppSettingsModel>(kHiveSettingsBox)
        .put('settings', event.appSettings);
  });

  await NotificationHandler.init();
  await BackgroundTasks.init();

  // await Hive.deleteBoxFromDisk(HIVE_SETTINGS_BOX);

  // await Hive.box<HistoryModel>(HIVE_HISTORY_BOX).deleteFromDisk();
}
