import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import '../exceptions/api/exceptions_plus_api.dart';
import 'base.dart';

class GogoAnime implements SourceBase {
  @override
  Future<List<SourceEpisodeHostsModel>> getEpisodeHosts(
      String episodeLink) async {
    final _response = await request.get(episodeLink);
    return parse(_response.data)
        .querySelector('div.anime_muti_link')!
        .querySelectorAll('li')
        .sublist(1)
        .map((e) {
      final name = e.className;
      String link = e.querySelector('a')!.attributes['data-video']!;
      if (!link.startsWith('http')) link = 'https:' + link;
      return SourceEpisodeHostsModel(host: name, hostLink: link);
    }).toList();
  }

  @override
  Future<List<String>> getEpisodeLinks(String episodeLink) async {
    final _response = await request.get(episodeLink);
    final _$ = parse(_response.data);
    final _slug = Uri.parse(episodeLink).pathSegments.last;
    final int? _totalEpisodes = int.tryParse(_$
        .querySelectorAll('div.anime_video_body > #episode_page > li')
        .last
        .querySelector('a')!
        .attributes['ep_end']!);
    if (_totalEpisodes == null) {
      throw SourceException(
          error: 'Could not fetch the last episode, html may be broken');
    }
    final List<String> episodeBox = [];
    for (var i = 0; i < _totalEpisodes; i++) {
      episodeBox.add(
          request.options.baseUrl + '/' + _slug + '-episode-${i + 1}');
    }
    return episodeBox;
  }

  @override
  Future<List<SourceSearchResultsModel>> getSearchResults(String query) async {
    final _response = await request
        .get('/search.html', queryParameters: {'keyword': query});
    if (_response.statusCode != 200) {
      throw SourceException(
          error: 'The server returned a 400. Could not get information');
    }

    return parse(_response.data)
        .querySelectorAll('div.last_episodes > ul.items > li')
        .map((e) {
      final String title = e.querySelector('a')!.attributes['title']!;
      final String link = e.querySelector('a')!.attributes['href']!;
      final String image = e.querySelector('img')!.attributes['src']!;
      return SourceSearchResultsModel(
          title: title,
          link: request.options.baseUrl + link,
          image: image);
    }).toList();
  }

  @override
  Future<int> getTotalEpisodesAvailable(String link) async {
    final _episodesCount = await getEpisodeLinks(link);
    return _episodesCount.length;
  }

  @override
  String get name => 'GogoAnime';

  @override
  Dio get request => Dio(BaseOptions(baseUrl: 'https://www1.gogoanime.ai'));

  @override
  SourceInfo get info => SourceInfo(developer: 'Taiyaki');

  @override
  void dispose() {
    request.close(force: true);
  }

  @override
  bool get usesCloudflare => false;
}
