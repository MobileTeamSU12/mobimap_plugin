package com.fpt.isc.mobimap_plugin.handler

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants
import com.fpt.isc.mobimap_plugin.listener.OnActivityResultListener
import com.fpt.isc.mobimap_plugin.listener.OnRequestPermissionsResult
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class PermissionRequestHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result
) : BaseHandler(messenger, plugin, result), OnRequestPermissionsResult {

    //    private val permissionsRequest = arrayOf(
//        Manifest.permission.CAMERA,
//        Manifest.permission.READ_PHONE_STATE,
//        Manifest.permission.READ_EXTERNAL_STORAGE,
//        Manifest.permission.WRITE_EXTERNAL_STORAGE,
//        Manifest.permission.ACCESS_FINE_LOCATION,
//        Manifest.permission.ACCESS_COARSE_LOCATION,
//    )
    val permissionsNeedRequest = mutableListOf<String>()
     lateinit var permissionsRequest : List<String>

    fun requestPermission(permissions: String): Boolean {
        permissionsRequest = findPermissions(permissions)
        plugin.onResultPermissionCallback = this
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            if (!Environment.isExternalStorageManager()) {
                val permissionIntent = Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION)
//                plugin.context.startActivity(permissionIntent)
                plugin.activity.startActivityForResult(permissionIntent, Constants.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION_REQUEST)
                return  false
            }
            grandOtherPermission()
        }
        return false
    }

    private  fun grandOtherPermission(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            permissionsNeedRequest.clear()
            for (permission in permissionsRequest) {
                if (!checkIfAlreadyHasPermission(plugin.context, permission)) {
                    permissionsNeedRequest.add(permission)
                }
            }
            if (permissionsNeedRequest.size > 0) {
                requestForSpecificPermission(plugin.activity, permissionsNeedRequest.toTypedArray())
            } else {
                result.success(true)
            }
        } else {
            result.success(true)
        }
    }

    private fun checkIfAlreadyHasPermission(context: Context, permission: String): Boolean {
        val result = ContextCompat.checkSelfPermission(context, permission)
        return result == PackageManager.PERMISSION_GRANTED
    }

    private fun requestForSpecificPermission(
        activity: Activity,
        permissions: Array<String>
    ) {
        ActivityCompat.requestPermissions(
            activity,
            permissions,
            Constants.PERMISSION_REQUEST_CODE
        )
    }

    override fun getEventChannelName(): String = Constants.PERMISSION_REQUEST_EVENT

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == Constants.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION_REQUEST) {
            grandOtherPermission()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissionsGrant: Array<out String>,
        grantResults: IntArray
    ) {
        when (requestCode) {
            Constants.PERMISSION_REQUEST_CODE -> {
                val grantList = mutableListOf<String>()
                val deniedList = mutableListOf<String>()
                permissionsGrant.forEachIndexed { index, permission ->
                    if (grantResults[index] == PackageManager.PERMISSION_GRANTED) {
                        grantList.add(permission)
                    } else {
                        deniedList.add(permission)
                    }
                }
                val isPermissionGrantedAll = grantList.size == permissionsNeedRequest.size
                if (isPermissionGrantedAll) {
                    result.success(true)
                } else {     // Permission Denied
                    result.success(false)
//                    requestPermission()
//                    eventSink?.success(false)
//                    UtilsHelper.gotoSettingPermission(activity)
                }
            }
        }
    }

    private fun findPermissions(permission: String): List<String> {
        return when (permission.lowercase()) {
            Constants.CAMERA_PERMISSION_KEY -> arrayListOf(Manifest.permission.CAMERA)
            Constants.STORAGE_PERMISSION_KEY -> arrayListOf(
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE
            )
            Constants.PHONE_STATE_PERMISSION_KEY -> arrayListOf(Manifest.permission.READ_PHONE_STATE)
            Constants.LOCATION_PERMISSION_KEY -> arrayListOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
            else -> arrayListOf(
                Manifest.permission.CAMERA,
                Manifest.permission.READ_PHONE_STATE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
        }
    }

}