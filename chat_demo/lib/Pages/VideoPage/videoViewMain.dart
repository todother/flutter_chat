import 'package:chat_demo/Provider/barrageProvider.dart';
import 'package:chat_demo/Provider/videoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoMainView extends StatelessWidget {
  const VideoMainView({Key key, @required this.tag, @required this.provider})
      : super(key: key);
  final String tag;
  final VideoProvider provider;
  @override
  Widget build(BuildContext context) {
    BarrageProvider barrageProvider = Provider.of<BarrageProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    List<Widget> widgets = List<Widget>();
    widgets.add(Hero(tag: tag, child: VideoPlayer(provider.controller)));
    var barrageList = barrageProvider.barrageList;
    var i = 0;
    var j = 0;
    for (i = 0; i < barrageList.length; i++) {
      for (j = 0; j < barrageList[i].length; j++) {
        var item = barrageList[i][j];
        if (i == 0 && j == 0) {
          // print("cur first value is ${barrageList[i][j].itemContent}");
        }
        widgets.add(Positioned(
          top: i * 50 * rpx,
          left: item.toLeft,
          child: BarrageText(
            rpx: rpx,
            barrage: barrageList[i][j].itemContent,
          ),
        ));
      }
    }
    return Stack(children: widgets);
  }
}

class BarrageText extends StatelessWidget {
  const BarrageText({Key key, @required this.rpx, @required this.barrage})
      : super(key: key);
  final double rpx;
  final String barrage;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: Text(
        barrage,
        // softWrap: false,
        style: TextStyle(
            fontSize: 35 * rpx,
            color: Colors.white,
            fontWeight: FontWeight.w500),
      )),
    );
  }
}