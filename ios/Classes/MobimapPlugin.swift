import Flutter
import UIKit

public class MobimapPlugin: NSObject, FlutterPlugin {
    @objc public static var application:UIApplication!
    @objc public static var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    @objc public static var flutterViewControler:FlutterViewController!
    @objc public static var GMSServicesAPIKey:String = ""
    @objc public static var networkMonitorStreamHandler:NetworkMonitorStreamHandler!
    @objc public static var gPSStreamHandler:GPSStreamHandler!
    var sink: FlutterEventSink?
    var mobimapPluginDelegate:AppDelegatePlugin
    public override init() {

        mobimapPluginDelegate = AppDelegatePlugin();
        mobimapPluginDelegate.application = MobimapPlugin.application
        mobimapPluginDelegate.launchOptions = MobimapPlugin.launchOptions
        mobimapPluginDelegate.flutterViewControler = MobimapPlugin.flutterViewControler
        mobimapPluginDelegate.GMSServicesAPIKey = MobimapPlugin.GMSServicesAPIKey
//        mobimapPluginDelegate.application(MobimapPlugin.application, didFinishLaunchingWithOptions:MobimapPlugin.launchOptions)
    }
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MobimapPlugin()
        let channel = instance.mobimapPluginDelegate.createChanelMethod(controler: MobimapPlugin.flutterViewControler)
        registrar.addMethodCallDelegate(instance, channel: channel)
        let eventGPSChannel = FlutterEventChannel(name: ChanelName.eventGPS.rawValue, binaryMessenger: registrar.messenger())
        MobimapPlugin.gPSStreamHandler = GPSStreamHandler(parentVCtrl: MobimapPlugin.flutterViewControler)
        eventGPSChannel.setStreamHandler(MobimapPlugin.gPSStreamHandler)
        let eventNetworkChannel = FlutterEventChannel(name: ChanelName.eventNetwork.rawValue, binaryMessenger: registrar.messenger())
        MobimapPlugin.networkMonitorStreamHandler = NetworkMonitorStreamHandler(parentVCtrl: MobimapPlugin.flutterViewControler)
        eventNetworkChannel.setStreamHandler(MobimapPlugin.networkMonitorStreamHandler)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var a = call.method
        print("FlutterMethodCall_".appending(a))
        self.mobimapPluginDelegate.chanelMethodCallHandler(controler: self.mobimapPluginDelegate.flutterViewControler, call: call, result: result)
//        result("iOS " + UIDevice.current.systemVersion)
    }
//    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//        self.sink = events
//        return nil
//    }
//
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//        self.sink = nil
//        return nil
//    }
}
