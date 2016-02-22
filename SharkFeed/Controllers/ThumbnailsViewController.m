//
//  ViewController.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/16/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "ThumbnailsViewController.h"
#import "ConnectionManager.h"
#import "Result.h"
#import "Photo.h"
#import "FeedThumbnailCell.h"
#import "ImageManager.h"
#import "RefreshControlView.h"
#import "LightboxViewController.h"

@interface ThumbnailsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray            *searchResult;
@property (nonatomic, strong) NSMutableDictionary       *inProgress;
@property (nonatomic, strong) Result                    *result;
@property (nonatomic, strong) RefreshControlView        *refreshControlView;
@property (nonatomic, strong) NSLayoutConstraint        *refreshControlViewHeight;
@property (nonatomic, strong) NSLayoutConstraint        *refreshControlViewTop;
@property (nonatomic, assign) BOOL                      pageLoading;

@end

@implementation ThumbnailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register collection view cell
    [_collectionView registerNib:[UINib nibWithNibName:@"FeedThumbnailCell" bundle:nil] forCellWithReuseIdentifier:@"FeedThumbnailCellId"];
    
    // Change navigation color
    CGSize size = self.navigationController.navigationBar.bounds.size;
    size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    UIImage *barImage = [UIImage resizeImage:[UIImage imageNamed:@"Background"] size:size];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:barImage];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIImage *logo = [UIImage imageNamed:@"SharkFeed_logosmall"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    
    // add custom view to refresh control
    self.refreshControlView = [[[NSBundle mainBundle] loadNibNamed:@"RefreshControlView" owner:self options:nil] objectAtIndex:0];
    
    [self.collectionView addSubview:self.refreshControlView];
    [self.refreshControlView addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControlView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.refreshControlViewTop = [NSLayoutConstraint constraintWithItem:self.refreshControlView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.collectionView
                                                              attribute:NSLayoutAttributeTopMargin
                                                             multiplier:1.0
                                                               constant:0.0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.refreshControlView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.collectionView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:0.0];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.refreshControlView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.collectionView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0];
    self.refreshControlViewHeight = [NSLayoutConstraint constraintWithItem:self.refreshControlView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:0.0];
    
    [self.collectionView addConstraints:@[self.refreshControlViewTop, left, width, self.refreshControlViewHeight]];
    [self.collectionView layoutIfNeeded];
    
    self.searchResult = [[NSMutableArray alloc] init];
    [self loadImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)startRefresh:(id)sender
{
    self.result = nil;
    [self loadImages];
}

- (void)loadImages
{
    // We load next page after scrolle view scroll to a threshold value or more. After we start loading page, a user may still scroll and the y value of content offset will still be equal or more than the threshold. Therefore we load one page at a time to prevent multiple unnccessary page load.
    if (self.pageLoading) {
        return;
    }
    
    self.pageLoading = YES;
    
    NSInteger page = (self.result && self.result.page < self.result.pages) ? ++self.result.page : 1;
    DLog(@"Loading page: %ld", (long)page);
    NSString *endpoint = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=949e98778755d1982f537d56236bbb42&tags=shark&format=json&nojsoncallback=1&page=%ld&extras=url_t,url_c,url_l,url_o", (long)page];
    
    // Show activity if the page is empty
    if (self.searchResult.count == 0) {
        [self.activityIndicator startAnimating];
    }
    
    [ConnectionManager dataWithEndpoint:endpoint completion:^(NSDictionary *response, NSError *error) {
        
        if (!self.result) {
            self.searchResult = [NSMutableArray new];
        }
        self.result = [[Result alloc] initWithJSONDictionary:response[@"photos"]];
        [self.searchResult addObjectsFromArray:self.result.photo];
        
        // update UI
        [self.activityIndicator stopAnimating];
        [self.collectionView reloadData];
        
        // if pulled to refresh end refreshing
        if (self.refreshControlView.isRefreshing) {
            [self.refreshControlView endRefreshing];
        }
        self.pageLoading = NO;
        
        
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.searchResult) ? self.searchResult.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedThumbnailCellId" forIndexPath:indexPath];
    Photo *photo = self.searchResult[indexPath.row];
    if (photo.thumbnailImage) {
        cell.thumbnail.image = photo.thumbnailImage;
    } else {
        [self startDownloadImage:photo forIndexPath:indexPath];        
        cell.thumbnail.image = nil;
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"LightBoxSegue" sender:indexPath];
    return YES;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    screenSize.width = (screenSize.width - 20 - 4) / 3;
    return CGSizeMake(floor(screenSize.width), floor(screenSize.width));
}

- (void)loadOnScreenCellImages
{
    if (self.searchResult.count > 0)
    {
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Photo *photo = self.searchResult[indexPath.row];
            
            if (!photo.thumbnailImage)
            {
                [self startDownloadImage:photo forIndexPath:indexPath];
            }
        }
    }
}

- (void)startDownloadImage:(Photo*)photo forIndexPath:(NSIndexPath*)indexPath
{
    if (_inProgress[indexPath] == nil) {
        [[ImageManager sharedManager] imageWithUrl:photo.url_t completion:^(UIImage *image) {
            FeedThumbnailCell *cell = (FeedThumbnailCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.thumbnail.image = image;
            [_inProgress removeObjectForKey:indexPath];
        }];
        [_inProgress setObject:photo forKey:indexPath];
    } else {
        DLog(@"In Progress %@", photo.url_t);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadOnScreenCellImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadOnScreenCellImages];
}

- (BOOL)isVisibleIndexPath:(NSIndexPath *)indexPath
{
    NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
    
    return [visiblePaths containsObject:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y / scrollView.contentSize.height > 0.70) {
        // load next page
        [self loadImages];
    }
    
//    CGFloat top = self.topLayoutGuide.length;
    
    if (scrollView.contentOffset.y < -64.0 && !self.refreshControlView.isRefreshing) {
        self.refreshControlViewTop.constant = 64 - fabsf((float)scrollView.contentOffset.y);
        self.refreshControlViewHeight.constant = fabsf((float)scrollView.contentOffset.y) - 64.0;
        [self.collectionView layoutIfNeeded];
    }
    
    if (scrollView.contentInset.top > 64.0 && !self.refreshControlView.isRefreshing) {
        DLog(@"");
        self.refreshControlViewTop.constant = 0.0;
        self.refreshControlViewHeight.constant = 0.0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.collectionView layoutIfNeeded];
            self.collectionView.contentInset = UIEdgeInsetsMake(64, self.collectionView.contentInset.left, self.collectionView.contentInset.bottom, self.collectionView.contentInset.right);
        } completion:nil];
        
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LightBoxSegue"]) {
        LightboxViewController *viewController = (LightboxViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        viewController.photo = self.searchResult[indexPath.row];
    }
}

@end
