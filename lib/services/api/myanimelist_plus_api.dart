import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotenv/dotenv.dart' show env;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/myanimelist/models.dart';
import '../../models/taiyaki/sync.dart';
import '../../models/taiyaki/trackers.dart';
import '../../models/taiyaki/user.dart';
import '../../store/global_user_store/global_user_action.dart';
import '../../store/global_user_store/global_user_store.dart';
import '../../utils/strings.dart';
import '../exceptions/api/exceptions_plus_api.dart';
import 'base_plus_api.dart';

class _Bearer {
  final String accessToken;
  final String refreshToken;
  final int expiry;

  _Bearer(
      {required this.accessToken,
      required this.expiry,
      required this.refreshToken});

  factory _Bearer.fromJson(Map<String, dynamic> json) => _Bearer(
      accessToken: json['access_token'],
      expiry: json['expires_in'],
      refreshToken: json['refresh_token']);
}

class MyAnimeListUserlistModel {
  final _ListStatus status;
  final _Node node;

  MyAnimeListUserlistModel(this.status, this.node);

  factory MyAnimeListUserlistModel.fromJson(Map<String, dynamic> json) =>
      MyAnimeListUserlistModel(_ListStatus.fromJson(json['list_status']),
          _Node.fromJson(json['node']));
}

class _ListStatus {
  final String status;
  final int score, numWatched;

  _ListStatus(this.status, this.score, this.numWatched);

  factory _ListStatus.fromJson(Map<String, dynamic> json) =>
      _ListStatus(json['status'], json['score'], json['num_episodes_watched']);
}

class _Node {
  final int id, episodes;
  final String title, image;

  _Node(this.id, this.title, this.image, this.episodes);

  factory _Node.fromJson(Map<String, dynamic> json) => _Node(
      json['id'],
      json['title'],
      json['main_picture']['large'] ?? json['main_picture']['medium'],
      json['num_episodes']);
}

class MyAnimeListAPI with OauthLoginHandler implements BaseTracker {
  final clientId = Platform.isIOS
      ? 'MYANIMELIST_CLIENT_IOS_ID'
      : 'MYANIMELIST_CLIENT_ANDROID_ID';
  late final Dio _request = Dio(BaseOptions(
      baseUrl: 'https://api.myanimelist.net/v2',
      contentType: Headers.jsonContentType))
    ..interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          final _tokens = GlobalUserStore.store.getState().myanimelistUser;
          if (_tokens?.accessToken != null) {
            if (DateTime.now().difference(_tokens!.expiresIn!).inMinutes <= 0) {
              final _newToken = await refreshTokens(_tokens.refreshToken!);
              options.headers.addAll({'Authorization': 'Bearer ' + _newToken});
            } else {
              options.headers
                  .addAll({'Authorization': 'Bearer ' + _tokens.accessToken});
            }
          }

