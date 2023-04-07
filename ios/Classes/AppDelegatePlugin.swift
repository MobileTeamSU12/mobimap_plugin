import UIKit
import Flutter
import GoogleMaps
import CoreMedia
import Reachability
import Network
import Photos
import flutter_local_notifications
import FirebaseMessaging
import FirebaseCore

@objc open class AppDelegatePlugin: FlutterAppDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var latLong:String = ""
    var id:String =  ""
    var drawText:NSArray = []
    var filename:String = ""
    var locationManager: CLLocationManager!
    var completionCallLocation: ((String) -> ())?
    var completionCallGetPathImage: ((String) -> ())?
    var isSaveImageFunction:Bool = false
    var chanelEventGPS:FlutterEventChannel!
    var gPSStreamHandler:GPSStreamHandler!
    var chanelEventNetwork:FlutterEventChannel!

    var networkStreamHandler:NetworkMonitorStreamHandler!
    @objc open var application:UIApplication!
    @objc open var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    @objc open var flutterViewControler:FlutterViewController!
    @objc open var GMSServicesAPIKey:String = ""
    // MARK: Application Life Cycle
    open override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        GMSServices.provideAPIKey("AIzaSyB5GlI1gKmxppYi6MxzJo2AgzyfE5C-6d8")
        GMSServices.provideAPIKey(GMSServicesAPIKey)
        //        GeneratedPluginRegistrant.register(with: self)
        self.application = application;
        self.launchOptions = launchOptions;
        if (self.flutterViewControler == nil){
            self.flutterViewControler = window?.rootViewController as? FlutterViewController
        }
        self.registerChanelMethod(controler: self.flutterViewControler)
        self.registerEventMethod(controler: self.flutterViewControler)
        self.registerNotification(application:self.application)
        return super.application(self.application, didFinishLaunchingWithOptions: self.launchOptions)
    }
    
    open override func applicationDidBecomeActive(_ application: UIApplication){
        //        if CLLocationManager.authorizationStatus() == .denied {
        //            FMapHelperPlugin.checkGPSMobiMap()
        //        } else if AVCaptureDevice.authorizationStatus(for: .video) == AVAuthorizationStatus.denied{
        //            FMapHelperPlugin.checkCameraSeesion()
        //        } else if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.denied{
        //            FMapHelperPlugin.checkLibraryCamera()
        //        }
        if (self.gPSStreamHandler != nil && self.chanelEventGPS != nil){
            //            self.chanelEventGPS.setStreamHandler(self.gPSStreamHandler)
            //            let _ =  self.gPSStreamHandler.onListen(withArguments: self.gPSStreamHandler.param, eventSink: self.gPSStreamHandler.sink!)
            self.gPSStreamHandler.sendGPSStatus()
        }
        if (self.chanelEventNetwork != nil && self.networkStreamHandler != nil){
            //            self.chanelEventNetwork.setStreamHandler(self.networkStreamHandler)
            //            let _ =  self.gPSStreamHandler.onListen(withArguments: self.gPSStreamHandler.param, eventSink: self.gPSStreamHandler.sink!)
            self.networkStreamHandler.sendNetworkStatus()
        }
    }
    
    open override func applicationDidEnterBackground(_ application: UIApplication) {
        self.startStandardUpdates()
    }
    
    open override func applicationWillEnterForeground(_ application: UIApplication) {
        self.startStandardUpdates()
    }
    
    open override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return false
    }
    open override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
//         let controler:FlutterViewController = window?.rootViewController as! FlutterViewController
//         let bateryChanel = FlutterMethodChannel(name: "plugins.flutter.io/quick_actions", binaryMessenger: controler.binaryMessenger)
//         bateryChanel.invokeMethod("launch", arguments: shortcutItem.type)
    }
    
    // MARK: push Notification Firebase
    
    open override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
    }
    
    open override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("Do what ever you want")
    }
    
    open override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
