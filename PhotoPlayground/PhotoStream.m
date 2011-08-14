//
//  PhotoStream.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoStream.h"
#import "Photo.h"

@interface PhotoStream()

@property (nonatomic, retain, readwrite) NSArray *photos;

- (void)loadPage:(NSUInteger)page;

@end

@implementation PhotoStream

@synthesize flickrContext;
@synthesize delegate;
@synthesize photos;

- (id)initWithFlickrContext:(OFFlickrAPIContext *)aFlickrContext
{
    self = [super init];
    if (self) {
        self.flickrContext = aFlickrContext;
        self.photos = [NSArray array];
        
        [self loadPage:0];
    }
    
    return self;
}

- (void)loadPage:(NSUInteger)page
{
    OFFlickrAPIRequest *pageRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    
    pageRequest.delegate = self;
    [pageRequest callAPIMethodWithGET:@"flickr.photos.search"
                            arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"me", @"user_id",
                                       @"date_taken", @"extras", 
                                       [NSString stringWithFormat:@"%i", page], @"page",
                                       nil]];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{    
    NSArray *photoDicts = [inResponseDictionary valueForKeyPath:@"photos.photo"];
    NSMutableArray *mutablePhotos = [NSMutableArray arrayWithArray:self.photos];
    
    for (NSDictionary *photoDict in photoDicts) {
        [mutablePhotos addObject:[Photo photoWithContext:flickrContext
                                              dictionary:photoDict]];
    }
    
    [mutablePhotos sortUsingSelector:@selector(compareByDateTaken:)];
    
    self.photos = mutablePhotos;
    
    NSInteger page = [[inResponseDictionary valueForKeyPath:@"photos.page"] integerValue];
    NSInteger nPages = [[inResponseDictionary valueForKeyPath:@"photos.pages"] integerValue];
    
    if (page < nPages) {
        [self loadPage:page + 1];
    } else {
        [delegate photoStreamChanged:self];
    }
}


- (void)dealloc
{
    [photos release];
    [flickrContext release];
    
    [super dealloc];
}

@end
