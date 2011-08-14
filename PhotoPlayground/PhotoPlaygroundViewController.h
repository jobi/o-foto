//
//  PhotoPlaygroundViewController.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PhotoStream.h"

@class OFFlickrAPIContext;
@class PhotoStreamView;

@interface PhotoPlaygroundViewController : UIViewController {
    @private
    OFFlickrAPIContext *flickrAPIContext;
    PhotoStreamView *photoStreamView;
}

- (void)showAuthenticationViewWithURL:(NSURL *)authURL;

@property (nonatomic, retain) IBOutlet PhotoStreamView *photoStreamView;
@property (nonatomic, retain) PhotoStream *photoStream;

@end
