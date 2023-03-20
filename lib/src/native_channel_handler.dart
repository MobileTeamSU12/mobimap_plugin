

import 'dart:async';

import 'package:flutter/services.dart';

import 'native_constants_value.dart';

class NativeChannelHandler {
  static final NativeChannelHandler instance = NativeChannelHandler._();

  factory NativeChannelHandler() => instance;

  NativeChannelHandler._();

  static const MethodChannel _platform = MethodChannel(NativeChanel.CHANNEL_NAME);

  /// Call and wait for get the data from native
  /// EX:
  /// NativeChannelHandler.call(function: NativeFunction.openGPSSetting);
  static Future<dynamic> call({required String function, Map<String, dynamic>? arguments}) async {
    try {
      return await _platform.invokeMethod(function, arguments);
    } catch (e) {
      print('error: $function $e');
      return null;
    }
  }

  /// lắng nghe event từ native code
  /// có thể sử dụng StreamBuilder để nhận data
  static Stream<T> event<T>({required EventChannel eventChannel, Map<String, dynamic>? params}) {
    try {
      return eventChannel.receiveBroadcastStream(params).cast();
    } catch (e) {
      return Stream.error(e);
    }
  }

  ///call the function and listen the value form native
  ///NativeChannelHandler.eventListener(channel: NativeChanel.EVENT_PERMISSION_NAME, onReceiveData: (value){
  ///   print('value $value');
  /// });
  static StreamSubscription<T> eventListener<T>({required String channel, Function(T data)? onReceiveData, Map<String, dynamic>? params}){
    final EventChannel eventChannel = EventChannel(channel);
    return event<T>(eventChannel: eventChannel, params: params).listen((event) {
      if(onReceiveData != null && event != null){
        onReceiveData(event);
      }
    });
  }
}
