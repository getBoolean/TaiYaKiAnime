class MyAnimeListUserModel {
  final int id;
  final String name;
  final String? avatar;

  MyAnimeListUserModel({required this.id, this.avatar, required this.name});

  factory MyAnimeListUserModel.fromJson(Map<String, dynamic> json) =>
      MyAnimeListUserModel(
          id: json['id'], name: json['name'], avatar: json['picture']);
}

class MyAnimeListEntryModel {
  final String? status;
  final int? score;
  final int numWatchedEpisodes;

  MyAnimeListEntryModel(
      {this.status, this.score, this.numWatchedEpisodes = 0});
  factory MyAnimeListEntryModel.fromJson(Map<String, dynamic> json) =>
      MyAnimeListEntryModel(
        numWatchedEpisodes: json['num_episodes_watched'],
        status: json['status'],
        score: json['score'],
      );
}
