//
//  RefreshControlView.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/19/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshControlView : UIControl

@property (nonatomic, assign, readonly) BOOL isRefreshing;

- (void)endRefreshing;

@end
