//
//  RefreshControlView.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/19/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "RefreshControlView.h"

#define MAX_CENTERVIEW_HEIGHT               106.0
#define MAX_PULL_TO_REFRESH_1_HEIGHT        31.0
#define MAX_PULL_TO_REFRESH_2_HEIGHT        44.0
#define MIN_PULL_TO_REFRESH_HEIGHT          5.0

@interface RefreshControlView()

@property (nonatomic, strong) IBOutlet UIView *centerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerViewHeight;
@property (strong, nonatomic) IBOutlet UIImageView *pullToRefresh1;
@property (strong, nonatomic) IBOutlet UIImageView *pullToRefresh2;
@property (weak, nonatomic) UICollectionView *superCV;

@property (nonatomic, assign) BOOL isRefreshing;


@end

@implementation RefreshControlView


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.centerViewHeight.constant = (self.frame.size.height > MAX_CENTERVIEW_HEIGHT) ? MAX_CENTERVIEW_HEIGHT : self.frame.size.height;
    [self beginRefreshingIfPossible];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    DLog(@"Frame changed: {%f,%f}", frame.size.width, frame.size.height);
    self.centerViewHeight.constant = (frame.size.height > MAX_CENTERVIEW_HEIGHT) ? MAX_CENTERVIEW_HEIGHT : frame.size.height;
}

- (UICollectionView*)superCV
{
    UIView *view = self.superview;
    while (view != nil) {
        if (view.class != [UICollectionView class] || [view.class isSubclassOfClass:[UICollectionView class]]) {
            return (UICollectionView*)view;
            break;
        }
        view = view.superview;
    }
    
    return nil;
}

- (void)beginRefreshingIfPossible
{
    if (!self.isRefreshing && self.frame.size.height > MAX_CENTERVIEW_HEIGHT + 10.0) {
        // lock view for refreshing
        self.isRefreshing = YES;
        
        if (self.superCV) {
            self.superCV.contentInset = UIEdgeInsetsMake(MAX_CENTERVIEW_HEIGHT + 10.0 + 64.0, self.superCV.contentInset.left, self.superCV.contentInset.bottom, self.superCV.contentInset.right);
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)endRefreshing
{
    self.isRefreshing = NO;
    if (self.superCV) {
        self.superCV.contentInset = UIEdgeInsetsMake(self.superCV.contentInset.top - 1, self.superCV.contentInset.left, self.superCV.contentInset.bottom, self.superCV.contentInset.right);
    }
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.isRefreshing) {
        [super sendAction:action to:target forEvent:event];
    }
}

@end
