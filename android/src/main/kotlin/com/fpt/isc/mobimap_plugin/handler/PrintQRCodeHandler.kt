package com.fpt.isc.mobimap_plugin.handler

import android.content.Context
import android.util.Log
import com.brother.sdk.lmprinter.PrintError
import com.brother.sdk.lmprinter.PrinterDriver
import com.brother.sdk.lmprinter.PrinterDriverGenerateResult
import com.brother.sdk.lmprinter.PrinterModel
import com.brother.sdk.lmprinter.setting.PTPrintSettings
import com.brother.sdk.lmprinter.setting.PrintImageSettings
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.io.OutputStream

class PrintQRCodeHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result
) : BaseHandler(messenger, plugin, result) {

    private val response: HashMap<String, Any> = HashMap()
    private val successMessage:String = "In QRCode thành công"

    fun printQrCode(
        onSuccess: (HashMap<String, Any>) -> Unit,
        context: Context,
        printerResult: PrinterDriverGenerateResult,
        labelSize: Int?,
        resolution: Int?,
        isAutoCut: Boolean?,
        numCopies: Int?,
        printerFilePath: String?,
    ) {
        val printerDriver = printerResult.driver

        // Printer settings
        val printSettings = settingPrinter(context, labelSize, resolution, isAutoCut, numCopies)

        if(!printerFilePath.isNullOrEmpty()){
            val file = File(printerFilePath).extension
            Log.d("file extension", file)
            val printError: PrintError = when (file) {
                "pdf" -> {
                    printerDriver.printPDF(printerFilePath, printSettings)
                }
                "png" -> {
                    printerDriver.printImage(printerFilePath, printSettings)
                }
                else -> {
                    response["status"] = false
                    response["message"] = "Error - Print QRCode: Not provided this extension"
                    onSuccess(response)
                    return
                }
            }

            if (printError.code != PrintError.ErrorCode.NoError) {
                response["status"] = false
                response["message"] = "Error - Print QRCode: ${printError.code}"
            } else {
                response["status"] = true
                response["message"] = successMessage
            }
            onSuccess(response)
            printerDriver.closeChannel();
        }
    }

    private fun settingPrinter(
        context: Context,
//        workPath: Any?,
        labelSize: Int?,
        resolution: Int?,
        isAutoCut: Boolean?,
        numCopies: Int?,
    ): PTPrintSettings {

        val printSettings = PTPrintSettings(PrinterModel.PT_E550W)
        // default value: label size: Width24mm, resolution: High, isAutoCut: true, numCopies: 1
        printSettings.labelSize = PTPrintSettings.LabelSize.values()[labelSize ?: 5]
        printSettings.workPath = context.filesDir.absolutePath
        printSettings.resolution = PrintImageSettings.Resolution.values()[resolution ?: 2]
        printSettings.isAutoCut = isAutoCut ?: true
        printSettings.numCopies = numCopies ?: 1
        printSettings.printOrientation = PrintImageSettings.Orientation.Landscape

        return printSettings
    }


    private fun copyFileUsingStream(source: InputStream, dest: FileOutputStream) {
        var ip: InputStream? = null
        var op: OutputStream? = null
        try {
            ip = source
            op = dest
            val buffer = ByteArray(1024)
            var length: Int
            while (ip.read(buffer).also { length = it } > 0) {
                op.write(buffer, 0, length)
            }
        } finally {
            ip?.close()
            op?.close()
        }
    }

}