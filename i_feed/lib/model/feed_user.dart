import 'package:flutter/foundation.dart';

import 'package:enum_to_string/enum_to_string.dart';

import './details/user_id.dart';
import './details/user_role.dart';

class FeedUser {
  UserId userId;
  UserRole role;
  String username;
  String avatar;

  FeedUser({
    @required this.userId,
    @required this.role,
    @required this.username,
    @required this.avatar,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId.toJson(),
        'role': EnumToString.parse(role),
        'username': username,
        'avatar': avatar,
      };
}
