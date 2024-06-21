import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_image/ImageUploadController.dart';
import 'package:offline_image/connectivity.dart';
import 'package:offline_image/imageModel.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ImageUploadController controller = Get.put(ImageUploadController());

  // Future<void> pickImages() async {
  //   final ImagePicker picker = ImagePicker();
  //   final List<XFile> images = await picker.pickMultiImage();
  //   if (images != null && images.isNotEmpty) {
  //     List<ImageModel> imageModels = images
  //         .map((image) async {
  //           final bytes = await image.readAsBytes();
  //           final base64String = base64Encode(bytes);

  //           print("${ImageModel(base64String).runtimeType}");
  //           return ImageModel(base64String);
  //         })
  //         .cast<ImageModel>()
  //         .toList();

  //     await controller.addImageChunks(imageModels);
  //     controller.uploadImages();
  //   }
  // }
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      List<ImageModel> imageModels = [];
      for (XFile image in images) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        imageModels.add(ImageModel(base64String));
      }

      await controller.addImageChunks(imageModels);
      controller.uploadImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Uploader')),
      body: Center(
        child: ElevatedButton(
          onPressed: pickImages,
          child: Text('Upload Images'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Simulate network connectivity change
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.wifi) {
            // WiFi is connected, handle your logic here
            print('connect to wifi');
          } else {
            // Handle other connectivity states (mobile, none, etc.)
            print('CONNECT TO INTERNET');
          }
        },
        child: Icon(Icons.network_check),
      ),
    );
  }
}
