/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiUtils.h"
#import "TiGooglemapsView.h"
#import "TiGooglemapsViewProxy.h"
#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiGooglemapsClusterItemProxy.h"
#import "TiGooglemapsCameraUpdateProxy.h"
#import "TiGooglemapsTileProxy.h"
#import "TiGooglemapsIndoorDisplayProxy.h"

#import "GMUMarkerClustering.h"

@implementation TiGooglemapsViewProxy

- (id)_initWithPageContext:(id<TiEvaluator>)context
{
    if (self = [super _initWithPageContext:context]) {
        q = dispatch_queue_create("ti.googlemaps-annotation-queue", DISPATCH_QUEUE_CONCURRENT);
    }

    return self;
}

- (TiGooglemapsView *)mapView
{
    return (TiGooglemapsView *)[self view];
}

- (NSMutableArray *)markers
{
    if (markers == nil) {
        markers = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return markers;
}

- (NSMutableArray *)overlays
{
    if (overlays == nil) {
        overlays = [[NSMutableArray alloc] initWithArray:@[]];
    }
    
    return overlays;
}

#pragma mark Public API's

- (void)setMyLocationButton:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setMyLocationButton:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"myLocationButton" notification:NO];
}

- (void)setCompassButton:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setCompassButton:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"compassButton" notification:NO];
}

- (void)setIndoorPicker:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setIndoorPicker:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"indoorPicker" notification:NO];
}

- (void)setIndoorEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setIndoorEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"indoorEnabled" notification:NO];
}

- (void)setScrollGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setScrollGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"scrollGestures" notification:NO];
}

- (void)setZoomGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setZoomGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"zoomGestures" notification:NO];
}

- (void)setTiltGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setTiltGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"tiltGestures" notification:NO];
}

- (void)setRotateGestures:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setRotateGestures:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"rotateGestures" notification:NO];
}

- (void)setConsumesGesturesInView:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setConsumesGesturesInView:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"consumesGesturesInView" notification:NO];
}

- (void)setAllowScrollGesturesDuringRotateOrZoom:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[[self mapView] mapView] settings] setAllowScrollGesturesDuringRotateOrZoom:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"allowScrollGesturesDuringRotateOrZoom" notification:NO];
}

- (void)setMyLocationEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setMyLocationEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"myLocationEnabled" notification:NO];
}

- (void)setMapType:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setMapType:[TiUtils intValue:value def:kGMSTypeNormal]];
    [self replaceValue:value forKey:@"mapType" notification:NO];
}

- (void)setTrafficEnabled:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    ENSURE_TYPE(value, NSNumber);
    
    [[[self mapView] mapView] setTrafficEnabled:[TiUtils boolValue:value]];
    [self replaceValue:value forKey:@"trafficEnabled" notification:NO];
}

- (void)setMapInsets:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(args, NSDictionary);
    
    UIEdgeInsets mapInsets = [TiUtils contentInsets:args];
    
    [[[self mapView] mapView] setPadding:mapInsets];
    [self replaceValue:args forKey:@"mapInsets" notification:NO];
}

- (void)setRegion:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(args, NSDictionary);
    
    id latitude = [args valueForKey:@"latitude"];
    id longitude = [args valueForKey:@"longitude"];
    id zoom = [args valueForKey:@"zoom"];
    id bearing = [args valueForKey:@"bearing"];
    id viewingAngle = [args valueForKey:@"viewingAngle"];
    
    ENSURE_TYPE(latitude, NSNumber);
    ENSURE_TYPE(longitude, NSNumber)
    ENSURE_TYPE_OR_NIL(zoom, NSNumber);
    ENSURE_TYPE_OR_NIL(bearing, NSNumber);
    ENSURE_TYPE_OR_NIL(viewingAngle, NSNumber);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[TiUtils doubleValue:latitude]
                                                            longitude:[TiUtils doubleValue:longitude]
                                                                 zoom:[TiUtils floatValue:zoom def:1]
                                                              bearing:[TiUtils floatValue:bearing def:0]
                                                         viewingAngle:[TiUtils floatValue:viewingAngle def:0]];
    
    [[[self mapView] mapView] setCamera:camera];
    [self replaceValue:args forKey:@"region" notification:NO];
}

