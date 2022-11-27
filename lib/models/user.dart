import 'dart:convert';

class User {
  String id;
  String email;
  String username;
  String? name;
  String? displayPic;

  User({required this.id, required this.email, required this.username, required this.name, required this.displayPic});

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? name,
    String? displayPic,
  }) {
    return User(
        id: id ?? this.id,
        email: email ?? this.email,
        username: username ?? this.username,
        name: name ?? this.name,
        displayPic: displayPic ?? this.displayPic);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': name,
      'display_pic': displayPic,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      name: map['name'],
      displayPic: map['display_pic'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, email: $email, image: $displayPic)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id && other.email == email && other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ username.hashCode ^ name.hashCode ^ displayPic.hashCode;
}
