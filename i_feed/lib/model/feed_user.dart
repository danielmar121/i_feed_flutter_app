import 'package:flutter/foundation.dart';

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
}
