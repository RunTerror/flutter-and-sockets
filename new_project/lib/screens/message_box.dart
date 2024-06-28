import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/locator.dart';
import 'package:new_project/models/message_model.dart';
import 'package:new_project/models/user_model.dart';
import 'package:new_project/socket_services.dart';

class MessageBox extends StatefulWidget {
  final UserModel reciever;
  final String conversationId;

  const MessageBox(
      {super.key, required this.reciever, required this.conversationId});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final SocketService _socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController
  String senderId = localApi.userModel!.id!;
  List<MessageModel> messages = []; // List to hold messages

  @override
  void initState() {
    super.initState();
    fetch();
    _socketService.connect(localApi.userModel!.id!);
    _socketService.joinConversation(widget.conversationId);
    _socketService.onReceiveMessage((message) {
      var newMessage = MessageModel.fromJson(message);
      setState(() {
        messages.add(newMessage);
      });
      _scrollToBottom(); // Scroll to bottom when a new message is added
    });
  }

  fetch() async {
    final fethedMessages = await api.getMessages(widget.conversationId, 1, 10);

    log('message len: ${fethedMessages?.length.toString()}');

    for (var message in fethedMessages!) {
      messages.add(message);
    }
    setState(() {});
  }

  void sendMessage(String text) async {
    log(widget.conversationId.toString());
    _socketService.sendMessage(widget.conversationId, senderId, text);
    _messageController.clear();
    _scrollToBottom(); // Scroll to bottom when a message is sent
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.reciever.name!),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach ScrollController
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isSender = message.senderId == senderId;
                final dateTime = DateTime.parse(message.timestamps!);
                String formattedTime = DateFormat('HH:mm').format(dateTime);
                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Makes the row take only the required width
                      mainAxisAlignment: isSender
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            message.content!,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5), // Add a small gap
            color: Colors.white, // Add background color to make gap visible
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // api.getMessages(widget.conversationId, 1, 10);
                    if (_messageController.text.trim().isNotEmpty) {
                      sendMessage(_messageController.text.trim());
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
