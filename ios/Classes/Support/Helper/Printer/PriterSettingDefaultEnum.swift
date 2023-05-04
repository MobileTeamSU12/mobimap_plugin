//
//PriterSettingDefault.swift
//SDK_Sample_Swift_V4
//
//Created by ThanhTC on 4/24/23.
//

import Foundation

// Mark : Default Setting
let kSelectedDevice :String = "SelectedDevice"
let kIPAddress :String = "IPAddress"
let kSerialNumber :String = "SerialNumber"
let kAdvertiseLocalName:String = "AdvertiseLocalName"

let kSelectedDeviceFromWiFi:String = "SelectedDeviceFromWiFi"
let kSelectedDeviceFromBluetooth :String = "SelectedDeviceFromBluetooth"
let kSelectedDeviceFromBLE :String = "SelectedDeviceFromBLE"

let kIsWiFi:String = "isWiFi"
let kIsBluetooth :String = "isBluetooth"
let kIsBLE :String = "isBLE"

let kPrintResultForWLAN:String = "printResultForWLAN"
let kPrintResultForBT:String = "printResultForBT"
let kPrintResultForBLE :String = "printResultForBLE"

let kPrintStatusBatteryPowerForWLAN:String = "printStatusBatteryPowerForWLAN"
let kPrintStatusBatteryPowerForBT:String = "printStatusBatteryPowerForBT"
let kPrintStatusBatteryPowerForBLE :String = "printStatusBatteryPowerForBLE"

let kSelectedSendDataPath:String = "selectedSendDataPath"
let kSelectedSendDataName:String = "selectedSendDataName"

let kSelectedPDFFilePath:String = "selectedPDFFilePath"

//pragma mark - Print Settings

let kExportPrintFileNameKey:String = "ExportPrintFileNameKey"

let kPrintNumberOfPaperKey :String = "PrintNumberOfPaperKey"

let kPrintPaperSizeKey :String = "PrintPaperSizeKey"
enum PrintPaperSize:Int
{
    case  A4  =  1,
          Letter,
          Legal
}

let kPrintOrientationKey :String = "PrintOrientationKey"
enum PrintOrientationKey:UInt8
{
    case Landscape  =  0x00,
         Portrate  =  0x01
}

let kScalingModeKey :String = "ScalingModeKey"
enum PrintFitKey:UInt8
{
    case Original  =  0x00,
         Fit  =  0x01,
         Custom  =  0x02
}

let kScalingFactorKey :String = "ScalingFactorKey"

let kPrintHalftoneKey :String = "PrintHalftoneKey"
enum PrintHalftoneKey:UInt8
{
    case Binary  =  0x00,
         Dither  =  0x01,
         ErrorDiffusion  =  0x02
}

let kPrintBinaryThresholdKey :String = "PrintBinaryThresholdKey"

let kPrintHorizintalAlignKey :String = "PrintHorizintalAlignKey"
enum PrintHorizintalAlignKey : UInt8
{
    case Left   =   0x00,
         Center  =  0x01,
         Right  =  0x02
}

let kPrintVerticalAlignKey :String = "PrintVerticalAlignKey"
enum PrintVerticalAlignKey:UInt8
{
    case Top  =  0x00,
         Middle =  0x01,
         Bottom =  0x02
}

let kPrintPaperAlignKey:String = "PrintPaperAlignKey"
enum PrintPaperAlignKey:UInt8
{
    case PaperLeft  =  0x00,
         PaperCenter  =  0x01,
         PaperRight =  0x02
}

let kPrintCodeKey :String = "PrintCodeKey"
enum PrintCodeKey:UInt8
{
    case CodeOn =  0x01,
         CodeOff  =  0x00
}

let kPrintCarbonKey :String = "PrintCarbonKey"
enum PrintCarbonKey:UInt8
{
    case CarbonOn =  0x02,
         CarbonOff  =  0x00
}

let kPrintDashKey :String = "PrintDashKey"
enum PrintDashKey:UInt8
{
    case DashOn =  0x04,
         DashOff  =  0x00
}

let kPrintFeedModeKey :String = "PrintFeedModeKey"
enum PrintFeedModeKey:UInt8
{
    case NoFeed =  0x08,
         EndOfPage  =  0x10,
         EndOfPageRetract =  0x20,
         FixPage  =  0x40
}

let kPrintCurlModeKey :String = "PrintCurlModeKey"
enum namePrintCurlModeKey:UInt8 {
    case CurlModeOff = 0x01,
         CurlModeOn = 0x02,
         AntiCurl =  0x03
}

let kPrintSpeedKey :String = "PrintSpeedKey"
enum PrintSpeed:UInt8
{
    case Faster =  0x00,
         Fast =  0x01,
         Slowly =  0x02,
         MoreSlowly =  0x03
}
let kPrintBidirectionKey :String = "PrintBidirectionKey"
enum PrintBidirectionKey:UInt8
{
    case BidirectionOn =  0x01,
         BidirectionOff  =  0x00
}

