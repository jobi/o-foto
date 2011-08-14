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
#import "PhotoStreamView.h"

@interface PhotoPlaygroundViewController()

@end

@implementation PhotoPlaygroundViewController

@synthesize photoStreamView;
@synthesize photoStream;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setPhotoStreamView:nil];
    [super viewDidUnload];
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

- (void)setPhotoStream:(PhotoStream *)aPhotoStream
{
    [aPhotoStream retain];
    [photoStream release];
    photoStream = aPhotoStream;
    
    self.photoStreamView.photoStream = photoStream;
}

- (void)dealloc
{    
    [photoStreamView release];
    [super dealloc];
}

@end
