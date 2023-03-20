//
//  AppPermition.swift
//  Runner
//
//  Created by ThanhTC on 8/18/22.
//

import Foundation
import Flutter
import AVFoundation
import PhotosUI
import CoreLocation
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import Reachability

open class AppPermission:NSObject {
    
    // MARK: Global Variable - Parameter
    var parentVCtrl:FlutterViewController!
    var completionCallLocation: ((Bool,String) -> ())?
    var completionCallInternet: ((Bool,String) -> ())?
    // MARK: init Class
    init(parentVCtrl:FlutterViewController) {
        self.parentVCtrl = parentVCtrl
    }
    
    // MARK: Check Camera Access
    func checkCameraAccess() ->(status:Bool,mes:String){
        var str:String = "Không có quyền truy cập camera"
        var status:Bool = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied , .restricted , .notDetermined:
            print("Denied, request permission from settings")
            str = "Ứng dụng cần cấp quyền truy cập camera"
            status = false
            self.presentSettings(message: str, preferenceType: PreferenceType.allSetting)
//        case .restricted:
//            print("Restricted, device owner must approve")
        case .authorized:
            str = "Đã cấp quyền"
            status = true
            print("Authorized, proceed")
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { success in
//                if success {
//                    print("Permission granted, proceed")
//                } else {
//                    print("Permission denied")
//                }
//            }
        @unknown default:
            print("Denied, request permission from settings")
        }
        return (status,str)
    }
    
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            self.gotoAppPrivacySettings(preferenceType: .video)
        })
        
        self.parentVCtrl!.present(alertController, animated: true)
    }
    // MARK: Check Proto Library Access
