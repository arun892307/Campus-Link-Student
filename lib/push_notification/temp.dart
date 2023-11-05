import 'dart:async';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }

class CurrentLocationManager{

  String logStr = '';
  LocationDto? _lastLocation;
  StreamSubscription<LocationDto>? locationSubscription;
  LocationStatus _status = LocationStatus.UNKNOWN;

  Future<GeoPoint> getCurrentLocation() async =>
      onData(await LocationManager().getCurrentLocation());

  GeoPoint onData(LocationDto location) {
    print('>> $location');
    return GeoPoint(location.latitude, location.longitude);
  }

  Future<bool> isLocationAlwaysGranted() async => await Permission.locationAlways.isGranted;

  Future<bool> askForLocationAlwaysPermission() async {
    bool granted = await Permission.locationAlways.isGranted;
    print("...........$granted");
  if (!granted) {
    granted =
        await Permission.locationAlways.request() == PermissionStatus.granted;
  }
    print("...........back from permission");
  return granted;
  }

  void start() async {
    // ask for location permissions, if not already granted
    if (!await isLocationAlwaysGranted()) {
      await askForLocationAlwaysPermission();
    }
    await LocationManager().start();
    locationSubscription?.cancel();
    locationSubscription = LocationManager().locationStream.listen(onData);
    await LocationManager().start();

  }

  void stop() {
    locationSubscription?.cancel();
    LocationManager().stop();

  }
}