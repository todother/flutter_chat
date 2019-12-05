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
    String channel = "com.guojio.todother/ffmpeg";
    var methodChannel = MethodChannel(channel);
    try {
      var result = await methodChannel
          .invokeMethod("getMediaDuration", {"filePath": filePath});
      return int.parse(result["duration"]);
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
}
