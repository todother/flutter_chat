import 'dart:io';

import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:chat_demo/Tools/nativeTool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecordVoiceRow extends StatelessWidget {
  const RecordVoiceRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecordProvider provider = Provider.of<VoiceRecordProvider>(context);
    SignalRProvider signalRProvider = Provider.of<SignalRProvider>(context);
    XFVoiceProvider xfVoiceProvider = Provider.of<XFVoiceProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    // String filePath;
    runXFVoiceVTT(cmdMp3, cmdPcm, resultPath, origPath, mp3Path) async {
      await NativeTool.ffmpegConverter(cmdMp3);
      await NativeTool.ffmpegConverter(cmdPcm);
      File(origPath).delete();
      File(mp3Path).delete();
      var bytes = File(resultPath).readAsBytesSync();
      xfVoiceProvider.initChannelVTT();
      xfVoiceProvider.convertVoiceToText("5ddc9677", bytes);
    }

    return GestureDetector(
        onTapDown: (result) {
          provider.beginRecord();
          // provider.updateVoiceRecord();
        },
        onTapUp: (result) {
          provider.stopRecord();
          String resultPath = provider.uploadPath;
          String mp3Path = provider.uploadPath;
          if (Platform.isIOS) {
            resultPath = resultPath.replaceAll(MEDIATYPE.M4A, MEDIATYPE.PCM);
            mp3Path = mp3Path.replaceAll(MEDIATYPE.M4A, MEDIATYPE.MP3);
          } else {
            resultPath = resultPath.replaceAll(MEDIATYPE.MP4, MEDIATYPE.PCM);
            mp3Path = mp3Path.replaceAll(MEDIATYPE.MP4, MEDIATYPE.MP3);
          }
          String cmdMP3 =
              NativeTool.cmdForRecordToMp3(provider.uploadPath, mp3Path);
          String cmdPCM = NativeTool.cmdForRecordToPCM(mp3Path, resultPath);
          runXFVoiceVTT(
              cmdMP3, cmdPCM, resultPath, provider.uploadPath, mp3Path);
        },
        onTapCancel: () {
          provider.cancelRecord();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.all(10*rpx),
          height: 80 * rpx,
          color: provider.ifTap ? Colors.grey[600] : Colors.white,
          child: Center(
              child: Container(
                  child: Text(
            '按住 说话',
            style: TextStyle(fontSize: 30 * rpx),
          ))),
        ));
  }
}
