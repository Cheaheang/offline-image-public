import 'dart:convert';
import 'dart:typed_data';

class ImageModel {
  final String base64;

  ImageModel(this.base64);

  // Converts an ImageModel instance to a JSON object
  Map<String, dynamic> toJson() => {
        'base64': base64,
      };

  // Creates an ImageModel instance from a JSON object
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(json['base64'] as String);
  }

  Future<Uint8List> readAsByteAsync() async {
    return base64Decode(base64);
  }
}
