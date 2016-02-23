//
//  ImageManager.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/18/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "ImageManager.h"
#import "AppDelegate.h"

@interface ImageManager()

@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *inprogess;

@end

@implementation ImageManager

- (instancetype)init
{
    if (self = [super init]) {
        _imageCache = [[NSCache alloc] init];
        _inprogess = [[NSMutableDictionary alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
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

#pragma mark - Download images

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
                    completion(image);
                }
                [self.inprogess removeObjectForKey:url];
            }];
        } else {
            // Download Image
            
            NSURL *imageUrl = [NSURL URLWithString:url];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *image = [UIImage imageWithData:data];
            
            if (image != nil) {
                [self.imageCache setObject:data forKey:url];
                [self.inprogess removeObjectForKey:url];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (completion) {
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

- (void)saveImageToPhotosWithUrl:(NSString *)url completion:(void (^)(BOOL))completion
{
    [self imageWithUrl:url completion:^(UIImage *image) {
        if (image) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        } else {
            if (completion) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completion(NO);
                }];
            }
        }
        
    }];
}

#pragma mark - Save image in photos

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!!" message:@"Couldn't save the photo" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

@end
