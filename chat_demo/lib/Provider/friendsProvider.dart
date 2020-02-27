import 'dart:convert';

import 'package:chat_demo/Model/sqliteModel/tuser.dart';
import 'package:chat_demo/Tools/dioHelper.dart';
import 'package:chat_demo/Tools/sqliteHelper.dart';
import 'package:flutter/material.dart';

class FriendsProvider with ChangeNotifier {
  List<Tuser> friends = List<Tuser>();
  FriendsProvider() {
    initFriends();
  }
  initFriends() async {
    var dio = DioHelper().dio;
    var result = await dio.get('/user/getAllUsers');

    if (result.data != null) {
      var users = result.data;
      var i = 0;
      for (i = 0; i < users.length; i++) {
        Tuser model = Tuser.fromJson(users[i]);
        await SqliteHelper().addNewUser(model.userId);
      }
    }
  }

  getAllUsers() async {
    friends = await SqliteHelper().getAllUsers();
    notifyListeners();
  }
}
