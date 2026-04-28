import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadPostImage({
    required String userId,
    required String postId,
    required File file,
  }) async {
    final ref = _storage.ref('posts/$userId/$postId/main.jpg');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.ref.getDownloadURL();
  }

  Future<void> deletePostImage({
    required String userId,
    required String postId,
  }) async {
    try {
      await _storage.ref('posts/$userId/$postId/main.jpg').delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  /// Sube el avatar del usuario y devuelve la URL pública. Sobrescribe el
  /// archivo anterior si existe (mismo path).
  Future<String> uploadAvatar({
    required String userId,
    required File file,
  }) async {
    final ref = _storage.ref('avatars/$userId/avatar.jpg');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.ref.getDownloadURL();
  }
}
