//
//  Photo.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "ObjectiveFlickr.h"

@interface Photo()

- (id)initWithContext:(OFFlickrAPIContext *)context dictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSURL *mediumSizeURL;
@property (nonatomic, retain) NSURLConnection *dataConnection;
@property (nonatomic, retain) NSMutableData *dataReceived;

@end

@implementation Photo

@synthesize title;
@synthesize context;
@synthesize delegate;
@synthesize mediumSizeURL;
@synthesize dataConnection;
@synthesize dataReceived;

+ (Photo *)photoWithContext:(OFFlickrAPIContext *)context dictionary:(NSDictionary *)dictionary;
{
    Photo *photo = [[Photo alloc] initWithContext:context dictionary:dictionary];
    return [photo autorelease];
}

- (id)initWithContext:(OFFlickrAPIContext *)aContext dictionary:(NSDictionary *)dictionary
{    
    if ((self = [super init])) {
        context = [aContext retain];
        title = [[dictionary valueForKeyPath:@"title"] copy];
        mediumSizeURL = [context photoSourceURLFromDictionary:dictionary
                                                         size:OFFlickrMediumSize];
    }
    
    return self;
}

- (void)loadData
{
    NSURLRequest *request=[NSURLRequest requestWithURL:mediumSizeURL
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self];
    self.dataConnection = connection;
    [connection release];
    
    self.dataReceived = [NSMutableData data];    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataReceived appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.dataConnection release];
    [self.delegate photo:self dataLoaded:self.dataReceived];
    self.dataReceived = nil;
}

- (void)dealloc
{
    [title release];
    [context release];
    [mediumSizeURL release];
    [dataConnection release];
    [dataReceived release];
    
    [super dealloc];
}

@end
