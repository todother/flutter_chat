import 'package:json_annotation/json_annotation.dart';
part 'tchatlog.g.dart';

@JsonSerializable()
class TChatLog {
  String loginId;
  String toUser;
  String fromUser;
  String content;
  int contentType;
  DateTime insertTime;
  String imgPath;
  String videoPath;
  String voicePath;
  int voiceLength;
  String otherId;//the userId for the other one in chat
  String grpId; //if grpId is null , means 1 on 1 chat
  String locaddress;
  double imgWidth;
  double imgHeight;
  String title;
  String locationImg;
  TChatLog(
      {this.loginId,
      this.contentType,
      this.toUser,
      this.content,
      this.fromUser,
      this.grpId,
      this.imgPath,
      this.insertTime,
      this.videoPath,
      this.voiceLength,
      this.voicePath,
      this.otherId,this.locaddress,this.imgHeight,this.imgWidth,this.locationImg,this.title});
factory TChatLog.fromJson(Map<String, dynamic> json) =>
      _$TChatLogFromJson(json);
  Map<String, dynamic> toJson() => _$TChatLogToJson(this);
    
}
