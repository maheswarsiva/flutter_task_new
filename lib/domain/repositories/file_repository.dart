import '../entities/app_file.dart';
import 'dart:typed_data';

abstract class FileRepository {
  Future<AppFile> uploadFile(Uint8List bytes, String filename, String contentType, Function(double) onProgress);
  Future<List<AppFile>> listFiles();
  Future<Uint8List> downloadFile(String url);
  Future<Uint8List> getResizedPreview(String url, int width, int height);
  
}