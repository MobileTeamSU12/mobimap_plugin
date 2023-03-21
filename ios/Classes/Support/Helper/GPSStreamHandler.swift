//
//  SPSStreamHandler.swift
//  Runner
//
//  Created by ThanhTC on 9/6/22.
//

import Foundation
import Flutter
open class GPSStreamHandler:NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    var param: Any?
    var parentVCtrl:FlutterViewController!
    init(parentVCtrl:FlutterViewController) {
        self.parentVCtrl = parentVCtrl
    }
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.sink = events
//        self.sendGPSStatus()
        return nil
    }
    
    @objc func sendGPSStatus() {
        guard let sink = self.sink else { return }
        AppPermission(parentVCtrl: self.parentVCtrl).requestGPSPermission { status, mes in
            sink(status)
        }
        
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
