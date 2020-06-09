import 'package:flutter/foundation.dart';

class Location {
  final double lat;
  final double lng;

  const Location({
    @required this.lat,
    @required this.lng,
  });

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
