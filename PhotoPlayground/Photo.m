//
//  Photo.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "ObjectiveFlickr.h"

static NSDateFormatter *dateFormatter = nil;

@interface Photo()

- (id)initWithContext:(OFFlickrAPIContext *)context dictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSURL *mediumSizeURL;
@property (nonatomic, retain) NSURLConnection *dataConnection;
@property (nonatomic, retain) NSMutableData *dataReceived;

@end

@implementation Photo

@synthesize title;
@synthesize dateTaken;
@synthesize context;
@synthesize delegate;
@synthesize mediumSizeURL;
@synthesize dataConnection;
@synthesize dataReceived;

+ (void)initialize
{
    dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
}

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
        mediumSizeURL = [[context photoSourceURLFromDictionary:dictionary
                                                          size:OFFlickrMediumSize] retain];
                
        dateTaken = [[dateFormatter dateFromString:[dictionary valueForKeyPath:@"datetaken"]] retain];
    }
    
    return self;
}

- (void)cancelLoadData
{
    if (self.dataConnection) {
        [self.dataConnection cancel];
        self.dataConnection = nil;
    }
}

- (void)loadData
{
    if (!self.dataConnection) {
        NSURLRequest *request=[NSURLRequest requestWithURL:mediumSizeURL
                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:60.0];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                      delegate:self];
        self.dataConnection = connection;
        [connection release];
        
        self.dataReceived = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataReceived appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.dataConnection = nil;
    [self.delegate photo:self dataLoaded:self.dataReceived];
    self.dataReceived = nil;
}

- (NSComparisonResult)compareByDateTaken:(id)obj
{
    Photo *photo = obj;
    return [self.dateTaken compare:photo.dateTaken];
}

- (void)dealloc
{
    [title release];
    [dateTaken release];
    [context release];
    [mediumSizeURL release];
    [dataConnection release];
    [dataReceived release];
    
    [super dealloc];
}

@end
