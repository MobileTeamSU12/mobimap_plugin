//
//  BRLMPrinterKitControlerViewController.swift
//  SDK_Sample_Swift_V4
//
//  Created by ThanhTC on 5/8/23.
//

import UIKit
import BRLMPrinterKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation
import NetworkExtension
public class BRLMPrinterKitControler: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
//        self.ssid = self.getWiFiName() ?? ""
    }
     public func getWiFiName() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
     public func getInterfaces() -> Bool {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return false
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return false
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return false
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return false
            }
            for d in SSIDDict.keys {
                print("\(d): \(SSIDDict[d]!)")
            }
        }
        return true
    }
    
     public func connectionWifi(ssid:String ,pass:String , complete:@escaping (_ status:Bool)->()){
        
        let configuration = NEHotspotConfiguration.init(ssid: ssid, passphrase: pass, isWEP: false)
        configuration.joinOnce = false
        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                if error!.localizedDescription == "already associated."
                {
                    //
                    print("Connected")
                    complete(true)
                }
                else{
                    print("No Connected")
                    complete(false)
                }
            }
            else {
                print("Can not Connected")
                
                complete(false)
            }
        }
    }
    
    @IBAction  public func Print(_ sender: Any) {
        self.printWithChanel()
    }
    
     public func checkConnectWifi(complete:@escaping (_ status:Bool,_ priterSettingUser:PrinterSettingUser?)->()){
        let priterSettingUser:PrinterSettingUser? = self.getPriterSettingDefault()
        if ((priterSettingUser != nil)){
            let wifiInterfaces = self.getWiFiName()
            if (wifiInterfaces == priterSettingUser!.priterWifiSSID!){
                complete(true,priterSettingUser!)
            }else {
                complete(false,priterSettingUser!)
               
            }
        } else {
            complete(false,nil)
        }
    }
    
     public func  getPriterSettingDefault()->PrinterSettingUser{
        var priterSettingUser:PrinterSettingUser = PrinterSettingUser()
        if (priterSettingUser.getPrintInfoSettingDefault() == nil){
            priterSettingUser.setPrintInfoSettingDefault(priterSettingUser)
        }
        priterSettingUser = priterSettingUser.getPrintInfoSettingDefault() ?? PrinterSettingUser()
        return priterSettingUser
    }
    
     public func openChanelPriter(complete:@escaping (_ driver:BRLMPrinterDriver?,_ priterSettingUser:PrinterSettingUser? )->()){
        var priterSettingUser:PrinterSettingUser? = PrinterSettingUser().getPrintInfoSettingDefault()
        if (priterSettingUser != nil){
            let channel:BRLMChannel = BRLMChannel(wifiIPAddress: priterSettingUser!.priterWifiIP!)
            let generateResult = BRLMPrinterDriverGenerator.open(channel)
            guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
                  let printerDriver = generateResult.driver else {
//                alert(title: "Error", message: "Open Channel: \(generateResult.error.code.rawValue)")
                complete(nil,priterSettingUser)
                return
            }
            complete(printerDriver,priterSettingUser)
        }
    }
    
     public func printWithChanel(){
        self.openChanelPriter() { [self] (printerDriver,priterSettingUser) in
            if ((printerDriver) != nil){
                defer {
                    printerDriver!.closeChannel()
                }
                // get file in theo đường dẫn
                guard
                    let url = Bundle.main.url(forResource: "IMG_2258", withExtension: "png")
                else {
                    showPrinterAlert(title: "Error", message: "Image file is not found.")
                    return
                }

                //Change here for your printer
                guard let printSettings =  BRLMPTPrintSettings(defaultPrintSettingsWith: BRLMPrinterModel(rawValue: priterSettingUser!.priterModel!) ?? BRLMPrinterModel.PT_E550W)
                else {
                    self.showPrinterAlert(title: "Error", message: "Fail to create setting.")
                    return
                }
                //Change here for your printer label
                printSettings.autoCut = true
                printSettings.numCopies = 1
//                printSettings.autoCutForEachPageCount = 1
                printSettings.labelSize = .width24mm
                printSettings.resolution = .high
                let printError = printerDriver!.printImage(with: url, settings: printSettings)
                
                if printError.code != .noError {
                    self.showPrinterAlert(title: "Error", message: "Print Image: \(String(describing: printError.code.rawValue))")
                }
                else {
                    self.showPrinterAlert(title: "Success", message: "Print Image")
                }
                return
            }
            self.showPrinterChanelIPSettingDialog(ipAddress: priterSettingUser!.priterWifiIP, actionHandler:  { ssid in
                priterSettingUser!.priterWifiIP = ssid
                priterSettingUser!.setPrintInfoSettingDefault(priterSettingUser!)
                self.printWithChanel()
            })
        }
        
    }
    
    @IBAction  public func connectionWifi(_ sender: UIButton) {
        
        self.checkConnectWifi { status, priterSettingUser in
            if (status && priterSettingUser == nil){
                self.showPrinterAlert(title: "Thông báo", message: "Lỗi kết nối đến máy in")
                return
            }
            if (!status){
                self.connectionWifi(ssid:priterSettingUser!.priterWifiSSID!, pass:priterSettingUser!.priterWifiPass!) {statusConneted in
                    if (!statusConneted) {
                        self.showPrinterWifiSettingDialog(ssid: priterSettingUser!.priterWifiSSID! ,pwd: priterSettingUser!.priterWifiPass!, actionHandler:  { ssidEdit, pwdEdit in
                            priterSettingUser!.priterWifiSSID = ssidEdit
                            priterSettingUser!.priterWifiPass = pwdEdit
                            priterSettingUser?.setPrintInfoSettingDefault(priterSettingUser!)
                            self.connectionWifi(sender)
                        })}
                    sender.setTitle("Connected", for: .normal)
                    self.printWithChanel()
                }
                return
            }
            sender.setTitle("Connected", for: .normal)
            self.printWithChanel()
        }
    }
    
}

