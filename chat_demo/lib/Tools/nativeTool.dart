
import 'dart:io';

import 'package:flutter/services.dart';

class NativeTool {
  static ffmpegConverter(String cmd) async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("runFfmpeg", {"cmd": cmd});
      return result;
    } catch (e) {
      print(e);
    }
  }

  static getMediaDuration(String filePath) async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel
          .invokeMethod("getMediaDuration", {"filePath": filePath});
      return int.parse(result["duration"]);
    } catch (e) {
      print(e);
    }
  }

  static requireLocation() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("requireLocation");
      return (result["result"]);
    } catch (e) {
      print(e);
    }
  }

  static String cmdForRecordToMp3(String filePath, String resultPath) {
    String cmd = "";
    if (Platform.isIOS) {
      cmd = "-i " + filePath + "  -acodec libmp3lame -aq 2 " + resultPath;
    } else {
      cmd = "-i " + filePath + " -vn -b:a 16k -c:a libmp3lame " + resultPath;
    }
    return cmd;
  }

  static String cmdForRecordToPCM(String filePath, String resultPath) {
    String cmd =
        " -i $filePath -acodec pcm_s16le -f s16le -ac 1 -ar 16000 $resultPath";
    return cmd;
  }

  static initGaodeMap() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("initGaodeMap");
      return result;
    } catch (e) {
      print(e);
    }
  }

  static initMapPosition() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("initMapPosition");
      return result["result"];
    } catch (e) {
      print(e);
    }
  }

  static getSelPosition() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("getSelPosition");
      return result;
    } catch (e) {
      print(e);
    }
  }

  static getPoiList() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("getPoiInfo");
      return result;
    } catch (e) {
      print(e);
    }
  }

  static moveCameraToPoi(double lati, double longi, int zoomTo) async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod(
          "moveCameraToPoi", {"lati": lati, "longi": longi, "zoomTo": zoomTo});
      return result;
    } catch (e) {
      print(e);
    }
  }

  static getScreenShot() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod(
        "shotScreen",
      );
      if (result != null) {
        return result["filePath"];
      }
      return "failed";
    } catch (e) {
      print(e);
    }
  }

  static disposeMapView() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod(
        "disposeMapView",
      );
    } catch (e) {
      print(e);
    }
  }

  static changeVideoSpeed(double value, dynamic textureId) async {
    const MethodChannel _channel = MethodChannel('flutter.io/videoPlayer');
    // var methodChannel = MethodChannel(channel);
    try {
      await _channel.invokeMethod<void>("changePlayBackSpeed",
          {"changedSpeed": value, "textureId": textureId});
    } catch (e) {
      print(e);
    }
  }

  static getIntentInfo() async {
    String channel = "com.guojio.todother/notify";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod("getIntentInfo");
      if (result["result"] == true) {
        return result["chatId"];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  static getTokenForNotify() async {
    String channel = "com.guojio.todother/nativeFunc";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel.invokeMethod('genToken');
      return result["token"];
    } catch (e) {
      print(e);
    }
  }
}
