//
//  PhotoPlaygroundAppDelegate.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPlaygroundViewController;

@interface PhotoPlaygroundAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PhotoPlaygroundViewController *viewController;

@end
