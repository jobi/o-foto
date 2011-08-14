//
//  PhotoPlaygroundAppDelegate.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoPlaygroundAppDelegate.h"
#import "PhotoPlaygroundViewController.h"
#import "FlickrApiKey.h"
#import "Photo.h"
#import "PhotoStream.h"

@interface PhotoPlaygroundAppDelegate()

- (void)updateFromAuthState;
- (void)showAuthenticationView;
- (void)loadPhotos;

@end

@implementation PhotoPlaygroundAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize authProvider;
@synthesize flickrContext;
@synthesize photoStream;

- (id)init
{
    if ((self = [super init])) {
        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:flickrApiKey.key
                                                      sharedSecret:flickrApiKey.secret];
        authProvider = [[FlickrAuthProvider alloc] initWithContext:flickrContext];
        authProvider.delegate = self;
    }
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self updateFromAuthState];
    
    return YES;
}

- (void)showAuthenticationView
{
    NSURL *url = [flickrContext loginURLFromFrobDictionary:nil
                                       requestedPermission:OFFlickrReadPermission];
    
    [self.viewController showAuthenticationViewWithURL:url];
}

- (void)updateFromAuthState
{
    switch (authProvider.authState) {
        case FlickrAuthStateNeedsFrob:
            [self showAuthenticationView];
            break;
        case FlickrAuthStateTokenQueried:
            [self.viewController dismissModalViewControllerAnimated:YES];
            break;
        case FlickrAuthStateAuthenticated:
            [self.viewController dismissModalViewControllerAnimated:YES];
            [self loadPhotos];
            break;
    }
}

- (void)authStateChanged:(FlickrAuthState)authState
{
    [self updateFromAuthState];
}

- (void)loadPhotos
{
    PhotoStream *aPhotoStream  = [[PhotoStream alloc]initWithFlickrContext:flickrContext];
    aPhotoStream.delegate = self;
    self.photoStream = aPhotoStream;
    [aPhotoStream release];
    
    
    /*
    OFFlickrAPIRequest *recentRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    
    recentRequest.delegate = self;
    [recentRequest callAPIMethodWithGET:@"flickr.photos.search"
                              arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"me", @"user_id",
                                                                                   @"litl", @"tags", 
                                                                                   //@"5", @"per_page",
                                                                                   nil]];
     */
}

- (void)photoStreamChanged:(PhotoStream *)aPhotoStream
{
    for (Photo *photo in photoStream.photos)
        [self.viewController addPhoto:photo];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{    
    NSArray *photos = [inResponseDictionary valueForKeyPath:@"photos.photo"];
    
    for (NSDictionary *photoDict in photos)
        [self.viewController addPhoto:[Photo photoWithContext:flickrContext dictionary:photoDict]];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"Got error %@", inError);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *prefix = @"photoplayground://flickr-auth/?frob=";
    NSString *urlString = [url absoluteString];
    
    if ([urlString hasPrefix:prefix]) {
        NSString *frob = [urlString substringFromIndex:[prefix length]];
        
        [authProvider useFrob:frob];
        
        return YES;
    }
    
    return NO;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
