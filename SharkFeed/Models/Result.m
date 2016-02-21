//
//  Result.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/16/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "Result.h"

@implementation Result

- (instancetype)init
{
    if (self = [super init]) {
        [self setValue:@"Photo" forKeyPath:@"propertyArrayMap.photo"];
    }
    
    return self;
}

@end
