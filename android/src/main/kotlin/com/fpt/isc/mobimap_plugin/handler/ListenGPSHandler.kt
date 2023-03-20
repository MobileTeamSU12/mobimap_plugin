package com.fpt.isc.mobimap_plugin.handler

import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants
import com.fpt.isc.mobimap_plugin.listener.OnGPSStatusChangeListener
import io.flutter.plugin.common.BinaryMessenger

class ListenGPSHandler(
    messenger: BinaryMessenger,
    activity: MobimapPlugin
) : BaseEventHandler(messenger, activity, Constants.EVENT_GPS_STATUS), OnGPSStatusChangeListener {

    fun listener() {
        plugin.setOnGPSStatusChangeListener(this)
    }

    override fun onGPSStatusChange(status: Boolean) {
        eventSink?.success(status)
    }


}