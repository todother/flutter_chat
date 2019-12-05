import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chat_demo/Model/xFVoiceConvertModel.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class XFVoiceProvider with ChangeNotifier {
  var textReplyOrderList = Map<int, String>(); //int 代表序列  string返回的SN
  bool speaked = false;
  var convertedText = "";
  var finalText = List<String>();
  IOWebSocketChannel channelTTV;
  IOWebSocketChannel channelVTT;

  initChannelTTV() {
    String host = "tts";
    String auth = genChannelToken(host);
    String url =
        "wss://$host-api.xfyun.cn/v2/tts?authorization=$auth&date=${HttpDate.format(DateTime.now().toLocal().add(Duration(hours: 8)))}&host=$host-api.xfyun.cn";
    Uri trans = Uri.tryParse(url);
    channelTTV = IOWebSocketChannel.connect(trans);
    notifyListeners();
  }

  initChannelVTT() {
    String host = "iat";
    String auth = genChannelToken(host);
    String url =
        "wss://$host-api.xfyun.cn/v2/iat?authorization=$auth&date=${HttpDate.format(DateTime.now().toLocal().add(Duration(hours: 8)))}&host=$host-api.xfyun.cn";
    Uri trans = Uri.tryParse(url);
    channelVTT = IOWebSocketChannel.connect(trans);
    channelVTT.stream.listen((data) {
      // print(data);
      XFVoiceConvertModel model =
          XFVoiceConvertModel.fromJson(json.decode(data));
      if (model.data.result.pgs == "rpl") {
        convertedText = "";
        model.data.result.ws.forEach((item) {
          item.cw.forEach((item) {
            convertedText += item.w;
          });
        });
        finalText.last = convertedText;
        String result = "";
        finalText.forEach((item) {
          result += item;
        });
        print(result);
      } else if (model.data.result.pgs == "apd") {
        convertedText = "";
        model.data.result.ws.forEach((item) {
          item.cw.forEach((item) {
            convertedText += item.w;
          });
        });
        finalText.add(convertedText);
        String result = "";
        finalText.forEach((item) {
          result += item;
        });
        print(result);
      }
      if (model.data.status == 2) {
        convertedText = "";
        finalText = List<String>();
        channelVTT.sink.close();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  converTextToVoice(String appid, String player, String text) {
    var data = <String, dynamic>{
      "common": {"app_id": appid},
      "business": {"vcn": player, "aue": "raw", "tte": "UTF8"},
      "data": {"status": 2, "text": base64.encode(utf8.encode(text))}
    };
    // String jsonString = jsonEncode(data);
    channelTTV.sink.add(data);
    notifyListeners();
  }

  closeChannel(IOWebSocketChannel channel) {
    channel.sink.close();
    notifyListeners();
  }

  convertVoiceToText(String appid, List<int> audio) async {
    int batchSize = 1280;
    int times = (audio.length / batchSize).ceil();
    var i = 0;
    int status = 0;
    for (i = 0; i < times; i++) {
      if (i == 0) {
        status = 0;
      } else if (i == times - 1) {
        status = 2;
      } else {
        status = 1;
      }
      var batchAudio = audio.sublist(
          i * batchSize, min((i + 1) * batchSize - 1, audio.length - 1));
      addSinkByBatch(base64Encode(batchAudio), appid, status);
      await Future.delayed(Duration(milliseconds: 40));
    }
    notifyListeners();
  }

  addSinkByBatch(String audio, String appid, int status) {
    var data = {
      "common": {"app_id": appid},
      "business": {
        "language": "zh_cn",
        "domain": "iat",
        "accent": "mandarin",
        "dwa": "wpgs"
      },
      "data": {
        "status": status,
        "format": "audio/L16;rate=16000",
        "encoding": "raw",
        "audio": audio
      }
    };
    String jsonString = jsonEncode(data);
    channelVTT.sink.add(jsonString);
    // notifyListeners();
  }

  String genChannelToken(String url) {
    String host = url + "-api.xfyun.cn";
    String date =
        HttpDate.format(DateTime.now().toLocal().add(Duration(hours: 8)));
    String request = "GET /v2/$url HTTP/1.1";
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
}
