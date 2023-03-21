//
//  NetworkMonitor1.swift
//  Runner
//
//  Created by ThanhTC on 9/8/22.
//

import Foundation
import Flutter
open class NetworkMonitorStreamHandler:NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    var timer: Timer?
    var param: Any?
    var parentVCtrl:FlutterViewController!
    init(parentVCtrl:FlutterViewController) {
        self.parentVCtrl = parentVCtrl
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
       // timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendNetworkStatus), userInfo: nil, repeats: true)
//        self.sendNetworkStatus()
        return nil
    }
    @objc func sendNetworkStatus() {
        guard let sink = sink else { return }
//        let check =  AppPermission(parentVCtrl: self.parentVCtrl).checkInternetConnectionStatus()
        AppPermission(parentVCtrl: self.parentVCtrl).checkInternetConnectionStatus { (status, mes) in
            if ((self.timer) != nil){
                [self.timer!.invalidate];
                self.timer = nil;
            }
            if (!status){
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.sendNetworkStatus), userInfo: nil, repeats: true)
            }
            sink(status)
        }
        
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
}
