package com.fpt.isc.mobimap_plugin.handler

import android.content.Intent
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.listener.OnActivityResultListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

abstract class BaseEventHandler(
    val messenger: BinaryMessenger,
    val plugin: MobimapPlugin,
    val eventChannelName: String
) : OnActivityResultListener, EventChannel.StreamHandler {
    protected var eventSink: EventChannel.EventSink? = null
    protected var eventChannel: EventChannel? = null

    init {
        init()
    }

    private fun init(isListenActivityResult: Boolean = true) {
        // listener onActivityResult at MainActivity
        if (isListenActivityResult) {
            plugin.onResultCallback = this
        }
        // create event Channel and set Stream
        if (eventChannelName.isNotEmpty()){
            eventChannel = EventChannel(messenger, eventChannelName)
            eventChannel!!.setStreamHandler(this)  // call onListen --> assign eventSink
        } else {
            throw Exception("eventChannelName not empty")
        }
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