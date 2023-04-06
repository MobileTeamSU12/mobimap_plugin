//
//  CusUIImage.m
//  CameraApp
//
//  Created by Dang Thi Tu Uyen on 5/26/17.
//  Copyright © 2017 Dang Thi Tu Uyen. All rights reserved.
//

#import "CusUIImagePlugin.h"

@implementation CusUIImagePlugin

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point{
    UIFont *font = [UIFont boldSystemFontOfSize:image.size.height / image.size.width *32];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [[UIColor whiteColor] set];
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, [attString length]);
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(1.0f, 1.5f);
    [attString addAttribute:NSShadowAttributeName value:shadow range:range];
    CGRect rect = CGRectMake(point.x - 10, (point.y - attString.size.height -5 ), image.size.width, image.size.height);
    [attString drawInRect:CGRectIntegral(rect)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
