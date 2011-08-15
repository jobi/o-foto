//
//  PhotoStreamView.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoStream.h"
#import "PhotoView.h"

@interface PhotoStreamView : UIScrollView <UIScrollViewDelegate, PhotoViewDelegate, PhotoStreamDelegate>

@property (nonatomic, retain) PhotoStream *photoStream;

@end
