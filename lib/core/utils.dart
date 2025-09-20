import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> resizeImageBytes(Uint8List data, int width, int height) async {
  final image = img.decodeImage(data);
  if (image == null) return data;
  final resized = img.copyResize(image, width: width, height: height);
  return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
}