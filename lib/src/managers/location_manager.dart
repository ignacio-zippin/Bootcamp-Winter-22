import 'dart:io';

import 'package:location/location.dart';
import 'package:playground_app/src/managers/permission_manager.dart';
import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

class LocationModel {
  bool? serviceEnabled;
  bool? hasPermission;
  double? latitude;
  double? longitude;

  LocationModel(
      {this.latitude, this.longitude, this.hasPermission, this.serviceEnabled});

  bool hasValues() {
    return longitude != null && latitude != null;
  }
}

class LocationManager {
  static final LocationManager _instance = LocationManager._constructor();

  factory LocationManager() {
    return _instance;
  }

  LocationManager._constructor();

  Location location = Location();

  final LocationModel _locationModel = LocationModel();
  LocationModel? get lastLocation => _locationModel;

  Future<LocationModel> getCurrentLocation() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return LocationModel(
          hasPermission: true,
          serviceEnabled: true,
          latitude: -24.7892,
          longitude: -65.4103);
    }
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    _locationModel.serviceEnabled = serviceEnabled;
    if (!serviceEnabled) {
      _locationModel.latitude = null;
      _locationModel.longitude = null;
      return _locationModel;
    }

    bool hasPermission = await PermissionManager().getPermissionForLocation();
    _locationModel.hasPermission = hasPermission;
    if (!hasPermission) {
      _locationModel.latitude = null;
      _locationModel.longitude = null;
      return _locationModel;
    }

    LocationData data = await location.getLocation();
    _locationModel.latitude = data.latitude;
    _locationModel.longitude = data.longitude;
    return _locationModel;
  }

  double pi = 3.141592653589793238;

  double toRadians(double degree) {
    return degree * pi / 180;
  }

  double toDegrees(double radian) {
    return radian * 180 / pi;
  }

  //midPoint(double lat1, double lon1, double lat2, double lon2) {
  midPoint(LatLng latLng1, LatLng latLng2) {
    
    double lat1 = latLng1.latitude;
    double lon1 = latLng1.longitude;
    double lat2 = latLng2.latitude;
    double lon2 = latLng2.longitude;
    double dLon = toRadians(lon2 - lon1);

    //convert to radians
    // lat1 = toRadians(lat1);
    // lat2 = toRadians(lat2);
    // lon1 = toRadians(lon1);

    lat1 = latLng1.latitudeInRad;
    lat2 = latLng2.latitudeInRad;
    lon1 = latLng1.longitudeInRad;

    double bx = math.cos(lat2) * math.cos(dLon);
    double by = math.cos(lat2) * math.sin(dLon);
    double lat3 = math.atan2(math.sin(lat1) + math.sin(lat2),
        math.sqrt((math.cos(lat1) + bx) * (math.cos(lat1) + bx) + by * by));
    double lon3 = lon1 + math.atan2(by, math.cos(lat1) + bx);

    return LatLng(toDegrees(lat3), toDegrees(lon3));
  }

  
}
