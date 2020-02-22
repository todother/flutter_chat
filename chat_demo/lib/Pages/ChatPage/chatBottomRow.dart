import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chat_demo/Model/xFVoiceConvertModel.dart';
import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/bottomRowAnimProvider.dart';
import 'package:chat_demo/Provider/goSocketProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Provider/webRTCProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

import 'chatBottomFuncSheet.dart';
import 'recordVoiceRow.dart';

class ChatBottomRow extends StatelessWidget {
  const ChatBottomRow(
      {Key key,
      @required this.provider,
      @required this.rpx,
      @required this.toBottom,
      @required this.voiceRecordProvider,
      @required this.xfVoiceProvider,
      @required this.txtController,
      @required this.webRTCProvider})
      : super(key: key);
  final double rpx;
  final double toBottom;
  final VoiceRecordProvider voiceRecordProvider;
  final XFVoiceProvider xfVoiceProvider;
  final TextEditingController txtController;
  final GoSocketProvider provider;
  final WebRTCProvider webRTCProvider;
  @override
  Widget build(BuildContext context) {
    // var channel = voiceRecordProvider.channel;
    BottomRowAnimProvider bottomRowAnimProvider=Provider.of<BottomRowAnimProvider>(context);
    var file=null;
    return Container(
      color: Colors.grey[100],
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [ Container(
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
                        onTap: () async {
                          file=await ImagePicker.pickVideo(source: ImageSource.gallery);
                          var a=0;
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
                                bottomRowAnimProvider.runAnimation();
                              },
                            ),
                      SizedBox(
                        width: 10 * rpx,
                      ),
                      voiceRecordProvider.appDocPath == null
                          ? Container()
                          : ChannelWatcher(
                              docPath: voiceRecordProvider.appDocPath,
                              goSocketProvider: provider,
                              xFVoice: xfVoiceProvider,
                            ),
                    ],
                  ),
                ),
                ChatBottomFuncSheet(webRTCProvider: webRTCProvider,)
                
          ]
        )
      )
    );
  }
}

class ChannelWatcherVTT extends StatefulWidget {
  ChannelWatcherVTT({Key key, @required this.xfVoice}) : super(key: key);
  final XFVoiceProvider xfVoice;
  @override
  _ChannelWatcherVTTState createState() => _ChannelWatcherVTTState();
}

class _ChannelWatcherVTTState extends State<ChannelWatcherVTT> {
  XFVoiceProvider xfVoiceProvider;
  @override
  void initState() {
    // TODO: implement initState
    xfVoiceProvider=widget.xfVoice;
    xfVoiceProvider.addListener((){
      setState(() {
        
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var channel = xfVoiceProvider.channelVTT;
    return (channel != null && channel.stream != null)
        ? StreamBuilder(
            stream: channel.stream,
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                XFVoiceConvertModel data =
                    XFVoiceConvertModel.fromJson(json.decode(snapShot.data));
                print(data.data.result);
              }
              return Container();
            },
          )
        : Container();
  }
}

class ChannelWatcher extends StatefulWidget {
  ChannelWatcher(
      {Key key,
      @required this.docPath,
      @required this.goSocketProvider,
      @required this.xFVoice})
      : super(key: key);
  // final IOWebSocketChannel channel;
  final String docPath;
  final GoSocketProvider goSocketProvider;
  final XFVoiceProvider xFVoice;
  @override
  _ChannelWatcherState createState() => _ChannelWatcherState();
}

class _ChannelWatcherState extends State<ChannelWatcher> {
  IOWebSocketChannel channel;
  String filePath;
  String fileStream = "";
  List<int> fileIntList = List<int>();
  bool ifAdded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if(channel?.sink!=null){
      channel.sink.close();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    channel = widget.xFVoice.channelTTV;
    return (channel == null || channel.stream == null)
        ? Container()
        : StreamBuilder(
            stream: channel.stream,
            // initialData: initialData ,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var result = jsonDecode(snapshot.data);
                fileStream = result["data"]["audio"].toString();
                fileIntList.addAll(base64.decode(fileStream));
                if (result["data"]["status"] == 2) {
                  String docPath = widget.docPath;
                  String filePath =
                      p.join(docPath, Uuid().v4().toString() + ".pcm");
                  Future.delayed(Duration(seconds: 2)).then((_) {
                    if (!ifAdded) {
                      ifAdded = true;
                      File file = File(filePath);
                      file.writeAsBytesSync(fileIntList);
                      widget.goSocketProvider.addVoiceFromXF(filePath);
                    }
                  });
                }
              }
              return Container();
            },
          );
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