- (void)setMapStyle:(id)value
{
    ENSURE_UI_THREAD(setMapStyle, value);
        
    if (value == nil) {
        [[[self mapView] mapView] setMapStyle:nil];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSError *error = nil;

        // Pretty simple check to distinguish between a JSON-file and JSON-content. Improve if desired 😙
        if ([[value pathExtension] isEqualToString:@"json"]) {
            [[[self mapView] mapView] setMapStyle:[GMSMapStyle styleWithContentsOfFileURL:[TiUtils toURL:value proxy:self]
                                                                                    error:&error]];
        } else {
            [[[self mapView] mapView] setMapStyle:[GMSMapStyle styleWithJSONString:[TiUtils stringValue:value]
                                                                             error:&error]];
        }
        
        if (error != nil) {
            NSLog(@"[ERROR] Ti.GoogleMaps: Could not apply map style: %@", [error localizedDescription]);
        }
    } else {
        NSLog(@"[ERROR] Invalid map-style provided. Use either a String or Blob type instead!");
    }
}

- (void)moveCamera:(id)value
{
    ENSURE_UI_THREAD(moveCamera, value);
    ENSURE_SINGLE_ARG(value, TiGooglemapsCameraUpdateProxy);
    
    [[[self mapView] mapView] moveCamera:[(TiGooglemapsCameraUpdateProxy *)value cameraUpdate]];
}

- (void)animateWithCameraUpdate:(id)value
{
    ENSURE_UI_THREAD(animateWithCameraUpdate, value);
    ENSURE_SINGLE_ARG(value, TiGooglemapsCameraUpdateProxy);
    
    [[[self mapView] mapView] animateWithCameraUpdate:[(TiGooglemapsCameraUpdateProxy *)value cameraUpdate]];
}

- (void)cluster:(id)unused
{
    ENSURE_UI_THREAD(cluster, unused);
    
    [[[self mapView] clusterManager] cluster];
}

- (void)addClusterItem:(id)args
{
    ENSURE_SINGLE_ARG(args, TiGooglemapsClusterItemProxy);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self mapView] clusterManager] addItem:[(TiGooglemapsClusterItemProxy *)args clusterItem]];
    });
}

- (void)addClusterItems:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);
    
    NSMutableArray *items = [NSMutableArray array];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSUInteger i = 0; i < [args count]; i++) {
            TiGooglemapsClusterItemProxy *clusterItem = [args objectAtIndex:i];
            ENSURE_TYPE(clusterItem, TiGooglemapsClusterItemProxy);
            
            [items addObject:[(TiGooglemapsClusterItemProxy *)clusterItem clusterItem]];
        }
        [[[self mapView] clusterManager] addItems:items];
    });
}

- (void)setClusterItems:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);
    
    [[[self mapView] clusterManager] clearItems];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self mapView] clusterManager] clearItems];
        [self addClusterItems:args];
    });
}

- (void)removeClusterItem:(id)args
{
    ENSURE_SINGLE_ARG(args, TiGooglemapsClusterItemProxy);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self mapView] clusterManager] removeItem:[(TiGooglemapsClusterItemProxy *)args clusterItem]];
    });
}

- (void)clearClusterItems:(id)unused
{
    [[[self mapView] clusterManager] clearItems];
}

- (void)addAnnotation:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, TiGooglemapsAnnotationProxy);

    TiGooglemapsAnnotationProxy *annotationProxy = args;
    
    dispatch_barrier_async(q, ^{
        [[self markers] addObject:annotationProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[annotationProxy marker] setMap:[[self mapView] mapView]];
        });
    });
}

- (void)addAnnotations:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);
    
    for (NSUInteger i = 0; i < [args count]; i++) {
        [self addAnnotation:@[[args objectAtIndex:i]]];
    }
}

- (void)removeAnnotation:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, TiGooglemapsAnnotationProxy);
    
    TiGooglemapsAnnotationProxy *annotationProxy = args;
    
    dispatch_barrier_async(q, ^{
        [[self markers] removeObject:annotationProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[annotationProxy marker] setMap:nil];
        });
    });
}

- (void)removeAnnotations:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);

    for (NSUInteger i = 0; i < [args count]; i++) {
        [self removeAnnotation:@[[args objectAtIndex:i]]];
    }
}

- (void)removeAllAnnotations:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    dispatch_barrier_async(q, ^{
        [[self markers] removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self mapView] mapView] clear];
        });
    });
}

- (void)setAnnotations:(id)args
{
    ENSURE_SINGLE_ARG(args, NSArray);

    dispatch_barrier_async(q, ^{
        for (NSUInteger i = 0; i < [[self markers] count]; i++) {
            [self removeAnnotation:@[[[self markers] objectAtIndex:i]]];
        }
    });
    
    [self addAnnotations:args];
}

- (void)addPolyline:(id)args
{
    id polylineProxy = [args objectAtIndex:0];
    
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] addObject:polylineProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[polylineProxy polyline] setMap:[[self mapView] mapView]];
        });
    });
}

- (void)removePolyline:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polylineProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polylineProxy, TiGooglemapsPolylineProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] removeObject:polylineProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[polylineProxy polyline] setMap:nil];
        });
    });
}

