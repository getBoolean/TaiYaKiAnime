import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Store/GlobalUserStore/GlobalUserAction.dart';
import '../../../Store/GlobalUserStore/GlobalUserStore.dart';
import '../../Widgets/bottom_navigation.dart';
import 'action.dart';
import 'state.dart';

Effect<OnboardingState> buildEffect() {
  return combineEffects(<Object, Effect<OnboardingState>>{
    OnboardingAction.action: _onAction,
    Lifecycle.initState: _onInit,
    OnboardingAction.moveToPage: _moveToPage,
    OnboardingAction.openDiscord: _openDiscord,
    OnboardingAction.dismissOnboarding: _dismissOnboarding,
  });
}

void _onAction(Action action, Context<OnboardingState> ctx) {}

void _dismissOnboarding(Action action, Context<OnboardingState> ctx) async {
  const _storage = FlutterSecureStorage();
  await _storage.write(key: 'onboarding', value: '1');
  GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateOnboarding());
  await Navigator.of(ctx.context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => const TaiyakiBottomNavigation()));
}

void _openDiscord(Action action, Context<OnboardingState> ctx) async {
  final _discordURI = Uri(scheme: 'https', host: 'discord.gg', path: '8fzmNSB');
  await launch(_discordURI.toString());
}

void _moveToPage(Action action, Context<OnboardingState> ctx) {
  final int? page = action.payload;
  final int currentPage = (ctx.state.pageController?.page?.ceil() ?? 0);
  if (page != null) {
    ctx.state.pageController?.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  } else {
    ctx.state.pageController?.animateToPage(currentPage + 1,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}

void _onInit(Action action, Context<OnboardingState> ctx) {
  ctx.addObservable(GlobalUserStore.store.subscribe);
  ctx.state.pageController = PageController(
    keepPage: true,
  );
}
