import 'dart:convert';

import 'package:chat_demo/Model/SendMsgTemplate.dart';
import 'package:chat_demo/Model/chatModel.dart';
import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Model/goReceiveMsgModel.dart';
import 'package:chat_demo/Model/goWebsocketModel.dart';
import 'package:chat_demo/Model/sqliteModel/tchatlog.dart';
import 'package:chat_demo/Model/sqliteModel/tuser.dart';
import 'package:chat_demo/Provider/chatListProvider.dart';
import 'package:chat_demo/Provider/chatRecordsProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:chat_demo/Tools/sqliteHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class GoSocketProvider with ChangeNotifier {
  IOWebSocketChannel channel;
  String socketUrl = "ws://192.168.0.3:5000/socket";
  List<ChatModel> records = List<ChatModel>();
  var connId;
  String ava1;
  String ava2;
  IOWebSocketChannel conn;
  String loginId;
  String toUser;
  ChatRecordsProvider chatRecordsProvider;
  ChatListProvider chatListProvider;
  GoSocketProvider(String userId) {
    loginId = userId;
    connWebSocket(userId);
  }

  updateChatListProvider(ChatListProvider provider){
    chatListProvider=provider;
  }
  updateChatDetail(ChatRecordsProvider provider){
    chatRecordsProvider=provider;
    // notifyListeners();
  }
  setConn(connection) {
    conn = connection;
    notifyListeners();
  }

  connWebSocket(String userId) async {
    records = List<ChatModel>();
    ava1 = 'https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_is.jpg';
    ava2 = 'https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg';

    
    channel = IOWebSocketChannel.connect("$socketUrl?userId=$userId");
    channel.stream.listen((msg) async {
      // print(msg);
      var mapResult = json.decode(msg);
      GoReceiveMsgModel receiveMsgModel = GoReceiveMsgModel.fromJson(mapResult);
      switch (receiveMsgModel.callbackName) {
        case "onConn":
          connId = jsonDecode(receiveMsgModel.jsonResponse)["connId"];
          notifyListeners();
          break;
        case "onReceiveMsg":
          print("$msg from on receive");
          var msgModel = json.decode(msg);
          TChatLog chatLog =
              TChatLog.fromJson(json.decode(msgModel["jsonResponse"]));
          await SqliteHelper().insertChatRecord(chatLog, loginId);
          Tuser user=await SqliteHelper().getUserInfo(chatLog.fromUser);
          ChatModel chatModel=ChatModel(contentModel: chatLog);
          chatModel.user=user;
          chatModel.contentModel=chatLog;
          if(chatRecordsProvider!=null && chatRecordsProvider?.ifDisposed!=true){
            chatRecordsProvider.updateChatRecordsInChat(chatModel);
          }
          
          chatListProvider.refreshChatList(loginId);
          break;
        default:
          break;
      }
    }, onError: (err) {
      print('err is $err');
    }, onDone: () {
      print('done');
    });
    notifyListeners();
  }

  invoke(String methodName, {Map<String, Object> args}) {
    args = args ?? Map<String, Object>();
    if (channel != null && channel.stream != null) {
      GoWebsocketModel socketModel =
          GoWebsocketModel(args: args, methodName: methodName);
      String jsonData = jsonEncode(socketModel);
      channel.sink.add(base64.decode(jsonData));
    }
  }

  // addChatRecord(ChatRecord record) {
  //   records.add(record);
  //   notifyListeners();
  // }

  sendMessage(msg, from,to,contentType) {
    // records.add(ChatRecord(
    //     content: msg, avatarUrl: ava1, sender: SENDER.SELF, chatType: 0));
    // conn.invoke('receiveMsgAsync', args: [
    //   jsonEncode(
    //       SendMsgTemplate(fromWho: connId, toWho: '', message: msg,avatarUrl: ava1,makerName: "张三").toJson())
    // ]);
    channel.sink.add(jsonEncode(SendMsgTemplate(
            fromUser: from, toUser: to, content: msg, contentType: contentType)
        .toJson()));
    TChatLog chatLog =
        TChatLog(fromUser: from, toUser: to, content: msg, contentType: contentType);
    SqliteHelper().insertChatRecord(chatLog, loginId);
    notifyListeners();
  }

  // addVoiceFromXF(String filePath) {
  //   records.add(ChatRecord(
  //     content: filePath,
  //     avatarUrl: ava2,
  //     sender: 0,
  //     chatType: 1,
  //     voiceDuration: 3,
  //   ));
  //   notifyListeners();
  // }
}
