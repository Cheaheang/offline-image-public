import 'package:http/http.dart' as http;
import 'package:offline_image/imageModel.dart';

Future<bool> sendImageChunk(List<ImageModel> images) async {
  for (var image in images) {
    var response = await http.post(
      Uri.parse('https://yourapi.com/upload'),
      body: {'image': image.base64},
    );
    if (response.statusCode != 200) {
      return false;
    }
  }
  return true;
}
