
import 'dart:convert';
import 'dart:io';

import 'package:chat_demo/Model/goWebsocketModel.dart';
import 'package:web_socket_channel/io.dart';

typedef MethodInvacationFunc = void Function(List<Object> arguments);
class SocketHelper{


  IOWebSocketChannel channel;
  Map<String, List<MethodInvacationFunc>> _methods;
  isStringEmpty(String orig){
    if (orig=="" || orig==null || orig.length==0){
      return true;
    }
    return false;
  }
  
  on(String methodName, MethodInvacationFunc newMethod){
    if (isStringEmpty(methodName) || newMethod == null) {
      return;
    }

    methodName = methodName.toLowerCase();
    if (_methods[methodName] == null) {
      _methods[methodName] = [];
    }

    // Preventing adding the same handler multiple times.
    if (_methods[methodName].indexOf(newMethod) != -1) {
      return;
    }

    _methods[methodName].add(newMethod);
  }


  

}