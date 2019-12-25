import 'dart:io';

import 'package:chat_demo/Tools/nativeTool.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ChooseFileProvider with ChangeNotifier {
  String filePath;
  String compressedImagePath;
  String tempImgFolder;
  String origPath;

  ChooseFileProvider() {
    getTempFolderPath();
  }

  getTempFolderPath() async {
    var folder = await getApplicationDocumentsDirectory();
    tempImgFolder = "${folder.path}/tempVideoFrames/";
    if (! await Directory(tempImgFolder).exists()) {
      await Directory(tempImgFolder).create(recursive: true);
    }
    notifyListeners();
  }

  runFFMpeg(String cmd) async{
    await NativeTool.ffmpegConverter(cmd);
  }

  genTempOrigPath(){
    String fileId=Uuid().v4().toString();
    String result=p.join(tempImgFolder,"$fileId.mp4");
    return result;
  }

  genTempMp4Path(){
    String fileId=Uuid().v4().toString();
    String result=p.join(tempImgFolder,"$fileId.mp4");
    return result;
  }

  genTempFramePath(){
    String fileId=Uuid().v4().toString();
    String result=p.join(tempImgFolder,"$fileId.jpg");
    return result;
  }

  updateFilePath(String choosedFilePath) {
    filePath = choosedFilePath;
    notifyListeners();
  }

  updateCompressedImagePath(String imgPath) {
    compressedImagePath = imgPath;
    notifyListeners();
  }

}
