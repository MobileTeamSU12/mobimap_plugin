package com.fpt.isc.mobimap_plugin.handler

import android.app.Activity
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import androidx.annotation.RequiresApi
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants
import com.fpt.isc.mobimap_plugin.constants.NetworkHelper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class ListenInternetConnection(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    activity: Activity
    ) : BaseEventHandler(messenger, plugin, Constants.EVENT_INTERNET_CONNECTION) {

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onListen(value: Any?, events: EventChannel.EventSink?) {
        super.onListen(value, events)
        val manager = plugin.context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            manager?.registerDefaultNetworkCallback(networkCallback)
        } else {
            val request = NetworkRequest.Builder()
                .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .build()
            manager?.registerNetworkCallback(request, networkCallback)
        }
    }

    private val networkCallback = object : NetworkHelper(){
        override fun onLost(network: Network) {
            super.onLost(network)
            activity.runOnUiThread { eventSink?.success(false) }
        }

        override fun onCapabilitiesChanged(network: Network, netCap: NetworkCapabilities) {
            super.onCapabilitiesChanged(network, netCap)
            activity.runOnUiThread { eventSink?.success(true) }
        }

    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCancel(value: Any?) {
        super.onCancel(value)
        val manager = plugin.context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        manager?.unregisterNetworkCallback(networkCallback)
    }
}