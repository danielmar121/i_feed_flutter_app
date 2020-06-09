import 'package:flutter/foundation.dart';

import './details/invoke_by.dart';
import './details/action_id.dart';
import './details/element_id.dart';

class FeedAction {
  ActionId actionId;
  String type;
  ElementId element;
  DateTime createdTimestamp;
  InvokedBy invokedBy;
  Map<String, Object> actionAttributes;

  FeedAction({
    @required this.actionId,
    @required this.type,
    @required this.element,
    @required this.createdTimestamp,
    @required this.invokedBy,
    @required this.actionAttributes,
  });

  Map<String, dynamic> toJson() => {
        'actionId': actionId == null ? null : actionId.toJson(),
        'type': type,
        'element': {'elementId': element.toJson()},
        'createdTimestamp': createdTimestamp == null
            ? null
            : createdTimestamp.toIso8601String(),
        'invokedBy': invokedBy.toJson(),
        'actionAttributes': actionAttributes,
      };
}
