import 'dart:io';

import 'package:chat_demo/Model/poiModel.dart';
import 'package:chat_demo/Provider/gaodeMapProvider.dart';
import 'package:chat_demo/Tools/nativeTool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GaodeMapMain extends StatelessWidget {
  const GaodeMapMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GaodeMapProvider gaodeMapProvider = Provider.of<GaodeMapProvider>(context);

    return Scaffold(
        body: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[ 
          Container(
            height: gaodeMapProvider.mapHeight,
            child: GaodeMapView(),
            color: Colors.blue,
          ),
          Listener(
              onPointerDown: (result) {
                double y = result.position.dy;
                gaodeMapProvider.updateStartY(y);
              },
              onPointerMove: (result) {
                double y = result.position.dy;
                gaodeMapProvider.updateMapHeight(y);
              },
              onPointerUp: (result) {
                gaodeMapProvider.runMapHeightAnimationUp();
              },
              child: Container(
                  height: gaodeMapProvider.poiListHeight, child: POIList())),
        ],
      ),
    ));
  }
}

class GaodeMapView extends StatelessWidget {
  const GaodeMapView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GaodeMapProvider provider = Provider.of<GaodeMapProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    var pixRatio=MediaQuery.of(context).devicePixelRatio;
    print(provider.mapHeight*pixRatio);
    return Stack(children: [
      Listener(
          onPointerMove: (result) {
            if (!provider.ifRequstPoi) {
              provider.updateRequestPoiStatus(true);
              provider.refreshPoiList();
            } else {
              return;
            }
          },
          child: Container(
            // height: 300,
            child: Platform.isIOS
                ? UiKitView(
                    viewType: "gaodeMap",
                  )
                : AndroidView(
                    viewType: "gaodeMap",
                    creationParams: {
                      "height":provider.mapHeight*pixRatio,
                    },
                    creationParamsCodec: StandardMessageCodec(),
                  ),
          )),
      Positioned(
        top: 60 * rpx,
        left: 40 * rpx,
        child: FlatButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.pop(context, "");
          },
        ),
      ),
      Positioned(
        top: 60 * rpx,
        right: 40 * rpx,
        child: RaisedButton(
          child: Text("提交"),
          onPressed: () async {
            String filePath = await NativeTool.getScreenShot();
            Navigator.pop(context, {
              "filePath": filePath,
              "address": provider.poiItems.first?.address,
              "title": provider.poiItems.first?.title
            });
          },
        ),
      )
    ]);
  }
}

class POIList extends StatelessWidget {
  const POIList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GaodeMapProvider provider = Provider.of<GaodeMapProvider>(context);
    List<PoiModel> poiItems = provider.poiItems;
    ScrollController _controller = ScrollController();
    return ListView.builder(
      controller: provider.ifMapPrimary ? null : _controller,
      itemCount: poiItems.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        PoiModel item = poiItems[index];
        return Container(
          color: Colors.white,
          child: GestureDetector(
              onTap: () {
                double lati = item.lati;
                double longi = item.longi;
                provider.updateCurSel(index);
                provider.moveCameraToPoi(lati, longi);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(item.title),
                    subtitle:
                        Text("${item.distance.toString()}米 | ${item.address}"),
                    trailing: provider.curSel == index
                        ? Icon(
                            Icons.done,
                            color: Colors.greenAccent,
                          )
                        : Container(
                            width: 10,
                          ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider())
                ],
              )),
        );
      },
    );
  }
}
