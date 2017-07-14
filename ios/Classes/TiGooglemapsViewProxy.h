/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "TiGooglemapsAnnotationProxy.h"

@interface TiGooglemapsViewProxy : TiViewProxy<GMSMapViewDelegate> {
    TiGooglemapsViewProxy *mapView;
    NSMutableArray *markers;
    NSMutableArray *overlays;
    
    @private
    dispatch_queue_t q;
}

/**
 *  An array of marker proxies.
 *
 *  @return The proxies
 *  @since 2.1.0
 */
- (NSMutableArray *)markers;

/**
 *  An array of overlay proxies.
 *
 *  @return The proxies
 *  @since 2.1.0
 */
- (NSMutableArray *)overlays;

/**
 *  Adds an annotation.
 *
 *  @param args The annotation.
 *  @since 2.2.0
 */
- (void)addAnnotation:(id)args;

/**
 *  Adds multiple annotations.
 *
 *  @param args The annotations.
 *  @since 2.2.0
 */
- (void)addAnnotations:(id)args;

/**
 *  Set multiple annotations.
 *
 *  @param args The annotations.
 *  @since 2.2.0
 */
- (void)setAnnotations:(id)args;

/**
 *  Remove an annotation.
 *
 *  @param args The annotation.
 *  @since 2.2.0
 */
- (void)removeAnnotation:(id)args;

/**
 *  Adds a polyline.
 *
 *  @param args The polyline proxy.
 *  @since 1.0.0
 */
- (void)addPolyline:(id)args;

/**
 *  Removes a polyline.
 *
 *  @param args The polyline proxy.
 *  @since 1.0.0
 */
- (void)removePolyline:(id)args;

/**
 *  Adds a polygon.
 *
 *  @param args The polygon proxy.
 *  @since 1.0.0
 */
- (void)addPolygon:(id)args;

/**
 *  Removes a polygon.
 *
 *  @param args The polygon proxy.
 *  @since 1.0.0
 */
- (void)removePolygon:(id)args;

/**
 *  Adds a circle.
 *
 *  @param args The circle proxy.
 *  @since 1.0.0
 */
- (void)addCircle:(id)args;

/**
 *  Removes a circle.
 *
 *  @param args The circle proxy.
 *  @since 1.0.0
 */
- (void)removeCircle:(id)args;

/**
 *  Animates to a location.
 *
 *  @param args The location to animate to.
 *  @since 2.1.0
 */
- (void)animateToLocation:(id)args;

/**
 *  Animates to a zoom level.
 *
 *  @param value The location to zoom to.
 *  @since 2.1.0
 */
- (void)animateToZoom:(id)value;

/**
 *  Animates to a bearing.
 *
 *  @param value The bearing value.
 *  @since 2.1.0
 */
- (void)animateToBearing:(id)value;

/**
 *  Animates to a viewing angle.
 *
 *  @param value The angle to animate to.
 *  @since 2.1.0
 */
- (void)animateToViewingAngle:(id)value;

/**
 *  Returns the currently selected annotation.
 *
 *  @return The selected annotation.
 *  @since 2.2.0
 */
- (id)getSelectedAnnotation:(id)unused;

/**
 *  Selects a annotation.
 *
 *  @param value The annotation proxy.
 *  @since 2.2.0
 */
- (void)selectAnnotation:(id)value;

/**
 *  Deselects a annotation.
 *
 *  @since 2.2.0
 */
- (void)deselectAnnotation:(id)unused;

/**
 *  Sets the state of the location-enabled button.
 *
 *  @param value The enabled value.
 *  @since 1.0.0
 */
- (void)setMyLocationEnabled:(id)value;

/**
 *  Sets the map type.
 *
 *  @param value The map type.
 *  @since 1.0.0
 */
- (void)setMapType:(id)value;

/**
 *  Sets the camera region.
 *
 *  @param value The region.
 *  @since 2.2.0
 */
- (void)setRegion:(id)args;

/**
 *  Sets the JSOn-based map style.
 *
 *  @param value The map style.
 *  @since 2.6.0
 */
- (void)setMapStyle:(id)value;

/**
 *  Moves the camera with the specified camera update.
 *
 *  @param value The camera update.
 *  @since 2.7.0
 */
- (void)moveCamera:(id)value;

/**
 *  Animates the camera with the specified camera update.
 *
 *  @param value The camera update.
 *  @since 2.7.0
 */
- (void)animateWithCameraUpdate:(id)value;

@end
