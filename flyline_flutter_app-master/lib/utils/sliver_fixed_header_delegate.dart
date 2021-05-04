import 'dart:math';
import 'package:flutter/material.dart';

class SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverFixedHeaderDelegate({
    @required this.maxHeight,
    double minHeight,
    @required this.child,
  }) : minHeight = minHeight ?? maxHeight;
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverFixedHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
