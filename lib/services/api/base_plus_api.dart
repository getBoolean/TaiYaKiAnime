import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import '../../models/taiyaki/sync.dart';
import '../../store/global_user_store/global_user_action.dart';

abstract class BaseTracker {
  Future<UpdateModel> login();

  Future<void> logout();

  Future<SyncModel> syncProgress(int id, SyncModel syncModel);

  Future getProfile();

  Future<List<AnimeListModel>> getAnimeList();
}

class OauthLoginHandler {
  // void openBrowser(BuildContext context, Uri uri) {
  //   showCupertinoModalBottomSheet(
  //       context: context, builder: (context) => OauthWebview(uri: uri));
  // }

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> obtainCode(Uri uri) async {
    try {
      final _result = await FlutterWebAuth.authenticate(
          url: uri.toString(), callbackUrlScheme: 'taiyaki');
      return _result;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
