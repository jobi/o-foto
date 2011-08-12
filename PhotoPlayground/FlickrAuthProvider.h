//
//  FlickrAuthProvider.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"

typedef enum {
    FlickrAuthStateNeedsFrob,
    FlickrAuthStateTokenQueried,
    FlickrAuthStateAuthenticated
} FlickrAuthState;

@protocol FlickrAuthProviderDelegate <NSObject>

- (void)authStateChanged:(FlickrAuthState)authState;

@end

@interface FlickrAuthProvider : NSObject <OFFlickrAPIRequestDelegate> {
    @private
    OFFlickrAPIContext *context;
    NSUserDefaults *defaults;
}

- (id)initWithContext:(OFFlickrAPIContext *)context;
- (void)useFrob:(NSString *)frob;

@property (nonatomic, assign) NSObject<FlickrAuthProviderDelegate> *delegate;
@property (nonatomic, readonly) FlickrAuthState authState;
@property (nonatomic, copy, readonly) NSString *token;

@end
