

import 'package:google_maps_flutter/google_maps_flutter.dart';

class UtilsHelper {
  UtilsHelper._();

  /// Convert a [String] to location
  /// The [String] have format: "(latitude,longitude)"
  static LatLng? stringToLocation(String location) {
    try {
      if (location.isEmpty) return null;
      location = location.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '');
      final temp = location.split(',');
      return LatLng(double.parse((temp[0])), double.parse((temp[1])));
    } catch (e) {
      return null;
    }
  }

  /// The result value is: "(latitude,longitude)"
  static String locationToString(LatLng location) {
    return '(${location.latitude},${location.longitude})';
  }
}
