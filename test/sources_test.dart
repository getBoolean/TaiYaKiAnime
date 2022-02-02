import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taiyaki/services/sources/base.dart';
import 'package:taiyaki/services/sources/gogoanime.dart';

const String _searchQuery = 'Kono Subarashii Sekai ni Shukufuku wo!';

late SourceBase base;

void main() async {
  //IMPORTANT
  //Input your custom made Source here;
  setUp(() => base = GogoAnime());

  test('Should return a search result', () async {
    final List<SourceSearchResultsModel> _searchResults =
        await base.getSearchResults(_searchQuery);
    if (_searchResults.isEmpty) {
      fail(
          "No results were returned from the search query. You could try a custom anime title, if its a new website and doesn't contain the popular anime mentioned above");
    }

    final _isValidLink = _searchResults.isNotEmpty &&
        (_searchResults.first.link).startsWith('http');

    expect(_isValidLink, true);
    debugPrint('PASSED SEARCH TEST');
  });

  test('Should return a list of all episodes', () async {
    //Must replace with a proper episode link you can use one from the source through the website itself
    const String episodeLink =
        'https://www1.gogoanime.ai/category/kono-subarashii-sekai-ni-shukufuku-wo-';
    final episodes = await base.getEpisodeLinks(episodeLink);

    expect(episodes.length, greaterThanOrEqualTo(1));

    final bool _isValid = episodes.isNotEmpty &&
        episodes.first.isNotEmpty;
    expect(_isValid, true);

    debugPrint('PASSED EPISODE LINKS TEST');
  });

  test('Should return at least one host on the corresponding source', () async {
    //Must replace with a proper episode link you can use one from the source through the website itself
    const String episodeLink =
        'https://www1.gogoanime.ai/kono-subarashii-sekai-ni-shukufuku-wo--episode-1';

    final _hosts = await base.getEpisodeHosts(episodeLink);
    expect(_hosts.length, greaterThan(0));
    final _isValidHost = _hosts.first.host.isNotEmpty &&
        _hosts.first.hostLink.startsWith('http');
    expect(_isValidHost, true);
    debugPrint(_hosts.first.hostLink);
    debugPrint('PASSED HOSTS TEST');
  });
}
