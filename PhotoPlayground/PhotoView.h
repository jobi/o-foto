//
//  PhotoView.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"

@class PhotoView;

@protocol PhotoViewDelegate <NSObject>

- (void)photoView:(PhotoView *)photoView imageLoaded:(UIImage *)image;

@end

@interface PhotoView : UIView <PhotoDelegate>

+ (PhotoView *)photoViewWithPhoto:(Photo *)photo;

- (void)loadImage;

@property (nonatomic, assign) id<PhotoViewDelegate> delegate;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) UIImage *image;

@end
