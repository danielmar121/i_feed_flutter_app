import 'package:flutter/foundation.dart';

class ElementId {
  String domain;
  String id;

  ElementId({
    @required this.domain,
    @required this.id,
  });

  String get getDomain {
    return domain;
  }

  String get getId {
    return id;
  }

  Map<String, dynamic> toJson() => {
        'domain': domain,
        'id': id,
      };
}
