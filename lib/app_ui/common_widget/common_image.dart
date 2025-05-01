import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/local_images.dart';

class CommonImage extends StatelessWidget {
  final double height;
  final double width;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final String imageUrl;
  final BoxFit fit;

  const CommonImage({
    Key? key,
    required this.height,
    required this.width,
    required this.imageUrl,
    this.borderWidth = 2.0,
    this.borderColor = Colors.black,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height ?? 100.0,
      width: width ?? 100,
      fit: fit,
      errorWidget: (context,string,objext) {
        return Image.asset(LocalImages.appLogo,width: width,height: height,);
      },
    );
  }
}
