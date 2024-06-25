import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:offline_image/imageModel.dart';

Future<bool> sendImageChunk(List<ImageModel> images) async {
  String? data;
  for (var image in images) {
    var response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/products/'),
      body: {'image': image.base64},
    );
    if (response.statusCode != 200) {
      return false;
    }
    data = jsonDecode(response.body);
  }
  print("data from api" + data.toString());
  return true;
}
