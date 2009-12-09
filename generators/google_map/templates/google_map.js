function upIt(string_or_null) {
	if(string_or_null) {
		return string_or_null.toUpperCase();
	} else {
		return null;
	}
}

function makePosition(options) {
	return google.maps.ControlPosition[upIt(options.position) || 'TOP_LEFT'];
}

function makeMapTypeControlOptions(options) {
	if(options) {
		mapControl = {};
		mapControl.position = makePosition(options);
		mapControl.style = google.maps.MapTypeControlStyle[upIt(options.style) || 'DEFAULT'];
		return mapControl;
	} else {
		return null;
	}
}

function makeNavigationControlOptions(options) {
	if(options) {
		navControl = {};
		navControl.position = makePosition(options);
		navControl.style = google.maps.NavigationControlStyle[upIt(options.style) || 'DEFAULT'];
		return navControl;
	} else {
		return null;
	}
}

function makeScaleControlOptions(options) {
	if(options) {
		scaleControl = {};
		scaleControl.position = makePosition(options);
		scaleControl.style = google.maps.ScaleControlStyle[upIt(options.style) || 'DEFAULT'];
		return scaleControl;
	} else {
		return null;
	}
}

function generateGmap(lat, lng, element_id, mapOptions) {
	var latlng = new google.maps.LatLng(lat, lng);
	
	// setup some of the options that cannot be passed in as strings
	mapOptions.mapTypeId = google.maps.MapTypeId[upIt(mapOptions.mapTypeId) || 'ROADMAP'];
	mapOptions.mapTypeControlOptions = makeMapTypeControlOptions(mapOptions.mapTypeControlOptions);
	mapOptions.navigationControlOptions = makeNavigationControlOptions(mapOptions.navigationControlOptions);
	mapOptions.scaleControlOptions = makeScaleControlOptions(mapOptions.scaleControlOptions);
	mapOptions.zoom = mapOptions.zoom || 8
	mapOptions.center = latlng;
	
	var map = new google.maps.Map(document.getElementById(element_id), mapOptions);
}