// MARK: CLLocationManagerDelegate
extension AppDelegatePlugin : CLLocationManagerDelegate {
    // MARK: CLLocationManager
    private func getLocation(controler:FlutterViewController, completion: ((String) -> ())? = nil) {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            completionCallLocation = completion
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.latLong = "\(String(center.latitude)) , \(String(center.longitude))"
        if (completionCallLocation != nil){
            completionCallLocation!(self.latLong)
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            UserDefaults.standard.setValue("fcmToken", forKey: fcmToken)
    }
    public func registerNotification(application:UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self;
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // If granted comes true you can enabled features based on authorization.
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}
// MARK: Custom Method
extension AppDelegatePlugin{
    public func chanelMethodCallHandler(controler:FlutterViewController,call:FlutterMethodCall, result:@escaping FlutterResult){
        switch call.method{
        case FunctionName.getBatteryLevel.rawValue:
            let num = self.betteryLevel()
            result(String(num))
            break
        case FunctionName.getImei.rawValue:
            let ime = self.getImei()
            result(ime)
            break
        case FunctionName.getOperatingSystemVersion.rawValue:
            let version = self.getSystemVersion()
            result(version)
            break
        case FunctionName.takePhoto.rawValue:
            guard let param = call.arguments as? [String:AnyObject] else {return}
            drawText = param[FunctionParameters.drawText.rawValue] as? NSArray ?? []
            filename = param[FunctionParameters.fileName.rawValue] as? String ?? ""
            self.pickerCamera(controler: controler) { str in
                print(str)
                result(str)
            }
            break
        case FunctionName.requestPermission.rawValue:
            guard let param = call.arguments as? [String:String] else {return}
            let permistionRequest:String = param[FunctionParameters.permissionRequest.rawValue] ?? ""
//                var resultMethod = self.requestPermission(controler: controler,permistionRequest: permistionRequest.uppercased())
//                result(resultMethod.mes)
            self.requestPermission(controler: controler, permistionRequest: permistionRequest) { status, mes in
                result(status)
            }
            break
        case FunctionName.openGPSSetting.rawValue:
            let url = URL.init(string: UIApplication.openSettingsURLString)
            UIApplication.shared .openURL(url!)
            break
        case FunctionName.updateAppVersion.rawValue:
            guard let param = call.arguments as? [String:String] else {return}
            let linkDownload:String = param[FunctionParameters.filePath.rawValue] ?? ""
            guard let url = URL(string: linkDownload) else {
              return //be safe
            }
            UIApplication.shared.openURL(url)
            break;
        case FunctionName.getLocation.rawValue:
            self.getLocation(controler: controler, completion: { str in
                result(str)
            })
            break
        case FunctionName.getImageFromGallery.rawValue:
            self.pickerPhotoLibrary(controler: controler) { str in
                print(str)
                result(str)
            }
            break
        case FunctionName.getInternetConnection.rawValue:
            var resultMethod = AppPermission(parentVCtrl: controler).checkInternetConnection()
            result(resultMethod.status)
            break
        case FunctionName.saveImageToGallery.rawValue:
            self.isSaveImageFunction = true
            guard let param = call.arguments as? [String:AnyObject] else {return}
            let myFlutterData: FlutterStandardTypedData = param[FunctionParameters.fileData.rawValue] as! FlutterStandardTypedData
            let myData = Data(myFlutterData.data)
            let Image:UIImage = UIImage(data: myData)!
            self.filename = param[FunctionParameters.fileName.rawValue] as? String ?? ""
            self.saveImageToGallery(image: Image) { str in
                result(str)
            }
            break
        case FunctionName.openAppSetting.rawValue:
//                guard let param = call.arguments as? [String:AnyObject] else {return}
//                AppPermission(parentVCtrl: self.flutterViewControler).presentSettings(message: "Đi đến cài đặt", preferenceType: .allSetting)
            AppPermission(parentVCtrl: self.flutterViewControler).gotoAppPrivacySettings(preferenceType: .allSetting)
            break
        case FunctionName.getGpsStatus.rawValue:
            var resultMethod = AppPermission(parentVCtrl: controler).checkGPSStatus()
            if (resultMethod.status){
                result(resultMethod.status)
            } else {
                self.startStandardUpdates()
                AppPermission(parentVCtrl: controler).requestGPSPermission(completion: { status, str in
                    result(status)
                })
            }
            break
        case FunctionName.getVersionApp.rawValue:
            let version = self.getAppVersion()
            result(version)
            break
        case FunctionName.getHashCommit.rawValue:
            let hasCommit = self.getHasCommit()
            result(hasCommit)
            break
        default:
            break
        }
    }
    // MARK: Register Chanel Method
    public func createChanelMethod(controler:FlutterViewController) -> FlutterMethodChannel{
        let chanelMethod = FlutterMethodChannel(name: ChanelName.method.rawValue, binaryMessenger: controler.binaryMessenger)
        return chanelMethod
    }
    // MARK: Register Chanel Method
    public func registerChanelMethod(controler:FlutterViewController) {
        let chanelMethod = self.createChanelMethod(controler: controler)
        chanelMethod.setMethodCallHandler ({ [self] (call:FlutterMethodCall, result:@escaping FlutterResult) -> Void in
            self.chanelMethodCallHandler(controler: controler, call: call, result: result)
        })
    }
    // MARK: Register Event Method
    public func registerEventMethod(controler:FlutterViewController) {
        self.chanelEventGPS = FlutterEventChannel(name: ChanelName.eventGPS.rawValue, binaryMessenger: self.flutterViewControler.binaryMessenger)
        self.gPSStreamHandler = GPSStreamHandler(parentVCtrl: controler)
        self.chanelEventGPS.setStreamHandler(self.gPSStreamHandler)

        self.chanelEventNetwork = FlutterEventChannel(name: ChanelName.eventNetwork.rawValue, binaryMessenger: self.flutterViewControler.binaryMessenger)
        self.networkStreamHandler = NetworkMonitorStreamHandler(parentVCtrl: controler)
        self.chanelEventNetwork.setStreamHandler(self.networkStreamHandler)
    }
    // MARK: get bettery Level
    private func betteryLevel ()-> Int{
        let device:UIDevice = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if (device.batteryState == .unknown){
            return -1
        }
        return Int((device.batteryLevel * 100))
    }
    // MARK: getImei
    private func getImei()-> String{
        let ime = OpenUDIDPlugin.value() ?? ""
        return ime
    }
    // MARK: getVersion
    private func getSystemVersion()-> String{
        let str = UIDevice().fullSystemVersion
        return str
    }
    // MARK: getAppVersion
    private func getAppVersion()-> String{
        let str = AppInfo().version
        return str
    }

    // MARK: getHasCommit
    private func getHasCommit()-> String{
        let str = AppInfo().commitID
        return str
    }

    // MARK: pickerCamera
    private func pickerCamera(controler:FlutterViewController, completion: ((String) -> ())? = nil) {
        let vc = UIImagePickerController()
        #if targetEnvironment(simulator)
        vc.sourceType = .photoLibrary
        #else
        vc.sourceType = .camera
        #endif
        vc.allowsEditing = true
        vc.delegate = self
        self.completionCallGetPathImage = completion
        controler.present(vc, animated: true)
    }

    // MARK: pickerPhotoLibrary
    private func pickerPhotoLibrary(controler:FlutterViewController,completion: ((String) -> ())? = nil ) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        self.completionCallGetPathImage = completion
        controler.present(vc, animated: true)
    }
    // MARK: imagePickerController
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let resizedImageWithText = FMapHelperPlugin.resizedImage(withDrawText: (self.drawText as! [Any]), didFinishPickingMediaWithInfo: info) as UIImage
//        FMapHelperPlugin.resizedImage(withText: self.id, location: self.location, didFinishPickingMediaWithInfo: info) as UIImage
        // print out the image size as a test
        print(resizedImageWithText.size)
        print(resizedImageWithText.pngData() as Any)
        //MARK: - Saving Image here
        if (picker.sourceType == .camera) {
            FMapHelperPlugin.saveImage(withFileName: self.filename, image: resizedImageWithText) { isComplete in
                if isComplete {
                    let phFetchRes = PHAsset.fetchAssets(with: PHAssetMediaType.image , options: nil) // Fetch all PHAssets of images from Camera roll
                    let asset =  phFetchRes.lastObject//phFetchRes.object(at: 0) // retrieve cell 0 as a asset
                    self.getAssetUrl(mPhasset: asset!) { responseURL in
                        print(responseURL as Any)
                        self.completionCallGetPathImage!((responseURL?.path)!)
                    }
                }
            }
        } else {
            if let assetURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
                let asset = result.firstObject
                self.getAssetUrl(mPhasset: asset!) { responseURL in
                    print(responseURL as Any)
                    self.completionCallGetPathImage!((responseURL?.path)!)
                }
            }
        }
    }

    func saveImageToGallery(image:UIImage,completion: ((String) -> ())? = nil) {
        self.completionCallGetPathImage = completion
        FMapHelperPlugin.saveImage(withFileName: self.filename, image: image) { isComplete in
            if isComplete {
                self.completionCallGetPathImage!("1")
            } else {
                self.completionCallGetPathImage!("0")
            }
        }
    }

    func getAssetUrl(mPhasset : PHAsset, completionHandler : @escaping((_ responseURL : NSURL?) -> Void)){
        if mPhasset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput: PHContentEditingInput?, info: [AnyHashable: Any]) -> Void in
                completionHandler(contentEditingInput?.fullSizeImageURL as URL? as NSURL?)
            })
        }
    }

    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let controler:FlutterViewController = window?.rootViewController as! FlutterViewController
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            controler.present(ac, animated: true)
        } else {
            let phFetchRes = PHAsset.fetchAssets(with: PHAssetMediaType.image , options: nil) // Fetch all PHAssets of images from Camera roll
            let asset =  phFetchRes.lastObject//phFetchRes.object(at: 0) // retrieve cell 0 as a asset
            self.getAssetUrl(mPhasset: asset!) { responseURL in
                print(responseURL as Any)
                self.completionCallGetPathImage!((responseURL?.path)!)
            }
        }
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        picker.dismiss(animated: true, completion: { () -> Void in

        })
    }


    // MARK: Check all Permistion
    private func requestPermission(controler:FlutterViewController,permistionRequest : String ) ->(status:Bool,mes:String) {
        let permistion = AppPermission(parentVCtrl: controler)
        var flag = (false,"Không có quyền")
        if (permistionRequest.uppercased().contains(PermistionRequest.CAMERA.rawValue)){
            flag = permistion.checkCameraAccessStatus()
            return flag
        }
        if (permistionRequest.uppercased().contains(PermistionRequest.STORAGE.rawValue)){
            flag = permistion.checkProtoLibraryAccessStatus()
            return flag
        }
        if (permistionRequest.uppercased().contains(PermistionRequest.LOCATION.rawValue)){
            flag = permistion.checkGPSStatus()
            return flag
        }
//        if (permistionRequest.uppercased().contains(PermistionRequest.INTERNET.rawValue)){
//            flag = permistion.checkInternetConnectionStatus()
//            return flag
//        }
        if (permistionRequest.uppercased().contains(PermistionRequest.ALL.rawValue)){
//            flag = permistion.checkInternetConnectionStatus()
//            if (!flag.0){
//                return flag
//            }
            flag = permistion.checkCameraAccessStatus()
            if (!flag.0){
                return flag
            }
            flag = permistion.checkProtoLibraryAccessStatus()
            if (!flag.0){
                return flag
            }
            flag = permistion.checkGPSStatus()
            return flag
        }
        return flag
    }

    func startStandardUpdates () {
        if (locationManager == nil) {
            locationManager = CLLocationManager.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
//            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
//    func save(fileName: String, type: String) {
//        let filename = "test.jpg"
//        let subfolder = "SubDirectory"
//
//        do {
//            let fileManager = FileManager.default
//            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let folderURL = documentsURL.appendingPathComponent(subfolder)
//            if !folderURL.checkPromisedItemIsReachableAndReturnError(nil) {
//                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
//            }
//            let fileURL = folderURL.appendingPathComponent(filename)
//
//            try imageData.writeToURL(fileURL, options: .AtomicWrite)
//        } catch {
//            print(error)
//        }
//    }
    private func requestPermission(controler:FlutterViewController,permistionRequest : String , completion: @escaping ((Bool,String) -> ())) {
        let permistion = AppPermission(parentVCtrl: controler)
        var flag = (false,"Không có quyền")
        if (permistionRequest.uppercased().contains(PermistionRequest.CAMERA.rawValue)){
            flag = permistion.checkCameraAccessStatus()
            completion(flag.0,flag.1)
            return
        }
        if (permistionRequest.uppercased().contains(PermistionRequest.STORAGE.rawValue)){
            flag = permistion.checkProtoLibraryAccessStatus()
            completion(flag.0,flag.1)
            return
        }
        if (permistionRequest.uppercased().contains(PermistionRequest.LOCATION.rawValue)){
            flag = permistion.checkGPSStatus()
            completion(flag.0,flag.1)
            return
        }
//        if (permistionRequest.uppercased().contains(PermistionRequest.INTERNET.rawValue)){
//            flag = permistion.checkInternetConnectionStatus()
//            completion(flag.0,flag.1)
//            return
//        }
        if (permistionRequest.uppercased().contains(PermistionRequest.ALL.rawValue)){
//            flag = permistion.checkInternetConnectionStatus()
//            if (!flag.0){
//                completion(flag.0,flag.1)
//                return
//            }
            permistion.requestCameraPermission(completion: { status in
                if (!status){
                    flag = permistion.checkCameraAccessStatus()
                    completion(flag.0,flag.1)
                    return
                }
            })
            
            flag = permistion.checkProtoLibraryAccessStatus()
            permistion.requestProtoLibraryPermission { status, mes in
                flag = permistion.checkProtoLibraryAccessStatus()
                completion(flag.0,flag.1)
                return
            }
           
            permistion.requestGPSPermission {status, mes in
                flag = permistion.checkGPSStatus()
                completion(flag.0,flag.1)
                return
            }
        }
    }
}