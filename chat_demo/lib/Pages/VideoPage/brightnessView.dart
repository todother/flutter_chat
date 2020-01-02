import 'dart:math';

import 'package:chat_demo/Provider/videoProvider.dart';
import 'package:flutter/material.dart';

import 'gaussianContainer.dart';
import 'roundClipper.dart';

class BrightnessView extends StatelessWidget {
  const BrightnessView(
      {Key key, @required this.radius, @required this.provider})
      : super(key: key);
  final double radius;
  final VideoProvider provider;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return GaussianContainer(
        decoration: BoxDecoration(
            ),
        child: Container(
            height: 60 * rpx,
            child: Row(children: [
              Transform.rotate(
                  angle: provider.screenBrightness * 2 * pi,
                  child: ClipPath(
                      clipper: RoundClipper(
                          center: Offset(radius, radius), r: radius),
                      // color: Colors.white,
                      child: Stack(children: [
                        Container(
                          width: 2 * radius,
                          height: 2 * radius,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                        Positioned(
                          left: provider.screenBrightness * 2 * radius,
                          top: 0,
                          child: Container(
                            width: 2 * radius,
                            height: 2 * radius,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                backgroundBlendMode: BlendMode.dstOut,
                                shape: BoxShape.circle),
                          ),
                        )
                      ]))),
              Container(
                  width: 200 * rpx,
                  margin: EdgeInsets.only(left: 40 * rpx),
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.green,
                        inactiveTrackColor: Colors.white,
                        thumbColor: Colors.transparent,
                        trackHeight: 5 * rpx,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 0 * rpx),
                        overlayColor: Colors.white.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 0 * rpx),
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: provider.screenBrightness * 100,
                        // activeColor: Colors.white,
                        onChanged: (value) {
                        },
                      )))
            ])));
  }
}