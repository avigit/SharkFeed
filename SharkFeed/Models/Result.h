//
//  Result.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/16/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger perpage;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray *photo;
@property (nonatomic, strong) NSString *stat;

@end
