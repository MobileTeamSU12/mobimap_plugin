package com.fpt.isc.mobimap_plugin.constants

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.graphics.*
import android.media.ExifInterface
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.text.TextPaint
import android.text.TextUtils
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.fpt.isc.mobimap_plugin.R
import java.io.File


object ImageUtils {
    private val DEFAULT_FOLDER = "Mobimap_Images"
    private val TYPE_IAMGE = "jpg"
    private val TYPE_IAMGE_LONG = "jpeg"

    fun modifyOrientation(bitmap: Bitmap, image_absolute_path: String?): Bitmap {
        val ei = ExifInterface(image_absolute_path!!)
        val orientation =
            ei.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL)
        return when (orientation) {
            ExifInterface.ORIENTATION_ROTATE_90 -> rotate(bitmap, 90f)
            ExifInterface.ORIENTATION_ROTATE_180 -> rotate(bitmap, 180f)
            ExifInterface.ORIENTATION_ROTATE_270 -> rotate(bitmap, 270f)
            ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> flip(bitmap, true, false)
            ExifInterface.ORIENTATION_FLIP_VERTICAL -> flip(bitmap, false, true)
            else -> bitmap
        }
    }

    private fun rotate(bitmap: Bitmap, degrees: Float): Bitmap {
        val matrix = Matrix()
        matrix.postRotate(degrees)
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
    }

    private fun flip(bitmap: Bitmap, horizontal: Boolean, vertical: Boolean): Bitmap {
        val matrix = Matrix()
        matrix.preScale(
            (if (horizontal) -1 else 1.toFloat()) as Float,
            (if (vertical) -1 else 1.toFloat()) as Float
        )
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
    }

    fun galleryAddPic(context: Context, path: String) {
        val mediaScanIntent = Intent("android.intent.action.MEDIA_SCANNER_SCAN_FILE")
        val f = File(path)
        val contentUri = Uri.fromFile(f)
        mediaScanIntent.data = contentUri
        context.sendBroadcast(mediaScanIntent)
    }

    fun drawText(context: Context, text: String, canvas: Canvas, width: Float, height: Float) {
        val tPaint = TextPaint()
        tPaint.textAlign = Paint.Align.RIGHT
        tPaint.textSize = 22.0f
        tPaint.color = Color.WHITE
        tPaint.style = Paint.Style.FILL
        val bounds = Rect()
        tPaint.getTextBounds(text, 0, text.length, bounds)
        val mPaint = Paint()
        mPaint.color = ContextCompat.getColor(context, R.color.transparentBlack)
        val left = width - 8f - bounds.width()
        val top = height - 3f - bounds.height()
        val bottom = height + 6f
        canvas.drawRect(left, top, width, bottom, mPaint)
        canvas.drawText(text, width, height, tPaint)
    }

    fun getScaledBitmap(
        bm: Bitmap,
        bmOriginalWidth: Int,
        bmOriginalHeight: Int,
        originalWidthToHeightRatio: Double,
        originalHeightToWidthRatio: Double,
        maxHeight: Int,
        maxWidth: Int
    ): Bitmap? {
        var bm: Bitmap? = bm
        if (bmOriginalWidth > maxWidth || bmOriginalHeight > maxHeight) {
            bm = if (bmOriginalWidth > bmOriginalHeight) {
                scaleDeminsFromWidth(bm, maxWidth, bmOriginalWidth, originalHeightToWidthRatio)
            } else {
                scaleDeminsFromHeight(bm, maxHeight, bmOriginalHeight, originalWidthToHeightRatio)
            }
        }
        return bm
    }

    private fun scaleDeminsFromWidth(
        bm: Bitmap?, maxWidth: Int, bmOriginalWidth: Int,
        originalHeightToWidthRatio: Double
    ): Bitmap? {
        //scale the width
        var bm: Bitmap? = bm
        val newWidth = Math.min(maxWidth.toDouble(), bmOriginalWidth * .75).toInt()
        val newHeight = (newWidth * originalHeightToWidthRatio).toInt()
        bm = Bitmap.createScaledBitmap(bm!!, newWidth, newHeight, true)
        return bm
    }

    private fun scaleDeminsFromHeight(
        bm: Bitmap?, maxHeight: Int, bmOriginalHeight: Int,
        originalWidthToHeightRatio: Double
    ): Bitmap? {
        var bm: Bitmap? = bm
        val newHeight = Math.min(maxHeight.toDouble(), bmOriginalHeight * .55).toInt()
        val newWidth = (newHeight * originalWidthToHeightRatio).toInt()
        bm = Bitmap.createScaledBitmap(bm!!, newWidth, newHeight, true)
        return bm
    }


    fun createFileImage(context: Context, name: String): File? {
        var path = ""
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val resolver = context.contentResolver
                val contentValues = ContentValues()
                contentValues.put(MediaStore.MediaColumns.DISPLAY_NAME, name)
                contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "image/$TYPE_IAMGE_LONG")
                contentValues.put(
                    MediaStore.MediaColumns.RELATIVE_PATH,
                    Environment.DIRECTORY_PICTURES + File.separator + DEFAULT_FOLDER
                )
                resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
                path = getImagePath(context, name).toString()
            } else {
                val imagesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).toString() + File.separator
                val dirFolder = File(imagesDir, DEFAULT_FOLDER)
                if (!dirFolder.exists()) {
                    dirFolder.mkdirs()
                }
                path = File(dirFolder, "$name.$TYPE_IAMGE").path
            }
        } catch (e: Exception) {
            print(e.message)
        }
        return File(path)
    }

    private fun getImagePath(context: Context, fileName: String): String? {
        val pathCache = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val uriPath = getUriImageByName(context, fileName, DEFAULT_FOLDER, TYPE_IAMGE)
            return if (uriPath != null) {
                getRealPathFromURI(context, uriPath)
            } else {
                ""
            }
        } else {
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                .toString() + File.separator + DEFAULT_FOLDER + File.separator + fileName + ".$TYPE_IAMGE"
        }
        if (!TextUtils.isEmpty(pathCache)) {
            if (isPathCorrect(pathCache)) {
                return pathCache
            }
        }
        return ""
    }

    private fun isPathCorrect(path: String): Boolean {
        return File(path).exists()
    }

    @SuppressLint("Range")
    @RequiresApi(Build.VERSION_CODES.Q)
    fun getUriImageByName(
        context: Context,
        rawName: String,
        folderName: String,
        format: String
    ): Uri? {
        val name = "$rawName.$format"
        val resultUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val whereName =
            MediaStore.MediaColumns.DISPLAY_NAME + " = ? AND " + MediaStore.MediaColumns.RELATIVE_PATH + " = ?"
        val whereNameParams = arrayOf(
            name,
            Environment.DIRECTORY_PICTURES + File.separator + folderName + File.separator
        )
        val nameCursor: Cursor? = context.contentResolver.query(
            resultUri,
            null,
            whereName,
            whereNameParams,
            null
        )
        while (nameCursor!!.moveToNext()) {
            val id = nameCursor.getString(nameCursor.getColumnIndex(MediaStore.MediaColumns._ID))
            nameCursor.close()
            return Uri.withAppendedPath(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id)
        }
        nameCursor.close()
        return null
    }

    private fun getRealPathFromURI(
        context: Context,
        contentUri: Uri?
    ): String? {
        var cursor: Cursor? = null
        return try {
            val proj =
                arrayOf(MediaStore.Images.Media.DATA)
            cursor = context.contentResolver.query(contentUri!!, proj, null, null, null)
            val columnIndex = cursor!!.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            cursor.moveToFirst()
            cursor.getString(columnIndex)
        } finally {
            cursor?.close()
        }
    }
}