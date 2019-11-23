class ChatRecord {
  int sender;
  String content;
  String avatarUrl;
  int chatType;
  int voiceDuration;
  ChatRecord(
      {this.sender,
      this.content,
      this.avatarUrl,
      this.chatType,
      this.voiceDuration});
}