//    func checkProtoLibraryAccess( completion: @escaping (Bool,String) -> (Void)){
//        if #available(iOS 14, *) {
//            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] (statusAuthorization) in
//                DispatchQueue.main.async { [unowned self] in
//                    let result = self.showUIProtoLibrary(for: statusAuthorization)
//                    completion(result.status,result.mes)
//                }
//            }
//        } else {
//            let statusAuthorization:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//
//            DispatchQueue.main.async { [unowned self] in
//                let result = self.showUIProtoLibrary(for: statusAuthorization)
//                completion( result.status,result.mes)
//            }
//        }
//    }
    
    func checkProtoLibraryAccess() -> (status:Bool,mes:String) {
        if #available(iOS 14, *) {
            let statusAuthorization:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            let result = self.showUIProtoLibrary(for: statusAuthorization)
            return (result.status,result.mes)
        } else {
            let statusAuthorization:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            let result = self.showUIProtoLibrary(for: statusAuthorization)
            return (result.status,result.mes)
        }
    }
   private func showUIProtoLibrary(for statusAuthorization: PHAuthorizationStatus) ->(status:Bool,mes:String) {
        var str:String = "Không có quyền truy cập thư viện hình ảnh"
        var status:Bool = false
        switch statusAuthorization {
        case .authorized:
            str = "Ứng dụng đã cấp quyền truy cập thư viện hình ảnh"
            status = true
            break
        case .limited, .restricted, .denied , .notDetermined:
            str = "Ứng dụng cần cấp quyền truy cập thư viện hình ảnh"
            status = false
            self.presentSettings(message: str, preferenceType: PreferenceType.photosPrivacy )
        @unknown default:
            break
        }
        return (status,str)
    }
    

    func gotoAppPrivacySettings(preferenceType:PreferenceType) {
//        UIApplication.openSettingsURLString.appending(settingType.rawValue.appending("/").appending(AppInfo().appID))
//        let str:String  = "App-Prefs:".appending(preferenceType.rawValue)
        var value:String = preferenceType.rawValue
        if (value == PreferenceType.photosPrivacy.rawValue){
            value = PreferenceType.photosPrivacy.rawValue.appending("/").appending(AppInfo().appID)
        }
        guard let url = URL(string: UIApplication.openSettingsURLString.appending(value)),UIApplication.shared.canOpenURL(url)
        else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { _ in
            })
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
    }
    
    func showFullAccessUI() {
        //        manageButton.isHidden = true
        //        seeAllButton.isHidden = true
        //
        //        let photoCount = PHAsset.fetchAssets(with: nil).count
        //        infoLabel.text = "Status: authorized\nPhotos: \(photoCount)"
    }
    
    func showRestrictedAccessUI() {
        //        manageButton.isHidden = true
        //        seeAllButton.isHidden = true
        //
        //        infoLabel.text = "Status: restricted"
    }
    
    func showLimittedAccessUI() {
        //        manageButton.isHidden = false
        //        seeAllButton.isHidden = true
        //
        //        let photoCount = PHAsset.fetchAssets(with: nil).count
        //        infoLabel.text = "Status: limited\nPhotos: \(photoCount)"
    }
    
    func showAccessDeniedUI() {
        //        manageButton.isHidden = true
        //        seeAllButton.isHidden = false
        //
        //        infoLabel.text = "Status: denied"
    }
    
    // MARK: Check GPS Access
    func checkGPSAccess() -> (status:Bool,mes:String){
        var str:String = "Không có quyền truy cập dịch vụ vị trí"
        var status:Bool = false
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            let statusAuthorization:CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                statusAuthorization = locationManager.authorizationStatus
            }
            else {
                statusAuthorization = CLLocationManager.authorizationStatus()
            }
            switch statusAuthorization {
            case .notDetermined, .restricted, .denied:
                str = "Ứng dụng cần cấp quyền truy cập dịch vụ vị trí"
                status = false
                self.presentSettings(message: str, preferenceType: .locationServices)
                print("No GPSAccess")
            case .authorizedAlways, .authorizedWhenInUse:
                str = "Đã cấp quyền"
                status = true
                print("GPSAccess")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        return (status,str)
    }

    func presentSettings(message:String,preferenceType:PreferenceType){
        let alertController = UIAlertController(title: "Thông báo",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            self.gotoAppPrivacySettings(preferenceType:preferenceType)
        })
        self.parentVCtrl!.present(alertController, animated: true)
    }
    
    func isWifiEnabled() -> Bool {

            var hasWiFiNetwork: Bool = false
            let interfaces: NSArray = CFBridgingRetain(CNCopySupportedInterfaces()) as! NSArray

            for interface  in interfaces {
               // let networkInfo = (CFBridgingRetain(CNCopyCurrentNetworkInfo(((interface) as! CFString))) as! NSDictionary)
                let networkInfo: [AnyHashable: Any]? = CFBridgingRetain(CNCopyCurrentNetworkInfo(((interface) as! CFString))) as? [AnyHashable : Any]
                if (networkInfo != nil) {
                    hasWiFiNetwork = true
                    break
                }
            }
            return hasWiFiNetwork;
        }
    
    // MARK: checkInternetConnection
