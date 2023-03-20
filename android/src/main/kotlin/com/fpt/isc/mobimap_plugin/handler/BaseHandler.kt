package com.fpt.isc.mobimap_plugin.handler

import android.content.Intent
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.listener.OnActivityResultListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

abstract class BaseHandler(
    protected val messenger: BinaryMessenger,
    protected val plugin: MobimapPlugin,
    protected val result: MethodChannel.Result
) : OnActivityResultListener, EventChannel.StreamHandler {
    protected var eventSink: EventChannel.EventSink? = null
    protected var eventChannel: EventChannel? = null

    open fun init(isListenActivityResult: Boolean = true) {
        // listener onActivityResult at MainActivity
        if (isListenActivityResult) {
            plugin.onResultCallback = this
        }
        // create event Channel and set Stream
        if (getEventChannelName().isNotEmpty()){
            eventChannel = EventChannel(messenger, getEventChannelName())
            eventChannel!!.setStreamHandler(this)  // call onListen --> assign eventSink
        }
    }

    /**
     * Override this function to use event channel
     */
    open fun getEventChannelName(): String {
        return ""
    }

    override fun onListen(value: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(value: Any?) {
//        eventSink = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        if (resultCode == Activity.RESULT_OK){
//
//        } else {
//            eventSink?.error("errorCode", "message", "detailError")
//            eventSink?.endOfStream()
//        }
    }
}