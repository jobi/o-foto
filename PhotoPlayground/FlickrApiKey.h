//
//  FlickrApiKey.h
//  PhotoPlayground
//
//  Created by Johan Bilien on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    NSString *key;
    NSString *secret;
} FlickrApiKey;

const FlickrApiKey flickrApiKey = { @"776631f1dbf1d39ae9f8578edb1abb07",
                                    @"b84d19d7e96d7c22" };
