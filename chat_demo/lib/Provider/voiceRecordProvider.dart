import 'dart:convert';
import 'dart:io';

import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceRecordProvider with ChangeNotifier {
  bool ifTap;
  FlutterSound flutterSound;
  String appDocPath;
  String filePath;

  DateTime start;
  String fileName;
  DateTime end;
  String uploadPath;
  WebSocketChannel channel;

  bool ifVoiceRecord;
  @override
  void dispose() {
    flutterSound.stopRecorder();
    super.dispose();
  }

  VoiceRecordProvider() {
    flutterSound = FlutterSound();
    ifTap = false;
    ifVoiceRecord = false;
    getAppDocPath();
  }

  ffmpegConverter(String filePath, SignalRProvider signalR) async {
    var channel = "com.guojio.todother/ffmpeg";
    var platform = MethodChannel(channel);
    try {
      var result =
          await platform.invokeMethod("runFfmpeg", {"filePath": filePath.replaceAll("file:///", "")});
      signalR.addVoiceChatRecord(result["mediaDuration"], 1, "/"+result["path"].toString());
      notifyListeners();
    } catch (e) {
      print(e);
    }
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

  initNewChannel() {
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
    channel = IOWebSocketChannel.connect(uri);
    print(channel.closeReason);
    print(channel.closeCode);
    print(channel.stream);
    var data = <String, dynamic>{
      "common": {"app_id": "5ddc9677"},
      "business": {"vcn": "xiaoyan", "aue": "speex-wb;7", "speed": 50},
      "data": {
        "status": 2,
        "encoding": "utf8",
        "text": base64.encode(utf8.encode('这是随便发的一句话'))
      }
    };
    String jsonString = jsonEncode(data);
    // channel.changeStream
    channel.sink.add(jsonString);
    // channel.changeStream((_) {
    //   notifyListeners();
    //   // return _;
    // });

    // notifyListeners();

    StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot);
        return Container();
      },
    );
  }

  updateVoiceRecord() {
    ifVoiceRecord = !ifVoiceRecord;
    notifyListeners();
  }

  getAppDocPath() async {
    var folder = await getApplicationDocumentsDirectory();
    appDocPath = folder.path;
    notifyListeners();
  }

  beginRecord(SignalRProvider signalRProvider) async {
    ifTap = true;
    fileName = Uuid().v4().toString();
    String fileType = '';
    if (Platform.isIOS) {
      fileType = '.m4a';
    } else {
      fileType = '.mp4';
    }
    // Directory appDocDir = await getApplicationDocumentsDirectory();

    // if (!appDocDir.existsSync()) {
    //   appDocDir.createSync(recursive: true);
    // }
    // appDocPath = appDocDir.path;
    // filePath = p.join(appDocPath, fileName + fileType);
    filePath = fileName + fileType;
    // if (!File(filePath).existsSync()) {
    //   File(filePath).createSync();
    // }
    signalRProvider.updateVoicePath(filePath);
    start = DateTime.now();
    Future<String> result = flutterSound.startRecorder(filePath);
    result.then((path) {
      print('startRecorder: $path');
      signalRProvider.updateVoicePath(path);
      uploadPath = path;
      notifyListeners();
      // return fileName;
    });
  }

  stopRecord() async {
    ifTap = false;
    await flutterSound.stopRecorder();

    // end = DateTime.now();

    notifyListeners();
  }

  uploadVoice(sender, SignalRProvider signalR, voiceLength) async {
    String path = File(uploadPath).path.replaceAll("file:///", "");

    Dio dio = Dio();
    var formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: filePath),
      "name": filePath,
      "sender": sender
    });
    String urlPath = "http://192.168.0.6:5000/upload/uploadFiles";
    var response = await dio.post(urlPath, data: formData);
    signalR.notifyVoice(fileName, voiceLength);
    dio.close();
  }

  playVoice(filePath) async {
    bool ifPlaying = flutterSound.isPlaying;

    if (ifPlaying) {
      await flutterSound.stopPlayer();
    } else {
      await flutterSound.startPlayer(filePath);
    }
  }

  cancelRecord() async {
    ifTap = false;
    await flutterSound.stopRecorder();
    if (File(filePath).existsSync()) {
      File(filePath).delete();
    }
    notifyListeners();
  }
}
