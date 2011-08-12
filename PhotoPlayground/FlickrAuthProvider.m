//
//  FlickrAuthProvider.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlickrAuthProvider.h"

@interface FlickrAuthProvider()

@property (nonatomic, readwrite) FlickrAuthState authState;
@property (nonatomic, copy, readwrite) NSString *token;

- (void)loadFromDefaults;

@end

@implementation FlickrAuthProvider

@synthesize delegate;
@synthesize authState;
@synthesize token;

- (id)initWithContext:(OFFlickrAPIContext *)aContext;
{
    self = [super init];
    if (self) {
        context = [aContext retain];
        defaults = [NSUserDefaults standardUserDefaults];
        authState = FlickrAuthStateNeedsFrob;
        
        [self loadFromDefaults];
    }
    
    return self;
}

- (void)loadFromDefaults
{
    NSString *aToken;
    
    if ((aToken = [defaults stringForKey:@"flickr-auth-token"])) {
        [self setToken:aToken];
    }
}

- (void)useFrob:(NSString *)frob
{
    OFFlickrAPIRequest *request = [[OFFlickrAPIRequest alloc] initWithAPIContext:context];
    
    [self setAuthState:FlickrAuthStateTokenQueried];
    
    request.delegate = self;
    [request callAPIMethodWithGET:@"flickr.auth.getToken"
                        arguments:[NSDictionary dictionaryWithObjectsAndKeys:frob, @"frob", nil]];
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    if (![[inResponseDictionary valueForKeyPath:@"stat"] isEqualToString:@"ok"])
        [self setAuthState:FlickrAuthStateNeedsFrob];
    
    NSString *aToken = [[inResponseDictionary valueForKeyPath:@"auth.token"] textContent];
    
    if (aToken) {
        [self setToken:aToken];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    [self setAuthState:FlickrAuthStateNeedsFrob];
}

- (void)setAuthState:(FlickrAuthState)anAuthState
{
    if (anAuthState != authState) {
        authState = anAuthState;
        [delegate authStateChanged:authState];
    }
}

- (void)setToken:(NSString *)aToken
{
    if (aToken == token)
        return;
    
    [token release];
    token = [aToken copy];
    
    [context setAuthToken:token];
    [defaults setObject:token forKey:@"flickr-auth-token"];
    [defaults synchronize];
    
    [self setAuthState:FlickrAuthStateAuthenticated];
}

- (void)dealloc
{
    [token release];
    [context release];
    
    [super dealloc];
}

@end
