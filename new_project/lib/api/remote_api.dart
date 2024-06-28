import 'dart:developer';
import 'package:new_project/locator.dart';
import 'package:new_project/models/conversation_model.dart';
import 'package:new_project/models/message_model.dart';
import 'package:new_project/models/user_model.dart';
import 'package:new_project/services/services.dart';

class Api {
  final httpService = HttpService();

  Future<UserModel?> register(
      String name, String email, String password) async {
    var data = {'name': name, 'email': email, 'password': password};

    try {
      final responseData = await httpService.post(
        'register',
        data,
      );

      // saving token
      var token = responseData['token'];
      token = 'Bearer $token';
      await localApi.saveKey('token', token);
      // taking user from data
      var userData = responseData['user'];
      final user = UserModel.fromJson(userData);
      await localApi.saveUser(user);
      return user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    var data = {'email': email, 'password': password};

    try {
      final responseData = await httpService.post('login', data);
      var token = responseData['token'];
      token = 'Bearer $token';
      await localApi.saveKey('token', token);
      final user = UserModel.fromJson(responseData['user']);
      await localApi.saveUser(user);

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<List<UserModel>?> getAllUsers() async {
    try {
      final responseData = await httpService.post('get-users', {}, auth: true);

      final List<dynamic> usersJson = responseData['users'];

      List<UserModel> users =
          usersJson.map((json) => UserModel.fromJson(json)).toList();
      return users;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> addFriend(String friendId) async {
    try {
      final responseData =
          await httpService.post('add-friend/$friendId', {}, auth: true);

      return responseData;
    } catch (e) {
      return null;
    }
  }

  Future<List<Conversation>?> getAllFriends() async {
    try {
      final responseData =
          await httpService.post('get-friends', {}, auth: true);

      final List<dynamic> friendsJson = responseData['conversations'];
      final conversations =
          friendsJson.map((e) => Conversation.fromJson(e)).toList();
      return conversations;
    } catch (e) {
      return null;
    }
  }

  Future<Conversation?> createConversation(
      String userId1, String userId2) async {
    try {
      final responseData = await httpService.post(
          'conversation', {'userId1': userId1, 'userId2': userId2},
          auth: true);

      if (responseData['conversation'] == null) return null;

      Conversation conversation =
          Conversation.fromJson(responseData['conversation']);

      return conversation;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final responseData = await httpService.post('getUser', {}, auth: true);

      // saving user
      final user = UserModel.fromJson(responseData['user']);
      await localApi.saveUser(user);

      return user;
    } catch (e) {
      log('error: $e');
      return null;
    }
  }

  Future<List<MessageModel>?> getMessages(
      String conversationId, int page, int limit) async {
    try {
      final responseData = await httpService.post('getMessages',
          {'conversationId': conversationId, 'page': page, 'limit': limit},
          auth: true);

      List<dynamic> messagesJson = responseData['messages'];

      final messages = messagesJson.map(
        (messageJson) {
          return MessageModel.fromJson(messageJson);
        },
      ).toList();

      return messages;
    } catch (e) {
      return null;
    }
  }
}
