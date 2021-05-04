import 'package:flutter/material.dart';
import 'package:motel/widgets/loading_screen.dart';

class LoadingOverlay {
  OverlayEntry _progressOverlayEntry;

  void show(BuildContext context) {
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }

  void hide() {
    if (_progressOverlayEntry != null) {
      _progressOverlayEntry.remove();
      _progressOverlayEntry = null;
    }
  }

  OverlayEntry _createdProgressEntry(BuildContext context) =>
      OverlayEntry(builder: (BuildContext context) => LoadingScreen());

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
}
