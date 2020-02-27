import 'package:chat_demo/Pages/ChatPage/chatBox.dart';
import 'package:chat_demo/Pages/ChatPage/chatDetail.dart';
import 'package:chat_demo/Provider/XFVoiceProvider.dart';
import 'package:chat_demo/Provider/bottomRowAnimProvider.dart';
import 'package:chat_demo/Provider/chatListProvider.dart';
import 'package:chat_demo/Provider/chatRecordsProvider.dart';
import 'package:chat_demo/Provider/chooseFileProvider.dart';
import 'package:chat_demo/Provider/contentEditingProvider.dart';
import 'package:chat_demo/Provider/globalDataProvider.dart';
import 'package:chat_demo/Provider/goSocketProvider.dart';
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
    GlobalDataProvider globalDataProvider =
        Provider.of<GlobalDataProvider>(context);
    GoSocketProvider goSocketProvider = Provider.of<GoSocketProvider>(context);
    goSocketProvider.chatListProvider=provider;
    if (provider == null) {
      return Center(child: CircularProgressIndicator());
    }
    ScrollController controller = ScrollController();
    return
        // GaodeMapView();
        SingleChildScrollView(
            controller: controller,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // ChatBox(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: provider.chatModels.length,
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
                                            ),
                                            ChangeNotifierProvider(
                                              builder: (_) =>
                                                  ChatRecordsProvider(
                                                      globalDataProvider.userId,
                                                      provider
                                                          .chatModels[index]
                                                          .contentModel
                                                          .otherId),
                                            )
                                          ],
                                          child: DetailPage(
                                            webRTCProvider: webRTCProvider,
                                            goSocketProvider: goSocketProvider,
                                            otherId: provider.chatModels[index]
                                                .contentModel.otherId,
                                            chatListProvider:provider
                                          ))));
                        },
                        child: ListTile(
                          leading: Image.network(
                              provider.chatModels[index].user.avatar),
                          title: Text(provider.chatModels[index].user.userName),
                          subtitle: Text(
                              provider.chatModels[index].contentModel.content),
                          trailing: Text(provider
                              .chatModels[index].contentModel.insertTime
                              .toString()),
                        )),
                    Divider()
                  ]);
                },
              )
            ]));
  }
}
