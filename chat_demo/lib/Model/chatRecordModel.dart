class ChatRecord {
  int sender;
  String content;
  String avatarUrl;
  int chatType;
  int voiceDuration;
  String address;
  String title;
  String locationImg;
  ChatRecord(
      {this.sender,
      this.content,
      this.avatarUrl,
      this.chatType,
      this.voiceDuration,
      this.locationImg,
      this.address,
      this.title
      });
}