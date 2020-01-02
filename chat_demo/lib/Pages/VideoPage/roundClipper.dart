import 'dart:ui';

import 'package:flutter/material.dart';

class RoundClipper extends CustomClipper<Path> {
  RoundClipper({@required this.center, @required this.r});
  final Offset center;
  final double r;

  

  @override
  Path getClip(Size size) {
    Path path = Path()..addOval(Rect.fromCircle(center: center, radius: r));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}