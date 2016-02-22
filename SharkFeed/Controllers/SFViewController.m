//
//  SFViewController.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/21/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "SFViewController.h"
#import "Reachability.h"

@interface SFViewController ()

@end

@implementation SFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)networkStatusChanged:(NSNotification*)notification
{
    // subclasses must implement this to handle network changes
}

@end