extension BRLMPrinterKitControler {
    public func showPrinterAlert(title:String, message:String) {
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
       present(alertController, animated: true)
   }
     public func showPrinterWifiSettingDialog(title:String? = "Thông báo",
                               subtitle:String? = "Kiểm tra thông tin wifi",
                               actionTitle:String? = "Kết nối",
                               cancelTitle:String? = "Hủy",
                               ssid:String? = "DIRECT-brPT-E550W6809",
                               pwd:String? = "00000000",
                               inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                               cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                               actionHandler: ((_ ssid: String?,  _ pwd:String) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Wifi Name"
            textField.text = ssid
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 1
        }
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Password"
            textField.text = pwd
            textField.isSecureTextEntry = true;
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 2
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textFields =  alert.textFields else {
                return
            }
            var ssid: String = ""
            var pwd: String = ""
            for textField:UITextField in textFields {
                if (textField.tag == 1){
                    ssid = textField.text!
                }
                if (textField.tag == 2){
                    pwd = textField.text!
                }
            }
            
            actionHandler?(ssid,pwd)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
     public func showPrinterChanelIPSettingDialog(title:String? = "Thông báo",
                               subtitle:String? = "Kiểm tra thông tin kết nối",
                               actionTitle:String? = "Kết nối",
                               cancelTitle:String? = "Hủy",
                               ipAddress:String? = "192.168.1.118",
                               inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                               cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                               actionHandler: ((_ ssid: String) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "IP Address"
            textField.text = ipAddress
            textField.keyboardType = UIKeyboardType.default
            textField.tag = 1
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textFields =  alert.textFields else {
                return
            }
            var ip: String = ""
            for textField:UITextField in textFields {
                if (textField.tag == 1){
                    ip = textField.text!
                }
            }
            actionHandler?(ip)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
