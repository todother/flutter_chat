import 'dart:convert';
import 'dart:io';

import 'package:chat_demo/Model/SendMsgTemplate.dart';
import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:chat_demo/Tools/nativeTool.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SignalRProvider with ChangeNotifier {
  HubConnection conn;
  String tempVoicePath;
  String connId;
  String ava1 =
      'https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_is.jpg';
  String ava2 =
      'https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg';

  List<ChatRecord> records;
  String hostUrl = "http://192.168.0.3";
  addVoiceChatRecord(time, sender, filePath) {
    records.add(ChatRecord(
        chatType: 1,
        content: filePath,
        voiceDuration: time,
        sender: sender,
        avatarUrl: ava1));
    notifyListeners();
  }

  addChatRecord(ChatRecord record) {
    records.add(record);
    notifyListeners();
  }

  uploadVoice(sender, String fileName, String filePath) async {
    String path = File(filePath).path.replaceAll("file:///", "");

    Dio dio = Dio();
    var formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: fileName),
      "name": fileName,
      "sender": sender
    });
    String urlPath = "$hostUrl:5000/upload/uploadFiles";
    var response = await dio.post(urlPath, data: formData);
    notifyVoice(fileName);
    dio.close();
  }

  SignalRProvider() {
    records = List<ChatRecord>();

    //chatRecord type 0 text 1 voice 2 image 3 video
    records.add(
        ChatRecord(avatarUrl: ava1, sender: 0, content: "你吃了么？", chatType: 0));
    records.add(
        ChatRecord(avatarUrl: ava2, sender: 1, content: "没吃呢", chatType: 0));
    records.add(ChatRecord(
        avatarUrl: ava1, sender: 0, content: "那快去吃饭吧！", chatType: 0));
    records.add(ChatRecord(
        avatarUrl: ava2,
        sender: 1,
        chatType: 0,
        content: "原来你不请我吃饭啊 \n 我还在这等你呢 \n 1231231231"));
    String url = '';
    if (Platform.isIOS) {
      url = '$hostUrl:5000/chatHub';
    } else {
      url = '$hostUrl:5000/chatHub';
    }
    conn = HubConnectionBuilder().withUrl(url).build();
    conn.start();

    conn.on('receiveConnId', (message) {
      connId = message.first.toString();
      notifyListeners();
    });

    conn.on('receiveMsg', (message) async {
      records.add(ChatRecord(
          content: message.first,
          avatarUrl: ava2,
          sender: SENDER.OTHER,
          chatType: 0));
      notifyListeners();
    });

    conn.on("receiveVoice", (message) async {
      Dio dio = Dio();
      String urlPath =
          "$hostUrl:5000/voiceTemp/" + message.first.toString() + ".mp3";
      Directory folder = await getTemporaryDirectory();
      String folderPath = folder.path;
      String savePath = p.join(folderPath, message.first.toString() + ".mp3");
      dio.download(urlPath, savePath).then((_) {
        records.add(ChatRecord(
          content: savePath,
          avatarUrl: ava2,
          sender: 0,
          chatType: 1,
          voiceDuration: int.parse(message[1]),
        ));
        dio.close();
        notifyListeners();
      });
    });
  }

  addVoiceFromXF(String filePath) {
    records.add(ChatRecord(
      content: filePath,
      avatarUrl: ava2,
      sender: 0,
      chatType: 1,
      voiceDuration: 3,
    ));
    notifyListeners();
  }

  sendMessage(msg) {
    records.add(ChatRecord(
        content: msg, avatarUrl: ava1, sender: SENDER.SELF, chatType: 0));
    conn.invoke('receiveMsgAsync', args: [
      jsonEncode(
          SendMsgTemplate(fromWho: connId, toWho: '', message: msg,avatarUrl: ava1,makerName: "张三").toJson())
    ]);

    notifyListeners();
  }

  notifyVoice(fileName) async {
    int voiceLength = NativeTool.getMediaDuration(fileName);
    conn.invoke("notifyVoice", args: [
      jsonEncode(SendMsgTemplate(
              fromWho: connId,
              toWho: connId,
              message: fileName,
              voiceLength: voiceLength)
          .toJson())
    ]);
  }
}
