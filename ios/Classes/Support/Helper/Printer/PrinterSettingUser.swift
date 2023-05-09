//
//  PriterUserDefault.swift
//  SDK_Sample_Swift_V4
//
//  Created by ThanhTC on 4/19/23.
//

import Foundation
import BRLMPrinterKit
//BRPtouchPrintInfo
public class PrinterSettingUser:NSObject,Codable{
    var priterWifiSSID:String?
    var priterWifiPass:String?
    var priterWifiIP:String?
    var priterModelName:String?
    var priterModel: Int?
    var priterBrand:String?
    var priterModelFullName:String?

    // All your properties should be included
    public enum CodingKeys: Any, CodingKey {
        case priterWifiSSID
        case priterWifiPass
        case priterWifiIP
        case priterModelName
        case priterModel
        case priterBrand
        case priterModelFullName
    }
   
        
    public func encode(to encoder: Encoder) throws {
        var personContainer = encoder.container(keyedBy: CodingKeys.self)
        try personContainer.encode(self.priterWifiSSID, forKey: .priterWifiSSID)
        try personContainer.encode(self.priterWifiPass, forKey: .priterWifiPass)
        try personContainer.encode(self.priterWifiIP, forKey: .priterWifiIP)
        try personContainer.encode(self.priterModelName, forKey: .priterModelName)
        try personContainer.encode(self.priterModel, forKey: .priterModel)
        try personContainer.encode(self.priterBrand, forKey: .priterBrand)
        try personContainer.encodeIfPresent(self.priterModelFullName, forKey: .priterModelFullName)
    }
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.priterWifiSSID = try values.decode(String.self, forKey: .priterWifiSSID)
        self.priterWifiPass = try values.decode(String.self, forKey: .priterWifiPass)
        self.priterWifiIP = try values.decode(String.self, forKey: .priterWifiIP)
        self.priterModelName = try values.decode(String.self, forKey: .priterModelName)
        self.priterModel = try values.decode(Int.self, forKey: .priterModel)
        self.priterBrand = try values.decode(String.self, forKey: .priterBrand)
        self.priterModelFullName = try values.decode(String.self, forKey: .priterModelFullName)
    }
    
    override init(){
        
        self.priterWifiSSID = "DIRECT-brPT-E550W68093"
        self.priterWifiPass = "00000000"
        self.priterWifiIP = "192.168.118.1"
        self.priterModelName = "PT-E550W"
        self.priterModel = BRLMPrinterModel.PT_E550W.rawValue
        self.priterBrand = "Brother"
        self.priterModelFullName = self.priterBrand!.appending(" ".appending(self.priterModelName!))
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
            return nil
        }
       if let printInfoSetting:PrinterSettingUser? = try! JSONDecoder().decode(PrinterSettingUser.self, from: jsonData) {
            return printInfoSetting
        } else {
            return nil
        }
        
    }
}
