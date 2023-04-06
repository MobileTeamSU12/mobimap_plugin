package com.fpt.isc.mobimap_plugin.handler

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


class AppSettingHandler (messenger: BinaryMessenger,
                         plugin: MobimapPlugin,
                         result: MethodChannel.Result
) : BaseHandler(messenger, plugin, result)  {

    fun gotoSettingPermission() {
        val appSettingIntent = Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:" + plugin.context.applicationContext.packageName)
        )

        plugin.activity.startActivityForResult(
            appSettingIntent,
            Constants.APP_SETTING_REQUEST
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == Constants.APP_SETTING_REQUEST) {
            result.success(true)
        }
    }
}