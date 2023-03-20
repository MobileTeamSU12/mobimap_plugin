package com.fpt.isc.mobimap_plugin.constants

import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest

open class NetworkHelper: ConnectivityManager.NetworkCallback() {

    override fun onLost(network: Network) {
        super.onLost(network)
    }

    override fun onUnavailable() {
        super.onUnavailable()
    }

    override fun onAvailable(network: Network) {
        super.onAvailable(network)
    }

    override fun onCapabilitiesChanged(network: Network, netCap: NetworkCapabilities) {
        super.onCapabilitiesChanged(network, netCap)
        // Pick the supported network states and notify Flutter of this new state
//            val status =
//                when {
//                    netCap.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> Constants.wifi
//                    netCap.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> Constants.cellular
//                    else -> Constants.unknown
//                }
    }
}