package com.fpt.isc.mobimap_plugin.handler

import android.content.Context
import android.util.Log
import com.brother.sdk.lmprinter.*
import com.brother.sdk.lmprinter.setting.PTPrintSettings
import com.brother.sdk.lmprinter.setting.PrintImageSettings
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.R
import com.fpt.isc.mobimap_plugin.constants.UtilsHelper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream

class ConnectChannelPrinterHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result
) : BaseHandler(messenger, plugin, result) {
    private var ipPrinterDefault = "192.168.118.1"

    fun connectToChannelPrinter(
        onSuccess: (printerDriver:PrinterDriverGenerateResult) -> Unit,
        onFailed: (message: String) -> Unit,
        ipPrinter: String?
    ) {
        try {
            if (ipPrinter != null){
                ipPrinterDefault = ipPrinter
            }
            //Input your printer's IP address
            val channel: Channel = Channel.newWifiChannel(ipPrinterDefault)
            //Input your printer's macAddress
            // val channel: Channel = Channel.newBluetoothChannel(macAddress, BluetoothAdapter.getDefaultAdapter())
            val result: PrinterDriverGenerateResult = PrinterDriverGenerator.openChannel(channel)
            if (result.error.code !== OpenChannelError.ErrorCode.NoError) {
                val message =
                    UtilsHelper.getStringRes(R.string.msg_can_not_connect_to_channel_printer)
                onFailed(message)
                return
            }
            onSuccess(result)
        } catch (e: Exception) {
            Log.d("connect channel printer", e.message.toString())
        }

    }
}