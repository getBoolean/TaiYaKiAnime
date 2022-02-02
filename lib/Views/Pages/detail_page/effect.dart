import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../Models/Anilist/models.dart';
import '../../../Models/Taiyaki/DetailDatabase.dart';
import '../../../Models/Taiyaki/Trackers.dart';
import '../../../Services/API/Anilist+API.dart';
import '../../../Services/API/MyAnimeList+API.dart';
import '../../../Services/API/SIMKL+API.dart';
import '../../../Services/Sources/index.dart';
import '../../../Store/GlobalUserStore/GlobalUserStore.dart';
import '../../../Utils/strings.dart';
import '../../Widgets/detail_bottom_sheet.dart';

import 'action.dart';
import 'state.dart';

Effect<DetailState> buildEffect() {
  return combineEffects(<Object, Effect<DetailState>>{
    DetailAction.action: _onAction,
    DetailAction.fetchLocalDatabase: _fetchLocalDatabase,
    Lifecycle.initState: _onInit,
    DetailAction.fetchSimklEpisodes: _onFetchSimklEpisodes,
    DetailAction.initTempDatabase: _initEmptyDatabase,
    DetailAction.showSnack: _showSnack,
    DetailAction.showBottomSheet: _showBottomSheet,
    DetailAction.fetchTrackers: _fetchTrackers,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<DetailState> ctx) {}

void _onDispose(Action action, Context<DetailState> ctx) {
  ctx.state.coverTimer?.cancel();
}

void _showBottomSheet(Action action, Context<DetailState> ctx) {
  showCupertinoModalBottomSheet(
      context: ctx.context,
      expand: false,
      builder: (BuildContext context) => DetailBottomSheet(
            individualSettingsModel:
                ctx.state.detailDatabaseModel!.individualSettingsModel!,
            eraseLink: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Remove source link?',
                      ),
                      content: const Text(
                          'This will not affect your progress or tracking data'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              final _ctx = ctx.state.detailDatabaseModel!;
                              ctx.dispatch(
                                  DetailActionCreator.udpateDetailDatabase(
                                      DetailDatabaseModel(
                                          title: _ctx.title,
                                          coverImage: _ctx.coverImage,
                                          ids: _ctx.ids,
                                          episodeProgress: _ctx.episodeProgress,
                                          lastWatchingModel:
                                              _ctx.lastWatchingModel)));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Confirm')),
                      ],
                    );
                  });
            },
          ));
}

void _showSnack(Action action, Context<DetailState> ctx) {
  final SnackDetail snack = action.payload;
  ScaffoldMessenger.of(ctx.context).showSnackBar(
    SnackBar(
      content: Text(snack.message,
          style: TextStyle(color: snack.isError ? Colors.white : null)),
      backgroundColor: snack.isError ? Colors.redAccent : null,
      duration: const Duration(milliseconds: 4450),
    ),
  );
}

void _onInit(Action action, Context<DetailState> ctx) async {
  final dynamic _ticker = ctx.stfState;
  ctx.state.tabController =
      TabController(length: ctx.state.tabs.length, vsync: _ticker);

  final AnilistNode data = await AnilistAPI().getDetailData(ctx.state.id,
      idMal: ctx.state.isMal ? ctx.state.id : null);
  ctx.dispatch(DetailActionCreator.updateAnilistData(data));
  ctx.dispatch(
      DetailActionCreator.updateCovers(data.bannerImage ?? data.coverImage));
  ctx.state.coverTimer = Timer.periodic(const Duration(seconds: 20),
      (timer) => ctx.dispatch(DetailActionCreator.switchCovers()));
  ctx.dispatch(DetailActionCreator.fetchDetailDatabase());
  ctx.dispatch(DetailActionCreator.initTempDatabase());

  if (ctx.state.detailDatabaseModel != null &&
      (ctx.state.detailDatabaseModel!.ids.anilist == null ||
          ctx.state.detailDatabaseModel!.ids.myanimelist == null)) {
    ctx.dispatch(DetailActionCreator.udpateDetailDatabase(
        ctx.state.detailDatabaseModel!.copyWith(
            ids: ctx.state.detailDatabaseModel!.ids
              ..anilist = data.id
              ..myanimelist = data.idMal)));
  }

  if (ctx.state.detailDatabaseModel != null &&
      ctx.state.detailDatabaseModel!.ids.simkl == null) {
    try {
      final _simklID = await SimklAPI().fetchSimklID(data.idMal);
      if (_simklID != null) {
        ctx.dispatch(DetailActionCreator.udpateDetailDatabase(
            ctx.state.detailDatabaseModel!.copyWith(
                ids: ctx.state.detailDatabaseModel!.ids..simkl = _simklID)));
      }

      await SimklAPI().fetchSimklData(_simklID!).then((data) {
        if (data.fanart != null) {
          ctx.dispatch(DetailActionCreator.updateCovers(data.fanart!));
        }
        return ctx.dispatch(DetailActionCreator.onUpdateSimklData(data));
      });
    } catch (error) {
      ctx.dispatch(DetailActionCreator.showSnackMessage(
          SnackDetail(message: error.toString(), isError: true)));
    }
  }

  ctx.dispatch(DetailActionCreator.fetchTrackers());

  //Fetches link if database has a link
}

