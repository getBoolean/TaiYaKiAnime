import '../models/taiyaki/trackers.dart';
import '../models/taiyaki/user.dart';
import '../store/global_user_store/global_user_store.dart';

UserModel mapTrackerToUser(ThirdPartyTrackersEnum tracker) {
  switch (tracker) {
    case ThirdPartyTrackersEnum.anilist:
      return GlobalUserStore.store.getState().anilistUser!;
    case ThirdPartyTrackersEnum.myanimelist:
      return GlobalUserStore.store.getState().myanimelistUser!;
    case ThirdPartyTrackersEnum.simkl:
      return GlobalUserStore.store.getState().simklUser!;
  }
}

String mapTrackerToAsset(ThirdPartyTrackersEnum tracker) {
  switch (tracker) {
    case ThirdPartyTrackersEnum.myanimelist:
      return 'assets/images/mal_icon.png';
    case ThirdPartyTrackersEnum.simkl:
      return 'assets/images/simkl_icon.png';
    case ThirdPartyTrackersEnum.anilist:
      return 'assets/images/anilist_icon.png';
  }
}

const taiyakiAccentColors = [
  'ffbe0b',
  'fb5607',
  'ff006e',
  '8338ec',
  '3a86ff',
  '08bdbd',
  '29bf12',
  '5f0f40',
  '0f4c5c',
  '9a031e',
  '4361ee',
  '4f000b',
  'ff7f51',
];
