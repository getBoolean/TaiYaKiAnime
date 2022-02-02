import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../store/global_settings_store/global_settings_store.dart';
import '../store/global_user_store/global_user_store.dart';
import 'routes.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/theme.dart';

class CreateApp extends StatefulWidget {
  const CreateApp({Key? key}) : super(key: key);

  @override
  _CreateAppState createState() => _CreateAppState();
}

class _CreateAppState extends State<CreateApp> {
  bool _isDark = GlobalSettingsStore.store.getState().appSettings.isDarkMode;
  String _accent = GlobalSettingsStore.store.getState().appSettings.accent;

  @override
  void initState() {
    GlobalSettingsStore.store.observable().listen((event) {
      final _isDarkS = event.appSettings;
      if (_isDarkS.isDarkMode != _isDark) {
        setState(() => _isDark = _isDarkS.isDarkMode);
      }
      if (_isDarkS.accent != _accent) {
        setState(() => _accent = _isDarkS.accent);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Color(int.parse('0xff$_accent'));
    const bgColor = Color(0xff121212);
    const cardColor = Color(0xff1D1D1D);
    const bottomNavbarColor = Color(0xff1f1f1f);

    return MaterialApp(
      theme: _isDark
          ? ThemeData.dark().copyWith(
              cardColor: cardColor,
              scaffoldBackgroundColor: bgColor,
              dialogBackgroundColor: bgColor,
              appBarTheme: const AppBarTheme(
                color: bgColor,
                elevation: 0.0,
              ),
              cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: bottomNavbarColor,
                type: BottomNavigationBarType.fixed,
                elevation: 8.0,
                showSelectedLabels: true,
                showUnselectedLabels: false,
              ),
              indicatorColor: accent,
              toggleableActiveColor: accent,
              primaryColor: accent,
              brightness: Brightness.dark,
              colorScheme: darkColorScheme(_accent),
              textTheme:
                  GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme))
          : ThemeData.light().copyWith(
              indicatorColor: ThemeData.light().scaffoldBackgroundColor,
              primaryColor: accent,
              toggleableActiveColor: accent,
              brightness: Brightness.light,
              cardTheme: CardTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              colorScheme: lightColorScheme(_accent),
              textTheme:
                  GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)),
      // home: TaiyakiBottomNavigation(),
      home: GlobalUserStore.store.getState().passedOnboarding
          ? const TaiyakiBottomNavigation()
          : routes.buildPage('onboarding_page', null),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          return routes.buildPage(settings.name, settings.arguments);
        });
      },
    );
  }
}
