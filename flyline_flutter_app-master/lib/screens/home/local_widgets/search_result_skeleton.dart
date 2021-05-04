import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchResultSkeleton extends StatelessWidget {
  const SearchResultSkeleton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 16),
      padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 8),
            child: Row(
              children: [
                Container(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      height: 24,
                      width: 96,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      height: 24,
                      width: 32,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 72),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 96),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
