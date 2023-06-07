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
    
    var  locationManager:CLLocationManager? = nil
    public override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
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
    public func checkConnectWifiWith(complete:@escaping (_ status:Bool,_ mes:String,_ printerSettingUser:PrinterSettingUser?)->()){
       let printerSettingUser:PrinterSettingUser? = self.getPrinterSettingDefault()
       if ((printerSettingUser != nil)){
           let wifiInterfaces = self.getWiFiName()
           if (wifiInterfaces == printerSettingUser!.printerWifiSSID!){
               complete(true,"Kết nối thành công vào mạng wifi máy in",printerSettingUser)
           }else {
               complete(false,"Chọn đúng mạng wifi máy của máy in",printerSettingUser)
           }
       } else {
           complete(false,"Chọn đúng mạng wifi máy của máy in",nil)
       }
   }
    
    public func checkConnectWifi(complete:@escaping (_ status:Bool,_ printerSettingUser:PrinterSettingUser?)->()){
    let printerSettingUser:PrinterSettingUser? = self.getPrinterSettingDefault()
    if ((printerSettingUser != nil)){
        let wifiInterfaces = self.getWiFiName()
        if (wifiInterfaces == printerSettingUser!.printerWifiSSID!){
            complete(true,printerSettingUser!)
        }else {
            complete(false,printerSettingUser!)

        }
    } else {
        complete(false,nil)
    }
}
    
     public func  getPrinterSettingDefault()->PrinterSettingUser{
        var printerSettingUser:PrinterSettingUser = PrinterSettingUser()
        if (printerSettingUser.getPrintInfoSettingDefault() == nil){
            printerSettingUser.setPrintInfoSettingDefault(printerSettingUser)
        }
        printerSettingUser = printerSettingUser.getPrintInfoSettingDefault() ?? PrinterSettingUser()
        return printerSettingUser
    }
    
     public func openChanelPrinter(complete:@escaping (_ driver:BRLMPrinterDriver?,_ printerSettingUser:PrinterSettingUser? )->()){
        var printerSettingUser:PrinterSettingUser? = PrinterSettingUser().getPrintInfoSettingDefault()
        if (printerSettingUser != nil){
            let channel:BRLMChannel = BRLMChannel(wifiIPAddress: printerSettingUser!.printerWifiIP!)
            let generateResult = BRLMPrinterDriverGenerator.open(channel)
            guard generateResult.error.code == BRLMOpenChannelErrorCode.noError,
                  let printerDriver = generateResult.driver else {
//                alert(title: "Error", message: "Open Channel: \(generateResult.error.code.rawValue)")
                complete(nil,printerSettingUser)
                return
            }
            complete(printerDriver,printerSettingUser)
        }
    }
    
     public func printWithChanel(){
        self.openChanelPrinter() { [self] (printerDriver,printerSettingUser) in
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
                guard let printSettings =  BRLMPTPrintSettings(defaultPrintSettingsWith: BRLMPrinterModel(rawValue: printerSettingUser!.printerModel!) ?? BRLMPrinterModel.PT_E550W)
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
            self.showPrinterChanelIPSettingDialog(ipAddress: printerSettingUser!.printerWifiIP, actionHandler:  { ssid in
                printerSettingUser!.printerWifiIP = ssid
                printerSettingUser!.setPrintInfoSettingDefault(printerSettingUser!)
                self.printWithChanel()
            })
        }
        
    }
    
    public func printFileWithChanel(_ filePath:String,autoCut:Bool, numCopies:Int,labelSize:Int,resolution:Int,complete:@escaping (_ status:Bool,_ mes:String)->()){
       self.openChanelPrinter() { [self] (printerDriver,printerSettingUser) in
           if ((printerDriver) != nil){
               defer {
                   printerDriver!.closeChannel()
               }
               // get file in theo đường dẫn
               guard
//                   let url = Bundle.main.url(forResource: "IMG_2258", withExtension: "png")
                    let url = URL(string: filePath)
               else {
//                   showPrinterAlert(title: "Error", message: " file is not found.")
                   complete(false," file is not found.")
                   return
               }

               //Change here for your printer
               guard let printSettings =  BRLMPTPrintSettings(defaultPrintSettingsWith: BRLMPrinterModel(rawValue: printerSettingUser!.printerModel!) ?? BRLMPrinterModel.PT_E550W)
               else {
//                   self.showPrinterAlert(title: "Error", message: "Fail to create setting.")
                   complete(false,"Fail to create setting.")
                   return
               }
               //Change here for your printer label
               printSettings.autoCut = autoCut
               printSettings.numCopies = UInt(numCopies)
//                printSettings.autoCutForEachPageCount = 1
               printSettings.labelSize = BRLMPTPrintSettingsLabelSize(rawValue: labelSize) ?? .width24mm
               printSettings.resolution = BRLMPrintSettingsResolution(rawValue: resolution) ?? .high
               var printError:BRLMPrintError = BRLMPrintError()
               if (filePath.lowercased().range(of: ".pdf", options: [.caseInsensitive, .diacriticInsensitive]) != nil){
                   printError = printerDriver!.printPDF(with: url, settings: printSettings)
               } else  if (filePath.lowercased().range(of: ".png", options: [.caseInsensitive, .diacriticInsensitive]) != nil) {
                    printError = printerDriver!.printImage(with: url, settings: printSettings)
               }
            if printError.code != .noError {
//                   self.showPrinterAlert(title: "Error", message: "Print Image: \(String(describing: printError.code.rawValue))")
                   
                   complete(false,printError.code == .setLabelSizeError ? "Thiết lập kích thức tem chưa đúng" : "Fail to create setting.")
               }
               else {
//                   self.showPrinterAlert(title: "Success", message: "Print Image")
                   complete(true,"Success Print ")
               }
               return
           }
           complete(false,"Fail to open Chanel Printer.")
//           self.showPrinterChanelIPSettingDialog(ipAddress: printerSettingUser!.printerWifiIP, actionHandler:  { ssid in
//               printerSettingUser!.printerWifiIP = ssid
//               printerSettingUser!.setPrintInfoSettingDefault(printerSettingUser!)
//               self.printWithChanel()
//           })
       }
       
   }
 
    @IBAction  public func connectionWifi(_ sender: UIButton) {
        
        self.checkConnectWifi { status, printerSettingUser in
            if (status && printerSettingUser == nil){
                self.showPrinterAlert(title: "Thông báo", message: "Lỗi kết nối đến máy in")
                return
            }
            if (!status){
                self.connectionWifi(ssid:printerSettingUser!.printerWifiSSID!, pass:printerSettingUser!.printerWifiPass!) {statusConneted in
                    if (!statusConneted) {
                        self.showPrinterWifiSettingDialog(ssid: printerSettingUser!.printerWifiSSID! ,pwd: printerSettingUser!.printerWifiPass!, actionHandler:  { ssidEdit, pwdEdit in
                            printerSettingUser!.printerWifiSSID = ssidEdit
                            printerSettingUser!.printerWifiPass = pwdEdit
                            printerSettingUser?.setPrintInfoSettingDefault(printerSettingUser!)
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

extension String{
    
}
