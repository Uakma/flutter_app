import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(
          primaryColor: Colors.white,
          brightness: Brightness.light,
        ),
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ),
    );
  }
}
