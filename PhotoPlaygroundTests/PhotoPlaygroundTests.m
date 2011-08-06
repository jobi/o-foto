//
//  PhotoPlaygroundTests.m
//  PhotoPlaygroundTests
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoPlaygroundTests.h"
#import "ObjectiveFlickr.h"
#import "FlickrApiKey.h"

@implementation PhotoPlaygroundTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testFlickr
{
    OFFlickrAPIContext *context = [[OFFlickrAPIContext alloc] initWithAPIKey:flickrApiKey.key
                                                                sharedSecret:flickrApiKey.secret];
    
    STAssertTrue([context isMemberOfClass:[OFFlickrAPIContext class]],
                 @"Successfully created a flickr API context");
    
    [context release];
}

@end
