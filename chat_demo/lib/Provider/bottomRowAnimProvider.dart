import 'package:flutter/material.dart';

class BottomRowAnimProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;
  double eachRowHeight;
  double rpx;
  double bottomSheetHeight = 0;
  bool ifExpanded = false;

  BottomRowAnimProvider(context) {
    rpx = MediaQuery.of(context).size.width / 750;
    eachRowHeight = 120 * rpx;
    animController = AnimationController(
        vsync: this,
        animationBehavior: AnimationBehavior.normal,
        duration: Duration(milliseconds: 150),
        reverseDuration: Duration(milliseconds: 150));
    animation = Tween<double>(begin: 0.0, end: 2 * eachRowHeight)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: animController))
          ..addListener(() {
            bottomSheetHeight = animation.value;
            notifyListeners();
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              ifExpanded = true;
            } else if (status == AnimationStatus.reverse) {
              ifExpanded = false;
            }
          });
  }

  runAnimation() {
    if (ifExpanded == false) {
      animController.forward(from: 0);
    }
  }

  reverseAnim() {
    if (ifExpanded == true) {
      animController.reverse(from: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
