import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Duration shimmerDuration;
  final VoidCallback? onLoaded;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.onLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: FancyShimmerImage(
          imageUrl: imageUrl,
          boxFit: fit,
          shimmerBackColor: Colors.grey[300],
          shimmerHighlightColor: Colors.grey[100],
          errorWidget: Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
