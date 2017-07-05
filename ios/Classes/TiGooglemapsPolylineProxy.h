/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GoogleMaps/GoogleMaps.h>
#import "TiUtils.h"

@interface TiGooglemapsPolylineProxy : TiProxy {
    NSInteger patternType;
    
    NSNumber *dashLength;
    NSNumber *gapLength;
    
    NSArray *styles;
}

@property(nonatomic,retain) GMSPolyline *polyline;

-(void)updatePattern:(float)scale;

@end
