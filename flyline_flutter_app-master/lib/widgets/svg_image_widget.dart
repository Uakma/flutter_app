import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImageWidget {
  static Widget asset(
    String assetPath, {
    double width,
    double height,
    BoxFit fit = BoxFit.contain,
    Color color,
    alignment = Alignment.center,
    String semanticsLabel,
  }) {
    if (kIsWeb) {
      return Image.network(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
      );
    } else {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        placeholderBuilder: (_) => Container(
          width: 30,
          height: 30,
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}