package com.fpt.isc.mobimap_plugin

import android.app.Activity
import android.net.Uri
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Context.LOCATION_SERVICE
import android.content.Intent
import android.content.IntentFilter
import android.location.LocationManager
import com.brother.sdk.lmprinter.PrinterDriverGenerateResult
import com.fpt.isc.mobimap_plugin.constants.Constants
import com.fpt.isc.mobimap_plugin.constants.UtilsHelper
import com.fpt.isc.mobimap_plugin.handler.*
import com.fpt.isc.mobimap_plugin.listener.OnActivityResultListener
import com.fpt.isc.mobimap_plugin.listener.OnGPSStatusChangeListener
import com.fpt.isc.mobimap_plugin.listener.OnRequestPermissionsResult
import io.flutter.app.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/** MobimapPlugin */
class MobimapPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    companion object {
        lateinit var appContext: Context
        fun getApplication(): Context {
            return appContext
        }
    }

    private val errorCode = "-1"

    var mOnGPSStatusChangeListener: OnGPSStatusChangeListener? = null

    private val mGPSBroadcast: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val locationManager = context.getSystemService(LOCATION_SERVICE) as LocationManager
            if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                Constants.statusGPS = true
                mOnGPSStatusChangeListener?.onGPSStatusChange(true)
            } else {
                mOnGPSStatusChangeListener?.onGPSStatusChange(false)
                Constants.statusGPS = false
            }
        }
    }

    private lateinit var mMethodChannel: MethodChannel
    lateinit var activity: Activity
    lateinit var context: Context
    private lateinit var binaryMessenger: BinaryMessenger
    private var printerResult: PrinterDriverGenerateResult? = null

    var onResultCallback: OnActivityResultListener? = null
    var onResultPermissionCallback: OnRequestPermissionsResult? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger
        mMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, Constants.CHANNEL_NAME)
        mMethodChannel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        appContext = flutterPluginBinding.applicationContext
    }

    private fun registerEvent(binaryMessenger: BinaryMessenger) {
        ListenInternetConnection(binaryMessenger, this, activity)
        val listenGPSHandler = ListenGPSHandler(binaryMessenger, this)
        listenGPSHandler.listener()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        mMethodChannel.setMethodCallHandler(null)
        teardownChannels()
        activity.unregisterReceiver(mGPSBroadcast)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                Constants.GET_IMEI -> {
                    result.success(UtilsHelper.getIMEI(context) ?: "")
                }
                Constants.OPEN_GPS_SETTING_FUN -> {
                    UtilsHelper.openLocationSetting(context)
                    result.success(true)
                }
                Constants.OPEN_APP_SETTING_FUN -> {
                    val handler = AppSettingHandler(binaryMessenger, this, result)
                    handler.init()
                    handler.gotoSettingPermission()
                }
                Constants.UPDATE_APP_VERSION -> {

                    //                    OpenFile.open(context, "file")
                    val pathFile = call.argument<String?>(Constants.FILE_PATH_ARGUMENT)
                    val fileHandler = FileLocalHandler(binaryMessenger, this, result)
                    fileHandler.installAPK(pathFile)
                    result.success("success")
                }
                Constants.GET_FILE_FUN -> {
                    //                    GetFile.get(context)
                    //                    result.success("success")
                }
                Constants.GET_OS_VERSION -> {
                    UtilsHelper.getAndroidVersion()
                    UtilsHelper.getSDKVersion()
                    val androidVersion =
                        "Android ${UtilsHelper.getAndroidVersion()} - SDK ${UtilsHelper.getSDKVersion()}"
                    result.success(androidVersion)
                }
                Constants.REQUEST_PERMISSION_FUN -> {
                    val permission: Any? = call.argument(Constants.PERMISSIONS_REQUEST_ARGUMENT)
                    if (permission is String) {
                        val handler = PermissionRequestHandler(binaryMessenger, this, result)
                        handler.init()
                        handler.requestPermission(permission)
                        //                        handler.initEvent(true)
                    } else {
                        result.error(errorCode, "param not empty", "param not empty")
                    }
                }
                Constants.TAKE_PHOTO -> {
                    val handler = TakePhotoHandler(binaryMessenger, this, result, activity)
                    handler.filename = call.argument<String?>(Constants.FILE_NAME)
                    handler.drawText = call.argument<List<String>?>(Constants.DRAW_TEXT)
                    handler.init(true)
                    handler.takeImage()
                }
                Constants.GET_IMAGE_FROM_GALLERY -> {
                    val handler = OpenGalleryHandler(binaryMessenger, this, result, activity)
//                    Log.i("TAG", "onMethodCall: ")
                    handler.init(true)
                    handler.openGallery()
                }
                Constants.SAVE_IMAGE_TO_GALLERY -> {
                    val data: Any? = call.argument(Constants.FILE_DATA_ARGUMENT)
                    val name: Any? = call.argument(Constants.FILE_NAME_ARGUMENT)

                    android.util.Log.d("DATA", "onMethodCall: ${data?.javaClass?.name}")
                    android.util.Log.d("DATA", "onMethodCall: $data")
                    result.success(true)
                }
                Constants.GET_INTERNET_CONNECTION -> {
                    result.success(Constants.statusConnection)
                }
                Constants.GET_LOCATION -> {
                    val handler = LocationHandler(binaryMessenger, this, result)
                    handler.getLocation({
                        val locationString = "${it.latitude},${it.longitude}"
                        result.success(locationString)
                    }, {
                        result.error(errorCode, it, "LocationHandler -> $it")
                    })
                }
                Constants.GET_GPS_STATUS -> {
                    val locationManager =
                        context.getSystemService(FlutterActivity.LOCATION_SERVICE) as LocationManager
                    if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                Constants.VERSION_APP -> {
//                    result.success(BuildConfig.VERSION_NAME)
                    result.success("Not implement yet")
                }
                Constants.HASH_COMMIT -> {
//                    result.success(BuildConfig.VERSION_HASH)
                    result.success("Not implement yet")
                }
                Constants.LAUNCH_BROWSER -> {
                    val url: String =
                        call.argument(Constants.URL_DATA_ARGUMENT) ?: "http://google.com"

                    val intent: Intent = Intent(Intent.ACTION_VIEW)
                    intent.setDataAndType(Uri.parse(url), "text/html")

                    activity.startActivity(intent)
//                    result.success("Success $url")
                }
                Constants.CONNECT_WIFI_PRINTER -> {
                    val ssidPrinter: String? = call.argument(Constants.ssidPrinter)
                    val passwordPrinter: String? = call.argument(Constants.printerPass)
                    val handler = ConnectWifiPrinterHandler(binaryMessenger, this, result)
                    GlobalScope.run {
                        handler.connectToWifiPrinter({
                            result.success(it)
                        }, context, ssidPrinter, passwordPrinter)
                    }
                }
                Constants.CONNECT_CHANNEL_PRINTER -> {
                    val ipPrinter: String? = call.argument(Constants.printerIPAddress)
                    val handler = ConnectChannelPrinterHandler(binaryMessenger, this, result)
                    GlobalScope.launch {
                        handler.connectToChannelPrinter({ printer, response ->
                            printerResult = printer
                            result.success(response)
                        }, ipPrinter)
                    }
                }
                Constants.PRINT_QR_CODE -> {
                    val labelSize: Int? = call.argument(Constants.LABEL_SIZE)
                    val resolution: Int? = call.argument(Constants.RESOLUTION)
                    val isAutoCut: Boolean? = call.argument(Constants.IS_AUTO_CUT)
                    val numCopies: Int? = call.argument(Constants.NUM_COPIES)
                    val handler = PrintQRCodeHandler(binaryMessenger, this, result)
                    if (printerResult != null) {
                        GlobalScope.launch {
                            handler.printQrCode({
                                result.success(true)
                            }, {
                                result.error(errorCode, it, "empty param")
                            }, context, printerResult!!, labelSize, resolution, isAutoCut, numCopies)
                        }
                    }else {
                        result.error(
                            errorCode,
                            UtilsHelper.getStringRes(R.string.msg_does_not_connect_to_channel_printer),
                            "empty param"
                        )
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error(errorCode, e.message, e.toString())
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        onResultCallback?.onActivityResult(requestCode, resultCode, data)
        return true
    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        onResultPermissionCallback?.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
        return true
    }

    private fun teardownChannels() {
        mMethodChannel.setMethodCallHandler(null)
    }

    fun setOnGPSStatusChangeListener(listener: OnGPSStatusChangeListener) {
        mOnGPSStatusChangeListener = listener
    }


    // activity
    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity;
        binding.addActivityResultListener(this)
        binding.addRequestPermissionsResultListener(this)

        val internetConnection = GetInternetConnectionHandler(activity)
        internetConnection.checkInternetConnection()

        val filter = IntentFilter(LocationManager.PROVIDERS_CHANGED_ACTION)
        filter.addAction(Intent.ACTION_PROVIDER_CHANGED)
        filter.addAction(LocationManager.MODE_CHANGED_ACTION)
        activity.registerReceiver(mGPSBroadcast, filter)

        registerEvent(binaryMessenger)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}
