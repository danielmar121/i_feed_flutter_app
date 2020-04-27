import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/details/element_id.dart';
import '../model/details/invoke_by.dart';
import '../model/details/user_id.dart';
import '../model/details/action_id.dart';
import '../model/feed_action.dart';

class FeedActions with ChangeNotifier {
  static const url = 'http://10.0.2.2:8083/acs';

  List<FeedAction> _actions = [
    FeedAction(
        actionId: ActionId(
          domain: null,
          id: null,
        ),
        type: "type",
        element: ElementId(domain: "domain", id: "id"),
        createdTimestamp: DateTime.now(),
        invokedBy: InvokedBy(
            userId: UserId(
          domain: "domain",
          email: "email",
        )),
        actionAttributes: {"daniel": 16, "mar": "hey"})
  ];

  List<FeedAction> get actions {
    return [..._actions];
  }

  Future<void> invokeAction() async {
    try {
      final response = await http.post(
        url + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(_actions[0].toJson()),
      );

      print(json.decode(response.body));

      _actions[0].actionId = ActionId(
          domain: json.decode(response.body)['actionId']['domain'],
          id: json.decode(response.body)['actionId']['id']);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteAllActions() async {
    try {
      final response = await http.delete(
        url + "/admin/actions/daniel/daniel",
        headers: {"Content-Type": "application/json"},
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getAllActions() async {
    try {
      final response = await http.get(
        url + "/admin/actions/daniel/daniel",
        headers: {"Content-Type": "application/json"},
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
