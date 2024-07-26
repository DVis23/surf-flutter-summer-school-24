import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class PhotoGalleryContainer extends StatefulWidget {
  final String urlImage;

  const PhotoGalleryContainer({super.key, required this.urlImage});

  @override
  State<PhotoGalleryContainer> createState() => _PhotoGalleryContainerState();
}

class _PhotoGalleryContainerState extends State<PhotoGalleryContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Hero(
        tag: widget.urlImage.hashCode,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: InteractiveViewer(
            maxScale: 3,
            child: Image.network(
              widget.urlImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.errorContainer,
                  highlightColor: Theme.of(context).colorScheme.onErrorContainer,
                  period: const Duration(milliseconds: 600),
                  direction: ShimmerDirection.ltr,
                  child: Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
