//
//  FlickrAuthViewController.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFFlickrAPIContext;

@interface FlickrAuthViewController : UIViewController

@property (nonatomic, copy) NSURL *authURL;

- (IBAction)authWithFlickr:(id)sender;

@end