let kPrintFeedMarginKey :String = "PrintFeedMarginKey"

let kPrintCustomLengthKey:String = "PrintCustomLengthKey"

let kPrintCustomWidthKey :String = "PrintCustomWidthKey"

let kPrintAutoCutKey :String = "PrintAutoCutKey"
enum PrintAutoCutKey:UInt8
{
    case AutoCutOn =  0x01,
         AutoCutOff  =  0x00
}

let kPrintCutAtEndKey:String = "PrintCutAtEndKey"
enum PrintCutAtEndKey:UInt8
{
    case CutAtEndOn =  0x02,
         CutAtEndOff  =  0x00
}

let kPrintHalfCutKey :String = "PrintHalfCutKey"
enum PrintHalfCutKey:UInt8
{
    case HalfCutOn =  0x04,
         HalfCutOff  =  0x00
}

let kPrintSpecialTapeKey :String = "PrintSpecialTapeKey"
enum PrintSpecialTapeKey:UInt8
{
    case SpecialTapeOn =  0x10,
         SpecialTapeOff  =  0x00
}

let kRotateKey :String = "RotateKey"
enum RotateKey:UInt8
{
    case RotateOn =  0x01,
         RotateOff  =  0x00
}

let kPeelKey :String = "PeelKey"
enum PeelKey:UInt8
{
    case PeelOn =  0x01,
         PeelOff  =  0x00
}

let kPrintCustomPaperKey :String = "PrintCustomPaperKey"

let kPrintCutMarkKey :String = "PrintCutMarkKey"
enum PrintCutMarkKey:UInt8
{
    case CutMarkOn =  0x01,
         CutMarkOff  =  0x00
}

let kPrintLabelMargineKey :String = "PrintLabelMargineKey"

let kPrintDensityMax5Key :String = "PrintDensityMax5Key"
enum PrintDensityMax5Key:UInt8
{
    case DensityMax5Levelminus5 =  0xFB,
         DensityMax5Levelminus4 =  0xFC,
         DensityMax5Levelminus3 =  0xFD,
         DensityMax5Levelminus2 =  0xFE,
         DensityMax5Levelminus1 =  0xFF,
         DensityMax5Level0  =  0x00,
         DensityMax5Level1  =  0x01,
         DensityMax5Level2  =  0x02,
         DensityMax5Level3  =  0x03,
         DensityMax5Level4  =  0x04,
         DensityMax5Level5  =  0x05
}

let kPrintDensityMax10Key :String = "PrintDensityMax10Key"
enum PrintDensityMax10Key:UInt32
{
    case DensityMax10Level0  =  0x00,
         DensityMax10Level1  =  0x01,
         DensityMax10Level2  =  0x02,
         DensityMax10Level3  =  0x03,
         DensityMax10Level4  =  0x04,
         DensityMax10Level5  =  0x05,
         DensityMax10Level6  =  0x06,
         DensityMax10Level7  =  0x07,
         DensityMax10Level8  =  0x08,
         DensityMax10Level9  =  0x09,
         DensityMax10Level10 =  0x0A
}

let kPrintTopMarginKey :String = "PrintTopMarginKey"

let kPrintLeftMarginKey :String = "PrintLeftMarginKey"

let kPJPaperKindKey :String = "PJPaperKindKey"
enum PJPaperKindKey:UInt8
{
    case PJRoll  =  0x01,
         PJCutPaper  =  0x02
}

// 20170727
// 16進数の形式で値をセットする必要がないため、10進数の形で設定している
//（※おそらく、今までは16進入力の必要のないものまで、16進数をセットしていた可能性がある）
let kPirintQuality :String = "PrintQualityKey"
enum PrintQualityKey:Int8
{
    case LowResolution  =  1,
         Normal  =  2,
         DoubleSpeed  =  3,
         HighResolution  =  4,
         HighResolutionUsingHRImage  =  5
}

let kPrintMode9 :String = "PrintMode9"
enum PrintMode9Key:Int8
{
    case Mode9ON =  1,
         MOde9OFF  =  0
}

let kPrintRawMode :String = "PrintRawMode"
enum PrintRawModeKey:Int8
{
    case RawModeON =  1,
         RawModeOFF  =  0
}

// Custom Paper Info Parameters
//common Parameters
let kUsingCustomPaperInfo:String = "UsingCustomPaperInfo"
let kPaperKind :String = "PaperKind"
let kUnitOfLength:String = "UnitOfLength"
//basic Parameters
let kTapeWidth :String = "TapeWidth"
let kTapeLength:String = "TapeLength"
let kRightMargin :String = "RightMargin"
let kLeftMagin :String = "LeftMagin"
let kTopMargin :String = "TopMargin"
let kBottomMargin:String = "kBottomMargin"
let kLabelPitch:String = "LabelPitch"
let kMarkPosition:String = "MarkPosition"
let kMarkHeight:String = "MarkHeight"
let kDisplayName :String = "DisplayName"

