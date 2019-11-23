import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatRow.dart';
class ChatDetailList extends StatelessWidget {
  const ChatDetailList({Key key, @required this.chatProvider})
      : super(key: key);
  final SignalRProvider chatProvider;
  @override
  Widget build(BuildContext context) {
    String ava1 =
        'https://pic2.zhimg.com/v2-d2f3715564b0b40a8dafbfdec3803f97_is.jpg';
    String ava2 =
        'https://pic4.zhimg.com/v2-0edac6fcc7bf69f6da105fe63268b84c_is.jpg';

    List<ChatRecord> records;
    records = chatProvider.records;
    // records.add(ChatRecord(avatarUrl: ava1, sender: 0, content: "你吃了么？"));
    // records.add(ChatRecord(avatarUrl: ava2, sender: 1, content: "没吃呢"));
    // records.add(ChatRecord(avatarUrl: ava1, sender: 0, content: "那快去吃饭吧！"));
    // records.add(ChatRecord(
    //     avatarUrl: ava2,
    //     sender: 1,
    //     content: "原来你不请我吃饭啊 \n 我还在这等你呢 \n 1231231231"));
    VoiceRecordProvider voiceRecordProvider =
        Provider.of<VoiceRecordProvider>(context);
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        if (records[index].chatType == 0) {
          return ChatRow(
              avatarUrl: records[index].avatarUrl,
              content: records[index].content,
              sender: records[index].sender,
              chatType: 0,
              );
        } else if (records[index].chatType == 1) {
          return GestureDetector(
            onTap: () {
                      voiceRecordProvider.playVoice(records[index].content);
                    },
            child: ChatRow(
              avatarUrl: records[index].avatarUrl,
                content: records[index].content,
                sender: records[index].sender,
                chatType: 1,
                voiceDuration: records[index].voiceDuration,
            )
          );
        } else {
          return Container();
        }
      },
    );
  }
}