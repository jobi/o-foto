//
//  Photo.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OFFlickrAPIContext;
@class Photo;

@protocol PhotoDelegate <NSObject>

- (void)photo:(Photo *)photo dataLoaded:(NSData *)data;

@end

@interface Photo : NSObject

+ (Photo *)photoWithContext:(OFFlickrAPIContext *)context dictionary:(NSDictionary *)dictionary;

- (void)loadData;
- (void)cancelLoadData;

@property (readonly) NSString *title;
@property (nonatomic, copy, readonly) NSDate *dateTaken;
@property (nonatomic, retain) OFFlickrAPIContext *context;
@property (nonatomic, assign) id<PhotoDelegate> delegate;

@end
