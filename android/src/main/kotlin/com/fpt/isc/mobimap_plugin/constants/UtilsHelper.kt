package com.fpt.isc.mobimap_plugin.constants

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import android.text.TextUtils
import androidx.annotation.StringRes
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.google.gson.Gson

object UtilsHelper {

    fun openLocationSetting(context: Context){
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        ContextCompat.startActivity(context, intent, null)
    }

    fun getSDKVersion(): String {
        return Build.VERSION.SDK_INT.toString()
    }

    fun getAndroidVersion(): String {
        return Build.VERSION.RELEASE
    }

    /**
     * if get IMEI not found get android Id
     */
    private var IMEINumber = ""
    @SuppressLint("HardwareIds")
    open fun getIMEI(context: Context): String? {
        if (!TextUtils.isEmpty(IMEINumber)) {
            return IMEINumber
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val IMEILocal = getSharePrefString(context, Constants.PREFS_SAVE_IMEI)
            return if (!TextUtils.isEmpty(IMEILocal)) {
                IMEILocal.also { IMEINumber = it }
            } else {
                Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
                    .also {
                        IMEINumber = it
                    }
            }
        }

        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            IMEINumber = "-1"
            gotoSettingPermission(context)
            return IMEINumber
        } else {
            val tm = context.getSystemService(Context.TELEPHONY_SERVICE)
            if (tm is TelephonyManager) {
                // get IMEI first imei
                IMEINumber = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    tm.imei.also { IMEINumber = it }
                } else {
                    tm.deviceId.also { IMEINumber = it }
                }
            }
        }
        // save before return
        saveSharePref(context, Constants.PREFS_SAVE_IMEI, IMEINumber)
        return IMEINumber
    }

    fun gotoSettingPermission(context: Context) {
//        val builder = AlertDialog.Builder(context)
//        builder.setTitle("Cài đặt quyền truy cập")
//            .setMessage("Vui lòng cung cấp đầy đủ quyền để ứng dụng hoạt động bình thường.")
//            .setCancelable(false)
//            .setPositiveButton("Đồng ý"
//            ) { _, _ ->
//
//                (context as Activity).finish()
//            }
//            .setNegativeButton("Hủy"
//            ) { _, _ -> (context as Activity).finish() }
//        val alert = builder.create()
//        alert.show()
        val intent = Intent()
        intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        val uri = Uri.fromParts("package", context.packageName, null)
        intent.data = uri
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK;
        (context as Activity).startActivityForResult(intent, Constants.APP_SETTING_REQUEST)
    }

    fun getSharePrefString(context: Context, key: String): String {
        return SharedPrefs.getInstance(context)[key, String::class.java]
    }

    fun <T> saveSharePref(context: Context, key: String, data: T) {
        SharedPrefs.getInstance(context).put(key, data)
    }

    val gson by lazy { Gson() }

    @JvmStatic
    fun getStringRes(@StringRes resString: Int): String {
        return try {
            MobimapPlugin.getApplication().resources.getString(resString)
        } catch (e: Exception) {
            ""
        }
    }

    @JvmStatic
    fun getStringRes(
        @StringRes resString: Int,
        vararg formatArr: Any
    ): String {
        return try {
            MobimapPlugin.getApplication().resources.getString(resString, *formatArr)
        } catch (e: Exception) {
            ""
        }
    }

    @JvmStatic
    fun hasPermissions(context: Context, vararg permissions: String): Boolean =
        permissions.all {
            ActivityCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
        }
}