import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentEditingProvider with ChangeNotifier{
  bool ifEdited;
  TextEditingController txtController = TextEditingController();
  ContentEditingProvider(){
    ifEdited=false;
  }
  updateEditStatus(String content){
    if(content!=null && content.length>0){
      ifEdited=true;
      
    }
    else{
      ifEdited=false;
    }
    notifyListeners();
  }
}