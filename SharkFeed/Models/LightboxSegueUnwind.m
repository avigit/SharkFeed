//
//  LightboxSegueUnwind.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/22/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "LightboxSegueUnwind.h"

@implementation LightboxSegueUnwind

- (void)perform
{
    UIView *sourceView = self.sourceViewController.view;
    UIView *destinationView = self.destinationViewController.view;
//    destinationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:destinationView aboveSubview:sourceView];
    
    [UIView animateWithDuration:0.25 animations:^{
//        destinationView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
        sourceView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        sourceView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.sourceViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
