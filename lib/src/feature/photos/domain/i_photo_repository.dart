import 'models/photo_entity.dart';

abstract interface class IPhotoRepository {
  Future<List<PhotoEntity>> getPhotos();
  Future<void> uploadImageToYandexCloud(String imagePath);
  Future<List<PhotoEntity>> downloadImageFromYandexCloud();
  Future<void> deleteImageFromYandexCloud(String imagePath);
}