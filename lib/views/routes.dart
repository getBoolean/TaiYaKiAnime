// ignore: import_of_legacy_library_into_null_safe
import 'package:fish_redux/fish_redux.dart';

import '../store/global_user_store/global_user_state.dart';
import '../store/global_user_store/global_user_store.dart';
import 'pages/anime_list_page/page.dart';
import 'pages/detail_page/page.dart';
import 'pages/discovery_page/page.dart';
import 'pages/downloads_page/page.dart';
import 'pages/history_page/page.dart';
import 'pages/onboarding_page/page.dart';
import 'pages/profile_page/page.dart';
import 'pages/search_page/page.dart';
import 'pages/settings_page/page.dart';
import 'pages/video_page/page.dart';

final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      'anime_list_page': AnimeListPage(),
      'discovery_page': DiscoveryPage(),
      'detail_page': DetailPage(),
      'downloads_page': DownloadsPage(),
      'history_page': HistoryPage(),
      'onboarding_page': OnboardingPage(),
      'profile_page': ProfilePage(),
      'settings_page': SettingsPage(),
      'search_page': SearchPage(),
      'video_page': VideoPage(),
    },
    visitor: (String path, Page<Object, dynamic> page) {
      /// 只有特定的范围的 Page 才需要建立和 AppStore 的连接关系
      /// 满足 Page<T> ，T 是 GlobalBaseState 的子类
      if (page.isTypeof<GlobalUserBaseState>()) {
        /// 建立 AppStore 驱动 PageStore 的单向数据连接
        /// 1. 参数1 AppStore
        /// 2. 参数2 当 AppStore.state 变化时, PageStore.state 该如何变化
        page.connectExtraStore<GlobalUserState>(GlobalUserStore.store,
            (dynamic pageState, GlobalUserState appState) {
          final GlobalUserBaseState p = pageState;
          if (p.anilistUser != appState.anilistUser ||
              p.simklUser != appState.simklUser ||
              p.myanimelistUser != appState.myanimelistUser) {
            if (pageState is Cloneable) {
              final dynamic copy = pageState.clone();
              final GlobalUserBaseState newState = copy;
              newState.myanimelistUser = appState.myanimelistUser;
              newState.simklUser = appState.simklUser;
              newState.anilistUser = appState.anilistUser;
              return newState;
            }
          }
          return pageState;
        });
      }
    });
