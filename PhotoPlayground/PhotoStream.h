//
//  PhotoStream.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"

@class PhotoStream;

@protocol PhotoStreamDelegate <NSObject>

- (void)photoStreamChanged:(PhotoStream *)photoStream;

@end

@interface PhotoStream : NSObject <OFFlickrAPIRequestDelegate>

@property (nonatomic, retain) OFFlickrAPIContext *flickrContext;
@property (nonatomic, assign) id<PhotoStreamDelegate> delegate;
@property (nonatomic, retain, readonly) NSArray *photos;

- initWithFlickrContext:(OFFlickrAPIContext *)flickrContext;

@end
