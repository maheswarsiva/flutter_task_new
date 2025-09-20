import '../repositories/file_repository.dart';
import '../entities/app_file.dart';
import 'dart:typed_data';

class FileUseCases {
  final FileRepository repository;
  FileUseCases(this.repository);

  Future<AppFile> upload(Uint8List bytes, String filename, String contentType, Function(double) onProgress) => repository.uploadFile(bytes, filename, contentType, onProgress);
  Future<List<AppFile>> list() => repository.listFiles();
  Future<Uint8List> download(String url) => repository.downloadFile(url);
  Future<Uint8List> preview(String url, int w, int h) => repository.getResizedPreview(url, w, h);
  
}