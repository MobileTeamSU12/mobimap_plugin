package com.fpt.isc.mobimap_plugin.handler

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.core.content.FileProvider
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants
import io.flutter.plugin.common.BinaryMessenger
import java.io.File
import io.flutter.plugin.common.MethodChannel


class FileLocalHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result,
) : BaseHandler(messenger, plugin, result){
    fun installAPK(pathFile: String?) {
        try {
            val intent = Intent(Intent.ACTION_VIEW)
            val uri: Uri
            if (pathFile != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    uri = FileProvider.getUriForFile(
                        plugin.context,
                        plugin.context.packageName + ".provider",
                        File(pathFile)
                    )

                    val resInfoList: List<ResolveInfo> = plugin.context.packageManager
                        .queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
                    for (resolveInfo in resInfoList) {
                        val packageName = resolveInfo.activityInfo.packageName
                        plugin.context.grantUriPermission(
                            packageName, uri,
                            Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION
                        )
                    }
                } else {
                    uri = Uri.fromFile(File(pathFile))
                }
                intent.setDataAndType(uri, "application/vnd.android.package-archive")
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                plugin.context.startActivity(intent)
            }
        } catch (ex: Exception) {
            Log.d("ErrorUpdate",ex.message.toString())
        }

    }

    override fun getEventChannelName(): String = Constants.UPDATE_APP_VERSION
}