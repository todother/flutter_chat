import 'dart:async';

import 'package:flutter/material.dart';

class LoginProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  Animation<double> backgroundAnimation;
  AnimationController backgroundController;

  double opacityMain = 1;
  double opacityToChange = 0;
  int index=0;
  int indexToChange=1;
  List<String> imgList;
  Timer interval;

  LoginProvider() {
    
    imgList=List<String>();
    imgList.add('lib/images/chat0.jpg');
    imgList.add('lib/images/chat1.jpg');
    imgList.add('lib/images/chat2.jpg');
    imgList.add('lib/images/chat3.jpg');
    backgroundController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    backgroundAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(backgroundController)
        ..addListener((){
          opacityMain=1-backgroundAnimation.value;
          opacityToChange=backgroundAnimation.value;
          notifyListeners();
        })..addStatusListener((status){
          if(status==AnimationStatus.completed){
            index=index+1;
            indexToChange=indexToChange+1;
            if(index==imgList.length){
              index=0;
            }

            if(indexToChange==imgList.length){
              indexToChange=0;
            }

            opacityMain=1;
            opacityToChange=0;
            notifyListeners();
          }
        });
    interval=Timer.periodic(Duration(seconds:5), (callback){
      backgroundController.forward(from: 0);
    });
  }

  @override
  void dispose() { 
    interval.cancel();
    backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
