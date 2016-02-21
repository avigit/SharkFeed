//
//  Photo.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/16/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "Photo.h"
#import "ImageManager.h"

@implementation Photo

- (UIImage *)thumbnailImage
{
    return [[ImageManager sharedManager] imageWithUrl:self.url_t];
}

- (UIImage *)mediumImage
{
    return [[ImageManager sharedManager] imageWithUrl:self.url_c];
}

- (UIImage *)largeImage
{
    return [[ImageManager sharedManager] imageWithUrl:self.url_l];
}

- (UIImage *)originalImage
{
    return [[ImageManager sharedManager] imageWithUrl:self.url_o];
}

@end
