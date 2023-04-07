import Flutter
import UIKit

public class MobimapPlugin: NSObject, FlutterPlugin,FlutterStreamHandler {
    var sink: FlutterEventSink?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: ChanelName.method.rawValue, binaryMessenger: registrar.messenger())
        let instance = MobimapPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        //    let eventGPSChannel = FlutterEventChannel(name: ChanelName.eventGPS.rawValue, binaryMessenger: registrar.messenger())
        //    eventGPSChannel.setStreamHandler(instance)
        //    let eventNetworkChannel = FlutterEventChannel(name: ChanelName.eventNetwork.rawValue, binaryMessenger: registrar.messenger())
        //    eventNetworkChannel.setStreamHandler(instance)
    }
    @objc public static func register(with registrar: FlutterPluginRegistrar ,_ application: UIApplication,
                                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?,futterViewControler:FlutterViewController!) {
            var appDelegatePlugin:AppDelegatePlugin = AppDelegatePlugin();
            appDelegatePlugin.application = application;
            appDelegatePlugin.flutterViewControler = futterViewControler;
            appDelegatePlugin.launchOptions = launchOptions
            appDelegatePlugin.registerChanelMethod(controler: appDelegatePlugin.flutterViewControler)
            appDelegatePlugin.registerEventMethod(controler: appDelegatePlugin.flutterViewControler)
            appDelegatePlugin.registerNotification(application:appDelegatePlugin.application)
    //        appDelegatePlugin.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.sink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.sink = nil
        return nil
    }
}
