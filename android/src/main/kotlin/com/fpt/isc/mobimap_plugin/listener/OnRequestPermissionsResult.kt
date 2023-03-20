package com.fpt.isc.mobimap_plugin.listener

interface OnRequestPermissionsResult {

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    )
}