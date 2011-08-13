//
//  PhotoPlaygroundViewController.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PhotoView.h"

@class OFFlickrAPIContext;

@interface PhotoPlaygroundViewController : UIViewController <PhotoViewDelegate> {
    @private
    OFFlickrAPIContext *flickrAPIContext;
}

- (void)showAuthenticationViewWithURL:(NSURL *)authURL;
- (void)addPhoto:(Photo *)photo;

@end
