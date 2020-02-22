import 'dart:async';
import 'dart:io';

import 'package:chat_demo/Model/userLoginModel.dart';
import 'package:chat_demo/Provider/themeProvider.dart';
import 'package:chat_demo/Tools/dioHelper.dart';
import 'package:chat_demo/Tools/sqliteHelper.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'goSocketProvider.dart';

class LoginProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {
  Animation<double> backgroundAnimation;
  AnimationController backgroundController;
  TextEditingController userNameController = TextEditingController();
  double opacityMain = 1;
  double opacityToChange = 0;
  int index = 0;
  int indexToChange = 1;
  List<String> imgList;
  Timer interval;
  bool ifValidUserName = false;
  String userName;
  String imei;
  SqliteHelper sqliteHelper;

  bool ifStartRequest = false;

  int curLoginWidget; //0 quick 1 normal

  getImei() async {
    String imeiT;
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      imeiT = iosInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var andInfo = await DeviceInfoPlugin().androidInfo;
      imeiT = andInfo.androidId;
    }
    return imeiT;
  }

  LoginProvider() {
    initPage();
  }

  Future ifNeedLogin() async {
    
  }

  initPage() {
    curLoginWidget = 0;
    userNameController.addListener(() {
      // print('in');
      userName = userNameController.text;
      ifValidUserName = checkValidUserName(userName);
      // print(ifValidUserName);
      notifyListeners();
    });
    imgList = List<String>();
    imgList.add('lib/images/chat0.jpg');
    imgList.add('lib/images/chat1.jpg');
    imgList.add('lib/images/chat2.jpg');
    imgList.add('lib/images/chat3.jpg');
    backgroundController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    backgroundAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(backgroundController)
          ..addListener(() {
            opacityMain = 1 - backgroundAnimation.value;
            opacityToChange = backgroundAnimation.value;
            notifyListeners();
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              index = index + 1;
              indexToChange = indexToChange + 1;
              if (index == imgList.length) {
                index = 0;
              }

              if (indexToChange == imgList.length) {
                indexToChange = 0;
              }

              opacityMain = 1;
              opacityToChange = 0;
              notifyListeners();
            }
          });
    interval = Timer.periodic(Duration(seconds: 5), (callback) {
      backgroundController.forward(from: 0);
    });
  }

  changeLoginBox() {
    curLoginWidget = curLoginWidget == 0 ? 1 : 0;
    notifyListeners();
  }

  ifUserExistsByTelNo(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = DioHelper().dio;
    ifStartRequest = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    imei = await getImei();
    var result = await dio.get("/user/ifUserExistsByTelNo",
        queryParameters: {"telNo": "18611111881", "imei": imei});
    ifStartRequest = false;
    notifyListeners();
    if (result.data["result"] == true) {
      sqliteHelper = SqliteHelper();
      await sqliteHelper.delCurLoginRecord();
      String loginId=result.data["userId"];
      await sqliteHelper.addNewLogin(loginId, imei);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        builder: (_) => GoSocketProvider(),
                      ),
                      ChangeNotifierProvider(
                        builder: (_) => ThemeProvider(prefs),
                      ),
                    ],
                    child: MyApp(
                      prefs: prefs,
                    ),
                  )),
          ModalRoute.withName("homepage"));
    } else {
      Fluttertoast.showToast(
          msg: "当前手机号尚未注册",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey[300],
          textColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  bool checkValidUserName(String userName) {
    bool ifMatch = RegExp("[^A-Za-z0-9]+").hasMatch(userName);
    return ifMatch;
  }

  @override
  void dispose() {
    interval.cancel();
    backgroundController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  addNewUser() async {
    Dio dio = DioHelper().dio;
    var response = await dio.post("/user/addNewUser",
        queryParameters: {"userName": userName},
        data: {"urlPath": "www.google.com"});
    print(response.data);
  }
}
