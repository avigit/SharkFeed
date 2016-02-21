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
- (void)imageWithUrl:(NSString *)url completion:(void (^)(UIImage *image))completion;
- (UIImage*)imageWithUrl:(NSString *)url;

@end
