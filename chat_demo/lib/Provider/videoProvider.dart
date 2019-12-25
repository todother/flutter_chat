import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  VideoPlayerController controller;
  String videoFilePath;
  bool ifPlaying = false;
  Animation<double> animation;
  AnimationController animationController;

  Animation<double> animIconForward;
  AnimationController animIconForwardController;

  Animation<double> animIconReverse;
  AnimationController animIconReverseController;

  double screenBrightness = 0;

  double iconToTop = 0;

  double brightnessDragStartY = 0;
  double brightnessDragCurY = 0;

  bool ifChangeBrightness = false;
  bool ifMuted = false;
  double curVolume = 0;

  double curAnimValue = 0;
  bool loaded = false;
  int videomilliSeconds = 0;
  int silderValue = 0;
  String totalTime = "00:00";
  String curTime = "00:00";
  bool isForward = true;

  VideoProvider(String filePath) {
    videoFilePath = filePath;
    animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        reverseDuration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        curAnimValue = animation.value;
        notifyListeners();
      });

    animIconForwardController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animIconForward = Tween<double>(begin: 0, end: 80).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: animIconForwardController))
      ..addListener(() {
        iconToTop = animIconForward.value;
        notifyListeners();
      });

    animIconReverseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    animIconReverse = Tween<double>(begin: 80, end: 0).animate(CurvedAnimation(
        curve: Curves.easeIn, parent: animIconReverseController))
      ..addListener(() {
        iconToTop = animIconReverse.value;
        notifyListeners();
      });

    getScreenBrightness();
    initVideo(filePath);
    // controller.play();
  }
  @override
  void dispose() {
    if (ifPlaying) {
      controller.pause();
    }
    controller.dispose();
    super.dispose();
  }

  brightnessDragStart(double y) {
    brightnessDragStartY = y;
    brightnessDragCurY = y;
    ifChangeBrightness = true;
    notifyListeners();
  }

  brightnessDragEnd() {
    ifChangeBrightness = false;
    notifyListeners();
  }

  brightnessDragUpdate(double y) {
    print("updated y : $y");
    double changedY = y - brightnessDragCurY;
    double changedBrightness = changedY / 3 / 100;
    updateScreenBrightness(-changedBrightness);
    brightnessDragCurY = y;
    print(changedBrightness);
    notifyListeners();
  }

  updateScreenBrightness(value) {
    screenBrightness = min(max(0.05, screenBrightness + value), 0.95);
    Screen.setBrightness(screenBrightness);
    // print(screenBrightness);
    notifyListeners();
  }

  getScreenBrightness() async {
    double brightness = await Screen.brightness;
    screenBrightness = brightness;
    notifyListeners();
  }

  initVideo(filePath) async {
    try {
      controller = VideoPlayerController.file(File(filePath));
      await controller.initialize();
      videomilliSeconds = controller.value.duration.inMilliseconds;
      int totalMinute = controller.value.duration.inMinutes;
      int totalSecond = (controller.value.duration.inSeconds) % 60;

      totalTime =
          "${totalMinute.toString().padLeft(2, "0")}:${totalSecond.toString().padLeft(2, "0")}";
      controller
        ..addListener(() {
          silderValue = controller.value.position.inMilliseconds;
          int curMinute = controller.value.position.inMinutes;
          int curSecond = controller.value.position.inSeconds % 60;
          curTime =
              "${curMinute.toString().padLeft(2, "0")}:${curSecond.toString().padLeft(2, "0")}";
          notifyListeners();
        });
      loaded = true;

      
      var volume = controller.value.volume;
      curVolume = volume;
      if (volume == 0.0) {
        ifMuted = true;
      }
      playVideo();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // calcDurationPercent(double percent) {
  //   double result = (videomilliSeconds / 100 * percent);
  //   return result;
  // }

  videoMoveToPosition(int miliseconds) async {
    await controller.seekTo(Duration(milliseconds: miliseconds));

    notifyListeners();
  }

  updateVolume() {
    ifMuted = !ifMuted;
    if (ifMuted == true) {
      controller.setVolume(0.0);
    } else {
      controller.setVolume(curVolume);
    }
    notifyListeners();
  }

  runAnimate() {
    if (isForward) {
      animationController.forward(from: 0);
      animIconForwardController.forward(from: 0);
      isForward = false;
    } else {
      animationController.reverse(from: 0);
      animIconReverseController.forward(from: 0);
      isForward = true;
    }
    notifyListeners();
  }

  playVideo() async {
    await controller.play();
    ifPlaying = true;
    notifyListeners();
  }

  pauseVideo() async {
    await controller.pause();
    ifPlaying = false;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
