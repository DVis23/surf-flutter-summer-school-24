import 'package:flutter/material.dart';

class PhotoViewContainer extends StatefulWidget {
  final String urlImage;

  const PhotoViewContainer({super.key, required this.urlImage});

  @override
  State<PhotoViewContainer> createState() => _PhotoViewContainerState();
}

class _PhotoViewContainerState extends State<PhotoViewContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
      },
      onTapUp: (details) {
        _controller.reverse();
      },
      child: Hero(
        tag: widget.urlImage.hashCode,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.network(
                    widget.urlImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


