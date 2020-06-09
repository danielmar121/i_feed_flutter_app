import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location_platform_interface/location_platform_interface.dart';

import '../model/details/element_Id.dart';
import '../model/details/created_by.dart';
import '../model/details/user_id.dart';
import '../model/details/location.dart';

import '../model/feed_element.dart';

class Elements with ChangeNotifier {
  // final hostAndPort = 'http://10.0.0.3:8083/acs'; // wifi connection
  final hostAndPort = 'http://10.0.2.2:8083/acs'; // localhost
  FeedElement _map;

  List<FeedElement> _bowls = [];

  List<FeedElement> _feedingAreas = [];

  List<FeedElement> get bowls {
    return [..._bowls];
  }

  FeedElement get map {
    return _map;
  }

  FeedElement findBowl(String bowlId) {
    return _bowls.firstWhere((element) => element.elementId.id == bowlId,
        orElse: () => null);
  }

  FeedElement findFeedArea(String feedAreaId) {
    return _feedingAreas
        .firstWhere((element) => element.elementId.id == feedAreaId);
  }

  FeedElement _makeFeedElement(prodData) {
    return FeedElement(
      elementId: ElementId(
          domain: prodData['elementId']['domain'],
          id: prodData['elementId']['id']),
      type: prodData['type'],
      name: prodData['name'],
      active: prodData['active'],
      createdTimestamp: prodData['createdTimestamp'],
      createdBy: CreatedBy(
          userId: UserId(
        domain: prodData['createdBy']['userId']['domain'],
        email: prodData['createdBy']['userId']['email'],
      )),
      location: Location(
        lat: prodData['location']['lat'],
        lng: prodData['location']['lng'],
      ),
      elementAttributes: prodData['elementAttributes'],
    );
  }

  Future<FeedElement> findElementByName(String name, UserId userId) async {
    if (_map == null) {
      try {
        final response = await http.get(
          hostAndPort +
              '/elements/${userId.domain}/${userId.email}/search/byName/${name}',
          headers: {"Content-Type": "application/json"},
        );
        final extractedData =
            json.decode(response.body)[0] as Map<String, dynamic>;
        _map = _makeFeedElement(extractedData);
        return _map;
      } catch (error) {
        print(error);
        throw error;
      }
    }
    return _map;
  }

  Future<List<FeedElement>> getAllFeedAreaNearBy(
      LocationData currentLocation, UserId userId) async {
    final distance = 0.01;
    final type = 'feeding_area';
    try {
      final response = await http.get(
        hostAndPort +
            "/elements/${userId.domain}/${userId.email}/search/typeNearby/${currentLocation.latitude}/${currentLocation.longitude}/$distance/$type",
        headers: {"Content-Type": "application/json"},
      );

      final List<FeedElement> loadedFeedingArea = [];
      final extractedData = json.decode(response.body) as List<dynamic>;

      if (extractedData == null || extractedData.isEmpty)
        return loadedFeedingArea;

      extractedData.forEach((prodData) {
        loadedFeedingArea.add(_makeFeedElement(prodData));
      });
      _feedingAreas = loadedFeedingArea;
      return loadedFeedingArea;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<FeedElement>> getBowls(
      UserId userId, FeedElement feedArea) async {
    try {
      final response = await http.get(
        hostAndPort +
            "/elements/${userId.domain}/${userId.email}/${feedArea.elementId.domain}/${feedArea.elementId.id}/children",
        headers: {"Content-Type": "application/json"},
      );

      final List<FeedElement> loadedFeedingArea = [];
      final extractedData = json.decode(response.body) as List<dynamic>;

      if (extractedData == null || extractedData.isEmpty)
        return loadedFeedingArea;

      extractedData.forEach((prodData) {
        loadedFeedingArea.add(_makeFeedElement(prodData));
      });
      _bowls = loadedFeedingArea;
      return loadedFeedingArea;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<FeedElement> getSpecificElement(
      UserId userId, FeedElement feedArea) async {
    final url = hostAndPort +
        '/elements/${userId.domain}/${userId.email}/${feedArea.elementId.getDomain}/${feedArea.elementId.getId}';
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return _makeFeedElement(extractedData);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
