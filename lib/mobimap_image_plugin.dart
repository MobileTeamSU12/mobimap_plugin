import 'package:flutter/foundation.dart';
import 'package:mobimap_plugin/src/native_channel_handler.dart';
import 'package:mobimap_plugin/src/native_constants_value.dart';

/// Containing all function effect on image, like get image, save,...
class MobiMapImagePlugin {
  static Future<String> getImageFromGallery() async {
   return await NativeChannelHandler.call(function: NativeFunction.getImageFromGallery) ?? '';
  }

  static Future<String> takePhoto({required List<String> drawText, required String fileName}) async {

    // drawText: this is the list of string, that is what we want to draw it in to the photo after taking
    // ['this is test 1, this is test 2, this is test 3, ...']
    final args =  {
      NativeArgument.drawText : drawText,
      NativeArgument.fileName : fileName
    };

    return await NativeChannelHandler.call(function: NativeFunction.takePhoto, arguments: args) ?? '';
  }

  static Future<bool> saveImageToGallery({required String fileName, required Uint8List data}) async {

    // data: this is the image we want to save, that can be a image we got from internet or something like that
    // type of the image is: Uint8List
    final args =  {
      NativeArgument.fileData : data,
      NativeArgument.fileName : fileName
    };

    return await NativeChannelHandler.call(
      function: NativeFunction.saveImageToGallery,
      arguments: args
    );
  }
}
