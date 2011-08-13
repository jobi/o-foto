//
//  PhotoView.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()

@end

@implementation PhotoView

@synthesize delegate;
@synthesize photo;

+ (PhotoView *)photoViewWithPhoto:(Photo *)photo
{
    PhotoView *photoView = [[PhotoView alloc] init];
    
    photoView.photo = photo;
    
    return [photoView autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        CALayer *layer = self.layer;
        
        layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        
        CGFloat rotationAngle = 60.0f * (M_PI/180) * rand()/RAND_MAX - (30.0f * (M_PI/180));
        [layer setAffineTransform:CGAffineTransformMakeRotation(rotationAngle)];
    }
    
    return self;
}

- (void)setPhoto:(Photo *)aPhoto
{
    [aPhoto retain];
    [photo release];
    photo = aPhoto;
    
    photo.delegate = self;
}

- (void)loadImage
{
    if (photo == nil)
        return;
    
    [photo loadData];
}

- (void)photo:(Photo *)photo dataLoaded:(NSData *)data
{
    UIImage *image = [[UIImage alloc]initWithData:data];
    
    self.image = image;
    [self.delegate photoView:self imageLoaded:image];

    [image release];
}

- (void)dealloc
{
    [photo release];
    
    [super dealloc];
}

@end
