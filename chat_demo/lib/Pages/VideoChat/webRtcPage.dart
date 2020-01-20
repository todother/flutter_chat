import 'package:chat_demo/Provider/webRTCProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';

class WebRtcMainPage extends StatelessWidget {
  const WebRtcMainPage({Key key, @required this.webRtcProvider})
      : super(key: key);
  final WebRTCProvider webRtcProvider;
  @override
  Widget build(BuildContext context) {
    // var webRtcProvider=Provider.of<WebRTCProvider>(context);
    var localRenderer = webRtcProvider.localRenderer;
    var remoteRenderer = webRtcProvider.remoteRenderer;
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: RTCVideoView(remoteRenderer),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                height: 100,
                width: 70,
                child: RTCVideoView(localRenderer),
              ),
            )
          ],
        ),
      ),
    );
  }
}
