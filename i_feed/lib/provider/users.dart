import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/details/user_details.dart';
import '../model/details/user_id.dart';
import '../model/details/user_role.dart';
import '../model/feed_user.dart';
import '../model/http_exception.dart';

class Users with ChangeNotifier {
  final String appDomain = "2020b.eylon.mizrahi";
  FeedUser _thisUser;
  // final hostAndPort = 'http://10.0.0.3:8083'; // wifi connection
  final hostAndPort = 'http://10.0.2.2:8083'; // localhost

  FeedUser get user {
    return _thisUser;
  }

  Future<void> login(String email) async {
    final url = hostAndPort + '/acs/users/login/$appDomain/$email';

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      var responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _thisUser = FeedUser(
          userId: UserId(
              domain: responseBody['userId']['domain'],
              email: responseBody['userId']['email']),
          role: EnumToString.fromString(
              UserRole.values, json.decode(response.body)['role']),
          username: responseBody['username'],
          avatar: responseBody['avatar']);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void logOut() {
    _thisUser = null;
  }

  Future<void> updateUser(FeedUser updateUserDetails) async {
    final url = hostAndPort +
        '/acs/users/${updateUserDetails.userId.domain}/${updateUserDetails.userId.email}';
    try {
      await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(updateUserDetails.toJson()),
      );
      _thisUser = updateUserDetails;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createUser(FeedUser newFeedUser) async {
    final url = hostAndPort + '/acs/users';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          UserDetails(
                  email: newFeedUser.userId.email,
                  role: newFeedUser.role,
                  username: newFeedUser.username,
                  avatar: newFeedUser.avatar)
              .toJson(),
        ),
      );
      var responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
