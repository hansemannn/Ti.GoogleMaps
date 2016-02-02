var win = Ti.UI.createWindow();
var maps = require("tigooglemaps");
maps.setAPIKey("<YOUR_GOOGLE_MAPS_API_KEY>");

/*
 *  Test data
 */
var companies = {
    appcelerator: {
        title: "Appcelerator",
        city: "San Jose, CA",
        latitude: 37.368122,
        longitude: -121.913653,
		groundAnchor: {x:0.5, y:0.5},
        rotation: 90
    },
    apple: {
        title: "Apple",
        city: "Cupertino, CA",
        latitude: 37.4028218,
        longitude: -122.1675878
    },
    facebook: {
        title: "Facebook",
        city: "Menlo Park, CA",
        latitude: 37.4748624,
        longitude: -122.1490817
    },
    microsoft: {
        title: "Microsoft",
        city: "Redmond, WA",
        latitude: 47.641959,
        longitude: -122.130588
    }
};

/*
 *  MapView
 */
var mapView = maps.createMapView({
    mapType: maps.MAP_TYPE_TERRAIN,
    camera: {
        latitude: companies.appcelerator.latitude,
        longitude: companies.appcelerator.longitude,
        zoom: 10
    }
});

/*
 * Events
 */
function handleClickEvent(e) {
    Ti.API.warn("\"click\" event fired!");
    Ti.API.warn(e);
}

function handleLongpressEvent(e) {
    Ti.API.warn("\"longpress\" event fired!");
    Ti.API.warn(e);
}

function handlerMarkerClickEvent(e) {
    Ti.API.warn("\"markerclick\" event fired!");
    Ti.API.warn(e);
}

function handleWillMoveEvent(e) {
    Ti.API.warn("\"willmove\" event fired!");
    Ti.API.warn(e);
}

function handleCameraChangeEvent(e) {
    Ti.API.warn("\"camerachange\" event fired!");
    Ti.API.warn(e);
}

function handleIdleEvent(e) {
    Ti.API.warn("\"idle\" event fired!");
    Ti.API.warn(e);
}

function handleMarkerInfoClickEvent(e) {
    Ti.API.warn("\"markerinfoclick\" event fired!");
    Ti.API.warn(e);
}

function handleOverlayClickEvent(e) {
    Ti.API.warn("\"overlayclick\" event fired!");
    Ti.API.warn(e);
}

function handleDragStartEvent(e) {
    Ti.API.warn("\"dragstart\" event fired!");
    Ti.API.warn(e);
}

function handleDragMoveEvent(e) {
    Ti.API.warn("\"dragmove\" event fired!");
    Ti.API.warn(e);
}

function handleDragEndEvent(e) {
    Ti.API.warn("\"dragend\" event fired!");
    Ti.API.warn(e);
}

function handleLocationClickEvent(e) {
    Ti.API.warn("\"locationclick\" event fired!");
    Ti.API.warn(e);
}

mapView.addEventListener("click", handleClickEvent);
mapView.addEventListener("longpress", handleLongpressEvent);
mapView.addEventListener("markerclick", handlerMarkerClickEvent);
mapView.addEventListener("willmove", handleWillMoveEvent);
mapView.addEventListener("camerachange", handleCameraChangeEvent);
mapView.addEventListener("idle", handleIdleEvent);
mapView.addEventListener("markerinfoclick", handleMarkerInfoClickEvent);
mapView.addEventListener("overlayclick", handleOverlayClickEvent);
mapView.addEventListener("dragstart", handleDragStartEvent);
mapView.addEventListener("dragmove", handleDragMoveEvent);
mapView.addEventListener("dragend", handleDragEndEvent);
mapView.addEventListener("locationclick", handleLocationClickEvent);

/*
 *  Marker
 */
for (var key in companies) {
    if (companies.hasOwnProperty(key)) {
        var company = companies[key];

        var marker = maps.createMarker({
            latitude: company.latitude,
            longitude: company.longitude,
            title: company.title,
            snippet: company.city
        });

        mapView.addMarker(marker);

        Ti.API.warn(key + ": " + company.title + " (" + company.city + ")");
    }
}

// mapView.addMarkers([marker]);
// mapView.removeMarker(marker);

/*
 *  Overlays - Polyline
 */
var polyline = maps.createPolyline({
    points: [{ // Can handle both object and array
        latitude: companies.appcelerator.latitude,
        longitude: companies.appcelerator.longitude,
    },{
        latitude: companies.microsoft.latitude,
        longitude: companies.microsoft.longitude,
    }],
    strokeWidth: 3,
    strokeColor: "#00adef"
});

mapView.addPolyline(polyline);
// mapView.removePolyline(polyline);

/*
 *  Overlays - Polygon
 */
var polygon = maps.createPolygon({
    points: [ // Can handle both object and array
        {
            latitude: companies.appcelerator.latitude,
            longitude: companies.appcelerator.longitude,
        },
        [companies.apple.latitude, companies.apple.longitude],
        [companies.facebook.latitude, companies.facebook.longitude]
    ],
    strokeWidth: 3,
    fillColor: 'rgba(160,26,32,0.2)', // RGB color with alpha transparency
    strokeColor: "#a01a20"
});

mapView.addPolygon(polygon);
// mapView.removePolygon(polygon);

/*
 *  Overlays - Circle
 */
var circle = maps.createCircle({
    center: [companies.appcelerator.latitude, companies.appcelerator.longitude], // Can handle both object and array
    radius: 5 * 1000, // 5km
    // fillColor: "green",
    strokeWidth: 3,
    strokeColor: "#a01a20"
});

mapView.addCircle(circle);
// mapView.removeCircle(circle);

win.add(mapView);
win.open();
