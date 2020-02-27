import 'package:flutter/material.dart';

class GlobalDataProvider with ChangeNotifier{
  String userId;
  updateUserId(String id ){
    userId=id;
    notifyListeners();
  }
  GlobalDataProvider(String loginId){
    userId=loginId;
  }
}