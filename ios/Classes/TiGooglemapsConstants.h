/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

typedef NS_ENUM(NSUInteger, TiGooglemapsOverlayType) {
    TiGooglemapsOverlayTypeUnknown = 0,
    TiGooglemapsOverlayTypePolygon,
    TiGooglemapsOverlayTypePolyline,
    TiGooglemapsOverlayTypeCircle
};

typedef NS_ENUM(NSUInteger, TiGooglemapsPolylinePattern) {
    TiGooglemapsPolylinePatternDashed = 1,
    TiGooglemapsPolylinePatternDotted = 2
};
