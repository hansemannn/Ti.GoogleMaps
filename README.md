# Ti.GoogleMaps


<img width="1094" src="http://abload.de/img/showcase3vron.png">

 Summary
---------------
Ti.GoogleMaps is an open-source project to support the Google Maps SDK for iOS on Appcelerator's Titanium Mobile. The module currently supports the following API's:
- [x] Map View
- [x] Marker
- [x] Polygon overlay
- [x] Polyline overlay
- [x] Circle overlay
- [x] All delegates (exposed as events)

Requirements
---------------
  - Titanium Mobile SDK 5.0.2.GA or later
  - iOS 7.1 or later
  - Xcode 6.4 or later

Download + Setup
---------------

### Download
  * [Stable release](https://github.com/hansemannn/Ti.GoogleMaps/releases)
  * Install from gitTio    <a href="http://gitt.io/component/ti.googlemaps" target="_blank"><img src="http://gitt.io/badge@2x.png" width="120" height="18" alt="Available on gitTio" /></a>

### Setup
Unpack the module and place it inside the `modules/iphone/` folder of your project.
Edit the modules section of your `tiapp.xml` file to include this module:
```xml
<modules>
    <module platform="iphone">ti.googlemaps</module>
</modules>
```

> **NOTE:** There is an issue in the Titanium Mobile SDK (5.2.0.GA) which prevents module developers from copying assets to the application. If you use Ti.SDK < 5.2.0.GA you can use the module just like before, if you use Ti.SDK 5.2.0.GA you can already use the latest module version (2.1.0) and upgrade to 5.2.1.GA asap. The SDK issue can be tracked [here](https://jira.appcelerator.org/browse/TIMOB-20489). Thank you!

Initialize the module by setting the Google Maps API key you can get from [here](https://developers.google.com/maps/signup).
```javascript
var maps = require("ti.googlemaps");
maps.setAPIKey("<YOUR_API_KEY>");
```

### Build
If you want to build the module from the source, you need to check some things beforehand:
- The latest GoogleMaps.framework is > 100 MB, so Github won't allow pushing it to the repository. So you need to get the [latest Google Maps iOS](https://developers.google.com /maps/documentation/ios-sdk/) and copy it into `/ios/platform/GoogleMaps.framework`. 
- Make sure to link the framework in "Build Phases" -> "Link Binary With Libraries" -> Select "GoogleMaps.framework"
- Set the `TITANIUM_SDK_VERSION` inside the `ios/titanium.xcconfig` file to the Ti.SDK version you want to build with.
- Build the project using the `ios/build.py` with `python [path/to/module]/ios/build.py` for Ti.SDK < 5.2.0 and `ti build -p ios --build-only` for Ti.SDK >= 5.2.1
- Check the [releases tab](https://github.com/hansemannn/ti.googlemaps/releases) for stable pre-packaged versions of the module

Features
--------------------------------
#### Map View
A map view creates the view on which marker and overlays can be added to. You can see all possible events in the demo app. In addition, you can specify one of the following constants to the `mapType` property:
 - ``MAP_TYPE_NORMAL``
 - ``MAP_TYPE_HYBRID``
 - ``MAP_TYPE_SATELLITE``
 - ``MAP_TYPE_TERRAIN``
 - ``MAP_TYPE_NONE``

```javascript
var mapView = maps.createMapView({
    mapType: maps.MAP_TYPE_TERRAIN,
    camera: { // Camera center of the map
        latitude: 37.368122,
        longitude: -121.913653,
        zoom: 10, // Zoom in points
		bearing: 0, // Map angle
		viewingAngle: 0 // Map Tilting
    }
});
```

Animate to a location:
```javascript
mapView.animateToLocation({
    latitude: 36.368122,
    longitude: -120.913653
});
```

Animate to a zoom level:
```javascript
mapView.animateToZoom(5);
```

Animate to a location:
```javascript
mapView.animateToBearing(0);
```

Animate to a viewing angle:
```javascript
mapView.animateToViewingAngle(30);

```

#### Marker
A marker represents a location specified by at least a `title` and a `snippet` property. It can be added to a map view:

```javascript
var marker = maps.createMarker({
    latitude : 37.368122,
    longitude : -121.913653,
    title : "Appcelerator, Inc",
    snippet : "1732 N. 1st Street, San Jose",
    pinColor: "green", // Default: Undefined
    image: "pin.png", // Default: Undefined
    tappable: true, // Default: true
    draggable: true, // Default: false
    flat: true, // Default: false
    infoWindowAnchor: { // Default: {x:0,y:0}
        x: 0.5,
        y: 0
    },
    groundAnchor: { // Anchor point for rotations Default: {x:0,y:0}
        x: 0.5,
        y: 0.5
    },
    rotation: 90, // in degrees
    userData: { // Default: Undefined
        id: 123,
        custom_key: "custom_value"
    }
});
mapView.addMarker(marker);
```

You also can add multiple markers as well as remove markers again:
```javascript
mapView.addMarkers([marker1,marker2,marker3]);
mapView.removeMarker(marker4);
```

You can select and deselect marker, as well as receive the currently selected marker:
```javascript
mapView.selectMarker(marker1); // Select
mapView.deselectMarker(); // Deselect
var selectedMarker = mapView.getSelectedMarker(); // Selected marker, null if no marker selected
```

#### Overlays
Overlays can be added to the map view just like markers. The module supports the methods ``addPolygon``, ``addPolyline`` and ``addCircle`` to add overlays and ``removePolygon``, ``removePolyline`` and ``removeCircle`` to remove them.

##### Polyline
A polyline is a shape defined by its ``points`` property. It needs at least 2 points to draw a line.

```javascript
var polyline = maps.createPolyline({
    points : [{ // Can handle both object and array
        latitude : -37.81319,
	    longitude : 144.96298
    }, [-31.95285, 115.85734]],
    strokeWidth : 3, // Default: 1
    strokeColor : "#f00"  // Default: Black (#000000)
});
mapView.addPolyline(polyline);
```

##### Polygon
A polygon is a shape defined by its ``points`` property. It behaves similiar to a polyline, but is meant to close its area automatically and also supports the ``fillColor`` property.

```javascript
var polygon = maps.createPolygon({
    points : [{ // Can handle both object and array
        latitude : -37.81819,
        longitude : 144.96798
    },
    [-32.95785, 115.86234],
    [-33.91785, 115.82234]],
    strokeWidth : 3,
    fillColor : "yellow", // Default: Blue (#0000ff)
    strokeColor : "green"
});
mapView.addPolygon(polygon);
```

##### Circle
A circle is a shape defined by the `center` property to specify its location as well as the ``radius` in meters.

```javascript
var circle = maps.createCircle({
    center : [-32.9689, 151.7721], // Can handle object or array
    radius : 500 * 1000, // 500km, Default: 0
    fillColor: "blue", // Default: transparent
    strokeWidth : 3,
    strokeColor : "orange"
});
mapView.addCircle(circle);
````

#### Events
The module supports all native delegates - exposed as events. These are:

- [x] click
- [x] overlayclick
- [x] locationclick
- [x] longpress
- [x] markerclick
- [x] markerinfoclick
- [x] camerachange
- [x] willmove
- [x] idle
- [x] dragstart
- [x] dragmove
- [x] dragend

#### Example
For a full example, check the demo in `iphone/example/app.js`.

Author
---------------
Hans Knoechel ([@hansemannnn](https://twitter.com/hansemannnn) / [Web](http://hans-knoechel.de))

License
---------------
MIT

Contributing
---------------
Code contributions are greatly appriciated, please submit a pull request!
