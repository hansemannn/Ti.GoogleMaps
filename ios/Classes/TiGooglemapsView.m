/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsView.h"
#import "TiGooglemapsViewProxy.h"
#import "TiGooglemapsAnnotationProxy.h"
#import "TiGooglemapsCircleProxy.h"
#import "TiGooglemapsPolygonProxy.h"
#import "TiGooglemapsPolylineProxy.h"
#import "TiGooglemapsConstants.h"
#import "TiClusterIconGenerator.h"
#import "TiClusterRenderer.h"
#import "TiPOIItem.h"
#import "TiGooglemapsClusterItemProxy.h"

@implementation TiGooglemapsView

- (GMSMapView *)mapView
{
    if (_mapView == nil) {

        _mapView = [[GMSMapView alloc] initWithFrame:[self bounds]];
        [_mapView setDelegate:self];
        [_mapView setAutoresizingMask:UIViewAutoresizingNone];

        [self addSubview:_mapView];
    }

    return _mapView;
}

- (GMUClusterManager *)clusterManager
{
    if (_clusterManager == nil) {
        // Set up the cluster manager with default icon generator and renderer.
        id<GMUClusterAlgorithm> algorithm = [[GMUNonHierarchicalDistanceBasedAlgorithm alloc] init];

        TiClusterIconGenerator *iconGenerator = [self createIconGenerator];

        TiClusterRenderer *renderer = [[TiClusterRenderer alloc] initWithMapView:_mapView clusterIconGenerator:iconGenerator];
        renderer.delegate = self;

        _clusterManager = [[GMUClusterManager alloc] initWithMap:[self mapView] algorithm:algorithm renderer:renderer];
        [_clusterManager setDelegate:self mapDelegate:self];
    }

    return _clusterManager;
}

- (void)renderer:(id<GMUClusterRenderer>)renderer willRenderMarker:(GMSMarker *)marker
{
    if ([[marker userData] isKindOfClass:[TiPOIItem class]]) {
        TiPOIItem *item = (TiPOIItem *)[marker userData];

        // Note: All native props are nullable, so we don't need to check against nil here

        [marker setTitle:item.title];

        [marker setSnippet:item.subtitle];

        [marker setIcon:item.icon];
    }
}

- (TiClusterIconGenerator *)createIconGenerator
{
    id clusterRanges = [[self proxy] valueForKey:@"clusterRanges"];
    id clusterBackgrounds = [[self proxy] valueForKey:@"clusterBackgrounds"];

    if (clusterRanges && clusterBackgrounds) {
        NSMutableArray *backgrounds = [NSMutableArray array];

        for (id background in clusterBackgrounds) {
            ENSURE_TYPE(background, NSString);
            UIImage *clusterBackground = [TiUtils image:background proxy:self.proxy];

            if (!clusterBackground) {
                NSLog(@"[ERROR] Cluster background-file (%@) cannot be found, skipping ...");
                continue;
            }

            [backgrounds addObject:clusterBackground];
        }

        return [[TiClusterIconGenerator alloc] initWithBuckets:clusterRanges backgroundImages:backgrounds];
    } else if (clusterRanges) {
        return [[TiClusterIconGenerator alloc] initWithBuckets:clusterRanges];
    }

    return [[TiClusterIconGenerator alloc] init];
}

- (TiGooglemapsViewProxy *)mapViewProxy
{
    return (TiGooglemapsViewProxy *)[self proxy];
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [TiUtils setView:_mapView positionRect:bounds];
    [super frameSizeChanged:frame bounds:bounds];
}

#pragma mark Cluster Delegates

- (void)clusterManager:(GMUClusterManager *)clusterManager didTapCluster:(id<GMUCluster>)cluster
{
    if ([[self proxy] _hasListeners:@"clusterclick"]) {
        [[self proxy] fireEvent:@"clusterclick" withObject:@{
            @"latitude": NUMDOUBLE(cluster.position.latitude),
            @"longitude": NUMDOUBLE(cluster.position.longitude),
            @"count": NUMUINTEGER(cluster.count),
            @"clusterItems": [self arrayFromClusterItems:cluster.items]
        }];
    }

    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithTarget:cluster.position zoom:_mapView.camera.zoom + 1];
    [_mapView moveCamera:[GMSCameraUpdate setCamera:newCamera]];
}

- (void)clusterManager:(GMUClusterManager *)clusterManager didTapClusterItem:(id<GMUClusterItem>)clusterItem
{
    if ([[self proxy] _hasListeners:@"clusteritemclick"]) {
        [[self proxy] fireEvent:@"clusteritemclick" withObject:@{
            @"latitude": NUMDOUBLE(clusterItem.position.latitude),
            @"longitude": NUMDOUBLE(clusterItem.position.longitude),
            @"title": [(TiPOIItem *)clusterItem title] ?: [NSNull null],
            @"subtitle": [(TiPOIItem *)clusterItem subtitle] ?: [NSNull null],
            @"userData": [(TiPOIItem *)clusterItem userData] ?: [NSNull null]
        }];
    }
}

