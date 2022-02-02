import 'dart:async';
import 'dart:convert';

import 'package:dotenv/dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Models/SIMKL/models.dart';
import 'Models/Taiyaki/DetailDatabase.dart';
import 'Models/Taiyaki/Settings.dart';
import 'Models/Taiyaki/Trackers.dart';
import 'Models/Taiyaki/User.dart';
import 'Services/API/Anilist+API.dart';
import 'Services/API/MyAnimeList+API.dart';
import 'Services/API/SIMKL+API.dart';
import 'Store/GlobalSettingsStore/GlobalSettingsAction.dart';
import 'Store/GlobalSettingsStore/GlobalSettingsStore.dart';
import 'Store/GlobalUserStore/GlobalUserAction.dart';
import 'Store/GlobalUserStore/GlobalUserStore.dart';
import 'Utils/strings.dart';
import 'Views/Widgets/TaiyakiBackgroundTasks.dart';
import 'Views/Widgets/TaiyakiNotificationHandler.dart';
import 'Views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DotEnv.load();
  await _initApp();

  runApp(CreateApp());
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

  await Hive.openBox<HistoryModel>(HIVE_HISTORY_BOX);
  await Hive.openBox<DetailDatabaseModel>(HIVE_DETAIL_BOX);

  await Hive.openBox<AppSettingsModel>(HIVE_SETTINGS_BOX);

  final _settingsBox = Hive.box<AppSettingsModel>(HIVE_SETTINGS_BOX);
  if (_settingsBox.isNotEmpty) {
    final AppSettingsModel? _settings = _settingsBox.get('settings');
    if (_settings != null) {
      GlobalSettingsStore.store
          .dispatch(GlobalSettingsActionCreator.onUpdateSettings(_settings));
    }
  }

  GlobalSettingsStore.store.observable().listen((event) async {
    await Hive.box<AppSettingsModel>(HIVE_SETTINGS_BOX)
        .put('settings', event.appSettings);
  });

  await NotificationHandler.init();
  await BackgroundTasks.init();

  // await Hive.deleteBoxFromDisk(HIVE_SETTINGS_BOX);

  // await Hive.box<HistoryModel>(HIVE_HISTORY_BOX).deleteFromDisk();
}
