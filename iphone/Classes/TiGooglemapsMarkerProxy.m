/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiGooglemapsMarkerProxy.h"
#import "TiUtils.h"

@implementation TiGooglemapsMarkerProxy

@synthesize marker = _marker;

-(GMSMarker*)marker
{
    if (_marker == nil) {
        _marker = [[GMSMarker alloc] init];
        
        [_marker setPosition:CLLocationCoordinate2DMake([TiUtils doubleValue:[self valueForKey:@"latitude"]],[TiUtils doubleValue:[self valueForKey:@"longitude"]])];
    }
    
    return _marker;
}

-(void)setMarker:(GMSMarker*)marker
{
    if (_marker) {
        RELEASE_TO_NIL(_marker);
    }
    
    _marker = marker;
    [self marker];
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark Public API's

-(void)setTitle:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setTitle:[TiUtils stringValue:value]];
}

-(NSString*)title
{
    return [[self marker] title];
}

-(void)setSnippet:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setSnippet:[TiUtils stringValue:value]];
}

-(NSString*)snippet
{
    return [[self marker] snippet];
}

-(void)setIcon:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setIcon:[TiUtils image:value proxy:self]];
}

-(TiBlob*)icon
{
    return [[TiBlob alloc] initWithImage:[[self marker] icon]];
}

-(void)setTappable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setTappable:[TiUtils boolValue:value def:YES]];
}

-(NSNumber*)tappable
{
    return NUMBOOL([[self marker] isTappable]);
}

-(void)setFlat:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setFlat:[TiUtils boolValue:value def:NO]];
}

-(NSNumber*)flat
{
    return NUMBOOL([[self marker] isFlat]);
}

-(void)setGroundAnchor:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [_marker setGroundAnchor:CGPointMake([TiUtils doubleValue:[value valueForKey:@"x"]],[TiUtils doubleValue:[value valueForKey:@"y"]])];
}

-(void)setRotation:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setRotation:[TiUtils doubleValue:value def:0]];
}

-(NSNumber*)rotation
{
    return NUMBOOL([[self marker] rotation]);
}

-(void)setDraggable:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setDraggable:[TiUtils boolValue:value def:NO]];
}

-(NSNumber*)draggable
{
    return NUMBOOL([[self marker] isDraggable]);
}

-(void)setUserData:(id)value
{
    ENSURE_UI_THREAD_1_ARG(value);
    [[self marker] setUserData:value];
}

-(id)userData
{
    return [[self marker] userData];
}

@end
