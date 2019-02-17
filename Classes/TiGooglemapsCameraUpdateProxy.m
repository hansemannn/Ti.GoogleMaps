/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-present by Hans Knöchel. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsCameraUpdateProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsCameraUpdateProxy

- (GMSCameraUpdate *)cameraUpdate
{
  if (!cameraUpdate) {
    NSLog(@"[ERROR] Trying to receive a camera update that has no action specified. This will likely cause a crash.");
  }

  return cameraUpdate;
}

- (void)zoomIn:(id)unused
{
  ENSURE_UI_THREAD_0_ARGS

  cameraUpdate = [GMSCameraUpdate zoomIn];
}

- (void)zoomOut:(id)unused
{
  ENSURE_UI_THREAD_0_ARGS

  cameraUpdate = [GMSCameraUpdate zoomOut];
}

- (void)zoom:(id)args
{
  ENSURE_UI_THREAD(zoom, args);

  id value = [args objectAtIndex:0];
  id point = nil;

  ENSURE_TYPE(value, NSNumber);

  if ([args count] == 2) {
    point = [args objectAtIndex:1];
    ENSURE_TYPE(value, NSDictionary);

    cameraUpdate = [GMSCameraUpdate zoomBy:[TiUtils floatValue:value]
                                   atPoint:[TiUtils pointValue:point]];
  } else {
    cameraUpdate = [GMSCameraUpdate zoomBy:[TiUtils floatValue:value]];
  }
}

- (void)setTarget:(id)args
{
  ENSURE_UI_THREAD(setTarget, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id latitude = [args objectForKey:@"latitude"];
  id longitude = [args objectForKey:@"longitude"];
  id zoom = [args objectForKey:@"zoom"];

  ENSURE_TYPE(latitude, NSNumber);
  ENSURE_TYPE(longitude, NSNumber);

  if (zoom) {
    ENSURE_TYPE(zoom, NSNumber);
    cameraUpdate = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude])
                                         zoom:[TiUtils floatValue:zoom]];
  } else {
    cameraUpdate = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude])];
  }
}

- (void)setCamera:(id)args
{
  ENSURE_UI_THREAD(setCamera, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id latitude = [args objectForKey:@"latitude"];
  id longitude = [args objectForKey:@"longitude"];
  id zoom = [args objectForKey:@"zoom"];
  id bearing = [args objectForKey:@"bearing"];
  id viewingAngle = [args objectForKey:@"viewingAngle"];

  ENSURE_TYPE(latitude, NSNumber);
  ENSURE_TYPE(longitude, NSNumber);
  ENSURE_TYPE(zoom, NSNumber);
  ENSURE_TYPE(bearing, NSNumber);
  ENSURE_TYPE(viewingAngle, NSNumber);

  CLLocationCoordinate2D target = CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude]);
  GMSCameraPosition *cameraPosition = [[GMSCameraPosition alloc] initWithTarget:target
                                                                           zoom:[TiUtils floatValue:zoom]
                                                                        bearing:[TiUtils doubleValue:bearing]
                                                                   viewingAngle:[TiUtils doubleValue:viewingAngle]];

  cameraUpdate = [GMSCameraUpdate setCamera:cameraPosition];
}

- (void)fitBounds:(id)args
{
  ENSURE_UI_THREAD(fitBounds, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id _padding = [args objectForKey:@"padding"];
  id _insets = [args objectForKey:@"insets"];
  id _bounds = [args objectForKey:@"bounds"];
  id _coordinate1 = [_bounds objectForKey:@"coordinate1"];
  id _coordinate2 = [_bounds objectForKey:@"coordinate2"];

  CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake([TiUtils doubleValue:[_coordinate1 objectForKey:@"latitude"]], [TiUtils doubleValue:[_coordinate1 objectForKey:@"longitude"]]);
  CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([TiUtils doubleValue:[_coordinate2 objectForKey:@"latitude"]], [TiUtils doubleValue:[_coordinate2 objectForKey:@"longitude"]]);

  GMSCoordinateBounds *coordinateBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:coordinate1
                                                                               coordinate:coordinate2];

  if (_padding && _insets) {
    NSLog(@"[ERROR] Cannot use both `padding` and `insets` in the `fitBounds` method. Check the Google Maps docs for more infos: https://developers.google.com/maps/documentation/ios-sdk/reference/interface_g_m_s_camera_update.html#abd6fdfa8800f8b2d9ba00af5e44fa385");
    return;
  }

  if (_padding) {
    cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds
                                  withPadding:[TiUtils floatValue:_padding]];
    return;
  }

  if (_insets) {
    cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds
                               withEdgeInsets:[TiUtils contentInsets:_insets]];
    return;
  }

  cameraUpdate = [GMSCameraUpdate fitBounds:coordinateBounds];
}

- (void)scrollBy:(id)args
{
  ENSURE_UI_THREAD(scrollBy, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  id x = [args objectForKey:@"x"];
  id y = [args objectForKey:@"y"];

  cameraUpdate = [GMSCameraUpdate scrollByX:[TiUtils floatValue:x]
                                          Y:[TiUtils floatValue:y]];
}

@end