void _fetchTrackers(Action action, Context<DetailState> ctx) {
  if (GlobalUserStore.store.getState().anilistUser != null) {
    AnilistAPI().getMediaList(ctx.state.id).then((value) {
      return ctx.dispatch(DetailActionCreator.updateAnilistData(
          ctx.state.anilistData!..mediaListEntryModel = value));
    });
  }

  if (GlobalUserStore.store.getState().myanimelistUser != null) {
    MyAnimeListAPI()
        .getEntryModel(ctx.state.detailDatabaseModel!.ids.myanimelist!)
        .then((value) =>
            ctx.dispatch(DetailActionCreator.updateMALEntryData(value)));
  }

  if (GlobalUserStore.store.getState().simklUser != null) {
    // MyAnimeListAPI().getEntryModel(data.idMal).then(
    //         (value) => ctx.dispatch(DetailActionCreator.updateMALEntryData(value)));
  }
}

void _fetchLocalDatabase(Action action, Context<DetailState> ctx) {
  final _box = Hive.box<DetailDatabaseModel>(HIVE_DETAIL_BOX);
  if (_box.isNotEmpty) {
    final _storageData = _box.get(ctx.state.id);

    if (_storageData != null) {
      ctx.dispatch(DetailActionCreator.udpateDetailDatabase(_storageData));
      if (_storageData.link != null && ctx.state.episodes.isEmpty) {
        ctx.dispatch(
            DetailActionCreator.fetchSimklEpisodes(_storageData.link!));
      }
    }
  }
}

void _initEmptyDatabase(Action action, Context<DetailState> ctx) {
  if (ctx.state.detailDatabaseModel != null) {
    if ((ctx.state.detailDatabaseModel?.totalEpisodes ?? 0) == 0 &&
        (ctx.state.anilistData?.episodes ?? 0) > 0) {
      final _newDatabase = ctx.state.detailDatabaseModel!
          .copyWith(totalEpisodes: ctx.state.anilistData!.episodes);
      ctx.dispatch(DetailActionCreator.udpateDetailDatabase(_newDatabase));
    }
    return;
  }
  final _data = ctx.state.anilistData!;

  final _newDatabase = DetailDatabaseModel(
      title: _data.title,
      coverImage: _data.coverImage,
      totalEpisodes: _data.episodes ?? 0,
      ids: ThirdPartyBundleIds(anilist: _data.id, myanimelist: _data.idMal));
  ctx.dispatch(DetailActionCreator.udpateDetailDatabase(_newDatabase));
}

void _onFetchSimklEpisodes(Action action, Context<DetailState> ctx) async {
  final String _link = action.payload;
  if (ctx.state.detailDatabaseModel?.sourceName == null) return;

  final int? _simklID = ctx.state.detailDatabaseModel!.ids.simkl;
  if (_simklID == null) return;
  await SimklAPI().fetchSimklData(_simklID).then((data) {
    if (data.fanart != null) {
      ctx.dispatch(DetailActionCreator.updateCovers(data.fanart!));
    }
    return ctx.dispatch(DetailActionCreator.onUpdateSimklData(data));
  });

  final _episodes = await SimklAPI().fetchSimklEpisodes(_simklID);
  final _sourceEpisodes =
      await nameToSourceBase(ctx.state.detailDatabaseModel!.sourceName!)
          .getEpisodeLinks(_link);
  for (var i = 0; i < _sourceEpisodes.length; i++) {
    _episodes[i] = _episodes[i].copyWith(link: _sourceEpisodes[i]);
  }
  final _filteredEpisodes = _episodes.where((element) => element.link != null);
  ctx.dispatch(DetailActionCreator.udpateDetailDatabase(ctx
      .state.detailDatabaseModel!
      .copyWith(episodeCount: _filteredEpisodes.length)));
  ctx.dispatch(
      DetailActionCreator.updateSimklEpisodes(_filteredEpisodes.toList()));
}
