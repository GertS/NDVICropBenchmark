$( document ).ready(function() {
    console.log( "ready to execute the code" );
    var basemapNr = 5;
    var initLocation = {
    	lat: 52.995687, 
    	lng: 7.037513,
    	zoomLevel: 14, 

    };
    map = initBaseMap(basemapNr,initLocation);
	
	    $.getJSON("http://gerts.github.io/NDVICropBenchmark/webpageData/parcelsStadskanaalWGS84.GeoJSON", function(data) {
		
		// alert("geojson file loaded");
		
		//When GeoJSON is loaded
		var geojsonLayer = new L.GeoJSON(data,{
		    "color": "#64FE2E",
		    "weight": 2,
		    "opacity": 0.4,
			onEachFeature: onEachFeature
		});		//New GeoJSON layer
		map.addLayer(geojsonLayer);			//Add layer to map	

	});

 //    $.ajax({
	//     type: "POST",
	//     url: "../webpageData/parcelsStadskanaalWGS84.GeoJSON",
	//     dataType: 'json',
	//     success: function (response) {
	//         geojsonLayer = L.geoJson(response).addTo(map);
	//         map.fitBounds(geojsonLayer.getBounds());
	//     }
	// });

	// L.geoJson("../webpageData/parcelsStadskanaalWGS84.GeoJSON").addTo(map);
	// var parcelsLayer = new L.GeoJSON("../webpageData/parcelsStadskanaalWGS84.GeoJSON");
	// parcelsLayer.addTo(map);
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
function onEachFeature(feature,layer){// does this feature have a property named popupContent?
    var id = feature.properties.id;
    var gewas = feature.properties.GWS_GEWAS;
    var gewasL= gewas.split(",");
    if (gewasL.length == 2){gewas = gewasL[1]+gewasL[0]}
    var opp = Math.floor(feature.properties.GEOMETRIE_Area/1000)/10; //to hectares with one decimal
	
	// data = {
	// 	labels:["2015-03-08", "2015-03-12", "2015-04-20", "2015-05-24", "2015-06-05", "2015-07-01" ,"2015-07-02", "2015-08-03", "2015-08-07", "2015-08-23", "2015-10-11", "2015-10-25"],
	// 	datasets: [
 //        {
 //            label: "My First dataset",
 //            fillColor: "rgba(220,220,220,0.2)",
 //            strokeColor: "rgba(220,220,220,1)",
 //            pointColor: "rgba(220,220,220,1)",
 //            pointStrokeColor: "#fff",
 //            pointHighlightFill: "#fff",
 //            pointHighlightStroke: "rgba(220,220,220,1)",
 //            data: [0.5275591 , 0.4625984 , 0.7047244,  0.8877953,  0.4842520,  0.5787402 , 0.6476378 , 0.4921260,  0.5807087,  0.4881890 , 0.9350394,0.9822835 ]
 //        }]
	// };

  	layer.bindPopup(gewas+": "+opp+" ha");
  	//TODO:
  	//instead of this create in the area at the left of the page a chart
}
var fieldRanks;
$.getJSON("http://gerts.github.io/NDVICropBenchmark/webpageData/ranksStadskanaal.json",function(json){
	fieldRanks = json;
});



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