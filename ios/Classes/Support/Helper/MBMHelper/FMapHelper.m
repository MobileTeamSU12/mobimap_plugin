//
//  FMapHelper.m
//  MobiMap
//
//  Created by ThanhTC on 04/23/20.
//  Copyright © 2020 RAD. All rights reserved.
//

#import "FMapHelper.h"
#import <AVFoundation/AVFoundation.h>
#import "CusUIImage.h"
#import "GoogleMaps/GoogleMaps.h"
#import <Photos/Photos.h>
#import <Reachability/ReachabilitySwift-umbrella.h>
@implementation FMapHelper

#pragma mark - imagePickerController

+ (void)createAlbum {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
             //Checks for App Photo Album and creates it if it doesn't exist
             PHFetchOptions *fetchOptions = [PHFetchOptions new];
             fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title == %@", @"Hình Ảnh MoBiMap"];
             PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
             if (fetchResult.count == 0){
                 //Create Album
                 PHAssetCollectionChangeRequest *albumRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Hình Ảnh MoBiMap"];
                 PHAssetChangeRequest *createImageRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"AppIcon"]];
                 [albumRequest addAssets:@[createImageRequest.placeholderForCreatedAsset]];
             }
         } completionHandler:^(BOOL success, NSError *error) {
             NSLog(@"Log here...");
             if (!success) {
                 NSLog(@"Error creating album: %@", error);
             }else{
                 NSLog(@"Perfecto");
             }
         }];
}

+ (void)createFolder {
    BOOL isDirectory;
    NSString *docDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *yoyoDir = [docDir stringByAppendingPathComponent:@"ImageMobiMap"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:yoyoDir isDirectory:&isDirectory] || !isDirectory) {
        NSError *error = nil;
        NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                         forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] createDirectoryAtPath:yoyoDir
                                  withIntermediateDirectories:YES
                                                   attributes:attr
                                                        error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
}

+ (UIImage*) resizedImageWithDrawText:(NSArray *)drawText didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSString *fullPhotoFilename = @"";
    for (NSString *text in drawText) {
        if (fullPhotoFilename.length == 0) {
            fullPhotoFilename = text;
        } else {
            fullPhotoFilename = [fullPhotoFilename stringByAppendingString:[NSString stringWithFormat:@"\n%@",text]];
        }
    }
    NSString *stringId = drawText.count > 0 ? drawText[0] : @"";
    NSString *stringLocation = drawText.count > 0 ? drawText[1] : @"";
    UIImage *resizedImage =[CusUIImage imageWithImage:chosenImage scaledToSize:CGSizeMake(chosenImage.size.width / 2, chosenImage.size.height / 2)];
    UIFont *font = [UIFont boldSystemFontOfSize:resizedImage.size.height / resizedImage.size.width * 32];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    double  wString = [[[NSAttributedString alloc] initWithString:stringId attributes:attributes] size].width;
    double  wStringlocation = [[[NSAttributedString alloc] initWithString:stringLocation attributes:attributes] size].width;
    wString = wString <= wStringlocation ? resizedImage.size.width - wStringlocation : resizedImage.size.width - wString;
    UIImage *resizedImageWithText = [CusUIImage drawFront:resizedImage text:fullPhotoFilename atPoint:CGPointMake(wString,resizedImage.size.height)];
    return resizedImageWithText;
}

+ (UIImage*) resizedImageWithText:(NSString*)name location:(NSString*)location didFinishPickingMediaWithInfo:(NSDictionary *)info data:(NSData *)data{
    UIFont *font = [UIFont boldSystemFontOfSize:32];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    double  wString = [[[NSAttributedString alloc] initWithString:name attributes:attributes] size].width;
     double  wStringlocation = [[[NSAttributedString alloc] initWithString:location attributes:attributes] size].width;
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (chosenImage == nil) {
        chosenImage = [UIImage imageWithData:data];
    }
    NSDictionary *chosenImgData = info[UIImagePickerControllerMediaMetadata];
    NSDictionary *chosenImgExif = [chosenImgData objectForKey:@"{Exif}"];
    NSString *chosenImgDateTimeOriginal = [chosenImgExif objectForKey:@"DateTimeOriginal"];
    UIImage *resizedImage = [CusUIImage imageWithImage:chosenImage scaledToSize:CGSizeMake(1024, 1024)];
    wString = wString <= wStringlocation ? resizedImage.size.width - wStringlocation : resizedImage.size.width - wString;
    UIImage *resizedImageWithText = [CusUIImage drawFront:resizedImage text:[NSString stringWithFormat:@"%@\n%@\n%@",name,location,chosenImgDateTimeOriginal] atPoint:CGPointMake(wString-5,900)];
    return resizedImageWithText;
}

