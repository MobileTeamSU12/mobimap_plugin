import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobimap_plugin/src/native_channel_handler.dart';
import 'package:mobimap_plugin/src/native_constants_value.dart';
import 'package:mobimap_plugin/src/utils_helper.dart';

/// Containing all function relate on GPS: get current location, get GPS status (GPS on or off) or listen it
class MobiMapGPSPlugin{

  /// Open the GPS setting (the default setting app of this device)
  static Future<void> openGpsSetting() async {
      NativeChannelHandler.call(function: NativeFunction.openGPSSetting);
  }

  /// Get the current location
  static Future<LatLng> getLocation() async {
    try{
      return UtilsHelper.stringToLocation(await NativeChannelHandler.call(function: NativeFunction.getLocation))!;
    }catch(e){
      return const LatLng(0, 0);
    }
  }

  /// [onReceiveData] : call back when get a new status
  /// EX:
  /// DeviceGPS.listenGPSStatus((status){
  ///   if(status){
  ///     print('GPS is on now');
  ///   }
  /// });
  static StreamSubscription? listenGPSStatus({Function(bool status)? onReceiveData}) {
    return NativeChannelHandler.eventListener<bool>(channel: NativeChanel.EVENT_GPS_STATUS, onReceiveData: (status) {
      if(onReceiveData == null) return;
      onReceiveData(status);
    });
  }

  /// Get the current status of GPS (GPS on or off)
  static Future<bool> getGpsStatus() async {
    try{
      return await NativeChannelHandler.call(function: NativeFunction.getGpsStatus);
    }catch(e){
      return false;
    }
  }
}