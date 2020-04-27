import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/details/user_details.dart';
import '../model/details/user_id.dart';
import '../model/details/user_role.dart';
import '../model/feed_user.dart';

class Users with ChangeNotifier {
  List<FeedUser> _users = [
    FeedUser(
        userId: UserId(
          domain: "domain",
          email: "email",
        ),
        role: UserRole.ADMIN,
        username: "username",
        avatar: "avatar")
  ];

  UserDetails newUser = UserDetails(
    email: "email",
    role: UserRole.ADMIN,
    username: "username",
    avatar: "avatar",
  );

  List<FeedUser> get users {
    return [..._users];
  }

  Future<void> createUser() async {
    const url = 'http://10.0.2.2:8083/acs/users';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': newUser.email,
          'role': EnumToString.parse(newUser.role),
          'username': newUser.username,
          'avatar': newUser.avatar,
        }),
      );
      print(json.decode(response.body));
      _users[0].role = EnumToString.fromString(
          UserRole.values, json.decode(response.body)['role']);
      _users[0].avatar = json.decode(response.body)['avatar'];
      _users[0].username = json.decode(response.body)['username'];
      _users[0].userId = UserId(
        domain: json.decode(response.body)['userId']['domain'],
        email: json.decode(response.body)['userId']['email'],
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login() async {
    const url =
        'http://10.0.2.2:8083/acs/users/login/2020b.eylon.mizrahi/email';
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getAllUsers() async {
    const url =
        'http://10.0.2.2:8083/acs/admin/users/2020b.eylon.mizrahi/email';
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteAllUsers() async {
    final url =
        'http://10.0.2.2:8083/acs/admin/users/2020b.eylon.mizrahi/email';
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );
      // print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateUser() async {
    final url =
        'http://10.0.2.2:8083/acs/users/${_users[0].userId.domain}/${_users[0].userId.email}';
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'userId': UserId(domain: "daniel", email: "email"),
          'role': EnumToString.parse(UserRole.ADMIN),
          'username': "test username",
          'avatar': "test avatar",
        }),
      );
      // print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
