//
//  SFViewController.h
//  SharkFeed
//
//  Created by Avigit Saha on 2/21/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SFViewController : UIViewController

/**
 *  This method gets called when there is a change in network connection
 *
 *  @param status Current network status
 */
- (void)updateViewsForNetworkStatus:(NetworkStatus)status;

@end
