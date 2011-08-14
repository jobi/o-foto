//
//  PhotoView.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView()

- (void)handleTranslationTouches:(NSSet *)touches;
- (void)handleSimilitudeTouches:(NSSet *)touches;

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
        
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *touchesInView = [event touchesForView:self];
    
    switch ([touchesInView count]) {
        case 1:
            [self handleTranslationTouches:touchesInView];
            break;
        case 2:
            [self handleSimilitudeTouches:touchesInView];
            break;
        default:
            break;
    }
    
}

- (void)handleTranslationTouches:(NSSet *)touches
{
    CGPoint point;
    CGPoint previous;
    
    for (UITouch *touch in touches) {
        point = [touch locationInView:self.superview];
        previous = [touch previousLocationInView:self.superview];
    }
    
    CGPoint position = self.layer.position;
    
    position.x += point.x - previous.x;
    position.y += point.y - previous.y;
    
    self.layer.position = position;
}

- (void)handleSimilitudeTouches:(NSSet *)touches
{
    CGAffineTransform m;
    
    CGFloat x1, y1, x2, y2;
    CGFloat x1p, y1p, x2p, y2p;
    
    UITouch *touch = [[touches allObjects]objectAtIndex:0];
    
    CGPoint point = [touch locationInView:self.superview];
    CGPoint previous = [touch previousLocationInView:self.superview];
    
    x1 = previous.x - self.center.x;
    y1 = previous.y - self.center.y;
    
    x1p = point.x - self.center.x;
    y1p = point.y - self.center.y;
    
    touch = [[touches allObjects]objectAtIndex:1];
    
    point = [touch locationInView:self.superview];
    previous = [touch previousLocationInView:self.superview];
    
    x2 = previous.x - self.center.x;
    y2 = previous.y - self.center.y;
    
    x2p = point.x - self.center.x;
    y2p = point.y - self.center.y;
    
    CGFloat d = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
	if (d < 0.1) {
        m = CGAffineTransformMakeTranslation(x1p-x1, y1p-y1);
    }
    
	CGFloat a = (y1-y2)*(y1p-y2p) + (x1-x2)*(x1p-x2p);
	CGFloat b = (y1-y2)*(x1p-x2p) - (x1-x2)*(y1p-y2p);
	CGFloat tx = (y1*x2 - x1*y2)*(y2p-y1p) - (x1*x2 + y1*y2)*(x1p+x2p) + x1p*(y2*y2 + x2*x2) + x2p*(y1*y1 + x1*x1);
	CGFloat ty = (x1*x2 + y1*y2)*(-y2p-y1p) + (y1*x2 - x1*y2)*(x1p-x2p) + y1p*(y2*y2 + x2*x2) + y2p*(y1*y1 + x1*x1);
	
    m = CGAffineTransformMake(a/d, -b/d, b/d, a/d, tx/d, ty/d);
    
    [self.layer setAffineTransform:CGAffineTransformConcat([self.layer affineTransform],  m)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)dealloc
{
    [photo release];
    
    [super dealloc];
}

@end
