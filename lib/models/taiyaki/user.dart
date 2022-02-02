class UserModel {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresIn;

  final String? username;
  final String? avatar;
  final String? background;
  final int? id;

  UserModel(
      {required this.accessToken,
      this.refreshToken,
      this.expiresIn,
      this.username,
      this.avatar,
      this.background,
      this.id});

  UserModel copyWith(
          {String? accessToken,
          String? refreshToken,
          DateTime? expiresIn,
          String? username,
          String? avatar,
          String? background,
          int? id}) =>
      UserModel(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        expiresIn: expiresIn ?? this.expiresIn,
        username: username ?? this.username,
        background: background ?? this.background,
        avatar: avatar ?? this.avatar,
        id: id ?? this.id,
      );

  Map<String, dynamic> toMap() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresIn': expiresIn?.toString(),
        'username': username,
        'background': background,
        'avatar': avatar,
        'id': id,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        accessToken: json['accessToken'],
        refreshToken:
            json['refreshToken'],
        expiresIn: (json['expiresIn'] != null && json['expiresIn'] != 'null')
            ? DateTime.parse(json['expiresIn'])
            : null,
        username: json['username'],
        avatar: json['avatar'],
        id: json['id'],
        background: json['background'],
      );
}
