import '../../domain/entities/app_file.dart';

class AppFileModel extends AppFile {
  AppFileModel({required super.id, required super.name, required super.url, required super.contentType, required super.size});

  factory AppFileModel.fromRef(String id, String name, String url, String contentType, int size) {
    return AppFileModel(id: id, name: name, url: url, contentType: contentType, size: size);
  }
}