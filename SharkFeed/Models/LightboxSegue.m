//
//  LightboxSegue.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/22/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "LightboxSegue.h"

@implementation LightboxSegue

- (void)perform
{
    UIView *sourceView = self.sourceViewController.view;
    UIView *destinationView = self.destinationViewController.view;
    destinationView.alpha = 0.0;
    destinationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:destinationView aboveSubview:sourceView];
    
    [UIView animateWithDuration:0.25 animations:^{
//        sourceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        destinationView.alpha = 1.0;
        destinationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    } completion:^(BOOL finished) {
        [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
    }];
}

@end
