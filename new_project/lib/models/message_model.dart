class MessageModel {
  final String? senderId;
  final String? content;
  final String? conversationId;
  final String? timestamps;

  MessageModel(
      {this.content, this.conversationId, this.senderId, this.timestamps});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        content: json['content'] ?? '',
        conversationId: json['conversationId'] ?? '',
        senderId: json['senderId'] ?? '',
        timestamps: json['timestamps'] ?? '');
  }
}
