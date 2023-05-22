package com.fpt.isc.mobimap_plugin.handler

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.wifi.WifiConfiguration
import android.net.wifi.WifiManager
import android.text.TextUtils
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.R
import com.fpt.isc.mobimap_plugin.constants.UtilsHelper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.*

class ConnectWifiPrinterHandler(
    binaryMessenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result
) : BaseHandler(binaryMessenger, plugin, result) {
    private var ssidFormatPrinter = "direct"
    private var passwordPrinterDefault = "00000000"
    private var networkSSID: String = ""
    private var isConnected = false


    fun connectToWifiPrinter(
        onSuccess: () -> Unit,
        onFailed: (message: String) -> Unit,
        context: Context,
        ssidPrinter:String?,
        passwordPrinter: String?
    ) {
        try {
            if(ssidPrinter != null)
                ssidFormatPrinter = ssidPrinter.lowercase()
            if(passwordPrinter != null)
                passwordPrinterDefault = passwordPrinter

            // check permission location
            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) == PackageManager.PERMISSION_DENIED
            ) {
                val message = UtilsHelper.getStringRes(R.string.msg_fine_location_denied)
                onFailed(message)
                return
            }
            val wifiManager =
                context.applicationContext.getSystemService(AppCompatActivity.WIFI_SERVICE) as WifiManager
            val conf = WifiConfiguration()
            val connectionManager =
                context.getSystemService(AppCompatActivity.CONNECTIVITY_SERVICE) as ConnectivityManager
            val wifiCheck = connectionManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI)
            val info = wifiManager.connectionInfo
            val ssid = info.ssid


            // check is connected wifi device if connected break here
            if (wifiCheck!!.isConnected) {
                val isFoundDeviceConnect = (!TextUtils.isEmpty(ssid)
                        && ssid.replace("\"".toRegex(), "").lowercase(Locale.getDefault())
                    .startsWith(ssidFormatPrinter))
                // check printer is connected
                if (isFoundDeviceConnect) {
                    onSuccess()
                } else {

                    // remove printer from list connected
                    val list = wifiManager.configuredNetworks
                    for (i in list) {
                        val temp = i.SSID.lowercase(Locale.getDefault()).replace("\"".toRegex(), "")
                        if (!TextUtils.isEmpty(i.SSID) && temp.startsWith(
                                ssidFormatPrinter
                            )
                        ) {
                            wifiManager.removeNetwork(i.networkId)
                            wifiManager.saveConfiguration()
                        }
                    }

                    // scan list wifi
                    val mScanResults = wifiManager.scanResults
                    var isNotFound = true
                    networkSSID = ""
                    for (results in mScanResults) {
                        val temp =
                            results.SSID.lowercase(Locale.getDefault()).replace("\"".toRegex(), "")
                        if (!TextUtils.isEmpty(temp) && temp.lowercase(Locale.getDefault())
                                .startsWith(ssidFormatPrinter)
                        ) {
                            networkSSID = results.SSID
                            isNotFound = false
                            break
                        }
                    }

                    // not found SSID print device stop connect
                    val isForceConnectPrinter = mScanResults.isEmpty()
                    if (isNotFound) {
                        val message =
                            UtilsHelper.getStringRes(R.string.msg_can_not_find_printer_wifi)
                        onFailed(message)
                        return
                    }

                    // config connect wifi scan found
                    conf.SSID = String.format("\"%s\"", networkSSID)
                    conf.preSharedKey = String.format(
                        "\"%s\"",
                        passwordPrinterDefault
                    )
                    val netId = wifiManager.addNetwork(conf)
                    wifiManager.disconnect()
                    wifiManager.enableNetwork(netId, true)
                    isConnected = wifiManager.reconnect()
                    if (isConnected) {
                        onSuccess()
                    } else {
                        val message =
                            UtilsHelper.getStringRes(R.string.msg_can_not_connect_to_printer_wifi)
                        onFailed(message)
                        return
                    }
                }
            } else {
                val message = UtilsHelper.getStringRes(R.string.msg_can_not_connect_to_wifi)
                onFailed(message)
                return
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
            e.message?.let { onFailed(it) }
        }


    }
}