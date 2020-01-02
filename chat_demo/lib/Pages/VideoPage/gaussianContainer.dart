import 'dart:ui';

import 'package:flutter/material.dart';

class GaussianContainer extends StatelessWidget {
  const GaussianContainer(
      {Key key, @required this.child, @required this.decoration})
      : super(key: key);
  final Widget child;
  final BoxDecoration decoration;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return ClipRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              // height: 150 * rpx,
              decoration: decoration,
              child: child,
            )));
  }
}