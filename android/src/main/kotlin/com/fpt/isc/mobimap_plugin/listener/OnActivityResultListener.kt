package com.fpt.isc.mobimap_plugin.listener

import android.content.Intent

interface OnActivityResultListener {
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
}