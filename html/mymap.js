$( document ).ready(function() {
    console.log( "ready to execute the code" );
    var basemapNr = 5;
    var initLocation = {
    	lat: 52.995687, 
    	lng: 7.037513,
    	zoomLevel: 14, 

    };
    map = initBaseMap(basemapNr,initLocation);
	
	// map.on('click', function(e) {
	// 	pass;
 //    });
});


function listAvailableBasemaps(){
	/**
	* lists the basemaps which can be used
	*/
	// free basemap providers: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
	var Thunderforest_TransportDark = L.tileLayer('http://{s}.tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png', {
		attribution: '&copy; <a href="http://www.opencyclemap.org">OpenCycleMap</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
		maxZoom: 19
	});
	var Thunderforest_Landscape = L.tileLayer('http://{s}.tile.thunderforest.com/landscape/{z}/{x}/{y}.png', {
		attribution: '&copy; <a href="http://www.opencyclemap.org">OpenCycleMap</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	});
	var Hydda_Full = L.tileLayer('http://{s}.tile.openstreetmap.se/hydda/full/{z}/{x}/{y}.png', {
		attribution: 'Tiles courtesy of <a href="http://openstreetmap.se/" target="_blank">OpenStreetMap Sweden</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
	});
	var Stamen_Toner = L.tileLayer('http://stamen-tiles-{s}.a.ssl.fastly.net/toner/{z}/{x}/{y}.{ext}', {
		attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
		subdomains: 'abcd',
		minZoom: 0,
		maxZoom: 20,
		ext: 'png'
	});
	var CartoDB_DarkMatter = L.tileLayer('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', {
		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
		subdomains: 'abcd',
		maxZoom: 19
	});
	var OpenStreetMap_HOT = L.tileLayer('http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png', {
		maxZoom: 19,
		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, Tiles courtesy of <a href="http://hot.openstreetmap.org/" target="_blank">Humanitarian OpenStreetMap Team</a>'
	});

	var basemaps = [Thunderforest_TransportDark,Thunderforest_Landscape,Hydda_Full,Stamen_Toner,CartoDB_DarkMatter,OpenStreetMap_HOT];	
	return basemaps;
}
function initBaseMap(basemapNr,initLocation){
	/**
	* Loads the basemap and shows it on the screen.
	* The basemapNR is the basemap fetched from listAvailableBasemaps()
	*/
	var basemap = listAvailableBasemaps()[basemapNr];
	var map = L.map('map').setView([initLocation.lat,initLocation.lng],initLocation.zoomLevel);
	basemap.addTo(map);
	return map;
}

// spinner stuff:
$body = $("body");

$(document).on({
    ajaxStart: function() { $body.addClass("loading");    },
    ajaxStop: function() { $body.removeClass("loading"); }    
});

$(document).on({
    ajaxStart: function() { $body.addClass("loading");    },
    ajaxStop: function() { $body.removeClass("loading"); }    
});