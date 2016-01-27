$( document ).ready(function() {
    console.log( "ready to execute the code" );
    var basemapNr = 5;
    var initLocation = {
    	lat: 52.995687, 
    	lng: 7.037513,
    	zoomLevel: 14, 

    };
    map = initBaseMap(basemapNr,initLocation);
	



});

function loadPolygons(){
    $.getJSON("http://gerts.github.io/NDVICropBenchmark/webpageData/parcelsStadskanaalWGS84.GeoJSON", function(data) {
		
		// alert("geojson file loaded");
		
		//When GeoJSON is loaded
		L.geoJson(data, {style: style,onEachFeature:onEachFeature}).addTo(map);

	});	
}

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
Object.values = obj => Object.keys(obj).map(key => obj[key]);

function getRankData(id){
	ranks = fieldRanks[id];
	labels = Object.keys(ranks);
	datasetsData = Object.values(ranks);
	data = {
		labels:labels,
		datasets: [
        {
            label: "Plaats tenopzichte van andere percelen met hetzelfde gewas",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: datasetsData
        }]
	};
	return data;
}
function getSummerRank(id){
	ranks = fieldRanks[id]
	length = Object.keys(ranks).length;
	datasetsData = Object.values(ranks)	
	return datasetsData[Math.floor(length/2)];
}

function whenClicked(e) {
	// e = event
	var properties = e.target.feature.properties;
	var id = properties.id;
	var gewas = properties.GWS_GEWAS;
	var gewasL= gewas.split(",");
	if (gewasL.length == 2){gewas = gewasL[1]+gewasL[0]}
	var opp = Math.floor(properties.GEOMETRIE_Area/1000)/10; //to hectares with one decimal  
	// You can make your ajax call declaration here
	//$.ajax(...
	$('#parcelInfo').html(gewas+": "+opp+" ha");
	// console.log(gewas+": "+opp+" ha"); 
	var ctx = $("#chartArea").get(0).getContext("2d");
	var myNewChart = new Chart(ctx);
	data = getRankData(properties.id-1);
	new Chart(ctx).Line(data, {
	    bezierCurve: true,
	    scaleOverride: true,
		// Number - The number of steps in a hard coded scale
	    scaleSteps: 5,
	    // Number - The value jump in the hard coded scale
	    scaleStepWidth: 0.2,
	    // Number - The scale starting value
	    scaleStartValue: 0,
	});
}

function onEachFeature(feature,layer){// does this feature have a property named popupContent?
    var id = feature.properties.id;
    var gewas = feature.properties.GWS_GEWAS;
    var gewasL= gewas.split(",");
    if (gewasL.length == 2){gewas = gewasL[1]+gewasL[0]}
    var opp = Math.floor(feature.properties.GEOMETRIE_Area/1000)/10; //to hectares with one decimal
    //bind click
    layer.on({
        click: whenClicked
    });
  	layer.bindPopup(gewas+": "+opp+" ha");
}
var fieldRanks;
$.getJSON("http://gerts.github.io/NDVICropBenchmark/webpageData/ranksStadskanaal.json",function(json){
	fieldRanks = json;
	loadPolygons();
});
//Colour scale for polygons:
function getColor(r) {
	// console.log(r);
	r = parseFloat(r);
    return r > 0.999999 ? '#1a9850':
           r > 0.7 ? '#91cf60' :
           r > 0.5 ? '#d9ef8b' :
           r > 0.2 ? '#fc8d59' :
                     '#d73027';
}
function style(feature) {
    return {
        fillColor: getColor(getSummerRank(feature.properties.id-1)),
        weight: 1,
        opacity: 1,
        color: 'white',
        dashArray: '3',
        fillOpacity: 0.4
    };
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