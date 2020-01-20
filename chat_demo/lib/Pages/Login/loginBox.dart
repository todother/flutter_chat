import 'dart:ui';

import 'package:flutter/material.dart';

class LoginBox extends StatelessWidget {
  const LoginBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController accountController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    double rpx = MediaQuery.of(context).size.width / 750;
    double margin = 45 * rpx;
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10 * rpx, sigmaY: 10 * rpx),
        child: Container(
            width: 750 * rpx - 2 * margin,
            margin: EdgeInsets.symmetric(horizontal: margin),
            padding:
                EdgeInsets.symmetric(horizontal: 20 * rpx, vertical: 20 * rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 30 * rpx, vertical: 20 * rpx),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20 * rpx),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 20 * rpx,
                            color: Colors.black54,
                            offset: Offset(20 * rpx, 20 * rpx))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20 * rpx,
                      ),
                      LoginTitle(
                        text: "账号/手机号",
                      ),
                      LoginTextField(
                        controller: accountController,
                        obsecure: false,
                        width: 750 * rpx - 2 * margin,
                        icon: Icon(
                          Icons.face,
                          size: 40 * rpx,
                        ),
                        hintText: "请输入您的账号/手机号",
                      ),
                      LoginTitle(
                        text: "密码",
                      ),
                      LoginTextField(
                        controller: pwdController,
                        obsecure: true,
                        width: 750 * rpx - 2 * margin,
                        icon: Icon(
                          Icons.lock,
                          size: 40 * rpx,
                        ),
                        hintText: "请输入您的密码",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text("注册账号"),
                            onPressed: () {},
                          ),
                          FlatButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text("忘记密码？"),
                            onPressed: () {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70 * rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20 * rpx)),
                        height: 90 * rpx,
                        // width: 750*rpx-2*margin,
                        padding: EdgeInsets.all(0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20 * rpx)),
                          color: Colors.green[500],
                          child: Text(
                            "登录",
                            style: TextStyle(
                                color: Colors.white, fontSize: 35 * rpx),
                          ),
                          onPressed: () {},
                        ),
                      ))
                    ],
                  ),
                )
              ],
            )));
  }
}

class LoginTitle extends StatelessWidget {
  const LoginTitle({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Text(
        text,
        style: TextStyle(fontFamily: "Pangmen", fontSize: 48 * rpx),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {Key key,
      @required this.controller,
      @required this.obsecure,
      @required this.icon,
      @required this.width,
      @required this.hintText})
      : super(key: key);
  final TextEditingController controller;
  final bool obsecure;
  final Icon icon;
  final double width;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25 * rpx),
      width: width,
      child: TextField(
        obscureText: obsecure,
        decoration: InputDecoration(
            border: InputBorder.none, icon: icon, hintText: hintText),
        style: TextStyle(fontSize: 35 * rpx),
      ),
    );
  }
}
