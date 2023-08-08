//
//  enumParam.swift
//  Runner
//
//  Created by ThanhTC on 8/24/22.
//

import Foundation
enum PermistionRequest:String{
    case ALL,LOCATION,STORAGE,CAMERA,INTERNET
}
enum ConnectionType{
    case wifi
    case cellular
    case ethernet
    case unknow
}
public enum PreferenceType:String{
        case about = "root=General&path=About"
        case accessibility = "root=General&path=ACCESSIBILITY"
        case airplaneMode = "root=AIRPLANE_MODE"
        case autolock = "root=General&path=AUTOLOCK"
        case cellularUsage = "root=General&path=USAGE/CELLULAR_USAGE"
        case brightness = "root=Brightness"
        case bluetooth = "root=Bluetooth"
        case dateAndTime = "root=General&path=DATE_AND_TIME"
        case facetime = "root=FACETIME"
        case general = "root=General"
        case keyboard = "root=General&path=Keyboard"
        case castle = "root=CASTLE"
        case storageAndBackup = "root=CASTLE&path=STORAGE_AND_BACKUP"
        case international = "root=General&path=INTERNATIONAL"
        case locationServices = "root=LOCATION_SERVICES"
        case accountSettings = "root=ACCOUNT_SETTINGS"
        case music = "root=MUSIC"
        case equalizer = "root=MUSIC&path=EQ"
        case volumeLimit = "root=MUSIC&path=VolumeLimit"
        case network = "root=General&path=Network"
        case nikePlusIPod = "root=NIKE_PLUS_IPOD"
        case notes = "root=NOTES"
        case notificationsId = "root=NOTIFICATIONS_ID"
        case phone = "root=Phone"
        case photos = "root=Photos"
        case photosPrivacy = "root=Privacy&path=PHOTOS"
        case managedConfigurationList = "root=General&path=ManagedConfigurationList"
        case reset = "root=General&path=Reset"
        case ringtone = "root=Sounds&path=Ringtone"
        case safari = "root=Safari"
        case assistant = "root=General&path=Assistant"
        case sounds = "root=Sounds"
        case softwareUpdateLink = "root=General&path=SOFTWARE_UPDATE_LINK"
        case store = "root=STORE"
        case twitter = "root=TWITTER"
        case facebook = "root=FACEBOOK"
        case usage = "root=General&path=USAGE"
        case video = "root=VIDEO"
        case vpn = "root=General&path=Network/VPN"
        case wallpaper = "root=Wallpaper"
        case wifi = "root=WIFI"
        case tethering = "root=INTERNET_TETHERING"
        case blocked = "root=Phone&path=Blocked"
        case doNotDisturb = "root=DO_NOT_DISTURB"
        case allSetting = ""
}
enum ChanelName:String{
    case method = "com.fpt.isc.mobimap_plugin/MobiMapMethod"
    case eventGPS = "com.fpt.isc.mobimap_plugin/MobiMapEventGPS"
    case eventNetwork = "com.fpt.isc.mobimap_plugin/MobiMapEventNetwork"
}
enum FunctionName:String{
    case getBatteryLevel = "getBatteryLevel"
    case getImei = "getImei"
    case getOperatingSystemVersion = "getOperatingSystemVersion"
    case requestPermission = "requestPermission"
    case getInternetConnection = "getInternetConnection"
    case takePhoto = "takePhoto"
    case updateAppVersion = "updateAppVersion"
    case openGPSSetting = "openGPSSetting"
    case getLocation = "getLocation"
    case getImageFromGallery = "getImageFromGallery"
    case saveImageToGallery = "saveImageToGallery"
    case openAppSetting = "openAppSetting"
    case getGpsStatus = "getGpsStatus"
    case getVersionApp = "getVersionApp"
    case getHashCommit = "getHashCommit"
    case checkConnecPrinterWifi = "checkConnecPrinterWifi"
    case connectChannelPrinter = "connectChannelPrinter"
    case connectWifiPrinter = "connectWifiPrinter"
    case printQRCode = "printQRCode"
    case closeFlutterApp = "closeFlutterApp"
    case launchBrowser = "launchBrowser"
    
    
}
enum FunctionParameters:String{
    case id = "id"
    case fileData = "fileData"
    case fileName = "fileName"
    case filePath = "filePath"
    case drawText = "drawText"
    case permissionRequest = "permissionType"
    case printerModelName = "printerModelName"
    case printerModel = "printerModel"
    case printerSSID = "printerSSID"
    case printerPass = "printerPass"
    case printerIPAddess = "printerIPAddess"
    case printerFilePath = "printerFilePath"
    
    case labelSize = "labelSize";
    case resolution = "resolution";
    case workPath = "workPath";
    case isAutoCut = "isAutoCut";
    case  numCopies = "numCopies";
    case  responsePrinterModelMessage = "message";
    case  responsePrinterModelStatus = "status";
    case  url = "url";
    
    
}
