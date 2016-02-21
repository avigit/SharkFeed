//
//  ConnectionManager.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/17/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager

+ (void)dataWithEndpoint:(NSString*)endpoint completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:endpoint];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(responseDict, error);
        }];
    }];
    
    [task resume];
}

@end
