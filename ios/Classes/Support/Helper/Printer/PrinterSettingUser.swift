//
//  PriterUserDefault.swift
//  SDK_Sample_Swift_V4
//
//  Created by ThanhTC on 4/19/23.
//

import Foundation
import BRLMPrinterKit
//BRPtouchPrintInfo
class PrinterSettingUser:NSObject,Codable{
    var priterWifiSSID:String?
    var priterWifiPass:String?
    var priterWifiIP:String?
    var priterModelName:String?
    var priterModel: Int?
    var priterBrand:String?
    var priterModelFullName:String?

    // All your properties should be included
    enum CodingKeys: Any, CodingKey {
        case priterWifiSSID
        case priterWifiPass
        case priterWifiIP
        case priterModelName
        case priterModel
        case priterBrand
        case priterModelFullName
    }
   
        
    func encode(to encoder: Encoder) throws {
        var personContainer = encoder.container(keyedBy: CodingKeys.self)
        try personContainer.encode(self.priterWifiSSID, forKey: .priterWifiSSID)
        try personContainer.encode(self.priterWifiPass, forKey: .priterWifiPass)
        try personContainer.encode(self.priterWifiIP, forKey: .priterWifiIP)
        try personContainer.encode(self.priterModelName, forKey: .priterModelName)
        try personContainer.encode(self.priterModel, forKey: .priterModel)
        try personContainer.encode(self.priterBrand, forKey: .priterBrand)
        try personContainer.encodeIfPresent(self.priterModelFullName, forKey: .priterModelFullName)
    }
    required init(from decoder: Decoder) throws {
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
    func setPrintInfoSettingDefault(_ printInfoSetting:PrinterSettingUser){
        var userDefaults: UserDefaults = UserDefaults.standard
            guard let encodedUser = try? JSONEncoder().encode(printInfoSetting) else {
                print("Couldn't save object")
               return
            }
        userDefaults.set(encodedUser, forKey: "printInfoSetting")
    }
    
    func getPrintInfoSettingDefault()-> PrinterSettingUser?{
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
    func printInfoSettingDefault()-> PrinterSettingUser{
        var printInfo:PrinterSettingUser = PrinterSettingUser()
//        printInfo.strPaperName = "18mm"
//        printInfo.nPrintMode = 1
//        printInfo.scaleValue = 0.5
//        printInfo.nDensity = 1
//        printInfo.nOrientation = 0
//        printInfo.nRotation = 0 // không có
//        printInfo.nHalftone = 0
//        printInfo.nHalftoneBinaryThreshold = 127
//        printInfo.nHorizontalAlign = 0
//        printInfo.nVerticalAlign = 0
//        printInfo.nPaperAlign = 0
//        printInfo.nExtFlag |= 0
//        printInfo.nExtFlag |= 0
//        printInfo.nExtFlag |= 0
//        printInfo.nExtFlag |= 8
//        printInfo.nAutoCutFlag = 1
//        printInfo.nAutoCutCopies = 1// không có
//        printInfo.bSpecialTape = false
//        printInfo.bHalfCut = false
//        printInfo.bEndcut = false
//        printInfo.nTopMargin = 0
//        printInfo.nLeftMargin = 0
//        printInfo.nSpeed = 1
//        printInfo.bBidirection = true
//        printInfo.nCustomLength = 200
//        printInfo.nCustomFeed = 0
//        printInfo.nCustomWidth = 80
//        printInfo.bOverWrite = false // không có
//        printInfo.nRollPrinterCase = 1
//        printInfo.bPeel = false
//        printInfo.bRotate180 = false
//        printInfo.bCutMark = true
//        printInfo.nLabelMargine = 0
//        printInfo.nPJPaperKind = 2
//        printInfo.nPrintQuality = 4
//        printInfo.bMode9 = true
//        printInfo.bRawMode = false
//        printInfo.bBanishMargin = false // không có
//        printInfo.bUseLegacyHalftoneEngine = false // không có
//        printInfo.bUseCopyCommandInTemplatePrint = false // không có
//        printInfo.bWaitCompletionOfSendingDataAndFile = false // không có
//        printInfo.nAutoCutFlag = 1
//        printInfo.nForceStretchPrintableArea = 0// không có
//        printInfo.nBiColorRedEnhancement = 0 // không có
//        printInfo.nBiColorGreenEnhancement = 0 // không có
//        printInfo.nBiColorBlueEnhancement = 0
//        printInfo.strSaveFilePath = "test" //0x00000001013c0c88
        return printInfo;
    }
}
//    required convenience public init(coder aDecoder: NSCoder) {
//        strSaveFilePath = aDecoder.decodeObject(forKey: "strSaveFilePath") as! String
//           name = aDecoder.decodeObject(forKey: "name") as! String
//           URLString = aDecoder.decodeObject(forKey: "URLString") as! String
//       }

//    public func encode(with aCoder: NSCoder) {
//           aCoder.encode(strSaveFilePath, forKey: "strSaveFilePath")
//           aCoder.encode(name, forKey: "name")
//           aCoder.encode(URLString, forKey: "URLString")
//       }
    
//    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(strPaperName, forKey: "strPaperName")
//    }
//
//    // MARK: - NSCoding
//    public override convenience init(coder aDecoder: NSCoder) {
//        strPaperName = aDecoder.decodeObject(forKey: "strPaperName") as? String
////            name = aDecoder.decodeObject(forKey: "name") as! String
////            URLString = aDecoder.decodeObject(forKey: "URLString") as! String
//    }
//@property    (copy,nonatomic)NSString*  strPaperName;
//@property    (assign,nonatomic)int      nPrintMode;
//@property    (assign,nonatomic)double   scaleValue;
//@property    (assign,nonatomic)int      nDensity;
//@property    (assign,nonatomic)int      nOrientation;
//@property    (assign,nonatomic)int      nRotation;
//@property    (assign,nonatomic)int      nHalftone;
//@property    (assign,nonatomic)int      nHalftoneBinaryThreshold;
//@property    (assign,nonatomic)int      nHorizontalAlign;
//@property    (assign,nonatomic)int      nVerticalAlign;
//@property    (assign,nonatomic)int      nPaperAlign;
//@property    (assign,nonatomic)int      nExtFlag;
//@property    (assign,nonatomic)int      nAutoCutFlag;
//@property   (assign,nonatomic)BOOL      bEndcut;
//@property    (assign,nonatomic)int      nAutoCutCopies;
//@property   (assign,nonatomic)BOOL      bSpecialTape;
//@property   (assign,nonatomic)BOOL      bHalfCut;
//@property   (assign,nonatomic)int       nNumberofCopies;
//@property   (assign,nonatomic)int       nTopMargin;
//@property   (assign,nonatomic)int       nLeftMargin;
//@property   (assign,nonatomic)int       nSpeed;
//@property   (assign,nonatomic)BOOL      bBidirection;
//@property   (assign,nonatomic)int       nCustomLength;
//@property   (assign,nonatomic)int       nCustomWidth;
//@property   (assign,nonatomic)int       nCustomFeed;
//@property   (copy,nonatomic)NSString*   strSaveFilePath;
//@property   (assign,nonatomic)BOOL      bOverWrite;
//@property   (assign,nonatomic)int       nRollPrinterCase;
//@property   (assign,nonatomic)BOOL      bRotate180;
//@property   (assign,nonatomic)BOOL      bPeel;
//@property   (assign,nonatomic)BOOL      bCutMark;
//@property   (assign,nonatomic)int       nLabelMargine;
//@property   (assign,nonatomic)int       nPJPaperKind;
//@property   (assign,nonatomic)int       nPrintQuality;
//@property   (assign,nonatomic)BOOL      bMode9;
//@property   (assign,nonatomic)BOOL      bRawMode;
//@property   (assign,nonatomic)BOOL      bBanishMargin;
//@property   (assign,nonatomic)BOOL      bUseLegacyHalftoneEngine;
//@property   (assign,nonatomic)BOOL      bUseCopyCommandInTemplatePrint;
//@property   (assign,nonatomic)BOOL      bWaitCompletionOfSendingDataAndFile;
//@property   (assign,nonatomic)int       nForceStretchPrintableArea;
//@property   (assign,nonatomic)int       nBiColorRedEnhancement;
//@property   (assign,nonatomic)int       nBiColorGreenEnhancement;
//@property   (assign,nonatomic)int       nBiColorBlueEnhancement;
