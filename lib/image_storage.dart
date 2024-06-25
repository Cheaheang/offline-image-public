import 'dart:convert';
import 'dart:ui';
import 'package:offline_image/imageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ImageStorage {
  static const String imgSendTasksKey = 'img_send_tasks';

  // static Future<void> saveImageChunks(List<ImageModel> images) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<List<ImageModel>> chunks = [];
  //   for (int i = 0; i < images.length; i += 5) {
  //     chunks.add(
  //         images.sublist(i, i + 5 > images.length ? images.length : i + 5));
  //   }

  //   List<String> jsonChunks = chunks
  //       .map((chunk) => jsonEncode(chunk.map((img) => img.toJson()).toList()))
  //       .toList();
  //   await prefs.setStringList(imgSendTasksKey, jsonChunks);
  // }

  static Future<String> saveImageChunks(List<ImageModel> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Generate a UUID to use as a key for the chunks
    String uuidKey = Uuid().v4();

    // Split images into chunks of 5
    List<List<ImageModel>> chunks = [];
    for (int i = 0; i < images.length; i += 5) {
      chunks.add(
          images.sublist(i, i + 5 > images.length ? images.length : i + 5));
    }

    // Convert each chunk to JSON format
    List<String> jsonChunks = chunks
        .map((chunk) => jsonEncode(chunk.map((img) => img.toJson()).toList()))
        .toList();

    // Save JSON chunks to SharedPreferences using the UUID key
    await prefs.setStringList(uuidKey, jsonChunks);
    print(uuidKey);
    print(jsonChunks);
    // Optionally return the UUID key for later retrieval
    return uuidKey;
  }

  static Future<List<List<ImageModel>>> getImageChunks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonChunks = prefs.getStringList(imgSendTasksKey) ?? [];
    return jsonChunks
        .map((chunk) => (jsonDecode(chunk) as List)
            .map((img) => ImageModel.fromJson(img))
            .toList())
        .toList();
  }

  static Future<void> removeImageChunk(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonChunks = prefs.getStringList(imgSendTasksKey) ?? [];
    if (index < jsonChunks.length) {
      jsonChunks.removeAt(index);
      await prefs.setStringList(imgSendTasksKey, jsonChunks);
    }
  }
}
