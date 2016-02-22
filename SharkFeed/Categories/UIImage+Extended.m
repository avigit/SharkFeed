//
//  UIImage+Extended.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/21/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "UIImage+Extended.h"

@implementation UIImage (Extended)

+ (UIImage*)resizeImage:(UIImage*)image size:(CGSize)size
{
    if (!image) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    return img;
}

@end
