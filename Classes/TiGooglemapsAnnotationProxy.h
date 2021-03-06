/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "TiViewProxy.h"
#import <GoogleMaps/GoogleMaps.h>

@interface TiGooglemapsAnnotationProxy : TiProxy

@property (nonatomic, retain) GMSMarker *marker;

/**
 *  Creates a new `TiGooglemapsAnnotationProxy` proxy from a native `GMSMarker` instance.
 *
 *  @return The new annotation proxy instance.
 *  @since 4.1.0
 */
- (id)_initWithPageContext:(id<TiEvaluator>)context andMarker:(GMSMarker *)marker;

/**
 *  Returns the annotation info window.
 *
 *  @return The info window
 *  @since 3.2.0
 */
- (TiViewProxy *)infoWindow;

/**
 *  Sets the annotation info window.
 *
 *  @param value The info window
 *  @since 3.2.0
 */
- (void)setInfoWindow:(id)value;

/**
 *  Sets the annotation title.
 *
 *  @param value The title
 *  @since 1.0.0
 */
- (void)setTitle:(id)value;

/**
 *  Sets the annotation subtitle.
 *
 *  @param value The subtitle
 *  @since 2.2.0
 */
- (void)setSubtitle:(id)value;

/**
 *  Sets the annotation center offset.
 *
 *  @param args The point
 *  @since 2.2.0
 */
- (void)setCenterOffset:(id)args;

/**
 *  Sets the annotation ground offset.
 *
 *  @param args The point
 *  @since 2.2.0
 */
- (void)setGroundOffset:(id)args;

/**
 *  Sets the annotation image.
 *
 *  @param value The image
 *  @since 2.1.0
 */
- (void)setImage:(id)value;

/**
 *  Sets the annotation pin color.
 *
 *  @param value The color
 *  @since 2.1.0
 */
- (void)setPinColor:(id)value;

/**
 *  Sets the annotation touch-capacity.
 *
 *  @param value The boolean capacity
 *  @since 2.2.0
 */
- (void)setTouchEnabled:(id)value;

/**
 *  Sets the annotation flat-capacity.
 *
 *  @param value The boolean capacity
 *  @since 1.0.0
 */
- (void)setFlat:(id)value;

/**
 *  Sets the annotation draggable-capacity.
 *
 *  @param value The boolean capacity
 *  @since 1.0.0
 */
- (void)setDraggable:(id)value;

/**
 *  Sets the annotation opacity.
 *
 *  @param value The boolean opacity
 *  @since 2.2.0
 */
- (void)setOpacity:(id)value;

/**
 *  Sets the annotation animation style.
 *
 *  @param value The animation style
 *  @since 2.2.0
 */
- (void)setAnimationStyle:(id)value;

/**
 *  Sets the annotation user data.
 *
 *  @param value The user data
 *  @since 1.0.0
 */
- (void)setUserData:(id)value;

/**
 *  Updates the annotation location (latitude, longitude)
 *
 *  @param value The locations data
 *  @since 2.4.0
 */
- (void)updateLocation:(id)args;

/**
 *  Sets the annotation custom view.
 *
 *  @param value The custom view
 *  @since 3.5.0
 */
- (void)setCustomView:(id)value;

@end
