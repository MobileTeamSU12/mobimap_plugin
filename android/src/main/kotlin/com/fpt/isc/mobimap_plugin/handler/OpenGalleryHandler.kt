package com.fpt.isc.mobimap_plugin.handler

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants
import com.fpt.isc.mobimap_plugin.constants.Constants.Companion.GALLERY_REQUEST
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class OpenGalleryHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result,
    private val activity: Activity,
) : BaseHandler(messenger, plugin, result) {
    private val errorCode = "-1"
    val intent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)

    fun openGallery() {
        val intent = Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
        activity.startActivityForResult(intent, GALLERY_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        val path = data?.let { handleImageSelect(it) }
        if (path == null) {
            result.error(errorCode, "Failed to pick image", "Failed to pick image")
        } else {
            result.success(path)
        }
    }

    private fun handleImageSelect(data: Intent): String? {
        var picturePath: String? = null
        val selectedImage: Uri? = data.data
        if (selectedImage != null) {
            val filePathColumn = arrayOf(MediaStore.Images.Media.DATA)
            val cursor: Cursor? =
                plugin.context.contentResolver.query(
                    selectedImage,
                    filePathColumn,
                    null,
                    null,
                    null
                )
            if (cursor != null) {
                cursor.moveToFirst()
                val columnIndex = cursor.getColumnIndex(filePathColumn[0])
                picturePath = cursor.getString(columnIndex)
                cursor.close()
            }
        }
        return picturePath
    }
}