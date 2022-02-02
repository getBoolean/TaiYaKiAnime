import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'overview_component/component.dart';
import 'overview_component/state.dart';
import 'recommendation_component/component.dart';
import 'recommendation_component/state.dart';
import 'reducer.dart';
import 'state.dart';
import 'stats_component/component.dart';
import 'stats_component/state.dart';
import 'sync_component/component.dart';
import 'sync_component/state.dart';
import 'view.dart';
import 'watch_component/component.dart';
import 'watch_component/state.dart';

class DetailPageArguments {
  final int id;
  final bool isMal;

  DetailPageArguments({required this.id, this.isMal = false});
}

class DetailPage extends Page<DetailState, DetailPageArguments>
    with TickerProviderMixin {
  DetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DetailState>(
              adapter: null,
              slots: <String, Dependent<DetailState>>{
                'overview_tab': OverviewConnector() + OverviewComponent(),
                'sync_tab': SyncConnector() + SyncComponent(),
                'watch_tab': WatchTabConnector() + WatchComponent(),
                'stats_tab': StatsConnector() + StatsComponent(),
                'recommendation_tab':
                    RecommendationConnector() + RecommendationComponent(),
              }),
          middleware: <Middleware<DetailState>>[],
        );
}
