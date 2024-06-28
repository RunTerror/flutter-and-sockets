import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_project/api/remote_api.dart';
import 'package:new_project/models/user_model.dart';

class FindPage extends StatefulWidget {
  const FindPage({super.key});

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  final Api _api = Api();

  late Future<List<UserModel>?> getUsers;

  @override
  void initState() {
    getUsers = getAllUsers();
    super.initState();
  }

  Future<List<UserModel>?> getAllUsers() async {
    return _api.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Users'),
        ),
        body: FutureBuilder(
          future: getUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            final users = snapshot.data;

            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index].email!),
                    subtitle: Text(users[index].name!),
                    trailing: IconButton(
                        onPressed: () {
                          log(users[index].id!.toString());
                          _api.addFriend(users[index].id!);
                        },
                        icon: const Icon(Icons.add)),
                  );
                },
              );
            }
            return const Text('nothing found');
          },
        ));
  }
}
