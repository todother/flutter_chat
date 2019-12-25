import 'package:chat_demo/Provider/videoProvider.dart';
import 'package:flutter/material.dart';

class VideoToolBar extends StatelessWidget {
  const VideoToolBar({Key key, @required this.provider}) : super(key: key);
  final VideoProvider provider;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      width: 590 * rpx,
      padding: EdgeInsets.symmetric(horizontal: 20 * rpx, vertical: 30 * rpx),
      child: Column(children: [
        Container(
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey[200],
                  inactiveTrackColor: Colors.grey[700],
                  thumbColor: Colors.grey[100],
                  trackHeight: 5 * rpx,
                  thumbShape:
                      RoundSliderThumbShape(enabledThumbRadius: 10 * rpx),
                  overlayColor: Colors.white.withAlpha(32),
                  overlayShape:
                      RoundSliderOverlayShape(overlayRadius: 20 * rpx),
                ),
                child: Slider(
                  min: 0,
                  max: provider.videomilliSeconds.toDouble(),
                  value: provider.silderValue.toDouble(),
                  activeColor: Colors.white,
                  onChanged: (value) {
                    // var result = provider.calcDurationPercent(value.ceil());
                    provider.videoMoveToPosition(value.ceil());
                  },
                ))),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (provider.curTime).toString(),
                  style: TextStyle(fontSize: 25 * rpx, color: Colors.white),
                ),
                Text(
                  (provider.totalTime).toString(),
                  style: TextStyle(fontSize: 25 * rpx, color: Colors.white),
                )
              ],
            )),
        Row(
          children: <Widget>[
            Container(
                child: Center(
              child: provider.ifPlaying
                  ? IconButton(
                      icon: Icon(Icons.pause),
                      iconSize: 80 * rpx,
                      color: Colors.white,
                      onPressed: () {
                        provider.pauseVideo();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 80 * rpx,
                      color: Colors.white,
                      onPressed: () {
                        provider.playVideo();
                      },
                    ),
            )),
          ],
        )
      ]),
    );
  }
}