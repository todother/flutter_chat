import 'package:chat_demo/Model/sqliteModel/tuser.dart';
import 'package:chat_demo/Pages/ChatPage/chatDetail.dart';
import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/bottomRowAnimProvider.dart';
import 'package:chat_demo/Provider/chatListProvider.dart';
import 'package:chat_demo/Provider/chatRecordsProvider.dart';
import 'package:chat_demo/Provider/chooseFileProvider.dart';
import 'package:chat_demo/Provider/contentEditingProvider.dart';
import 'package:chat_demo/Provider/friendsProvider.dart';
import 'package:chat_demo/Provider/globalDataProvider.dart';
import 'package:chat_demo/Provider/goSocketProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Provider/webRTCProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsMain extends StatelessWidget {
  const FriendsMain(
      {Key key,
      @required this.goSocketProvider,
      @required this.webRTCProvider,
      @required this.globalDataProvider,@required this.chatListProvider})
      : super(key: key);
  final GoSocketProvider goSocketProvider;
  final WebRTCProvider webRTCProvider;
  final GlobalDataProvider globalDataProvider;
  final ChatListProvider chatListProvider;
  @override
  Widget build(BuildContext context) {
    FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context);
    List<Tuser> users = friendsProvider.friends;
    return Scaffold(
      body: Container(child: 
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                          builder: (_) => VoiceRecordProvider(),
                                        ),
                                        ChangeNotifierProvider(
                                          builder: (_) =>
                                              ContentEditingProvider(),
                                        ),
                                        ChangeNotifierProvider(
                                            builder: (_) => XFVoiceProvider()),
                                        ChangeNotifierProvider(
                                          builder: (_) =>
                                              BottomRowAnimProvider(context),
                                        ),
                                        ChangeNotifierProvider(
                                          builder: (_) => ChooseFileProvider(),
                                        ),
                                        ChangeNotifierProvider(
                                          builder: (_) => ChatRecordsProvider(
                                              globalDataProvider.userId,
                                              users[index].userId),
                                        )
                                      ],
                                      child: DetailPage(
                                        webRTCProvider: webRTCProvider,
                                        goSocketProvider: goSocketProvider,
                                        otherId: users[index].userId,
                                        chatListProvider: chatListProvider,
                                      ))));
                    },
                    child: ListTile(
                      leading: Image.network(users[index].avatar),
                      title: Text(users[index].userName),
                    )),
                Divider()
              ]);
            },
            itemCount: users.length,
            
          )
        ));
  }
}