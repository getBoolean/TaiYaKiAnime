import 'base.dart';
import 'gogoanime.dart';

final kTaiyakiSources = [GogoAnime()];

SourceBase nameToSourceBase(String name) {
  switch (name) {
    case 'GogoAnime':
      return GogoAnime();
    default:
      throw Exception('This source does not exist');
  }
}
