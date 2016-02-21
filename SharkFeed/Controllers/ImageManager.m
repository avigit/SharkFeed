//
//  ImageManager.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/18/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "ImageManager.h"

#define kImageCacheKey         @"ImageCache"

@interface ImageManager()

@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *inprogess;

@end

@implementation ImageManager

- (instancetype)init
{
    if (self = [super init]) {
        [self initializeImageCache];
        _inprogess = [[NSMutableDictionary alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

#pragma mark - Class Methods

+ (instancetype)sharedManager {
    static ImageManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
    });
    return sharedManager;
}


+ (instancetype)allocWithZone:(NSZone *)zone {
    return [self sharedManager];
}

#pragma mark - Instance Methods

- (void)willEnterForeground
{
    [self initializeImageCache];
}

- (void)didEnterBackground
{
    [self saveImageCache];
}

- (void)didReceiveMemoryWarning
{
    
}

- (UIImage*)imageWithUrl:(NSString *)url
{
    return [UIImage imageWithData:[self.imageCache objectForKey:url]];
}

- (void)imageWithUrl:(NSString *)url completion:(void (^)(UIImage *image))completion
{
    // check for invalid url
    if (url == nil || [url isEqualToString:@""]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (completion) {
                completion(nil);
            }
        }];
        return;
    }
    NSOperation *download = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage *image = [self imageWithUrl:url];
        
        if (image != nil) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (completion) {
                    [self.inprogess removeObjectForKey:url];
                    completion(image);
                }
            }];
        } else {
            DLog(@"Downloading Image...");
            NSURL *imageUrl = [NSURL URLWithString:url];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *image = [UIImage imageWithData:data];
            
            if (image != nil) {
                [self.imageCache setObject:data forKey:url];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (completion) {
                    [self.inprogess removeObjectForKey:url];
                    completion(image);
                }
            }];
        }
    }];
    
    NSOperation *operation = [_inprogess objectForKey:url];
    
    if (operation != nil) {
        [download addDependency:operation];
    }
    
    [self.inprogess setObject:download forKey:url];
    [self.queue addOperation:download];
}

- (void)saveImageCache
{
    [[NSUserDefaults standardUserDefaults] setObject:_imageCache forKey:kImageCacheKey];
}

- (void)initializeImageCache
{
    
    if (self.imageCache == nil) {
        NSDictionary *images = [[NSUserDefaults standardUserDefaults] objectForKey:kImageCacheKey];
        self.imageCache = [NSMutableDictionary dictionaryWithDictionary:images];
        if (self.imageCache == nil) {
            self.imageCache = [[NSMutableDictionary alloc] init];
        }
    }
}

@end
