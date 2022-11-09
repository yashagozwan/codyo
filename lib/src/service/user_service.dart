import 'package:codyo/src/constant/constant.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show FileOptions, PostgrestException;

class UserService {
  Future<User> getUserById(int userId) async {
    try {
      final dynamicUser =
          await supabase.from('users').select().eq('id', userId).single();
      final user = User.fromMap(dynamicUser);
      return user;
    } on PostgrestException {
      rethrow;
    }
  }

  Future<String> uploadAvatar(XFile xFile) async {
    try {
      final fileBytes = await xFile.readAsBytes();
      final fileExt = xFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = fileName;

      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            fileBytes,
            fileOptions: FileOptions(contentType: xFile.mimeType),
          );

      return supabase.storage.from('avatars').getPublicUrl(filePath);
    } on PostgrestException {
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await supabase
          .from('users')
          .update(user.toPostgresUpdate())
          .eq('id', user.id);
    } on PostgrestException {
      rethrow;
    }
  }
}
