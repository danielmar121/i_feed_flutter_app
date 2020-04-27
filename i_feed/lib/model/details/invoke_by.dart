import 'package:flutter/foundation.dart';

import './user_id.dart';

class InvokedBy {
  UserId userId;

  InvokedBy({
    @required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId.toJson(),
      };
}