+ (UIImage*)resizedImageCASDWithText:(NSString*)name location:(NSString*)location didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *chosenImgData = info[UIImagePickerControllerMediaMetadata];
    NSDictionary *chosenImgExif = [chosenImgData objectForKey:@"{Exif}"];
    NSString *chosenImgDateTimeOriginal = [chosenImgExif objectForKey:@"DateTimeOriginal"] ;
    NSString *fullPhotoFilename = [NSString stringWithFormat:@"%@\n%@\n%@",name,location,chosenImgDateTimeOriginal];
    UIImage *resizedImage =[CusUIImage imageWithImage:chosenImage scaledToSize:CGSizeMake(720, 1080)];
    UIFont *font = [UIFont boldSystemFontOfSize:resizedImage.size.height / resizedImage.size.width * 16];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    double  wString = [[[NSAttributedString alloc] initWithString:name attributes:attributes] size].width;
    double  wStringlocation = [[[NSAttributedString alloc] initWithString:location attributes:attributes] size].width;
    wString = wString <= wStringlocation ? resizedImage.size.width - wStringlocation : resizedImage.size.width - wString;
    UIImage *resizedImageWithText = [CusUIImage drawFront:resizedImage text:fullPhotoFilename atPoint:CGPointMake(wString,resizedImage.size.height)];
    return resizedImageWithText;
}

#pragma mark - ShowImagePicker

+ (void) showImagePickerCamera:(nullable id /*<UIViewController>*/) parentVCtrl delegate: (nonnull id /*<UIImagePickerControllerDelegate>*/)delegate isEdit:(BOOL)isEdit{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)delegate;
    picker.allowsEditing = isEdit;
    NSString *mediaType = AVMediaTypeVideo;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        // do your logic
    } else if(authStatus == AVAuthorizationStatusDenied){
        [FMapHelper checkCameraSeesion];
        return;
    } else if(authStatus == AVAuthorizationStatusRestricted){
        // restricted, normally won't happen
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
            } else {
            }
        }];
    } else {
        // impossible, unknown authorization status
    }
    if (parentVCtrl == nil){
        [FMapHelper addSubVCtrl:picker];
        return;
    }
    [parentVCtrl presentViewController:picker animated:YES completion:NULL];
}

+ (void) showImagePickerLibrary:(nullable id /*<UIViewController>*/) parentVCtrl delegate: (nonnull id /*<UIImagePickerControllerDelegate>*/)delegate isEdit:(BOOL)isEdit{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)delegate;
    picker.allowsEditing = isEdit;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (parentVCtrl == nil){
        [FMapHelper addSubVCtrl:picker];
        return;
    }
    [parentVCtrl presentViewController:picker animated:YES completion:NULL];
}

+ (UIViewController*) addSubVCtrl:(nonnull id /*<UIViewController>*/) subVCtrl{
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController) {
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    if (![topRootViewController isKindOfClass:[UIAlertController class]]) {
        [topRootViewController presentViewController:subVCtrl animated:YES completion:nil];
    }
    return topRootViewController;
}

+(void)checkGPSMobiMap {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Dịch vụ định vị đã tắt!"
                                          message:@"Vui lòng bật dịch vụ định vị trong cài đặt để tiếp tục sử dụng dịch vụ !"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Đi tới cài đặt" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    if ([CLLocationManager authorizationStatus] == AVAuthorizationStatusDenied) {
        topRootViewController = [FMapHelper addSubVCtrl:alertController];
    }
}

+(void)checkInternetMobimap {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Thông Báo"
                                          message:@"Có lỗi xảy ra.\nVui lòng kiểm tra kết nối mạng và thử lại!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
        }
    }]];
    topRootViewController = [FMapHelper addSubVCtrl:alertController];
}

+ (void)checkCameraSeesion {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Dịch vụ Camera đã tắt !"
                                          message:@"Vui lòng bật dịch vụ Camera trong cài đặt để tiếp tục sử dụng dịch vụ !"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Đi tới cài đặt" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus== AVAuthorizationStatusDenied) {
       topRootViewController = [FMapHelper addSubVCtrl:alertController];
    } else {
        [topRootViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

+ (void)checkLibraryCamera {
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
       UIAlertController *alertController = [UIAlertController
                                             alertControllerWithTitle:@"Dịch vụ Library đã tắt !"
                                             message:@"Vui lòng bật dịch vụ Library trong cài đặt để tiếp tục sử dụng dịch vụ !"
                                             preferredStyle:UIAlertControllerStyleAlert];
       [alertController addAction:[UIAlertAction actionWithTitle:@"Đi tới cài đặt" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
           [[UIApplication sharedApplication] openURL:url];
       }]];
       PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
       if (status == AVAuthorizationStatusDenied) {
        topRootViewController = [FMapHelper addSubVCtrl:alertController];
       } else {
           [topRootViewController dismissViewControllerAnimated:NO completion:nil];
       }
}

+ (void)saveImageWithFileName:(NSString *)file_name image:(UIImage *)image completion:(void (^)(BOOL finished))completion{
    NSData *data = UIImageJPEGRepresentation(image, 0.75);
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        options.originalFilename = [NSString stringWithFormat:@"%@.JPG",file_name];
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"success");
            completion(YES);
        } else {
            UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Thông báo"
                                                  message:[NSString stringWithFormat:@"%@",error]
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                completion(NO);
            }]];
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if (authStatus== AVAuthorizationStatusDenied) {
               topRootViewController = [FMapHelper addSubVCtrl:alertController];
            } else {
                [topRootViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
    }];
}
@end
