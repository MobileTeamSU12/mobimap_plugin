//
//  NetworkMonitor.swift
//  Runner
//
//  Created by ThanhTC on 8/22/22.
//

import Foundation
import Network
@available(iOS 12.0, *)
public class NetworkMonitor{
    public static var shared = NetworkMonitor()
    private let monitor:NWPathMonitor
    private let queue  = DispatchQueue.global()
    var isConected:Bool = false
    var connectionType:ConnectionType? = .wifi
    private init() {
        self.monitor = NWPathMonitor()
    }
    func startMonitoring(){
        self.monitor.start(queue: self.queue)
        self.monitor.pathUpdateHandler = {[weak self] path in
            self?.isConected = path.status == .satisfied
            self?.getConectionType(path: path)
        }
    }
    func stopMonitoring(){
        self.monitor.cancel()
    }
    func getConectionType(path:NWPath){
        if (path.usesInterfaceType(.wifi)){
            self.connectionType = .wifi
            return
        }
        if (path.usesInterfaceType(.cellular)){
            self.connectionType = .cellular
            return
        }
        if (path.usesInterfaceType(.wiredEthernet)){
            self.connectionType = .ethernet
            return
        }
        if (path.usesInterfaceType(.loopback)){
            self.connectionType = .unknow
            return
        }
        if (path.usesInterfaceType(.other)){
            self.connectionType = .unknow
            return
        }
    }
}
