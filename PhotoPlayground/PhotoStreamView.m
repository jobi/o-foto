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
#define SPREAD 300.0f

@interface PhotoStreamView()

- (void)baseInit;
- (void)updateContentSize;
- (void)createViews;
- (CGFloat)pixelPerSecond:(NSTimeInterval)timeInterval;
- (void)updateVisiblePhotoViews;

@property (nonatomic, retain) NSMutableArray *photoViews;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

@end

@implementation PhotoStreamView

@synthesize photoStream;
@synthesize photoViews;
@synthesize startDate;
@synthesize endDate;

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
    
    NSArray *photos = photoStream.photos;
    self.startDate = ((Photo *)[photos objectAtIndex:0]).dateTaken;
    self.endDate = ((Photo *)[photos objectAtIndex:[photos count] - 1]).dateTaken;
    
    [self updateContentSize];
    [self createViews];
}

- (CGFloat)pixelPerSecond:(NSTimeInterval)timeInterval
{
    NSTimeInterval secondsInAMonth = 30 * 24 * 3600;
    
    return PADDING + self.frame.size.width * timeInterval / secondsInAMonth;
}

- (NSDate *)dateForOffset:(CGFloat)offset
{
    NSTimeInterval secondsInAMonth = 30 * 24 * 3600;
    NSTimeInterval time = secondsInAMonth * offset / self.frame.size.width;
    return [NSDate dateWithTimeInterval:time
                              sinceDate:self.startDate];
}

- (void)updateContentSize
{
    
    NSTimeInterval timeInterval = [self.endDate timeIntervalSinceDate:self.startDate];
    //timeInterval += 2 * 30 * 24 * 3600;
    
    self.contentSize = CGSizeMake([self pixelPerSecond:timeInterval] + PADDING,
                                  self.frame.size.height);
}

- (void)photoView:(PhotoView *)photoView imageLoaded:(UIImage *)image
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];

    photoView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);

    [UIView commitAnimations];

}

- (void)createViews
{
    for (Photo *photo in self.photoStream.photos) {
        PhotoView *photoView = [PhotoView photoViewWithPhoto:photo];
        photoView.delegate = self;
        [self.photoViews addObject:photoView];
        
        //photoView.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        
        CGFloat x = [self pixelPerSecond:[photoView.photo.dateTaken timeIntervalSinceDate:self.startDate]];
        x += 2 * SPREAD * rand()/RAND_MAX - SPREAD;
        CGFloat y = self.frame.size.height * rand()/RAND_MAX;
        photoView.center = CGPointMake(x, y);
        photoView.bounds = CGRectMake(0, 0, 500, 500);
        
        [photoView setAlpha:0.0f];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [photoView setAlpha:1.0];
        [UIView commitAnimations];

    }
    
    [self updateVisiblePhotoViews];
}

- (void)updateVisiblePhotoViews
{
    NSDate *visibleStartDate = [self dateForOffset:self.contentOffset.x - self.frame.size.width - SPREAD];
    NSDate *visibleEndDate = [self dateForOffset:self.contentOffset.x + 2 * self.frame.size.width + SPREAD];
    
    for (PhotoView *photoView in self.photoViews) {
        if ([photoView.photo.dateTaken earlierDate:visibleStartDate] == visibleStartDate &&
            [photoView.photo.dateTaken laterDate:visibleEndDate] == visibleEndDate) {
            if (photoView.superview != self) {
                [self addSubview:photoView];
                [photoView loadImage];
            }
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
