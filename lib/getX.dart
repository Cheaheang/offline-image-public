import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:offline_image/api.dart';
import 'package:offline_image/connectivity.dart';
import 'package:offline_image/imageModel.dart';
import 'package:offline_image/image_storage.dart';

class ImageUploadController extends GetxController {
  var imageChunks = <List<ImageModel>>[].obs;
  var isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialChunks();
    NetworkMonitor.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none && !isUploading.value) {
        uploadImages();
      }
    } as void Function(List<ConnectivityResult> event)?);
  }

  Future<void> loadInitialChunks() async {
    imageChunks.value = await ImageStorage.getImageChunks();
  }

  Future<void> addImageChunks(List<ImageModel> images) async {
    await ImageStorage.saveImageChunks(images);
    imageChunks.value = await ImageStorage.getImageChunks();
  }

  Future<void> uploadImages() async {
    if (isUploading.value) return;
    isUploading.value = true;

    List<String> taskKeys = await ImageStorage.getTaskKeys();
    for (int i = 0; i < imageChunks.length; i++) {
      try {
        var connectivityResult = await NetworkMonitor.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          throw Exception('No internet connection');
        }
        if (connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.mobile) {
          String task_key = await sendImageChunk(taskKeys[i], imageChunks[i]);
          if (task_key != "") await ImageStorage.removeImageChunk(task_key);
          imageChunks.value = await ImageStorage.getImageChunks();
        }
      } catch (e) {
        break;
      }
    }

    isUploading.value = false;
  }
}

class callCounter extends GetxController {
  int count = 0;
}
