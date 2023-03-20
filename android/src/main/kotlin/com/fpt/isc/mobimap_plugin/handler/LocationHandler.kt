package com.fpt.isc.mobimap_plugin.handler

import android.Manifest
import android.annotation.SuppressLint
import android.location.Location
import android.util.Log
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.R
import com.fpt.isc.mobimap_plugin.constants.UtilsHelper
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.Task
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class LocationHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result
) : BaseHandler(messenger, plugin, result) {
    private val mFusedLocationClient by lazy {
        LocationServices.getFusedLocationProviderClient(plugin.context)
    }

    @SuppressLint("MissingPermission")
    fun getLocation(onSuccess: (location: Location) -> Unit,
                    onFailure: ((message: String) -> Unit)? = null,) {
        if (!UtilsHelper.hasPermissions(
                plugin.context, Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
        ) {
            onFailure?.invoke(UtilsHelper.getStringRes(R.string.msg_permission_gps_denied))
            return
        }
        val taskGetLocation: Task<Location?> =
            mFusedLocationClient.getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
        taskGetLocation.addOnSuccessListener {
            if (it != null)
                onSuccess(it)
            else
                onFailure?.invoke(UtilsHelper.getStringRes(R.string.msg_can_not_get_gps))
            Log.i("native","current Location success")
        }
        taskGetLocation.addOnFailureListener {
            val message = UtilsHelper.getStringRes(R.string.msg_can_not_get_gps)
            onFailure?.invoke(
                it.message ?: message
            )
            Log.i("native","current Location failed")
        }

    }
}