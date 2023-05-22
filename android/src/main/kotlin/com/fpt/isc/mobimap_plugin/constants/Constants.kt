package com.fpt.isc.mobimap_plugin.constants

class Constants {
    companion object {

        var statusConnection = false
        var statusGPS = false
        const val PERMISSION_REQUEST_CODE = 1

        const val PREFS_FILE_NAME = "sharedpref_save_temp_data"
        const val PREFS_SAVE_IMEI = "prefs_imei"

        /**
         * FUN NAME METHOD CHANNEL
         */
        const val OPEN_GPS_SETTING_FUN: String = "openGPSSetting"
        const val OPEN_APP_SETTING_FUN: String = "openAppSetting"
        const val UPDATE_APP_VERSION: String = "updateAppVersion"
        const val GET_FILE_FUN: String = "getFile"
        const val SAVE_IMAGE_TO_GALLERY: String = "saveImageToGallery"
        const val REQUEST_PERMISSION_FUN: String = "requestPermission"
        const val GET_OS_VERSION: String = "getOperatingSystemVersion"
        const val GET_IMEI: String = "getImei"
        const val TAKE_PHOTO: String = "takePhoto"
        const val GET_IMAGE_FROM_GALLERY: String = "getImageFromGallery"
        const val GET_INTERNET_CONNECTION: String = "getInternetConnection"
        const val LISTEN_INTERNET_CONNECTION: String = "listenInternetConnection"
        const val GET_LOCATION: String = "getLocation"
        const val GET_GPS_STATUS: String = "getGpsStatus"
        const val VERSION_APP: String = "getVersionApp"
        const val HASH_COMMIT: String = "getHashCommit"
        const val LAUNCH_BROWSER: String = "launchBrowser"
        const val CONNECT_WIFI_PRINTER: String = "connectWifiPrinter"
        const val CONNECT_CHANNEL_PRINTER: String = "connectChannelPrinter"
        const val PRINT_QR_CODE: String = "printQRCode"

        /**
         * Argument Name
         */

        const val FILE_PATH_ARGUMENT: String = "filePath"
        const val FILE_NAME_ARGUMENT: String = "fileName"
        const val FILE_DATA_ARGUMENT: String = "fileData"
        const val URL_DATA_ARGUMENT: String = "url"
	    const val PERMISSIONS_REQUEST_ARGUMENT: String = "permissionType"
        // Arguments Printer
        const val LABEL_SIZE: String = "labelSize"
        const val RESOLUTION: String = "resolution"
        const val WORK_PATH: String = "workPath"
        const val IS_AUTO_CUT: String = "isAutoCut"
        const val NUM_COPIES: String = "numCopies"
        const val ssidPrinter:String = "ssidPrinter"
        const val passwordPrinter:String = "passwordPrinter"
        const val ipPrinter:String = "ipPrinter"

        /**
         * Event channel Name
         */
        const val PREFIX = "com.fpt.isc.mobimap_plugin"
        const val CHANNEL_NAME: String = "$PREFIX/MobiMapMethod"
        const val PERMISSION_REQUEST_EVENT = "$PREFIX/PermissionEvent"
        const val EVENT_GPS_STATUS = "$PREFIX/MobiMapEventGPS";
        const val EVENT_INTERNET_CONNECTION = "$PREFIX/MobiMapEventNetwork";


        const val CAMERA_PERMISSION_KEY = "camera"
        const val ALL_PERMISSION_KEY = "all"
        const val STORAGE_PERMISSION_KEY = "storage"
        const val PHONE_STATE_PERMISSION_KEY = "phone_state"
        const val LOCATION_PERMISSION_KEY = "location"

        /**
         * Action Image
         */
        const val CAMERA_REQUEST = 1
        const val GALLERY_REQUEST = 2
        const val FILE_NAME = "fileName"
        const val DRAW_TEXT = "drawText"

        /**
         *
         */
        const val wifi = 1
        const val cellular = 2
        const val disconnected = 3
        const val unknown = 4
        const val eof = -1

        /**
         *
         */

        const val ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION_REQUEST = 302
        const val APP_SETTING_REQUEST = 312
    }
}
