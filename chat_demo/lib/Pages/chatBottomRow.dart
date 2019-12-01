import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:chat_demo/Pages/recordVoiceRow.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart' as p;

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
    var channel = voiceRecordProvider.channel;
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
              ),
              // voiceRecordProvider.appDocPath == null
              //     ? Container()
              //     : ChannelWatcher(
              //         docPath: voiceRecordProvider.appDocPath,
              //         signalR: provider,
              //       )
            ],
          ),
        )));
  }
}

class ChannelWatcher extends StatefulWidget {
  ChannelWatcher({Key key, @required this.docPath, @required this.signalR})
      : super(key: key);
  // final IOWebSocketChannel channel;
  final String docPath;
  final SignalRProvider signalR;
  @override
  _ChannelWatcherState createState() => _ChannelWatcherState();
}

class _ChannelWatcherState extends State<ChannelWatcher> {
  IOWebSocketChannel channel;
  String filePath;
  String fileStream = "";
  List<int> fileIntList=List<int>();
  bool ifAdded = false;
  @override
  void initState() {
    super.initState();

    String auth = genChannelToken();

    Uri uri = Uri(
        host: "tts-api.xfyun.cn",
        scheme: "wss",
        path: "v2/tts",
        port: null,
        queryParameters: <String, dynamic>{
          "authorization": auth,
          "data":
              HttpDate.format(DateTime.now().toLocal().add(Duration(hours: 8))),
          "host": "tts-api.xfyun.cn"
        });
    String url =
        "wss://tts-api.xfyun.cn/v2/tts?authorization=$auth&date=${HttpDate.format(DateTime.now().toLocal().add(Duration(hours: 8)))}&host=tts-api.xfyun.cn";
    Uri trans = Uri.tryParse(url);
    channel = IOWebSocketChannel.connect(trans);
    var data = <String, dynamic>{
      "common": {"app_id": "5ddc9677"},
      "business": {"vcn": "aisjiuxu", "aue": "raw", "tte": "UTF8", "speed": 50},
      "data": {
        "status": 2,
        "text": base64.encode(utf8.encode('我们遇到什么问题也不要怕勇敢的面对它战胜恐惧的最好办法就是面对恐惧加油奥利给'))
      }
    };
    String jsonString = jsonEncode(data);
    channel.sink.add(jsonString);
  }

  String genChannelToken() {
    String host = "tts-api.xfyun.cn";
    String date =
        HttpDate.format(DateTime.now().toLocal().add(Duration(hours: 8)));
    String request = "GET /v2/tts HTTP/1.1";
    String apiSecret = "da7f50cf02885bb7501195c258d49630";
    String apiKey = "71f9a0ab12cdf0a22ed82a82c1c57eaf";
    String signatureOrigin = "host: $host\ndate: $date\n$request";
    var shaKey = utf8.encode(apiSecret);
    var hmac = Hmac(sha256, shaKey);
    var signatureSha = hmac.convert(utf8.encode(signatureOrigin)).bytes;
    var signatureResult = base64Encode(signatureSha);
    String authOrig =
        'api_key="$apiKey",algorithm="hmac-sha256",headers="host date request-line",signature="$signatureResult"';

    return base64Encode(utf8.encode(authOrig));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // IOWebSocketChannel channel=widget.channel;
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
                      widget.signalR.addVoiceFromXF(filePath);
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