//    func checkInternetConnectionStatus(completion: @escaping ((Bool,String) -> ())) {
//        var str:String = "Không có kết nối"
//        var status:Bool = false
//        do {
//            let reachability = try Reachability()
//            reachability.notificationCenter.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
//            try reachability.startNotifier()
//            self.completionCallInternet = completion
//        } catch {
//            str = "Unable to start notifier"
//            status = false
//            completion(status,str)
//        }
//    }
     func checkInternetConnectionStatus(completion: @escaping ((Bool,String) -> ())) {
        var str:String = "Không có kết nối"
        var status:Bool = false
        do {
            let reachability = try Reachability()
            reachability.notificationCenter.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
            }
            try reachability.startNotifier()
            if (reachability.connection != .unavailable){
                str = "Kết nối mạng thành công ".appending(reachability.connection.description)
                print(str)
                status = true
            }
            completion(status,str)
        } catch {
            str = "Unable to start notifier"
            status = false
            completion(status,str)
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        var str:String = "Không có kết nối"
        var status:Bool = false
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            str = " Kết nối mạng thành công ".appending(reachability.connection.description)
            print(str)
            status = true
//            print("Reachable via WiFi")
        case .cellular:
            str = "Kết nối mạng thành công ".appending(reachability.connection.description)
            print(str)
            status = true
//            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            status = false
        case .unavailable:
            status = false
            print("Network not reachable")
        }
        self.completionCallInternet!(status,str)
    }
    func checkInternetConnection()->(status:Bool,mes:String){
        var str:String = "Không có kết nối"
        var status:Bool = false
        do {
            let reachability = try Reachability()
            
            reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
            }
           
            try reachability.startNotifier()
            if (reachability.connection != .unavailable){
                str = "Kết nối mạng thành công ".appending(reachability.connection.description)
                status = true
            }
            return (status,str)
        } catch {
            str = "Unable to start notifier"
            status = false
            return (status,str)
        }
    }
    
    // MARK: Check GPS Access
    func checkGPSStatus() -> (status:Bool,mes:String){
        var str:String = "Không có quyền truy cập dịch vụ vị trí"
        var status:Bool = false
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            let statusAuthorization:CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                statusAuthorization = locationManager.authorizationStatus
            }
            else {
                statusAuthorization = CLLocationManager.authorizationStatus()
            }
            switch statusAuthorization {
            case .notDetermined, .restricted, .denied:
                str = "Ứng dụng cần cấp quyền truy cập dịch vụ vị trí"
                status = false
                print("No access GPSStatus")
            case .authorizedAlways, .authorizedWhenInUse:
                str = "Đã cấp quyền"
                status = true
                print("Access GPSStatus")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        return (status,str)
    }
    // MARK: Check Camera Access status
    func checkCameraAccessStatus() ->(status:Bool,mes:String){
        
        var str:String = "Không có quyền truy cập camera"
        var status:Bool = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied , .restricted , .notDetermined:
            print("Denied, request permission from settings")
            str = "Ứng dụng cần cấp quyền truy cập camera"
            status = false
//        case .restricted:
//            print("Restricted, device owner must approve")
        case .authorized:
            str = "Đã cấp quyền"
            status = true
            print("Authorized, proceed")
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { success in
//                if success {
//                    print("Permission granted, proceed")
//                } else {
//                    print("Permission denied")
//                }
//            }
        @unknown default:
            print("Denied, request permission from settings")
        }
        return (status,str)
    }
    
    // MARK: Check Proto Library Access Status
    
    func checkProtoLibraryAccessStatus() -> (status:Bool,mes:String) {
        if #available(iOS 14, *) {
            let statusAuthorization:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            let result = self.showUIProtoLibraryStatus(for: statusAuthorization)
            return (result.status,result.mes)
        } else {
            let statusAuthorization:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
            let result = self.showUIProtoLibraryStatus(for: statusAuthorization)
            return (result.status,result.mes)
        }
    }
    private func showUIProtoLibraryStatus(for statusAuthorization: PHAuthorizationStatus) ->(status:Bool,mes:String) {
         var str:String = "Không có quyền truy cập thư viện hình ảnh"
         var status:Bool = false
         switch statusAuthorization {
         case .authorized:
             str = "Ứng dụng đã cấp quyền truy cập thư viện hình ảnh"
             status = true
             break
         case .limited, .restricted, .denied , .notDetermined:
             str = "Ứng dụng cần cấp quyền truy cập thư viện hình ảnh"
             status = false
         @unknown default:
             break
         }
         return (status,str)
     }
    
    func requestCameraPermission(completion: @escaping ((Bool) -> ())){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            completion (accessGranted)
        })
    }
    func requestProtoLibraryPermission(completion: @escaping ((Bool,String) -> ())){
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { access in
                //            guard access == true else { return }
                var check = self.checkProtoLibraryAccessStatus()
                completion(check.status,check.mes)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { access in
                var check = self.checkProtoLibraryAccessStatus()
                completion(check.status,check.mes)
            }
        }
    }
    func requestGPSPermission(completion: @escaping ((Bool,String) -> ())) {
       var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.completionCallLocation = completion
        if #available(iOS 14.0, *) {
            self.locationManager(manager: locationManager, didChangeAuthorizationStatus: locationManager.authorizationStatus)
        } else {
            self.locationManager(manager: locationManager, didChangeAuthorizationStatus: CLLocationManager.authorizationStatus())
        }
    }
}
extension AppPermission : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            manager.requestLocation()
//        }
        var check = self.checkGPSStatus()
        self.completionCallLocation!(check.status,check.mes)
    }

    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("location:: (location)")
        }
    }

    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}
