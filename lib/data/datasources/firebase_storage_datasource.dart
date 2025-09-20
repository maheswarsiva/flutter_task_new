import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Reference _userFolderRef(String uid) => _storage.ref().child('uploads').child(uid);

  Future<TaskSnapshot> uploadBytesWithProgress(String uid, String filename, Uint8List data, SettableMetadata metadata, Function(double) onProgress) async {
    final ref = _userFolderRef(uid).child(filename);
    final uploadTask = ref.putData(data, metadata);
    uploadTask.snapshotEvents.listen((snapshot) {
      final denom = snapshot.totalBytes == 0 ? 1 : snapshot.totalBytes;
      final prog = snapshot.bytesTransferred / denom;
      try {
        onProgress(prog);
      } catch (_) {}
    });
    final snapshot = await uploadTask;
    return snapshot;
  }

  Future<List<Reference>> listFiles(String uid) async {
    final ref = _userFolderRef(uid);
    final result = await ref.listAll();
    return result.items;
  }

  Future<Uint8List> downloadUrlAsBytes(String url) async {
    final ref = _storage.refFromURL(url);
    final data = await ref.getData(10 * 1024 * 1024); // 10MB limit
    return data ?? Uint8List(0);
  }
  
}