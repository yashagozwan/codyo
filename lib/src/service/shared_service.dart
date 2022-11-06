import 'package:codyo/src/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  final _shared = SharedPreferences.getInstance();

  Future<bool> saveUserId(int userId) async {
    final shared = await _shared;
    final id = await shared.setInt('userId', userId);
    if (id) return true;
    return false;
  }

  Future<int?> getUserId() async {
    final shared = await _shared;
    final id = shared.getInt('userId');
    if (id != null) return id;
    return null;
  }

  Future<bool> removeUserId() async {
    final shared = await _shared;
    final userId = await getUserId();
    if (userId == null) return false;
    final id = await shared.remove('userId');
    if (id) return true;
    return false;
  }

  Future<bool> saveUser(User user) async {
    final shared = await _shared;
    final id = await shared.setInt('id', user.id);
    final avatarUrl = await shared.setString('avatarUrl', user.avatarUrl);
    final name = await shared.setString('name', user.name);
    final email = await shared.setString('email', user.email);
    final phone = await shared.setString('phone', user.phone);
    final password = await shared.setString('password', user.password);
    final createdAt = await shared.setInt('createdAt', user.createdAt);

    if (id && avatarUrl && name && email && phone && password && createdAt) {
      return true;
    }

    return false;
  }

  Future<User?> getLoggedInUser() async {
    final shared = await _shared;
    final id = shared.getInt('id');
    final avatarUrl = shared.getString('avatarUrl');
    final name = shared.getString('name');
    final email = shared.getString('email');
    final phone = shared.getString('phone');
    final password = shared.getString('password');
    final createdAt = shared.getInt('createdAt');

    if (id != null &&
        avatarUrl != null &&
        name != null &&
        email != null &&
        phone != null &&
        password != null &&
        createdAt != null) {
      return User(
        id: id,
        name: name,
        email: email,
        phone: phone,
        password: password,
        createdAt: createdAt,
      );
    }
  }

  Future<bool> removeUser() async {
    final user = await getLoggedInUser();
    if (user == null) return false;

    final shared = await _shared;
    final id = await shared.remove('id');
    final avatarUrl = await shared.remove('avatarUrl');
    final name = await shared.remove('name');
    final email = await shared.remove('email');
    final phone = await shared.remove('phone');
    final password = await shared.remove('password');
    final createdAt = await shared.remove('createdAt');

    if (id && avatarUrl && name && email && phone && password && createdAt) {
      return true;
    }

    return false;
  }
}
