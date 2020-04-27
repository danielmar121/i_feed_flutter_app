import 'package:flutter/foundation.dart';

class UserId {
  String domain;
  String email;

  UserId({
    @required this.domain,
    @required this.email,
  });

  Map<String, dynamic> toJson() => {
        'domain': domain,
        'email': email,
      };
}
