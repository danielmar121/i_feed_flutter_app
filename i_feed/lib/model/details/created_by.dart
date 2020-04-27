import 'package:flutter/foundation.dart';

import './user_id.dart';

class CreatedBy {
  UserId userId;

  CreatedBy({
    @required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId.toJson(),
      };
}
