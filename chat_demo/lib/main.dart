import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/chatListProvider.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/chatDetail.dart';
import 'Provider/contentEditingProvider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '简单聊天',
      theme: ThemeData(primaryColor: Colors.blueGrey),
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

class ChatList extends StatelessWidget {
  const ChatList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatListProvider provider = Provider.of<ChatListProvider>(context);
    if (provider == null) {
      return Center(child: CircularProgressIndicator());
    }
    ScrollController controller = ScrollController();
    return SingleChildScrollView(
        controller: controller,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // ChatBox(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: provider.chats.length,
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(providers: [
                                    ChangeNotifierProvider(
                                      builder: (_) => VoiceRecordProvider(),
                                    ),
                                    ChangeNotifierProvider(
                                      builder: (_) => ContentEditingProvider(),
                                    ),
                                    ChangeNotifierProvider(
                                        builder: (_) => XFVoiceProvider())
                                  ], child: DetailPage())));
                    },
                    child: ListTile(
                      leading: Image.network(
                          provider.chats[index].userIds[0].avatarUrl),
                      title: Text(provider.chats[index].userIds[0].userName),
                      subtitle: Text(provider.chats[index].lastContent),
                      trailing: Text(provider.chats[index].lastUpdateTime),
                    )),
                Divider()
              ]);
            },
          )
        ]));
  }
}

class ChatBox extends StatelessWidget {
  const ChatBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    double triHeight = 14 * rpx;
    double triWidth = 20 * rpx;
    return Container(
      // width: 500 * rpx,
      // alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.centerLeft,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: triWidth),
            padding: EdgeInsets.all(20 * rpx),
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10 * rpx)),
            child: Text("safasdfasdfasdf asdf asa  asdf \n asdfasdf "),
          ),
          Positioned(
              left: 0,
              top: 25 * rpx,
              child: CustomPaint(
                painter: ChatBoxPainter(height: triHeight, width: triWidth),
              )),
        ],
      ),
    );
  }
}

class ChatBoxPainter extends CustomPainter {
  ChatBoxPainter({@required this.width, @required this.height});
  final double width;
  final double height;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..color = Colors.greenAccent;

    Path path = Path()
      ..moveTo(0, height / 2)
      ..lineTo(width, height)
      ..lineTo(width, 0)
      ..lineTo(0, height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ChatBoxPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ChatBoxPainter oldDelegate) => false;
}
