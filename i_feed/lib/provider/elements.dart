import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/details/element_Id.dart';
import '../model/details/created_by.dart';
import '../model/details/user_id.dart';
import '../model/details/location.dart';

import '../model/feed_element.dart';

class Elements with ChangeNotifier {
  List<FeedElement> _elements = [
    FeedElement(
        elementId: ElementId(
          domain: "domain",
          id: "elementId",
        ),
        type: "type",
        name: "name",
        active: true,
        createdTimestamp: DateTime.now(),
        createdBy: CreatedBy(userId: UserId(domain: "domain", email: "email")),
        location: Location(lat: 10, lng: 20),
        elementAttributes: {"daniel": 16, "mar": "hey"})
  ];

  List<FeedElement> get elements {
    return [..._elements];
  }

  Future<void> createElement() async {
    const url = 'http://10.0.2.2:8083/acs/elements/daniel/daniel';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'elementId': _elements[0].elementId.toJson(),
          'type': _elements[0].type,
          'name': _elements[0].name,
          'active': _elements[0].active,
          'createdTimestamp': _elements[0].createdTimestamp.toIso8601String(),
          'createdBy': _elements[0].createdBy.toJson(),
          'location': _elements[0].location.toJson(),
          'elementAttributes': _elements[0].elementAttributes,
        }),
      );
      _elements[0].elementId = ElementId(
          domain: json.decode(response.body)['elementId']['domain'],
          id: json.decode(response.body)['elementId']['id']);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getAllElements() async {
    const url = 'http://10.0.2.2:8083/acs/elements/daniel/daniel';
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getSpecificElement() async {
    final url =
        'http://10.0.2.2:8083/acs/elements/daniel/daniel/${_elements[0].elementId.getDomain}/${_elements[0].elementId.getId}';
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteAllElements() async {
    final url = 'http://10.0.2.2:8083/acs/admin/elements/daniel/daniel';
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );
      // print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateElement() async {
    final url =
        'http://10.0.2.2:8083/acs/elements/daniel/daniel/${_elements[0].elementId.getId}/${_elements[0].elementId.getDomain}';
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'elementId': _elements[0].elementId.toJson(),
          'type': "another type",
          'name': null,
          'active': _elements[0].active,
          'createdTimestamp': _elements[0].createdTimestamp.toIso8601String(),
          'createdBy': _elements[0].createdBy.toJson(),
          'location': _elements[0].location.toJson(),
          'elementAttributes': _elements[0].elementAttributes,
        }),
      );
      print(json.decode(response.body));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // Future<void> fetchAndSetProducts() async {
  //   const url =
  //       'https://udemy-flutter-shopapp-54cdd.firebaseio.com/products.json';
  //   try {
  //     final response = await http.get(url);
  //     final List<Product> loadedProduct = [];
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) return;
  //     extractedData.forEach((prodId, prodData) {
  //       loadedProduct.add(Product(
  //         id: prodId,
  //         title: prodData['title'],
  //         description: prodData['description'],
  //         price: prodData['price'],
  //         imageUrl: prodData['imageUrl'],
  //         isFavorite: prodData['isFavorite'],
  //       ));
  //       _items = loadedProduct;
  //       notifyListeners();
  //     });
  //   } catch (error) {
  //     throw (error);
  //   }
  // }
}
