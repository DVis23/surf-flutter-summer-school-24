import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_summer_school_24/src/feature/photos/domain/i_photo_repository.dart';
import 'package:surf_flutter_summer_school_24/src/feature/photos/domain/models/photo_entity.dart';


class GalleryModel extends ElementaryModel {
  final IPhotoRepository photoRepository;
  final ValueNotifier<List<PhotoEntity>> images = ValueNotifier([]);

  GalleryModel(this.photoRepository);

  Future<void> fetchPhotos() async {
    final photos = await photoRepository.getPhotos();
    images.value = photos;
  }
}