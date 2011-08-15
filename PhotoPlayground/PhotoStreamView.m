//
//  PhotoStreamView.m
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoStreamView.h"
#import "Photo.h"

#define PADDING 400.0f

@interface PhotoStreamView()

- (void)baseInit;
- (void)updateContentSize;
- (void)createViewsForPhotos:(NSArray *)photos;
- (void)updateVisiblePhotoViews;

@property (nonatomic, retain) NSMutableArray *photoViews;


@end

@implementation PhotoStreamView

@synthesize photoStream;
@synthesize photoViews;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (void)baseInit
{
    self.delegate = self;
    self.canCancelContentTouches = NO;
    self.photoViews = [NSMutableArray array];
    
    NSString *imageName = [[NSBundle mainBundle] pathForResource:@"pattern" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
    
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)setPhotoStream:(PhotoStream *)aPhotoStream
{
    [aPhotoStream retain];
    [photoStream release];
    
    photoStream = aPhotoStream;
    photoStream.delegate = self;
    
    [self createViewsForPhotos:photoStream.photos];
    [self updateContentSize];
}

- (void)photoStream:(PhotoStream *)photoStream loadedPhotos:(NSArray *)photos
{
    [self createViewsForPhotos:photos];
    [self updateContentSize];
}

- (void)updateContentSize
{
    NSUInteger count = [self.photoViews count];
    PhotoView *lastView = count?[self.photoViews objectAtIndex:count - 1]:nil;
    self.contentSize = CGSizeMake(lastView?lastView.center.x + PADDING:0.0f,
                                  self.frame.size.height);
}

- (void)photoView:(PhotoView *)photoView imageLoaded:(UIImage *)image
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];

    photoView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);

    [UIView commitAnimations];

}

- (void)createViewsForPhotos:(NSArray *)photos
{
    NSUInteger count = [self.photoViews count];
    CGFloat previousX = count?((PhotoView *)[self.photoViews objectAtIndex:count - 1]).center.x:PADDING;
    
    for (Photo *photo in photos) {
        PhotoView *photoView = [PhotoView photoViewWithPhoto:photo];
        photoView.delegate = self;
        [self.photoViews addObject:photoView];
        
        CGFloat x = previousX + 250 + 20 * rand() / RAND_MAX;
        CGFloat y = self.frame.size.height * rand()/RAND_MAX;
        photoView.center = CGPointMake(x, y);
        photoView.bounds = CGRectMake(0, 0, 500, 500);
        
        [photoView setAlpha:0.0f];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [photoView setAlpha:1.0];
        [UIView commitAnimations];

        previousX = x;
    }
    
    [self updateVisiblePhotoViews];
}

- (void)updateVisiblePhotoViews
{
    for (PhotoView *photoView in self.photoViews) {
        CGFloat x = photoView.center.x;
        CGFloat offset = self.contentOffset.x;
        CGFloat width = self.frame.size.width;
        
        if (x >= offset - width &&
            x <=  offset + 2 * width) {
            if (photoView.superview != self) {
                [self addSubview:photoView];
                [photoView loadImage];
            }
        } else if (x >= offset - 3 * width &&
                   x <= offset + 4 * width) {
            [photoView loadImage];
        } else {
            if (photoView.superview) {
                [photoView unloadImage];
                [photoView removeFromSuperview];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateVisiblePhotoViews];
}

- (void)dealloc
{
    [photoStream release];
    
    [super dealloc];
}

@end
