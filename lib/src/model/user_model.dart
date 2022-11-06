import 'package:codyo/src/constant/constant.dart';
import 'package:codyo/src/util/util.dart';

class User {
  int id;
  String avatarUrl;
  String name;
  String email;
  String phone;
  String password;
  int createdAt = 0;

  User({
    this.id = 0,
    this.avatarUrl = defaultImageUrl,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.createdAt = 0,
  });

  factory User.fromMap(dynamic data) {
    return User(
      id: data['id'],
      avatarUrl: data['avatarUrl'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      password: data['password'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toPostgres() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': Util.hashPassword(password),
      'avatarUrl': avatarUrl,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'User(id:$id, avatarUrl:$avatarUrl, name:$name, email:$email, phone:$phone, password:$password, createdAt:$createdAt)';
  }
}
