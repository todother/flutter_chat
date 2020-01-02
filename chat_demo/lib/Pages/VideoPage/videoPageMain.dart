import 'package:chat_demo/Pages/VideoPage/videoToolBar.dart';
import 'package:chat_demo/Provider/barrageProvider.dart';
import 'package:chat_demo/Provider/videoProvider.dart';
import 'package:chat_demo/Tools/nativeTool.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brightnessView.dart';
import 'gaussianContainer.dart';
import 'videoViewMain.dart';

class VideoPlayerPage extends StatelessWidget {
  const VideoPlayerPage({Key key, @required this.tag}) : super(key: key);
  final String tag;
  @override
  Widget build(BuildContext context) {
    VideoProvider provider = Provider.of<VideoProvider>(context);

    double rpx = MediaQuery.of(context).size.width / 750;
    double brightnessIconSize = 30 * rpx;
    return Material(
        child: GestureDetector(
            onTap: () {
              provider.runAnimate();
              // NativeTool.changeVideoSpeed(1.5,provider.controller.textureId);
            },
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
              child: Stack(children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: provider.loaded == false
                          ? CircularProgressIndicator()
                          : AspectRatio(
                              aspectRatio:
                                  provider.controller.value.aspectRatio,
                              child: GestureDetector(
                                  onVerticalDragStart: (result) {
                                    provider.brightnessDragStart(
                                        result.localPosition.dy);
                                  },
                                  onVerticalDragUpdate: (result) {
                                    provider.brightnessDragUpdate(
                                        result.localPosition.dy);
                                  },
                                  onVerticalDragEnd: (result) {
                                    provider.brightnessDragEnd();
                                  },
                                  child: MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                          builder: (_) => BarrageProvider(
                                              provider.videomilliSeconds, rpx),
                                        )
                                      ],
                                      child: Container(
                                          width: 750 * rpx,
                                          child: VideoMainView(
                                            tag: tag,
                                            provider: provider,
                                          ))))),
                    )),
                provider.curAnimValue >= 0.05
                    ? Positioned(
                        bottom: 120 * rpx,
                        left: 80 * rpx,
                        // top: MediaQuery.of(context).size.height-170*rpx,
                        child: GaussianContainer(
                          child: VideoToolBar(
                            provider: provider,
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(100, 80, 80, 80),
                              borderRadius: BorderRadius.circular(20 * rpx)),
                        ),
                      )
                    : Container(),
                provider.iconToTop >= 1
                    ? Positioned(
                        left: 80 * rpx,
                        top: provider.iconToTop,
                        child: GaussianContainer(
                            child: Container(
                              child: IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(100, 80, 80, 80),
                            )))
                    : Container(),
                provider.iconToTop >= 1
                    ? Positioned(
                        right: 80 * rpx,
                        top: provider.iconToTop,
                        child: GaussianContainer(
                            child: Container(
                              child: IconButton(
                                icon: provider.ifMuted
                                    ? Icon(Icons.volume_up)
                                    : Icon(Icons.volume_off),
                                color: Colors.white,
                                onPressed: () {
                                  provider.updateVolume();
                                },
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(100, 80, 80, 80),
                            )))
                    : Container(),
                provider.ifChangeBrightness
                    ? Positioned(
                        top:
                            (MediaQuery.of(context).size.height - 60 * rpx) / 2,
                        left:
                            (750 - 2 * brightnessIconSize - 40 - 200) / 2 * rpx,
                        child: BrightnessView(
                          provider: provider,
                          radius: brightnessIconSize,
                        ),
                      )
                    : Container()
              ]),
            )));
  }
}