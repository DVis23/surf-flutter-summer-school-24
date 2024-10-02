import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/photo_repository.dart';
import '../photo_view/photo_view_widget.dart';
import 'gallery_model.dart';
import 'gallery_widget.dart';

class GalleryWidgetModel extends WidgetModel<GalleryWidget, GalleryModel> {
  GalleryWidgetModel(super.model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    model.fetchPhotos();
  }

  void onPhotoTap(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoViewWidget(
          images: model.images.value,
          initialIndex: index,
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      await model.photoRepository.uploadImageToYandexCloud(pickedFile.path);
    }
    model.fetchPhotos();
  }
}

GalleryWidgetModel createGalleryWidgetModel(BuildContext _) =>
GalleryWidgetModel(GalleryModel(PhotoRepository()));


