import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_image/ImageUploadController.dart';
import 'package:offline_image/api.dart';
import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:offline_image/home_page.dart';
import 'package:offline_image/stateManagement.dart';

// import 'package:video_player/video_player.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // File
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomePage(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  io.File? _selectedImage;
  final SaveBase64Image convert64 = Get.put(SaveBase64Image());
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: Text('Pick Image from Gallery')),
            ElevatedButton(
                onPressed: () {}, child: Text('Pick image from camera')),
            const SizedBox(
              height: 20,
            ),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : Text('Please select iamge'),
          ],
        ),
      )),
    ));
  }

  Future _pickImageFromGallery() async {
    //select image
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (returnedImage == null) return;
    //set path to variable '_selectedImage'
    setState(() {
      _selectedImage = io.File(returnedImage.path);
    });
    //convert image to base64
    final bytes = io.File(returnedImage.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print(_selectedImage);
    // print(img64);
    convert64.img64.add(img64);
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    print('++++++++++++++++++++++++++Break link++++++++++++++++++++++++++++++');
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    convert64.img64.forEach(
      (element) {
        print(element);
      },
    );
    // print(convert64.img64);
  }
}

// class HomeScreen extends StatelessWidget {
//   final ImageUploadController controller = Get.put(ImageUploadController());

//   Future<void> pickImages() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? images = await picker.pickMultiImage();
//     if (images != null && images.isNotEmpty) {
//       List<ImageModel> imageModels = images.map((image) {
//         final bytes = image.readAsBytes();
//         final base64String = base64Encode(bytes);
//         return ImageModel(base64String);
//       }).toList();

//       await controller.addImageChunks(imageModels);
//       controller.uploadImages();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Image Uploader')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: pickImages,
//           child: Text('Upload Images'),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Simulate network connectivity change
//           NetworkMonitor.onConnectivityChanged.add(ConnectivityResult.wifi);
//         },
//         child: Icon(Icons.network_check),
//       ),
//     );
//   }
// }
