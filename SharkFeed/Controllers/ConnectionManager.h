//
//  ConnectionManager.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/17/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionManager : NSObject

+ (void)dataWithEndpoint:(NSString*)endpoint completion:(void(^)(NSDictionary *response, NSError *error))completion;

@end
