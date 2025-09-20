import 'package:flutter/foundation.dart';
import '../../domain/repositories/file_repository.dart';
import '../../domain/entities/app_file.dart';
import '../../domain/repositories/auth_repository.dart';

class FileProvider extends ChangeNotifier {
  final FileRepository repository;
  final AuthRepository authRepository;
  List<AppFile> files = [];
  double uploadProgress = 0.0;
  bool loading = false;
  String? error;

  FileProvider(this.repository, this.authRepository);

  Future<void> fetchFiles() async {
    loading = true;
    notifyListeners();
    try {
      files = await repository.listFiles();
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  Future<AppFile?> upload(Uint8List bytes, String filename, String contentType) async {
    uploadProgress = 0;
    notifyListeners();
    try {
      final appFile = await repository.uploadFile(bytes, filename, contentType, (p) {
        uploadProgress = p;
        notifyListeners();
      });
      files.insert(0, appFile);
      uploadProgress = 0;
      notifyListeners();
      return appFile;
    } catch (e) {
      error = e.toString();
      uploadProgress = 0;
      notifyListeners();
      return null;
    }
  }

  Future<Uint8List> download(String url) async {
    return await repository.downloadFile(url);
  }

  Future<Uint8List> preview(String url, int w, int h) async {
    return await repository.getResizedPreview(url, w, h);
  }
}