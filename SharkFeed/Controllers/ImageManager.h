//
//  ImageManager.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/18/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject

+ (instancetype)sharedManager;

/**
 *  This method checks image cache if there is any image already available for the url
 *
 *  @param url this is image url
 *
 *  @return return an image if there is any
 */
- (UIImage*)imageWithUrl:(NSString *)url;

/**
 *  This method download an image from the specified url and cache it
 *
 *  @param url        this is a url in string format
 *  @param completion this one returns and image object if there is any
 */
- (void)imageWithUrl:(NSString *)url completion:(void (^)(UIImage *image))completion;

/**
 *  This method download an image from the url and save it in iPhone's photos. If there is an image but it could not save the image in photos then it shows an alert.
 *
 *  @param url        this is a url in string format
 *  @param completion it calls the completion block if there is no image
 */
- (void)saveImageToPhotosWithUrl:(NSString*)url completion:(void (^)(BOOL success))completion;

@end
