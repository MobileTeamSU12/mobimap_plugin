library mobimap_plugin;

import 'dart:async';

import 'package:mobimap_plugin/src/native_channel_handler.dart';
import 'package:mobimap_plugin/src/native_constants_value.dart';

/// this is the bridge to connect all the function native to flutter, except some function like in [NativeImageHelper]
class MobiMapPlugin {
  MobiMapPlugin._();

  /// for this function, in Android, the filePath is the path of the file, that was downloaded
  /// in IOS, the filePath is the link to swift file for the IOS system auto update
  static Future<String> updateAppVersion(String filePath) async {
    return await NativeChannelHandler.call(function: NativeFunction.updateAppVersion, arguments: {NativeArgument.filePath: filePath});
  }

  static Future<String> getImei() async {
    return await NativeChannelHandler.call(function: NativeFunction.getImei);
  }

  static Future<String> getOperatingSystemVersion() async {
    return await NativeChannelHandler.call(function: NativeFunction.getOperatingSystemVersion);
  }

  static Future<String> getAppVersion() async {
    return await NativeChannelHandler.call(function: NativeFunction.getVersionApp);
  }

  static Future<String> getHashCommit() async {
    return await NativeChannelHandler.call(function: NativeFunction.getHashCommit);
  }

  static Future<void> openAppSetting() async {
    return await NativeChannelHandler.call(function: NativeFunction.openAppSetting);
  }

  static Future<bool> requestPermission({required String type}) async {
    return await NativeChannelHandler.call(function: NativeFunction.requestPermission, arguments: {NativeArgument.permissionType: type});
  }

  static Future<bool> getInternetConnection() async {
    return await NativeChannelHandler.call(function: NativeFunction.getInternetConnection) ?? false;
  }

  static StreamSubscription<bool>? listenInternetConnection({Function(bool status)? onReceiveData}) {
    return NativeChannelHandler.eventListener<bool>(
        channel: NativeChanel.EVENT_INTERNET_CONNECTION,
        onReceiveData: (status) {
          if (onReceiveData == null) return;
          onReceiveData(status);
        });
  }

  static Future<void> launchBrowser(String url) async {
    return await NativeChannelHandler.call(function: NativeFunction.launchBrowser, arguments: {
      NativeArgument.url: url,
    });
  }

  static Future<bool> checkConnnecPrinterWifi({
    required String printerModel,
    required String printerSSID,
    required String printerPass,
    required String printerIPAddess,
  }) async {
    Map<String, dynamic>? argPrinterInfo = Map<String, dynamic>();
    argPrinterInfo = {
      NativeArgument.printerModel: printerModel,
      NativeArgument.printerSSID: printerSSID,
      NativeArgument.printerPass: printerPass,
      NativeArgument.printerIPAddress: printerIPAddess,
    };
    return await NativeChannelHandler.call(function: NativeFunction.checkConnecPrinterWifi, arguments: argPrinterInfo);
  }

  static Future<bool> connectChannelPrinter({
    required String printerModel,
    required String printerIPAddess,
  }) async {
    Map<String, dynamic>? argPrinterInfo = Map<String, dynamic>();
    argPrinterInfo = {
      NativeArgument.printerModel: printerModel,
      NativeArgument.printerIPAddress: printerIPAddess,
    };
    return await NativeChannelHandler.call(function: NativeFunction.connectChannelPrinter, arguments: argPrinterInfo);
  }
  static Future<bool> connectPrinterWifi({
  required String printerSSID,
  required String printerPass,
  }) async {
    Map<String, dynamic>? argPrinterInfo = Map<String, dynamic>();
    argPrinterInfo = {
      NativeArgument.printerSSID: printerSSID,
      NativeArgument.printerPass: printerPass,
    };
    final result = await NativeChannelHandler.call(function: NativeFunction.connectWifiPrinter, arguments: argPrinterInfo);
    print("Connect wifi: $result");
    if(result){
       final resultChannel = await MobiMapPlugin.connectChannelPrinter(printerIPAddess: "192.168.118.1", printerModel: "PT_E550W");
       print("Connect channel: $resultChannel");
       return resultChannel;
    }else{
      return result;
    }
  }

  static Future<void> printQrCode({
    required int labelSize,
    required int resolution,
    required bool isAutoCut,
    required int numCopies,
}) async {
    print("start print QRCode");
    final result = await NativeChannelHandler.call(function: NativeFunction.printQRCode, arguments: {
      NativeArgument.labelSize: 5, // 3: Width12mm, 4: Width18mm, 5: Width24mm(default)
      NativeArgument.resolution: 2, // 0: Low, 1: Normal, 2: High(default)
      NativeArgument.isAutoCut: true, // true(default)/false
      NativeArgument.numCopies: 1, // 1(default)
    });
    print(result);
  }
}