          return handler.next(options);
        },
      ),
    );

  @override
  Future<UpdateModel> login() async {
    const _storage = FlutterSecureStorage();
    final String challenge = getRandString(100);
    final Uri _authEndpoint = Uri(
        scheme: 'https',
        host: 'myanimelist.net',
        path: '/v1/oauth2/authorize',
        queryParameters: {
          'response_type': 'code',
          'client_id': env[clientId],
          'redirect_uri': 'taiyaki://myanimelist/redirect',
          'code_challenge_method': 'plain',
          'code_challenge': challenge
        });

    final Uri _tokenEndpoint =
        Uri.parse('https://myanimelist.net/v1/oauth2/token');

    const String _redirectEndpoint = 'taiyaki://myanimelist/redirect';

    final _tempCode = await obtainCode(_authEndpoint);
    
    if (_tempCode == null) {
      throw APIException(message: 'Could not obtain the code from MyAnimeList');
    }

    final _code = Uri.parse(_tempCode).queryParameters['code'];

    final _tokenResponse = await Dio().postUri(_tokenEndpoint,
        data: {
          'client_id': env[clientId],
          'grant_type': 'authorization_code',
          'code': _code,
          'redirect_uri': _redirectEndpoint,
          'code_verifier': challenge,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));

    if (_tokenResponse.statusCode == 200) {
      final _Bearer _bearer = _Bearer.fromJson(_tokenResponse.data);
      final UserModel model = UserModel(
          accessToken: _bearer.accessToken,
          refreshToken: _bearer.refreshToken,
          expiresIn: DateTime.now().add(
            Duration(seconds: _bearer.expiry),
          ));
      final UpdateModel updateModel = UpdateModel(
          model: model, tracker: ThirdPartyTrackersEnum.myanimelist);

      await Future.sync(() => GlobalUserStore.store
          .dispatch(GlobalUserActionCreator.onUpdateUser(updateModel)));

      await _storage
          .write(key: 'myanimelist', value: json.encode(model.toMap()))
          .whenComplete(() => getProfile());

      return updateModel;
    } else {
      throw APIException(message: 'Could not grab the access token from MAL');
    }
  }

  @override
  Future<SyncModel> syncProgress(int id, SyncModel syncModel) async {
    final Map<String, dynamic> data = {};
    if (syncModel.progress != null) {
      data.addAll({'num_watched_episodes': syncModel.progress});
    }
    if (syncModel.status != null && syncModel.status != 'Not in List') {
      data.addAll({'status': SyncModel.convertToMAL(syncModel.status)});
    }
    if (syncModel.score != null) data.addAll({'score': syncModel.score});

    final _response = await _request.put('/anime/$id/my_list_status',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    final MyAnimeListEntryModel _model =
        MyAnimeListEntryModel.fromJson(_response.data);
    return SyncModel(
        progress: _model.numWatchedEpisodes,
        status: _model.status,
        score: _model.score,
        episodes: syncModel.episodes);
  }

  @override
  Future getProfile() async {
    final _response = await _request.get('/users/@me');
    final MyAnimeListUserModel model =
        MyAnimeListUserModel.fromJson(_response.data);

    final UserModel _user = GlobalUserStore.store
        .getState()
        .myanimelistUser!
        .copyWith(username: model.name, avatar: model.avatar, id: model.id);

    await storage
        .write(key: 'myanimelist', value: json.encode(_user.toMap()))
        .whenComplete(() => GlobalUserStore.store.dispatch(
            GlobalUserActionCreator.onUpdateUser(UpdateModel(
                model: _user, tracker: ThirdPartyTrackersEnum.myanimelist))));
  }

  Future<MyAnimeListEntryModel> getEntryModel(int id) async {
    final _response = await _request
        .get('/anime/$id', queryParameters: {'fields': 'my_list_status'});
    final MyAnimeListEntryModel _entryModel =
        _response.data['my_list_status'] != null
            ? MyAnimeListEntryModel.fromJson(_response.data['my_list_status'])
            : MyAnimeListEntryModel();
    return _entryModel;
  }

  //Refreshes the token and returns the new accessToken if required
  Future<String> refreshTokens(String refreshToken) async {
    final Uri _tokenEndpoint =
        Uri.parse('https://myanimelist.net/v1/oauth2/token');

    final _tokens = await Dio().postUri(_tokenEndpoint,
        data: {
          'grant_type': 'refresh_token',
          'client_id': env[clientId],
          'refresh_token': refreshToken
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));

    final _Bearer _bearer = _Bearer.fromJson(_tokens.data);

    final UserModel model =
        GlobalUserStore.store.getState().myanimelistUser!.copyWith(
            accessToken: _bearer.accessToken,
            refreshToken: _bearer.refreshToken,
            expiresIn: DateTime.now().add(
              Duration(seconds: _bearer.expiry),
            ));
    final UpdateModel updateModel =
        UpdateModel(model: model, tracker: ThirdPartyTrackersEnum.myanimelist);

    await storage
        .write(key: 'myanimelist', value: json.encode(model.toMap()))
        .whenComplete(() => GlobalUserStore.store
            .dispatch(GlobalUserActionCreator.onUpdateUser(updateModel)));

    return _bearer.accessToken;
  }

  @override
  Future<List<AnimeListModel>> getAnimeList() async {
    final _response = await _request.get('/users/@me/animelist',
        queryParameters: {
          'sort': 'list_updated_at',
          'limit': 1000,
          'fields': 'list_status,num_episodes'
        });
    final List<MyAnimeListUserlistModel> myAnimeListUserlistModel =
        List<MyAnimeListUserlistModel>.from(_response.data['data']
            .map((i) => MyAnimeListUserlistModel.fromJson(i))
            .toList());
    final List<AnimeListModel> list = myAnimeListUserlistModel
        .map((e) => AnimeListModel(
            title: e.node.title,
            status: _myanimelistToNative(e.status.status),
            coverImage: e.node.image,
            id: e.node.id,
            progress: e.status.numWatched,
            score: (e.status.score).toDouble(),
            totalEpisodes: e.node.episodes))
        .toList();
    GlobalUserStore.store.dispatch(GlobalUserActionCreator.onUpdateUserList(
        list, ThirdPartyTrackersEnum.myanimelist));
    return list;
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: 'myanimelist');
    GlobalUserStore.store.dispatch(
        GlobalUserActionCreator.removeUser(ThirdPartyTrackersEnum.myanimelist));
  }
}

String _myanimelistToNative(String status) {
  switch (status) {
    case 'watching':
      return 'Watching';
    case 'plan_to_watch':
      return 'Plan to Watch';
    case 'completed':
      return 'Completed';
    case 'on_hold':
      return 'On Hold';
    case 'dropped':
      return 'Dropped';
    default:
      return status;
  }
}
