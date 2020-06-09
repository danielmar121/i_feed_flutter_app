import 'package:flutter/foundation.dart';

import 'package:enum_to_string/enum_to_string.dart';

import 'user_role.dart';

class UserDetails {
  String email;
  UserRole role;
  String username;
  String avatar;

  UserDetails({
    @required this.email,
    @required this.role,
    @required this.username,
    @required this.avatar,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'role': EnumToString.parse(role),
        'username': username,
        'avatar': avatar,
      };
}
