import 'package:flutter/foundation.dart';
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
}
