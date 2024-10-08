import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:surf_flutter_summer_school_24/src/feature/photos/domain/models/photo_entity.dart';
import 'widgets/gallery_appbar.dart';
import 'widgets/photo_gallery_container.dart';
import 'gallery_widget_model.dart';

class GalleryWidget extends ElementaryWidget<GalleryWidgetModel> {
  const GalleryWidget({
    Key? key,
    WidgetModelFactory<GalleryWidgetModel> wm = createGalleryWidgetModel,
  })
      : super(wm, key: key);

  @override
  Widget build(GalleryWidgetModel wm) {
    return Scaffold(
      appBar: GalleryAppbar(onTab: wm.pickImage),
      body: ValueListenableBuilder<List<PhotoEntity>>(
        valueListenable: wm.model.images,
        builder: (context, images, child) {
          return GridView.builder(
            primary: false,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 5,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => wm.onPhotoTap(index),
                child: PhotoGalleryContainer(urlImage: images[index].url),
              );
            },
          );
        },
      ),
    );
  }
}