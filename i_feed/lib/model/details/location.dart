import 'package:flutter/foundation.dart';

class Location {
  double lat;
  double lng;

  Location({
    @required this.lat,
    @required this.lng,
  });

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
