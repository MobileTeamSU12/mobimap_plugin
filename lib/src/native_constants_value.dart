class NativeChanel{
  NativeChanel._();

  /// prefix
  static const PREFIX = 'com.fpt.isc.mobimap_plugin';

  /// channel name (native module)
  static const CHANNEL_NAME = '$PREFIX/MobiMapMethod';

  static const EVENT_CHANNEL_NAME = '$PREFIX/MobiMapEvent';
  static const EVENT_PERMISSION_NAME = '$PREFIX/PermissionEvent';
  static const EVENT_GPS_STATUS = '$PREFIX/MobiMapEventGPS';
  static const EVENT_INTERNET_CONNECTION = '$PREFIX/MobiMapEventNetwork';

  /// fun channel fun name
  static const FUN_OS_VERSION = 'os_version';
  static const FUN_REQUEST_PERMISSION = 'request_permission';
}

class NativeFunction{

  NativeFunction._();

  static const String getLocation = 'getLocation';
  static const String openGPSSetting = 'openGPSSetting';
  static const String openAppSetting = 'openAppSetting';
  static const String listenGPSStatus = 'listenGPSStatus';
  static const String getImageFromGallery = 'getImageFromGallery';
  static const String updateAppVersion = 'updateAppVersion';
  static const String requestPermission = 'requestPermission';
  static const String getInternetConnection = 'getInternetConnection';
  static const String getImei = 'getImei';
  static const String getOperatingSystemVersion = 'getOperatingSystemVersion';
  static const String takePhoto = 'takePhoto';
  static const String getGpsStatus = 'getGpsStatus';
  static const String getVersionApp = 'getVersionApp';
  static const String getHashCommit = 'getHashCommit';
  static const String launchBrowser = 'launchBrowser';

  ///Đang xem xét
  static const String saveImageToGallery = 'saveImageToGallery';
  static const String connectPrinter = 'connectPrinter';
  static const String QRcode = 'QRcode';
  // Printer
  static const String checkConnnecPrinterWifi = 'checkConnnecPrinterWifi';
  static const String connectChannelPrinter = 'connectChannelPrinter';
  static const String connectWifiPrinter = 'connectWifiPrinter';

}

class NativeArgument{
  NativeArgument._();

  static const String fileName = 'fileName';
  static const String filePath = 'filePath';
  static const String drawText = 'drawText';
  static const String fileData = 'fileData';
  static const String permissionType = 'permissionType';
  static const String url = 'url';
  // For Printer
  static const String printerModel = 'printerModel';
  static const String printerSSID = 'printerSSID';
  static const String printerPass = 'printerPass';
  static const String printerIPAddess = 'printerIPAddess';
}
