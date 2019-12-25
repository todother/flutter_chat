import 'package:flutter/material.dart';

class ChatRecord {
  int sender;
  String content;
  String avatarUrl;
  int chatType;
  int voiceDuration;
  String address;
  String title;
  String locationImg;
  double imgHeight;
  double imgWidth;
  BoxFit imgFitType;
  String videoPath;
  ChatRecord(
      {this.sender,
      this.content,
      this.avatarUrl,
      this.chatType,
      this.voiceDuration,
      this.locationImg,
      this.address,
      this.title,
      this.imgFitType,
      this.imgHeight,
      this.imgWidth,
      this.videoPath});
}
