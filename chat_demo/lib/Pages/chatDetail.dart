import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Pages/chatBottomRow.dart';
import 'package:chat_demo/Pages/gaodeMapPage.dart';
import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/contentEditingProvider.dart';
import 'package:chat_demo/Provider/gaodeMapProvider.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatDetailList.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignalRProvider provider = Provider.of<SignalRProvider>(context);
    VoiceRecordProvider voiceRecordProvider =
        Provider.of<VoiceRecordProvider>(context);
    ContentEditingProvider contentEditingProvider =
        Provider.of<ContentEditingProvider>(context);
    XFVoiceProvider xfVoiceProvider = Provider.of<XFVoiceProvider>(context);
    if (provider == null || provider.conn == null || provider.connId == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    bool ifVoiceRecord = voiceRecordProvider.ifVoiceRecord;
    TextEditingController txtController = contentEditingProvider.txtController;
    double toBottom = MediaQuery.of(context).viewInsets.bottom;
    double rpx = MediaQuery.of(context).size.width / 750;
    txtController.addListener(() {
      contentEditingProvider.updateEditStatus(txtController.text);
    });
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("AAA"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                              ChangeNotifierProvider(
                                builder: (_) => GaodeMapProvider(context),
                              ),
                            ], child: GaodeMapMain())));
                ChatRecord chatRecord = ChatRecord(
                    address: result["address"],
                    title: result["title"],
                    locationImg: result["filePath"],
                    chatType: CHATTYPE.LOCATION,
                    avatarUrl:'https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_is.jpg' ,
                    sender: SENDER.SELF);
                provider.addLocationRecord(chatRecord);
              },
            )
          ],
        ),
        body: ChatDetailList(
          chatProvider: provider,
        ),
        bottomNavigationBar:
            // RecordVoiceRow()
            ChatBottomRow(
          provider: provider,
          voiceRecordProvider: voiceRecordProvider,
          xfVoiceProvider: xfVoiceProvider,
          txtController: txtController,
          rpx: rpx,
          toBottom: toBottom,
        ));
  }
}

class ChatBoxPainter extends CustomPainter {
  ChatBoxPainter(
      {@required this.width, @required this.height, @required this.color});
  final double width;
  final double height;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()
      ..moveTo(0, height / 2)
      ..lineTo(width, height)
      ..lineTo(width, 0)
      ..lineTo(0, height / 2);

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..strokeWidth = 1;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ChatBoxPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ChatBoxPainter oldDelegate) => false;
}
