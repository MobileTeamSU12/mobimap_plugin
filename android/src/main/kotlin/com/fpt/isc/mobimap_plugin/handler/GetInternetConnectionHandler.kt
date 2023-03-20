package com.fpt.isc.mobimap_plugin.handler

import android.app.Activity
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import com.fpt.isc.mobimap_plugin.constants.Constants
import com.fpt.isc.mobimap_plugin.constants.NetworkHelper

class GetInternetConnectionHandler(val activity: Activity)  {

    private val networkCallback = object : NetworkHelper(){
        override fun onAvailable(network: Network) {
            super.onAvailable(network)
            Constants.statusConnection = true
        }

        override fun onUnavailable() {
            super.onUnavailable()
            Constants.statusConnection = true
        }

    }

    fun checkInternetConnection() {
        val manager = activity.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            manager?.registerDefaultNetworkCallback(networkCallback)
        } else {
            val request = NetworkRequest.Builder()
                .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
                .build()
            manager?.registerNetworkCallback(request, networkCallback)
        }
    }
}