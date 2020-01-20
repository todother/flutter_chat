import 'package:flutter/material.dart';

class RECORDSTATUS {
  static const int NOT_STARTED = -1; //尚未开始
  static const int START = 0; //录音开始
  static const int END = 1; //录音结束  抬起手
  static const int BREAK = 2; //语音中断
  static const int CANCEL = 3; //录音取消
}

class MEDIATYPE{
  static const String MP4=".mp4";
  static const String MP3=".mp3";
  static const String M4A=".m4a";
  static const String PCM=".pcm";
}

class CHATTYPE{
  static const int TEXT=0;
  static const int VOICE=1;
  static const int LOCATION=2;
  static const int IMAGE=3;

}

class SENDER{
  static const int SELF=0;
  static const int OTHER=1;
}

class THEMECOLORMAPPING{
  static const int BLUEGREY=0;
  static const int RED=1;
  static const int PURPLE=2;
  static const int YELLOW=3;
}

class THEMECOLOR{
  static const Color BLUEGREY=Colors.blueGrey;
  static const Color RED=Colors.redAccent;
  static const Color PURPLE=Colors.purpleAccent;
  static const Color YELLOW=Colors.yellowAccent;
}

class THEMEMODE{
  static const int DARK=1;
  static const int LIGHT=0;
}