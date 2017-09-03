/**
 * Ti.GoogleMaps
 * Copyright (c) 2015-Present by Hans Knoechel, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import <GooglePlacePicker/GooglePlacePicker.h>

@interface TiGooglemapsPlacePickerDialogProxy : TiProxy<GMSPlacePickerViewControllerDelegate> {
    GMSPlacePickerViewController *dialog;
}

- (void)open:(id)args;

- (void)configure:(id)value;

@end
