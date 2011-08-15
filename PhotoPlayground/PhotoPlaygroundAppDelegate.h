//
//  PhotoPlaygroundAppDelegate.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrAuthProvider.h"

@class PhotoPlaygroundViewController;
@class OFFlickrAPIContext;
@class PhotoStream;

@interface PhotoPlaygroundAppDelegate : NSObject <UIApplicationDelegate, FlickrAuthProviderDelegate, OFFlickrAPIRequestDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PhotoPlaygroundViewController *viewController;
@property (nonatomic, retain) FlickrAuthProvider *authProvider;
@property (nonatomic, retain) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) PhotoStream *photoStream;

@end
