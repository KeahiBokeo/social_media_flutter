import 'dart:typed_data';

import 'package:social_media_flutter/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  @override
  Future<String?> uploadProfileImageMobile(String path, String filename) {
    // TODO: implement uploadProfileImageMobile
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String filename) {
    // TODO: implement uploadProfileImageWeb
    throw UnimplementedError();
  }
}
