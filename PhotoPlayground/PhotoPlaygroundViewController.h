//
//  PhotoPlaygroundViewController.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OFFlickrAPIContext;

@interface PhotoPlaygroundViewController : UIViewController {
    @private
    OFFlickrAPIContext *flickrAPIContext;
}

- (void)showAuthenticationViewWithURL:(NSURL *)authURL;

@end
