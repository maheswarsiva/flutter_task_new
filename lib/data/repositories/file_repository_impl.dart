import '../../domain/repositories/file_repository.dart';
import '../datasources/firebase_storage_datasource.dart';
import '../../domain/entities/app_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../../domain/repositories/auth_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FirebaseStorageDataSource datasource;
  final AuthRepository authRepository;
  FileRepositoryImpl(this.datasource, this.authRepository);

  @override
  Future<AppFile> uploadFile(Uint8List bytes, String filename, String contentType, Function(double) onProgress) async {
    try {
      final uid = authRepository.getCurrentUserId();
      if (uid == null) {
        throw Exception('User not authenticated');
      }
      final meta = SettableMetadata(contentType: contentType);
      final snapshot = await datasource.uploadBytesWithProgress(uid, filename, bytes, meta, onProgress);
      final ref = snapshot.ref;
      final url = await ref.getDownloadURL();
      final metaRemote = await ref.getMetadata();
      return AppFile(id: ref.name, name: filename, url: url, contentType: metaRemote.contentType ?? contentType, size: metaRemote.size ?? bytes.length);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AppFile>> listFiles() async {
    try {
      final uid = authRepository.getCurrentUserId();
      if (uid == null) throw Exception('User not authenticated');
      final items = await datasource.listFiles(uid);
      final list = <AppFile>[];
      for (final ref in items) {
        final url = await ref.getDownloadURL();
        final meta = await ref.getMetadata();
        list.add(AppFile(id: ref.name, name: ref.name, url: url, contentType: meta.contentType ?? 'application/octet-stream', size: meta.size ?? 0));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Uint8List> downloadFile(String url) async {
    try {
      final uid = authRepository.getCurrentUserId();
      if (uid == null) throw Exception('User not authenticated');
      return await datasource.downloadUrlAsBytes(url);
    } catch (e) {
      rethrow;
    }
  }

 @override
Future<Uint8List> getResizedPreview(String url, int width, int height) async {
  try {
    // Just get the full image bytes, no resizing
    final bytes = await datasource.downloadUrlAsBytes(url);
    return bytes;
  } catch (e) {
    rethrow;
  }
}
}