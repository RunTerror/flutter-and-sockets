import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? email;

  UserModel({this.email, this.id, this.name});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(email: data['email'], name: data['name'], id: data['_id']);
  }
}
