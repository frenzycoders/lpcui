class User {
  String id;
  String name;
  String username;
  String email;
  String password;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
  });

  User.fromJSON(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        email = json['email'],
        username = json['username'],
        password = json['password'];
}
