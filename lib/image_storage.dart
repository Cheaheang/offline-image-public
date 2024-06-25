import 'dart:convert';
import 'dart:ui';
import 'package:offline_image/imageModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ImageStorage {
  // static const String imgSendTasksKey = 'img_send_tasks';
  static const String offlineImagesKey = 'offline_images';
  static final Uuid uuid = Uuid();
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

  static void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(offlineImagesKey);
  }

  static Future<List<String>> getTaskKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> existingUUIDs = prefs.getStringList(offlineImagesKey) ?? [];
    return existingUUIDs;
  }

  static Future<String> saveImageChunks(List<ImageModel> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> existingUUIDs = prefs.getStringList(offlineImagesKey) ?? [];

    // Split images into chunks of 5
    List<List<ImageModel>> chunks = createChunks(images, 5);

    for (var chunk in chunks) {
      String uuidKey = uuid.v4();
      String jsonChunk = jsonEncode(chunk.map((img) => img.toJson()).toList());

      // Save JSON chunk to SharedPreferences using the UUID key
      await prefs.setString(uuidKey, jsonChunk);

      // Add the UUID key to the list
      existingUUIDs.add(uuidKey);
    }

    // Save the updated list of UUID keys to SharedPreferences
    await prefs.setStringList(offlineImagesKey, existingUUIDs);

    print("image chunk saved => ${existingUUIDs}");
    print("all images ${jsonEncode(prefs.getStringList(offlineImagesKey))}");
    return existingUUIDs.join(", ");
  }

  static List<List<ImageModel>> createChunks(
      List<ImageModel> images, int chunkSize) {
    List<List<ImageModel>> chunks = [];
    for (int i = 0; i < images.length; i += chunkSize) {
      int end = (i + chunkSize < images.length) ? i + chunkSize : images.length;
      chunks.add(images.sublist(i, end));
    }
    return chunks;
  }

  // static Future<List<List<ImageModel>>> getImageChunks() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> jsonChunks = prefs.getStringList(imgSendTasksKey) ?? [];
  //   return jsonChunks
  //       .map((chunk) => (jsonDecode(chunk) as List)
  //           .map((img) => ImageModel.fromJson(img))
  //           .toList())
  //       .toList();
  // }

  static Future<List<List<ImageModel>>> getImageChunks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> uuidKeys = prefs.getStringList(offlineImagesKey) ?? [];

    List<List<ImageModel>> imageChunks = [];
    for (var uuidKey in uuidKeys) {
      String? jsonChunk = prefs.getString(uuidKey);
      if (jsonChunk != null) {
        List<dynamic> decodedChunk = jsonDecode(jsonChunk);
        List<ImageModel> imageChunk =
            decodedChunk.map((img) => ImageModel.fromJson(img)).toList();
        imageChunks.add(imageChunk);
      }
    }

    return imageChunks;
  }

  // static Future<void> removeImageChunk(int index) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> jsonChunks = prefs.getStringList(imgSendTasksKey) ?? [];
  //   if (index < jsonChunks.length) {
  //     jsonChunks.removeAt(index);
  //     await prefs.setStringList(imgSendTasksKey, jsonChunks);
  //   }
  // }

  static Future<void> removeImageChunk(String uuidKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> uuidKeys = prefs.getStringList(offlineImagesKey) ?? [];

    if (uuidKeys.contains(uuidKey)) {
      uuidKeys.remove(uuidKey);
      await prefs.remove(uuidKey);
      await prefs.setStringList(offlineImagesKey, uuidKeys);
      print("Removed chunk id : ${uuidKey}");
    }
  }
}
