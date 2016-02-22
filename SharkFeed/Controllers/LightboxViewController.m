//
//  LightboxViewController.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/20/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import "LightboxViewController.h"
#import "ImageManager.h"
#import "ConnectionManager.h"

@interface LightboxViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *originalImageView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation LightboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setInfoLabelText];
    
    if (self.photo.originalImage) {
        self.originalImageView.image = self.photo.originalImage;
    } else {
        self.originalImageView.image = self.photo.thumbnailImage;
        
        [[ImageManager sharedManager] imageWithUrl:[self endpointForHighQualityPhoto] completion:^(UIImage *image) {
            if (image) {
                self.originalImageView.image = image;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setInfoLabelText
{
    self.infoLabel.text = @"";
    NSString *endpoint = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=949e98778755d1982f537d56236bbb42&photo_id=%@&format=json&nojsoncallback=1", self.photo._id];
    [ConnectionManager dataWithEndpoint:endpoint completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            // Log it or send a telemetry. We dont want to show user any error here
        } else {
            NSDictionary *photoDict = response[@"photo"];
            self.infoLabel.text = ((NSDictionary*)photoDict[@"description"])[@"_content"];
        }
    }];
    
}

- (NSString*)endpointForHighQualityPhoto
{
    NSString *endpoint = nil;
    if (self.photo.url_o) {
        endpoint = self.photo.url_o;
    } else if (self.photo.url_l) {
        endpoint = self.photo.url_l;
    } else if (self.photo.url_c) {
        endpoint = self.photo.url_c;
    } else {
        endpoint = self.photo.url_t;
    }
    
    return endpoint;
}

- (IBAction)download:(id)sender
{
    [[ImageManager sharedManager] saveImageToPhotosWithUrl:[self endpointForHighQualityPhoto] completion:^(BOOL success) {
        if (!success) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!!" message:@"Couldn't save the photo" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)openInApp:(id)sender
{
    NSString *endpoint = [NSString stringWithFormat:@"flickr://photos/%@/%@", self.photo.owner, self.photo._id];
    NSURL *myURL = [NSURL URLWithString:endpoint];
    [[UIApplication sharedApplication] openURL:myURL];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end