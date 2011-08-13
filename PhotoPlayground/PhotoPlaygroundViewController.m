//
//  PhotoPlaygroundViewController.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoPlaygroundViewController.h"
#import "ObjectiveFlickr.h"
#import "FlickrAuthViewController.h"

@interface PhotoPlaygroundViewController()

@property (nonatomic, retain) NSMutableArray *photoViews;

@end

@implementation PhotoPlaygroundViewController

@synthesize photoViews;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    photoViews = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.photoViews = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)showAuthenticationViewWithURL:(NSURL *)authURL
{
    FlickrAuthViewController *authViewController =
        [[FlickrAuthViewController alloc]initWithNibName:@"FlickrAuthViewController" 
                                                  bundle:[NSBundle mainBundle]];
    
    authViewController.authURL = authURL;
    
    [self presentModalViewController:authViewController animated:YES];
    [authViewController release];
}

- (void)photoView:(PhotoView *)photoView imageLoaded:(UIImage *)image
{
    photoView.layer.position = CGPointMake(self.view.frame.size.width * rand()/RAND_MAX,
                                           self.view.frame.size.height * rand()/RAND_MAX);
    photoView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.view addSubview:photoView];
    
    [photoView setAlpha:0.0f];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [photoView setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)addPhoto:(Photo *)photo
{
    PhotoView *photoView = [PhotoView photoViewWithPhoto:photo];
    
    photoView.delegate = self;
    
    [photoViews addObject:photoView];
    
    [photoView loadImage];
}

- (void)dealloc
{    
    [super dealloc];
}

@end
