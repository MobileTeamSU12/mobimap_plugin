//
//  FMapHelper.h
//  MobiMap
//
//  Created by ThanhTC on 04/23/20.
//  Copyright © 2020 RAD. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface FMapHelperPlugin : NSObject

#pragma mark - imagePickerController

+ (void)createFolder;

+ (void)createAlbum;

+ (void)saveImageWithFileName:(NSString *)file_name image:(UIImage *)image completion:(void (^)(BOOL finished))completion;

+ (UIImage *)resizedImageWithDrawText:(NSArray *)drawText didFinishPickingMediaWithInfo:(NSDictionary *)info;

+ (UIImage *)resizedImageWithText:(NSString *)name location:(NSString *)location didFinishPickingMediaWithInfo:(NSDictionary *)info data:(NSData *)data;

+ (UIImage *)resizedImageCASDWithText:(NSString *)name location:(NSString *)location didFinishPickingMediaWithInfo:(NSDictionary *)info;

#pragma mark - ShowImagePicker
+ (void)showImagePickerCamera:(nullable id /*<UIViewController>*/)parentVCtrl delegate:(nonnull id /*<UIImagePickerControllerDelegate>*/)delegate isEdit:(BOOL)isEdit;

+ (void)showImagePickerLibrary:(nullable id /*<UIViewController>*/)parentVCtrl delegate:(nonnull id /*<UIImagePickerControllerDelegate>*/)delegate isEdit:(BOOL)isEdit;

+ (UIViewController *)addSubVCtrl:(nonnull id /*<UIViewController>*/)subVCtrl;

+ (void)checkCameraSeesion;
+ (void)checkGPSMobiMap;
+ (void)checkLibraryCamera;
+ (void)checkInternetMobimap;
@end
