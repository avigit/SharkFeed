//
//  SFPhotoInfo.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/21/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "SFPhotoInfo.h"

@implementation SFPhotoInfo

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super initWithJSONDictionary:dict]) {
        _title = ((NSDictionary*)dict[@"title"])[@"_content"];
        _desc = ((NSDictionary*)dict[@"description"])[@"_content"];
    }
    
    return self;
}

@end
