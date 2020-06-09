import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:provider/provider.dart';

import '../model/details/location.dart';
import '../model/details/user_id.dart';
import '../model/feed_element.dart';
import '../provider/users.dart';
import '../provider/elements.dart';
import '../provider/actions.dart';
import '../widget/app_drawer.dart';
import '../widget/button_with_icon.dart';
import '../screen/feeding_area_details_screen.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';

  final Location initialLocation;
  final bool isSelecting;
  MapScreen({
    this.initialLocation =
        const Location(lat: 32.07483037619601, lng: 34.77195315063),
    this.isSelecting = true,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  Map<String, Marker> _markers = {};
  Completer<GoogleMapController> _mapController = Completer();
  location.LocationData currentLocation;
  GoogleMapController mapController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _selectPosition(LatLng position) {
    _pickedLocation = position;
    setState(() {
      _markers['position'] = Marker(
          markerId: MarkerId('position'),
          onTap: () {},
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ));
    });
  }

  Future<void> _refresh() async {
    final GoogleMapController mapController = await _mapController.future;
    currentLocation = await location.Location().getLocation();
    UserId userId = Provider.of<Users>(context).user.userId;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      ),
      zoom: 16,
    )));
    final elementsNearBy = await Provider.of<Elements>(context, listen: false)
        .getAllFeedAreaNearBy(currentLocation, userId);
    Set<Marker> markers = elementsNearBy
        .map((element) => Marker(
            markerId: MarkerId(element.elementId.id),
            onTap: () {
              Navigator.of(context).pushNamed(
                  FeedingAreaDetailsScreen.routeName,
                  arguments: element.elementId.id);
            },
            position: LatLng(element.location.lat, element.location.lng),
            icon: element.elementAttributes['fullFoodBowl'] == 0 ||
                    element.elementAttributes['fullWaterBowl'] == 0
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  )
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  )))
        .toSet();
    setState(() {
      _markers = {};
      markers.forEach((marker) {
        _markers[marker.markerId.value] = marker;
      });
    });
  }

  void _addFeedingArea() async {
    UserId userId = Provider.of<Users>(context).user.userId;
    FeedElement map = Provider.of<Elements>(context, listen: false).map;
    if (map == null) {
      map = await Provider.of<Elements>(context, listen: false)
          .findElementByName('map', userId);
    }

    Provider.of<FeedActions>(context, listen: false)
        .addFeedingArea(map, _pickedLocation, userId);
    setState(() {
      _markers.remove('position');
    });
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('iFeed'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_location),
              onPressed: _addFeedingArea,
            )
          ],
        ),
        drawer: AppDrawer(),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: currentLocation != null
                    ? LatLng(
                        currentLocation.latitude,
                        currentLocation.longitude,
                      )
                    : LatLng(
                        widget.initialLocation.lat,
                        widget.initialLocation.lng,
                      ),
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              onTap: widget.isSelecting ? _selectPosition : null,
              markers: _markers.values.toSet(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  widthFactor: 150,
                  child: Container(
                    width: 150,
                    child: ButtonWithIcon(
                      title: 'Refresh',
                      color: Theme.of(context).primaryColor,
                      icon: Icons.refresh,
                      function: _refresh,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ],
        ));
  }
}
