import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:new_project/models/user_model.dart';
part 'conversation_model.g.dart';

@HiveType(typeId: 1)
class Conversation {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final List<UserModel>? participants;

  Conversation({this.id, this.participants});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> participantsJson = json['participants'];

    var conversation = Conversation(
        id: json['_id'],
        participants:
            participantsJson.map((user) => UserModel.fromJson(user)).toList());

    return conversation;
  }
}
