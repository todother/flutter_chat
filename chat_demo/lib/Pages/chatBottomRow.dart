import 'dart:math';
import 'package:chat_demo/Pages/recordVoiceRow.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:flutter/material.dart';

class ChatBottomRow extends StatelessWidget {
  const ChatBottomRow(
      {Key key,
      @required this.provider,
      @required this.rpx,
      @required this.toBottom,
      @required this.voiceRecordProvider,
      @required this.txtController})
      : super(key: key);
  final double rpx;
  final double toBottom;
  final VoiceRecordProvider voiceRecordProvider;
  final TextEditingController txtController;
  final SignalRProvider provider;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[100],
        child: SafeArea(
            child: Container(
          color: Colors.grey[100],
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: toBottom),
          height: 110 * rpx,
          child: Row(
            children: <Widget>[
              voiceRecordProvider.ifVoiceRecord
                  ? OutlinedIconButton(
                      icon: Icon(Icons.keyboard),
                      onTap: () {
                        voiceRecordProvider.updateVoiceRecord();
                      },
                    )
                  : Transform.rotate(
                      angle: pi / 2,
                      child: OutlinedIconButton(
                        icon: Icon(Icons.wifi),
                        onTap: () {
                          voiceRecordProvider.updateVoiceRecord();
                        },
                      )),
              SizedBox(
                width: 10 * rpx,
              ),
              Expanded(
                  child: voiceRecordProvider.ifVoiceRecord
                      ? RecordVoiceRow()
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 10 * rpx),
                          color: Colors.white,
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            maxLines: 1,
                            autocorrect: false,
                            controller: txtController,
                          ))),
              SizedBox(
                width: 10 * rpx,
              ),
              OutlinedIconButton(
                icon: Icon(Icons.face),
                onTap: () {
                  print('tapped face');
                },
              ),
              txtController.text.length > 0
                  ? Container(
                      width: 140 * rpx,
                      child: RaisedButton(
                        color: Colors.green[300],
                        child: Text(
                          "提交",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          provider.sendMessage(txtController.text);
                          txtController.clear();
                        },
                      ))
                  : OutlinedIconButton(
                      icon: Icon(Icons.add),
                      onTap: () {
                        print('tapped add');
                      },
                    ),
              SizedBox(
                width: 10 * rpx,
              )
            ],
          ),
        )));
  }
}

class OutlinedIconButton extends StatelessWidget {
  const OutlinedIconButton({Key key, @required this.icon, @required this.onTap})
      : super(key: key);
  final Icon icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
        width: 60 * rpx,
        margin: EdgeInsets.all(10 * rpx),
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(width: 4 * rpx)),
        child: IconButton(
          splashColor: Colors.transparent,
          icon: icon,
          iconSize: 40 * rpx,
          padding: EdgeInsets.all(0),
          onPressed: onTap,
        ));
  }
}
