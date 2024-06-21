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

    for (int i = 0; i < imageChunks.length; i++) {
      try {
        var connectivityResult = await NetworkMonitor.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          throw Exception('No internet connection');
        }
        await sendImageChunk(imageChunks[i]);
        await ImageStorage.removeImageChunk(i);
        imageChunks.value = await ImageStorage.getImageChunks();
      } catch (e) {
        break;
      }
    }

    isUploading.value = false;
  }
}
