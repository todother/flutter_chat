import 'dart:convert';
import 'dart:io';

import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class VoiceRecordProvider with ChangeNotifier {
  bool ifTap;
  FlutterSound flutterSound;
  String appDocPath;
  String filePath;
  DateTime start;
  String fileName;
  DateTime end;
  String uploadPath;

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
      uploadPath=path;
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

  uploadVoice() async {



    String url = 'http://localhost:5000/upload/uploadFiles';
    uploadPath=uploadPath.replaceAll('file:///', '');
    String convertPath="";
    if(Platform.isIOS){
      convertPath=uploadPath.replaceAll(".m4a", ".mp3");
    }
    else{
      convertPath=uploadPath.replaceAll('mp4', '.mp3');
    }
    var ffmpeg=FlutterFFmpeg();
    await ffmpeg.execute('-i '+uploadPath+" -acodec libmp3lame -aq 2 "+convertPath);
    var dio=Dio();
    var formData= FormData.fromMap({
      "file":await MultipartFile.fromFile(convertPath),
      "name":fileName.split('.').first
    });
    var response=await dio.post(url,data:formData );
    print(response);
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
