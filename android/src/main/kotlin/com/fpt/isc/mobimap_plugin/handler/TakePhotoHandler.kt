package com.fpt.isc.mobimap_plugin.handler

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.text.TextUtils
import androidx.core.content.FileProvider
import com.fpt.isc.mobimap_plugin.MobimapPlugin
import com.fpt.isc.mobimap_plugin.constants.Constants.Companion.CAMERA_REQUEST
import com.fpt.isc.mobimap_plugin.constants.ImageUtils
import com.fpt.isc.mobimap_plugin.constants.ImageUtils.createFileImage
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream


class TakePhotoHandler(
    messenger: BinaryMessenger,
    plugin: MobimapPlugin,
    result: MethodChannel.Result,
    private val activity: Activity,
) : BaseHandler(
    messenger,
    plugin,
    result
) {
    var filename: String? = null
    var drawText: List<String>? = null
    private var currentFile: File? = null
    private var originalSizePhoto: Int? = null
    private val defaultSize: Int = 1024
    private val errorCode = "-1"

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == CAMERA_REQUEST) {
                if (currentFile != null) {
                    this.currentFile?.path?.let {
                        resizeAndDrawDateTimeToImage(it)
                    }
                    result.success(currentFile?.path)
                    currentFile = null
                } else {
                    result.error(errorCode, "Failed to take photo", "Failed to take photo")
                }
            }
        } else if (resultCode == Activity.RESULT_CANCELED) {
            result.error(errorCode, "Failed to take photo", "Failed to take photo")
        }
    }

    fun takeImage() {
        currentFile = createImageFile(filename)
        val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        val uri: Uri
        if (currentFile != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                uri = FileProvider.getUriForFile(
                    plugin.context,
                    plugin.context.applicationContext.packageName + ".provider",
                    currentFile!!
                )
                val resInfoList: List<ResolveInfo> = plugin.context.packageManager
                    .queryIntentActivities(takePictureIntent, PackageManager.MATCH_DEFAULT_ONLY)
                for (resolveInfo in resInfoList) {
                    val packageName = resolveInfo.activityInfo.packageName
                    plugin.context.applicationContext.grantUriPermission(
                        packageName, uri,
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION
                    )
                }
            } else {
                uri = Uri.fromFile(currentFile!!)
            }
            takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, uri)
            activity.startActivityForResult(
                takePictureIntent,
                CAMERA_REQUEST
            )
        }
    }


    private fun resizeAndDrawDateTimeToImage(
        imagePath: String,
        originalSize: Int? = null
    ) {
        var photoBm = BitmapFactory.decodeFile(imagePath)

        //**************** Resize image *****************
        //get its original dimensions
        if (photoBm != null) {
            val bmOriginalWidth = photoBm.width
            val bmOriginalHeight = photoBm.height
            val originalWidthToHeightRatio = 1.0 * bmOriginalWidth / bmOriginalHeight
            val originalHeightToWidthRatio = 1.0 * bmOriginalHeight / bmOriginalWidth
            //choose a maximum height
            val maxHeight = originalSize ?: originalSizePhoto ?: defaultSize
            //choose a max width
            val maxWidth = originalSize ?: originalSizePhoto ?: defaultSize
            //call the method to get the scaled bitmap
            photoBm = ImageUtils.getScaledBitmap(
                photoBm, bmOriginalWidth, bmOriginalHeight,
                originalWidthToHeightRatio, originalHeightToWidthRatio,
                maxHeight, maxWidth
            )
        }
        try {
            val bitmap: Bitmap = ImageUtils.modifyOrientation(photoBm, imagePath)

            val mutableBitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true)
            val cs = Canvas(mutableBitmap)
            cs.drawBitmap(mutableBitmap, 0f, 0f, null)

            val toolName = drawText?.get(0)
            val location = drawText?.get(1)
            val time = drawText?.get(2)
            //Draw name
            ImageUtils.drawText(
                plugin.context,
                toolName ?: "",
                cs,
                mutableBitmap.width - 20f,
                mutableBitmap.height - 86f
            )

            //Draw location
            ImageUtils.drawText(
                plugin.context,
                location ?: "",
                cs,
                mutableBitmap.width - 20f,
                mutableBitmap.height - 53f
            )

            //Draw datetime
            ImageUtils.drawText(
                plugin.context,
                time ?: "",
                cs,
                mutableBitmap.width - 20f,
                mutableBitmap.height - 20f
            )
            try {
                mutableBitmap.compress(
                    Bitmap.CompressFormat.JPEG, 100, FileOutputStream(
                        File(imagePath)
                    )
                )
                ImageUtils.galleryAddPic(plugin.context, imagePath)
            } catch (e: FileNotFoundException) {
                e.printStackTrace()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun createImageFile(fileName: String?): File? {
        val formatName: String = if (TextUtils.isEmpty(fileName)) {
            String.format("%s", System.currentTimeMillis())
        } else {
            String.format("%s_%s", fileName, System.currentTimeMillis())
        }
        return createFileImage(plugin.context, formatName)
    }
}