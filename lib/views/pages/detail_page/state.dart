import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../models/anilist/models.dart';
import '../../../models/myanimelist/models.dart';
import '../../../models/simkl/models.dart';
import '../../../models/taiyaki/detail_database.dart';
import '../../../utils/strings.dart';
import 'page.dart';

class DetailState implements Cloneable<DetailState> {
  late int id;
  late bool isMal;
  TabController? tabController;

  //Anilist
  AnilistNode? anilistData;
  //Simkl
  SimklNode? simklData;

  List<String> covers = [];

  //Cover Timer

  Timer? coverTimer;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MyAnimeListEntryModel? malEntryData;

  DetailDatabaseModel? _detailDatabaseModel;

  List<SimklEpisodeModel> episodes = [];

  final List<Tab> tabs = [
    const Tab(
      text: 'Overview',
    ),
    const Tab(
      text: 'Sync',
    ),
    const Tab(
      text: 'Watch',
    ),
    const Tab(text: 'Stats'),
    const Tab(text: 'Recommendations')
  ];

  //Overview State
  bool synopsisExpanded = false;

  DetailDatabaseModel? get detailDatabaseModel => _detailDatabaseModel;

  set setDetailDatabaseModel(DetailDatabaseModel? model) {
    _detailDatabaseModel = model;
    Hive.box<DetailDatabaseModel>(kHiveDetailBox)
        .put(model!.ids.anilist, model);
  }

  @override
  DetailState clone() {
    return DetailState()
      ..id = id
      ..tabController = tabController
      ..covers = covers
      ..coverTimer = coverTimer
      ..simklData = simklData
      ..anilistData = anilistData
      ..malEntryData = malEntryData
      .._detailDatabaseModel = _detailDatabaseModel
      ..episodes = episodes
      ..synopsisExpanded = synopsisExpanded;
  }
}

DetailState initState(DetailPageArguments args) {
  return DetailState()
    ..id = args.id
    ..isMal = args.isMal;
}
