//
//  FlickrAuthViewController.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlickrAuthViewController.h"
#import "ObjectiveFlickr.h"

@implementation FlickrAuthViewController

@synthesize authURL;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)authWithFlickr:(id)sender
{
    [[UIApplication sharedApplication] openURL:authURL];
}

- (void) dealloc
{
    [authURL release];
    
    [super dealloc];
}
@end
