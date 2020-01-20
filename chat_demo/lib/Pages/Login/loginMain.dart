import 'package:chat_demo/Pages/Login/loginBox.dart';
import 'package:chat_demo/Provider/loginProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BackgroundSlideMain(),
          BackgroundSlideToChange(),
          Positioned(
            left: 0,
            top: 250 * rpx,
            child: LoginBox(),
          ),
          Positioned(
            bottom:230 * rpx,
            left: 0,
            child: Container(
              width: 750 * rpx,
              padding: EdgeInsets.symmetric(horizontal: 40 * rpx),
              child: Divider(color: Colors.blueGrey),
            ),
          ),
          Positioned(
            bottom: 100 * rpx,
            left: 0,
            child: Container(
              width: 750 * rpx,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.face,
                    size: 100 * rpx,
                    color: Colors.white70,
                  ),
                  Icon(
                    Icons.face,
                    size: 100 * rpx,
                    color: Colors.white70,
                  ),
                  Icon(
                    Icons.face,
                    size: 100 * rpx,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BackgroundSlideMain extends StatelessWidget {
  const BackgroundSlideMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);
    return Opacity(
      opacity: provider.opacityMain,
      child: Image.asset(
        'lib/images/chat${provider.index}.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

class BackgroundSlideToChange extends StatelessWidget {
  const BackgroundSlideToChange({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);
    return Opacity(
      opacity: provider.opacityToChange,
      child: Image.asset(
        'lib/images/chat${provider.indexToChange}.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
