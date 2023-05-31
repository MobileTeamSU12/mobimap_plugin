//
//  PrinterUserDefault.swift
//  SDK_Sample_Swift_V4
//
//  Created by ThanhTC on 4/19/23.
//

import Foundation
import BRLMPrinterKit
//BRPtouchPrintInfo
public class PrinterSettingUser:NSObject,Codable{
    var printerWifiSSID:String?
    var printerWifiPass:String?
    var printerWifiIP:String?
    var printerModelName:String?
    var printerModel: Int?
    var printerBrand:String?
    var printerModelFullName:String?

    // All your properties should be included
    public enum CodingKeys: Any, CodingKey {
        case printerWifiSSID
        case printerWifiPass
        case printerWifiIP
        case printerModelName
        case printerModel
        case printerBrand
        case printerModelFullName
    }
   
        
    public func encode(to encoder: Encoder) throws {
        var personContainer = encoder.container(keyedBy: CodingKeys.self)
        try personContainer.encode(self.printerWifiSSID, forKey: .printerWifiSSID)
        try personContainer.encode(self.printerWifiPass, forKey: .printerWifiPass)
        try personContainer.encode(self.printerWifiIP, forKey: .printerWifiIP)
        try personContainer.encode(self.printerModelName, forKey: .printerModelName)
        try personContainer.encode(self.printerModel, forKey: .printerModel)
        try personContainer.encode(self.printerBrand, forKey: .printerBrand)
        try personContainer.encodeIfPresent(self.printerModelFullName, forKey: .printerModelFullName)
    }
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.printerWifiSSID = try values.decode(String.self, forKey: .printerWifiSSID)
        self.printerWifiPass = try values.decode(String.self, forKey: .printerWifiPass)
        self.printerWifiIP = try values.decode(String.self, forKey: .printerWifiIP)
        self.printerModelName = try values.decode(String.self, forKey: .printerModelName)
        self.printerModel = try values.decode(Int.self, forKey: .printerModel)
        self.printerBrand = try values.decode(String.self, forKey: .printerBrand)
        self.printerModelFullName = try values.decode(String.self, forKey: .printerModelFullName)
    }
    
    override init(){
        
        self.printerWifiSSID = "DIRECT-brPT-E550W6809"
        self.printerWifiPass = "00000000"
        self.printerWifiIP = "192.168.118.1"
        self.printerModelName = "PT-E550W"
        self.printerModel = BRLMPrinterModel.PT_E550W.rawValue
        self.printerBrand = "Brother"
        self.printerModelFullName = self.printerBrand!.appending(" ".appending(self.printerModelName!))
    }
    public func setPrintInfoSettingDefault(_ printInfoSetting:PrinterSettingUser){
        var userDefaults: UserDefaults = UserDefaults.standard
            guard let encodedUser = try? JSONEncoder().encode(printInfoSetting) else {
                print("Couldn't save object")
               return
            }
        userDefaults.set(encodedUser, forKey: "printInfoSetting")
    }
    
    public func getPrintInfoSettingDefault()-> PrinterSettingUser?{
        guard let jsonData = UserDefaults.standard.object(forKey: "printInfoSetting") as? Data else {
            print("Couldn't load object data")
            let printer:PrinterSettingUser = PrinterSettingUser()
            printer.setPrintInfoSettingDefault(printer);
            return getPrintInfoSettingDefault()
        }
       if let printInfoSetting:PrinterSettingUser? = try! JSONDecoder().decode(PrinterSettingUser.self, from: jsonData) {
            return printInfoSetting
        } else {
            return nil
        }
        
    }
}
