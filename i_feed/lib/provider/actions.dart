import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../model/details/element_id.dart';
import '../model/details/invoke_by.dart';
import '../model/details/user_id.dart';
import '../model/feed_action.dart';

import 'package:i_feed/model/feed_element.dart';

class FeedActions with ChangeNotifier {
  // final hostAndPort = 'http://10.0.0.3:8083/acs'; // wifi connection
  final hostAndPort = 'http://10.0.2.2:8083/acs'; // localhost
  final UserId _manager =
      new UserId(domain: "2020b.eylon.mizrahi", email: "manager@manager.com");

  Future<void> addFeedingArea(
      FeedElement map, LatLng pickedLocation, UserId userId) async {
    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'add-feeding_area',
        element: ElementId(domain: map.elementId.domain, id: map.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: {
          'managerDomain': _manager.domain,
          'managerEmail': _manager.email,
          'elementName': 'feeding area',
          'elementLat': pickedLocation.latitude,
          'elementLng': pickedLocation.longitude,
          'fullFoodBowl': 0,
          'fullWaterBowl': 0,
        });
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );

      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeFeedingArea(FeedElement feedElement, UserId userId) async {
    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'remove-feeding_area',
        element: ElementId(
            domain: feedElement.elementId.domain, id: feedElement.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: {
          'managerDomain': _manager.domain,
          'managerEmail': _manager.email,
          'elementName': 'feeding area',
          'elementLat': feedElement.location.lat,
          'elementLng': feedElement.location.lng,
          'fullFoodBowl': 0,
          'fullWaterBowl': 0,
        });
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateFoodBowl(FeedElement editedFoodBowl, UserId userId) async {
    final actionAttributes = {
      'managerDomain': _manager.domain,
      'managerEmail': _manager.email,
      "state": !editedFoodBowl.elementAttributes['state'],
      "animal": editedFoodBowl.elementAttributes['animal'],
      "weight": editedFoodBowl.elementAttributes['weight'],
      "brand": editedFoodBowl.elementAttributes['brand'],
      "lastFillDate": DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 24 * 2)
          .toIso8601String(),
    };
    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'refill-food_bowl',
        element: ElementId(
            domain: editedFoodBowl.elementId.domain,
            id: editedFoodBowl.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: actionAttributes);
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addFoodBowl(
      FeedElement editedFoodBowl, FeedElement feedArea, UserId userId) async {
    final actionAttributes = {
      'managerDomain': _manager.domain,
      'managerEmail': _manager.email,
      'elementName': 'food bowl',
      'elementLat': feedArea.location.lat,
      'elementLng': feedArea.location.lng,
      "state": true,
      "animal": editedFoodBowl.elementAttributes['animal'],
      "weight": editedFoodBowl.elementAttributes['weight'],
      "brand": editedFoodBowl.elementAttributes['brand'],
      "lastFillDate": DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 24 * 2)
          .toIso8601String(),
    };
    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'add-food_bowl',
        element: ElementId(
            domain: feedArea.elementId.domain, id: feedArea.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: actionAttributes);
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeFoodBowl(FeedElement feedElement, UserId userId) async {
    final actionAttributes = {
      'managerDomain': _manager.domain,
      'managerEmail': _manager.email,
      'elementName': 'food bowl',
      'elementLat': feedElement.location.lat,
      'elementLng': feedElement.location.lng,
      "state": true,
      "animal": feedElement.elementAttributes['animal'],
      "weight": feedElement.elementAttributes['weight'],
      "brand": feedElement.elementAttributes['brand'],
      "lastFillDate": DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 24 * 2)
          .toIso8601String(),
    };

    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'remove-food_bowl',
        element: ElementId(
            domain: feedElement.elementId.domain, id: feedElement.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: actionAttributes);
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addWaterBowl(
      FeedElement editedWaterBowl, FeedElement feedArea, UserId userId) async {
    final actionAttributes = {
      'managerDomain': _manager.domain,
      'managerEmail': _manager.email,
      'elementName': 'water bowl',
      'elementLat': feedArea.location.lat,
      'elementLng': feedArea.location.lng,
      "state": true,
      "waterQuality": editedWaterBowl.elementAttributes['waterQuality'],
    };
    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'add-water_bowl',
        element: ElementId(
            domain: feedArea.elementId.domain, id: feedArea.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: actionAttributes);
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateWaterBowl(
      FeedElement editedWaterBowl, UserId userId) async {
    final actionAttributes = {
      'managerDomain': _manager.domain,
      'managerEmail': _manager.email,
      "state": !editedWaterBowl.elementAttributes['state'],
      "waterQuality": editedWaterBowl.elementAttributes['waterQuality'],
    };
    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'refill-water_bowl',
        element: ElementId(
            domain: editedWaterBowl.elementId.domain,
            id: editedWaterBowl.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: actionAttributes);
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> removeWaterBowl(FeedElement waterBowl, UserId userId) async {
    final actionAttributes = {
      'managerDomain': _manager.domain,
      'managerEmail': _manager.email,
      'elementName': 'water bowl',
      'elementLat': waterBowl.location.lat,
      'elementLng': waterBowl.location.lng,
      "state": !waterBowl.elementAttributes['state'],
      "waterQuality": waterBowl.elementAttributes['waterQuality'],
    };

    FeedAction addFeedingAreaInvokeAction = FeedAction(
        actionId: null,
        type: 'remove-water_bowl',
        element: ElementId(
            domain: waterBowl.elementId.domain, id: waterBowl.elementId.id),
        createdTimestamp: null,
        invokedBy: InvokedBy(userId: userId),
        actionAttributes: actionAttributes);
    try {
      final response = await http.post(
        hostAndPort + "/actions",
        headers: {"Content-Type": "application/json"},
        body: json.encode(addFeedingAreaInvokeAction.toJson()),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
