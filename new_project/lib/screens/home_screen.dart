import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/api/remote_api.dart';
import 'package:new_project/locator.dart';
import 'package:new_project/models/conversation_model.dart';
import 'package:new_project/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Api _api = Api();
  @override
  void initState() {
    getFriends = _api.getAllFriends();
    super.initState();
  }

  late Future<List<Conversation>?> getFriends;

  void _startConversation(UserModel reciever, String conversationId) async {
    final args = {'reciever': reciever, 'conversationId': conversationId};
    Navigator.pushNamed(context, '/message', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/finduser');
              },
              icon: const Icon(
                Icons.find_in_page,
                color: Colors.grey,
              ),
            ),
            IconButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/login');
                  await localApi.clearUser();
                  await localApi.deleteKey('token');
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: FutureBuilder(
          future: getFriends,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final conversations = snapshot.data!;

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No friends found'),
              );
            }

            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                Conversation conversation = conversations[index];
                String conversationId = conversation.id!;
                late UserModel reciever;
                for (var participant in conversation.participants!) {
                  String id = participant.id!;
                  if (id != localApi.userModel!.id) {
                    reciever = participant;
                    break;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 214, 211, 211),
                    onTap: () async {
                      var user = localApi.userModel;
                      user ??= await localApi.getUser();
                      _startConversation(reciever, conversationId);
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                    title: Text(reciever.name!),
                  ),
                );
              },
            );
          },
        ));
  }
}
