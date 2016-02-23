//
//  UIImage+Extended.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/21/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extended)

/**
 *  It resizes the image passed in the image parameter
 *
 *  @param image an UIImage
 *  @param size  size to be 
 *
 *  @return an image
 */
+ (UIImage*)resizeImage:(UIImage*)image size:(CGSize)size;

@end
