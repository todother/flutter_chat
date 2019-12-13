import 'dart:async';
import 'dart:convert';

import 'package:chat_demo/Model/poiModel.dart';
import 'package:chat_demo/Tools/nativeTool.dart';
import 'package:flutter/material.dart';

class GaodeMapProvider with ChangeNotifier {
  @override
  void dispose() {
    super.dispose();
    NativeTool.disposeMapView();
    if (job != null) {
      job.cancel();
    }
  }

  bool ifLoaded = false;
  double totalHeight = 0;
  double mapHeight = 0;
  double poiListHeight = 0;
  double mapHeightPercent = 0.6;
  bool ifMapPrimary = true;
  double startY = 0;
  double endY = 0;
  double curY = 0;
  double lati = 0;
  double longi = 0;
  List<PoiModel> poiItems = List<PoiModel>();
  Timer job;
  int curSel = -1;
  int zoomTo = 19;
  bool ifRequstPoi = false;

  Animation<double> animation;
  AnimationController animationController;
  GaodeMapProvider(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    totalHeight = screenSize.height;
    mapHeight = mapHeightPercent * totalHeight;
    poiListHeight = (1 - mapHeightPercent) * totalHeight;

    initGaodeMap();
  }

  updateCurSel(index) {
    curSel = index;
    notifyListeners();
  }

  updateRequestPoiStatus(bool status) {
    ifRequstPoi = status;
    notifyListeners();
  }

  updateStartY(double y) {
    startY = y;
    curY = y;
    notifyListeners();
  }

  updateMapHeight(double movedTo) {
    double changed = curY - movedTo;
    curY = movedTo;
    mapHeight = mapHeight - changed;
    poiListHeight = poiListHeight + changed;
    print("changed:$changed,mapHeight:$mapHeight");
    notifyListeners();
  }

  updateSelPosition() async {
    notifyListeners();
  }

  runMapHeightAnimationUp() {
    animation = Tween<double>(
            begin: mapHeight, end: (1 - mapHeightPercent) * totalHeight)
        .animate(animationController)
          ..addListener(() {
            mapHeight = animation.value;
            poiListHeight = totalHeight - mapHeight;
            print("mapheight:$mapHeight,poiListHeight:$poiListHeight");
            notifyListeners();
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              ifMapPrimary = false;
              notifyListeners();
            }
          });
    animationController.forward(from: 0);
  }

  runMapHeightAnimationDown() {
    animation =
        Tween<double>(begin: mapHeight, end: (mapHeightPercent) * totalHeight)
            .animate(animationController)
              ..addListener(() {
                mapHeight = animation.value;
                poiListHeight = totalHeight - mapHeight;
                // print("mapheight:$mapHeight,poiListHeight:$poiListHeight");
                notifyListeners();
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  ifMapPrimary = true;
                  notifyListeners();
                }
              });
    animationController.forward(from: 0);
  }

  initGaodeMap() async {
    var poiresult = await NativeTool.initGaodeMap();
    if (poiresult["success"] == "OK") {
      ifLoaded = true;
      // var poiresult= await NativeTool.initMapPosition();
      updatePoiList(poiresult["result"]);
    }
  }

  updatePoiList(poiresult) {
    ifRequstPoi = false;
    if (poiresult != null) {
      List<dynamic> mapPoiList = json.decode(poiresult);
      poiItems = List<PoiModel>();
      mapPoiList.forEach((item) {
        poiItems.add(PoiModel.fromJson(item));
      });
      curSel = -1;
    }
    notifyListeners();
  }

  moveCameraToPoi(double lati, double longi) async{
    var result =await NativeTool.moveCameraToPoi(lati, longi, zoomTo);
    updatePoiList(result["result"]);
  }

  refreshPoiList() async {
    var result = await NativeTool.getSelPosition();

    lati = result["lati"];
    longi = result["longi"];
    var poiresult = await NativeTool.getPoiList();
    updatePoiList(poiresult["result"]);
  }
}
