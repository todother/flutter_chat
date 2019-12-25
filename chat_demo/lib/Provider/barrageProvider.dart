import 'dart:math';

import 'package:chat_demo/Model/barrageItemModel.dart';
import 'package:flutter/material.dart';

class BarrageProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  Animation<double> barrageAnim;
  int maxLine = 5;
  double rpx = 0;
  double curAnimValue = 0;
  int barrageCount = 1000;
  int videoLength = 0;
  double defaultSpeed;
  bool ifFinishAnim = true;
  double lastUpdate = 0;
  AnimationController barrageAnimController;
  List<BarrageItemModel> origData = List<BarrageItemModel>();
  List<List<BarrageItemModel>> barrageList = List<List<BarrageItemModel>>();

  BarrageProvider(int videoLength, double rpx) {
    this.rpx = rpx;
    this.videoLength = videoLength;
    defaultSpeed = 300 * rpx;
    genRandomData();
    List.generate(maxLine, (index) {
      barrageList.add(List<BarrageItemModel>());
    });
    barrageAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: videoLength));
    barrageAnim = Tween<double>(begin: 0, end: videoLength.toDouble())
        .animate(barrageAnimController)
          ..addListener(() {
            if (ifFinishAnim) {
              ifFinishAnim = false;
              curAnimValue = barrageAnim.value;
              // print(
                  // 'before add data : value ${barrageList[0].map((item) => item.itemContent).toList()}, toLeft ${barrageList[0].map((item) => item.toLeft.toString()).toList()}');
              List<BarrageItemModel> newData =
                  getBarrageItemBeforeMilliSecond(barrageAnim.value.toInt());
              newData.forEach((item) {
                addItemToList(item);
              });
              // print(
                  // 'after add data : value ${barrageList[0].map((item) => item.itemContent).toList()}, toLeft ${barrageList[0].map((item) => item.toLeft.toString()).toList()}');
              updateBarrageToLeft();
              // removeBarrageItemBeforeMilliSecond(barrageAnim.value.toInt());
              removeBarrageIfOutOfRange();
              ifFinishAnim = true;
              lastUpdate = barrageAnim.value;
              notifyListeners();
            }
          });
    barrageAnimController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  void dispose() {
    if (barrageAnimController.isAnimating) {
      barrageAnimController.stop();
    }
    barrageAnimController.dispose();
    super.dispose();
  }

  animRunAtPosition(int milliSeccond) {
    barrageAnimController.reset();
    barrageAnimController.forward(from: milliSeccond.toDouble());
  }

  removeBarrageItemBeforeMilliSecond(int milliSecond) {
    List<BarrageItemModel> tempData = List<BarrageItemModel>();
    tempData = origData;
    origData = origData
      ..removeWhere((item) => item.itemStartMilliSecond <= milliSecond);
  }

  List<BarrageItemModel> getBarrageItemBeforeMilliSecond(int milliSecond) {
    List<BarrageItemModel> data = origData
        .where((item) =>
            item.itemStartMilliSecond <= milliSecond &&
            item.itemStartMilliSecond >= lastUpdate)
        .toList();
    origData.removeWhere((item) => item.itemStartMilliSecond <= milliSecond);
    return data;
  }

  calcSpeedForBarrageItem(double itemWidth, double defaultSpeed) {
    double totalWidth = 750 * rpx + itemWidth;
    double calcSpeed = defaultSpeed;
    if (totalWidth / defaultSpeed >= 5.0) {
      calcSpeed = totalWidth / 5;
    }
    return calcSpeed; // moves per millisecond
  }

  addItemToList(BarrageItemModel barrage) {
    bool ifAdded = false;
    barrageList = barrageList
      ..forEach((item) {
        if (ifAdded) {
          return;
        }
        if (item.length == 0) {
          item.add(barrage);
          ifAdded = true;
        } else {
          if (item.last.toLeft <= 750 * rpx - barrage.itemWidth - 20 * rpx) {
            //20 rpx means padding
            item.add(barrage);
            ifAdded = true;
          }
        }
      });
    // notifyListeners();
  }

  removeBarrageIfOutOfRange() {
    barrageList.forEach((item) {
      if (item.length > 0) {
        item.removeWhere((o) => o.toLeft <= -o.itemWidth);
      }
    });
    // notifyListeners();
  }

  updateBarrageToLeft() {
    barrageList.forEach((list) {
      list.forEach((item) {
        item.toLeft = item.toLeft -
            (curAnimValue - item.itemStartMilliSecond) *
                item.speed /
                1000 /
                500;
      });
    });
  }

  genRandomData() {
    String barrageContent;
    List.generate(barrageCount, (index) {
      int startTime = Random().nextInt(videoLength);
      int barrContentLength = min(1, Random().nextInt(20));
      barrageContent = "哈";
      origData.add(BarrageItemModel(
          itemContent: barrageContent * barrContentLength,
          itemStartMilliSecond: startTime,
          speed: calcSpeedForBarrageItem(
              barrContentLength * 35 * rpx, defaultSpeed),
          toLeft: 750 * rpx,
          itemWidth: barrContentLength * 35 * rpx,
          ifShow: true));
    });
    origData.sort(
        (a, b) => a.itemStartMilliSecond.compareTo(b.itemStartMilliSecond));
    notifyListeners();
  }
}
