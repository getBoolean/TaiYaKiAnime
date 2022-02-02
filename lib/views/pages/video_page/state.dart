import 'package:better_player/better_player.dart';
import 'package:fish_redux/fish_redux.dart';
import '../../../models/simkl/models.dart';
import '../../../models/taiyaki/detail_database.dart';
import '../../../services/hosts/base.dart';
import '../../../services/sources/base.dart';

import 'page.dart';

class VideoState implements Cloneable<VideoState> {
  bool isFullscreen = false;
  DetailDatabaseModel? detailDatabaseModel;
  SimklEpisodeModel? episode;

  List<SimklEpisodeModel> playlist = [];

  bool synopsisExpanded = false;
  bool isPlaylistVisible = false;

  // FijkPlayer? playerController;
  BetterPlayerController? videoController;

  List<SourceEpisodeHostsModel> allAvailableHosts = [];
  List<HostsLinkModel> allAvailableQualities = [];

  SourceEpisodeHostsModel? currentSelectedHost;
  HostsLinkModel? currentSelectedQuality;

  @override
  VideoState clone() {
    return VideoState()
      ..isPlaylistVisible = isPlaylistVisible
      ..playlist = playlist
      ..videoController = videoController
      ..synopsisExpanded = synopsisExpanded
      ..isFullscreen = isFullscreen
      ..detailDatabaseModel = detailDatabaseModel
      ..episode = episode
      ..allAvailableHosts = allAvailableHosts
      ..allAvailableQualities = allAvailableQualities
      ..currentSelectedHost = currentSelectedHost
      ..currentSelectedQuality = currentSelectedQuality;
  }
}

VideoState initState(VideoPageArguments args) {
  return VideoState().clone()
    ..episode = args.episode
    ..detailDatabaseModel = args.databaseModel
    ..playlist = args.playlist;
}
