import Flutter
import UIKit

public class MobimapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let channel = FlutterMethodChannel(name: ChanelName.method.rawValue, binaryMessenger: registrar.messenger())
    let instance = MobimapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let eventGPS = FlutterEventChannel(name: ChanelName.eventGPS.rawValue, binaryMessenger: registrar.messenger())
    eventGPS.setStreamHandler(instance)
    let eventNetwork = FlutterEventChannel(name: ChanelName.eventNetwork.rawValue, binaryMessenger: registrar.messenger())
    eventNetwork.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
