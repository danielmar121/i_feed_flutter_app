import 'package:flutter/foundation.dart';

import './details/created_by.dart';
import './details/element_Id.dart';
import './details/location.dart';

class FeedElement {
  ElementId elementId;
  String type;
  String name;
  bool active;
  DateTime createdTimestamp;
  CreatedBy createdBy;
  Location location;
  Map<String, dynamic> elementAttributes;

  FeedElement({
    @required this.elementId,
    @required this.type,
    @required this.name,
    @required this.active,
    @required this.createdTimestamp,
    @required this.createdBy,
    @required this.location,
    @required this.elementAttributes,
  });

  Map<String, dynamic> toJson() => {
        'actionId': elementId.toJson(),
        'type': type,
        'name': name,
        'active': active,
        'element': element.toJson(),
        'createdTimestamp': createdTimestamp.toIso8601String(),
        'invokedBy': invokedBy.toJson(),
        'actionAttributes': actionAttributes,
      };
}
