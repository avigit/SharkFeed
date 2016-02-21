//
//  Photo.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/16/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString      *_id;
@property (nonatomic, strong) NSString      *owner;
@property (nonatomic, strong) NSString      *secret;
@property (nonatomic, strong) NSNumber      *server;
@property (nonatomic, assign) NSInteger     farm;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, assign) NSInteger     ispublic;
@property (nonatomic, assign) NSInteger     isfriend;
@property (nonatomic, assign) NSInteger     isfamily;
@property (nonatomic, strong) NSString      *url_t;
@property (nonatomic, assign) NSInteger     height_t;
@property (nonatomic, assign) NSInteger     width_t;
@property (nonatomic, strong) UIImage       *thumbnailImage;
@property (nonatomic, strong) NSString      *url_c;
@property (nonatomic, assign) NSInteger     height_c;
@property (nonatomic, assign) NSInteger     width_c;
@property (nonatomic, strong) UIImage       *mediumImage;
@property (nonatomic, strong) NSString      *url_l;
@property (nonatomic, assign) NSInteger     height_l;
@property (nonatomic, assign) NSInteger     width_l;
@property (nonatomic, strong) UIImage       *largeImage;
@property (nonatomic, strong) NSString      *url_o;
@property (nonatomic, assign) NSInteger     height_o;
@property (nonatomic, assign) NSInteger     width_o;
@property (nonatomic, strong) UIImage       *originalImage;

@end
