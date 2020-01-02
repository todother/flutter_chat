import 'package:chat_demo/Provider/chatListProvider.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/webRTCProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/MainPage/chatList.dart';

void main(List<String> args) {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        builder: (_) => SignalRProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  const MyApp({Key key}) : super(key: key);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.resumed) {
      print('resumed');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '简单聊天',
      theme: ThemeData(
          primaryColor: Colors.blueGrey,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  SignalRProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("简单聊天"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: MultiProvider(providers: [
        ChangeNotifierProvider(
          builder: (_) => ChatListProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => WebRTCProvider(context),
        )
      ], child: ChatList()),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.chat_bubble,
                color:
                    // Colors.blue
                    Theme.of(context).primaryColor,
              ),
              title: Text("聊天")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.perm_identity,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.chat_bubble,
                color: Colors.greenAccent,
              ),
              title: Text("聊天"))
        ],
      ),
    );
  }
}
