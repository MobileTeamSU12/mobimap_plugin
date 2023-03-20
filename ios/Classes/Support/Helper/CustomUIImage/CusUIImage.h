//
//  CusUIImage.h
//  CameraApp
//
//  Created by Dang Thi Tu Uyen on 5/26/17.
//  Copyright © 2017 Dang Thi Tu Uyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusUIImage : UIImage
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point;

@end