#pragma mark Map View Delegates

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if ([[self proxy] _hasListeners:@"regionwillchange"]) {
        [[self proxy] fireEvent:@"regionwillchange" withObject:@{
            @"map" : [self proxy],
            @"latitude" : NUMDOUBLE(mapView.camera.target.latitude),
            @"longitude" : NUMDOUBLE(mapView.camera.target.longitude),
            @"gesture" : NUMBOOL(gesture)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{    
    GMSVisibleRegion visibleRegion = [mapView.projection visibleRegion];
    
    float latitudeDelta = visibleRegion.farRight.latitude - visibleRegion.nearRight.latitude;
    float longitudeDelta = visibleRegion.farRight.longitude - visibleRegion.nearLeft.longitude;
    
    //Updating all polylines strokes
    NSMutableArray* overlays = ((TiGooglemapsViewProxy *)[self proxy]).overlays;
    NSArray* filtered = [overlays filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", [TiGooglemapsPolylineProxy class]]];
    
    if (filtered.count > 0) {
        float scale = 1.0/[mapView.projection pointsForMeters:1 atCoordinate:mapView.camera.target];
        
        for (TiGooglemapsPolylineProxy* polyline in filtered)
            [polyline updatePattern:scale];
    }

    if ([[self proxy] _hasListeners:@"regionchanged"]) {
        NSMutableDictionary *updatedRegion = [NSMutableDictionary dictionaryWithDictionary:@{
            @"latitude" : NUMDOUBLE(position.target.latitude),
            @"longitude" : NUMDOUBLE(position.target.longitude),
            @"latitudeDelta": NUMDOUBLE(latitudeDelta),
            @"longitudeDelta": NUMDOUBLE(longitudeDelta),
            @"zoom": NUMFLOAT(position.zoom),
            @"bearing": NUMDOUBLE(position.bearing),
            @"viewingAngle": NUMDOUBLE(position.viewingAngle)
        }];

        [(TiGooglemapsViewProxy *)[self proxy] replaceValue:updatedRegion forKey:@"region" notification:NO];

        NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:updatedRegion];
        [event setObject:[self proxy] forKey:@"map"];

        [[self proxy] fireEvent:@"regionchanged" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    if ([[self proxy] _hasListeners:@"idle"]) {
        [[self proxy] fireEvent:@"idle" withObject:[self dictionaryFromCameraPosition:position]];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": @"map",
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(coordinate.latitude),
            @"longitude": NUMDOUBLE(coordinate.longitude)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ([[self proxy] _hasListeners:@"longclick"]) {
        [[self proxy] fireEvent:@"longclick" withObject:@{
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(coordinate.latitude),
            @"longitude": NUMDOUBLE(coordinate.longitude)
        }];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": @"pin",
            @"annotation": [self dictionaryFromMarker:marker],
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(marker.position.latitude),
            @"longitude": NUMDOUBLE(marker.position.longitude)
        }];
    }

    return NO;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": @"infoWindow",
            @"annotation": [self dictionaryFromMarker:marker],
            @"map": [self proxy],
            @"latitude": NUMDOUBLE(marker.position.latitude),
            @"longitude": NUMDOUBLE(marker.position.longitude)
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay
{
    if ([[self proxy] _hasListeners:@"overlayclick"]) {
        [[self proxy] fireEvent:@"overlayclick" withObject:@{
            @"overlay": [self overlayProxyFromOverlay:overlay]
        }];
    }
    if ([[self proxy] _hasListeners:@"click"]) {
        [[self proxy] fireEvent:@"click" withObject:@{
            @"clicksource": [self overlayTypeFromOverlay:overlay],
            @"map": [self proxy],
            @"overlay": [self overlayProxyFromOverlay:overlay]
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragstart"]) {
        NSDictionary *event = @{
            @"annotation" : [self dictionaryFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragstart" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragend"]) {
        NSDictionary *event = @{
            @"annotation" : [self dictionaryFromMarker:marker]
        };
      [[self proxy] fireEvent:@"dragend" withObject:event];
    }
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    if ([[self proxy] _hasListeners:@"dragmove"]) {
        NSDictionary *event = @{
            @"annotation" : [self dictionaryFromMarker:marker]
        };
        [[self proxy] fireEvent:@"dragmove" withObject:event];
    }
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    TiGooglemapsAnnotationProxy *annotation = nil;

    for (TiGooglemapsAnnotationProxy *proxy in [(TiGooglemapsViewProxy *)[self proxy] markers]) {
        if ([[[[proxy marker] userData] objectForKey:@"uuid"] isEqualToString:[[marker userData] objectForKey:@"uuid"]]) {
            annotation = proxy;
            [annotation rememberSelf];
        }
    }

    if (!annotation) {
        return nil;
    }

    return [[annotation infoWindow] view];
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    if ([[self proxy] _hasListeners:@"locationclick"]) {
        NSDictionary *event = @{
            @"map" : [self proxy]
        };
        [[self proxy] fireEvent:@"locationclick" withObject:event];
    }
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView
{
    if ([[self proxy] _hasListeners:@"complete"]) {
        [[self proxy] fireEvent:@"complete"];
    }
}

#pragma mark Helper

- (NSDictionary *)dictionaryFromCameraPosition:(GMSCameraPosition *)position
{
    if (position == nil) {
        return @{};
    }

    return @{
       @"latitude" : NUMDOUBLE(position.target.latitude),
       @"longitude" : NUMDOUBLE(position.target.longitude),
       @"zoom" : NUMFLOAT(position.zoom),
       @"viewingAngle" : NUMDOUBLE(position.viewingAngle),
       @"bearing" : NUMDOUBLE([position bearing])
    };
}

- (NSDictionary *)dictionaryFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    return @{
        @"latitude": NUMDOUBLE(coordinate.latitude),
        @"longitude": NUMDOUBLE(coordinate.longitude)
    };
}

- (NSDictionary *)dictionaryFromMarker:(GMSMarker *)marker
{
    if (!marker) {
        return @{};
    }

    return @{
        @"latitude": NUMDOUBLE(marker.position.latitude),
        @"longitude": NUMDOUBLE(marker.position.longitude),
        @"userData": marker.userData ?: [NSNull null],
        @"title": marker.title ?: [NSNull null],
        @"subtitle": marker.snippet ?: [NSNull null]
    };
}

- (id)overlayTypeFromOverlay:(GMSOverlay *)overlay
{
    ENSURE_UI_THREAD(overlayTypeFromOverlay, overlay);

    if ([overlay isKindOfClass:[GMSPolygon class]]) {
        return NUMINTEGER(TiGooglemapsOverlayTypePolygon);
    } else if ([overlay isKindOfClass:[GMSPolyline class]]) {
        return NUMINTEGER(TiGooglemapsOverlayTypePolyline);
    } else if ([overlay isKindOfClass:[GMSCircle class]]) {
        return NUMINTEGER(TiGooglemapsOverlayTypeCircle);
    }

    NSLog(@"[ERROR] Unknown overlay provided: %@", [overlay class])

    return NUMINTEGER(TiGooglemapsOverlayTypeUnknown);
}

- (id)overlayProxyFromOverlay:(GMSOverlay *)overlay
{
    for (TiProxy *overlayProxy in [[self mapViewProxy] overlays]) {
        // Check for polygons
        if ([overlay isKindOfClass:[GMSPolygon class]] && [overlayProxy isKindOfClass:[TiGooglemapsPolygonProxy class]]) {
            if ([(TiGooglemapsPolygonProxy *)overlayProxy polygon] == overlay) {
                return (TiGooglemapsPolygonProxy *)overlayProxy;
            }

        // Check for polylines
        } else if ([overlay isKindOfClass:[GMSPolyline class]] && [overlayProxy isKindOfClass:[TiGooglemapsPolylineProxy class]]) {
            if ([(TiGooglemapsPolylineProxy *)overlayProxy polyline] == overlay) {
                return (TiGooglemapsPolylineProxy *)overlayProxy;
            }

        // Check for circles
        } else if ([overlay isKindOfClass:[GMSCircle class]] && [overlayProxy isKindOfClass:[TiGooglemapsCircleProxy class]]) {
            if ([(TiGooglemapsCircleProxy *)overlayProxy circle] == overlay) {
                return (TiGooglemapsCircleProxy *)overlayProxy;
            }
        }
    }

    return [NSNull null];
}

- (NSArray *)arrayFromClusterItems:(NSArray<id<GMUClusterItem>> *)clusterItems
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:clusterItems.count];

    for (id<GMUClusterItem> clusterItem in clusterItems) {
        [result addObject:[[TiGooglemapsClusterItemProxy alloc] _initWithPageContext:[[self proxy] pageContext]
                                                                          andPosition:clusterItem.position
                                                                                title:[(TiPOIItem *)clusterItem title]
                                                                             subtitle:[(TiPOIItem *)clusterItem subtitle]
                                                                                 icon:[(TiPOIItem *)clusterItem icon]
                                                                             userData:[(TiPOIItem *)clusterItem userData]]];
    }

    return result;
}

#pragma mark Constants

MAKE_SYSTEM_PROP(OVERLAY_TYPE_POLYGON, TiGooglemapsOverlayTypePolygon);
MAKE_SYSTEM_PROP(OVERLAY_TYPE_POLYLINE, TiGooglemapsOverlayTypePolyline);
MAKE_SYSTEM_PROP(OVERLAY_TYPE_CIRCLE, TiGooglemapsOverlayTypeCircle);

@end
