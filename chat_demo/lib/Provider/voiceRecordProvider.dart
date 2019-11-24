import 'dart:convert';
import 'dart:io';

import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  uploadVoice(sender,SignalRProvider signalR,voiceLength) async {
    String path=File(uploadPath).path.replaceAll("file:///", "");
    
    Dio dio=Dio();
    var formData=FormData.fromMap({
      "file":await MultipartFile.fromFile(path,filename: filePath),
      "name":filePath,
      "sender":sender
    });
    String urlPath="http://192.168.0.6:5000/upload/uploadFiles";
    var response=await dio.post(urlPath,data:formData );
    signalR.notifyVoice(fileName,voiceLength);
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
