import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:offline_image/getX.dart';
import 'package:offline_image/imageModel.dart';

bool isOdd(int number) {
  return number % 2 != 0;
}

Future<String> sendImageChunk(task_key, List<ImageModel> images) async {
  callCounter cnt = Get.put(callCounter());
  String result_key = task_key;
  //String? data;
  for (var image in images) {
    var response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/products/'),
      body: {'image': image.base64},
    );
    if (response.statusCode != 200) {
      return "";
    }
    //data = jsonDecode(response.body);
  }
  //print("data from api" + data.toString());
  cnt.count++;
  if (isOdd(cnt.count)) result_key = "";
  return result_key;
}