- (void)addPolygon:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polygonProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] addObject:polygonProxy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[polygonProxy polygon] setMap:[[self mapView] mapView]];
        });
    });
}

- (void)removePolygon:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id polygonProxy = [args objectAtIndex:0];
    ENSURE_TYPE(polygonProxy, TiGooglemapsPolygonProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] removeObject:polygonProxy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[polygonProxy polygon] setMap:nil];
        });
    });
}

- (void)addCircle:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id circleProxy = [args objectAtIndex:0];
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] addObject:circleProxy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[circleProxy circle] setMap:[[self mapView] mapView]];
        });
    });
}

- (void)removeCircle:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);

    id circleProxy = [args objectAtIndex:0];
    ENSURE_TYPE(circleProxy, TiGooglemapsCircleProxy);
    
    dispatch_barrier_async(q, ^{
        [[self overlays] removeObject:circleProxy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[circleProxy circle] setMap:nil];
        });
    });
}

- (void)addTile:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    id tileProxy = [args objectAtIndex:0];
    ENSURE_TYPE(tileProxy, TiGooglemapsTileProxy);
    
    [[tileProxy tile] setMap:[[self mapView] mapView]];
}

- (void)removeTile:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    id tileProxy = [args objectAtIndex:0];
    ENSURE_TYPE(tileProxy, TiGooglemapsTileProxy);
    
    [[tileProxy tile] setMap:nil];
}

- (id)getSelectedAnnotation:(id)unused
{
    ENSURE_UI_THREAD(getSelectedAnnotation, unused);
    GMSMarker *selectedMarker = [[[self mapView] mapView] selectedMarker];
    
    if (selectedMarker == nil) {
        return [NSNull null];
    }
    
    for (NSUInteger i = 0; i < [[self markers] count]; i++) {
        TiGooglemapsAnnotationProxy *annotation = [[self markers] objectAtIndex:i];
        if ([annotation marker] == [[[self mapView] mapView] selectedMarker]) {
            return annotation;
        }
    }
    return [NSNull null];
}

- (void)selectAnnotation:(id)value
{
    ENSURE_UI_THREAD(selectAnnotation, value);
    id annotationProxy = [value objectAtIndex:0];
    ENSURE_TYPE(annotationProxy, TiGooglemapsAnnotationProxy);
    
    [[[self mapView] mapView] setSelectedMarker:[annotationProxy marker]];
}

- (void)deselectAnnotation:(id)unused
{
    ENSURE_UI_THREAD(deselectAnnotation, unused);
    [[[self mapView] mapView] setSelectedMarker:nil];
}

- (void)animateToLocation:(id)args
{
    ENSURE_UI_THREAD(animateToLocation, args);
    ENSURE_TYPE(args, NSArray);
    
    id params = [args objectAtIndex:0];
    
    id latitude = [params valueForKey:@"latitude"];
    id longitude = [params valueForKey:@"longitude"];
    
    if (!CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude]))) {
        NSLog(@"[ERROR] Ti.GoogleMaps: Invalid location provided. Please check your latitude and longitude.");
        return;
    }
    
    [[[self mapView] mapView] animateToLocation:CLLocationCoordinate2DMake([TiUtils doubleValue:latitude], [TiUtils doubleValue:longitude])];
}

- (void)animateToZoom:(id)value
{
    ENSURE_UI_THREAD(animateToZoom, value);
    ENSURE_ARG_COUNT(value, 1);
    ENSURE_TYPE([value objectAtIndex:0], NSNumber);
    
    [[[self mapView] mapView] animateToZoom:[TiUtils floatValue:[value objectAtIndex:0]]];
}

- (void)animateToBearing:(id)value
{
    ENSURE_UI_THREAD(animateToBearing, value);
    ENSURE_ARG_COUNT(value, 1);
    ENSURE_TYPE([value objectAtIndex:0], NSNumber);
    
    [[[self mapView] mapView] animateToBearing:[TiUtils doubleValue:[value objectAtIndex:0]]];
}

- (void)animateToViewingAngle:(id)value
{
    ENSURE_UI_THREAD(animateToViewingAngle, value);
    ENSURE_ARG_COUNT(value, 1);
    ENSURE_TYPE([value objectAtIndex:0], NSNumber);
    
    [[[self mapView] mapView] animateToViewingAngle:[TiUtils doubleValue:[value objectAtIndex:0]]];
}

- (id)indoorDisplay
{
    return [[TiGooglemapsIndoorDisplayProxy alloc] _initWithPageContext:[self pageContext] andIndoorDisplay:[[[self mapView] mapView] indoorDisplay]];
}

@end
