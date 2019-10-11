class User {
  String token;
  String username;
  String nick;
  User({
    this.token,this.username,this.nick
  });

  static User fromJson(Map<String, dynamic> json){
    return User(
      token: json['token'],
      username: json['user']['username'],
      nick:json['user']['nick'],
    );
  }
}