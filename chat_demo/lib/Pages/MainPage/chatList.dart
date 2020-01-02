import 'package:chat_demo/Pages/ChatPage/chatBox.dart';
import 'package:chat_demo/Pages/ChatPage/chatDetail.dart';
import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/bottomRowAnimProvider.dart';
import 'package:chat_demo/Provider/chatListProvider.dart';
import 'package:chat_demo/Provider/chooseFileProvider.dart';
import 'package:chat_demo/Provider/contentEditingProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Provider/webRTCProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatListProvider provider = Provider.of<ChatListProvider>(context);
    WebRTCProvider webRTCProvider = Provider.of<WebRTCProvider>(context);
    if (provider == null) {
      return Center(child: CircularProgressIndicator());
    }
    ScrollController controller = ScrollController();
    return
        // GaodeMapView();
        SingleChildScrollView(
            controller: controller,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ChatBox(),
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
                                  builder: (context) => MultiProvider(
                                          providers: [
                                            ChangeNotifierProvider(
                                              builder: (_) =>
                                                  VoiceRecordProvider(),
                                            ),
                                            ChangeNotifierProvider(
                                              builder: (_) =>
                                                  ContentEditingProvider(),
                                            ),
                                            ChangeNotifierProvider(
                                                builder: (_) =>
                                                    XFVoiceProvider()),
                                            ChangeNotifierProvider(
                                              builder: (_) =>
                                                  BottomRowAnimProvider(
                                                      context),
                                            ),
                                            ChangeNotifierProvider(
                                              builder: (_) =>
                                                  ChooseFileProvider(),
                                            )
                                          ],
                                          child: DetailPage(
                                            webRTCProvider: webRTCProvider,
                                          ))));
                        },
                        child: ListTile(
                          leading: Image.network(
                              provider.chats[index].userIds[0].avatarUrl),
                          title:
                              Text(provider.chats[index].userIds[0].userName),
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
