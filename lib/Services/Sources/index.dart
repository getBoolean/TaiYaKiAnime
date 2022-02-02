import 'Base.dart';
import 'Gogoanime.dart';

final kTaiyakiSources = [GogoAnime()];

SourceBase nameToSourceBase(String name) {
  switch (name) {
    case 'GogoAnime':
      return GogoAnime();
    default:
      throw Exception('This source does not exist');
  }
}
