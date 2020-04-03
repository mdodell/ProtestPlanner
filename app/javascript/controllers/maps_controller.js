import { Controller } from 'stimulus';

export default class extends Controller {

    static targets = ["map", "topNav", "bottomNav", "addMarkerButton"]

    initialize(){

    }

    connect(){
        if(typeof(google) != "undefined"){
            this.initMap();
        }
        $("#loading_map").fadeOut(1, () => {
            $("#loading_map").remove();
        });
    }

    resizeMap(){
        const topNavHeight = $(this.topNavTarget).outerHeight();
        const bottomNavHeight = $(this.bottomNavTarget).outerHeight();
        $(this.mapTarget).height(`calc(100vh - ${topNavHeight + bottomNavHeight}px)`);
    }

    addMarker(){
        console.log("Adding marker");
    }

    initMap(){
        const { latitude, longitude } = JSON.parse(this.data.get("event"));

        this.map = new google.maps.Map(this.mapTarget, {
            center: new google.maps.LatLng(latitude || 39.5, longitude || -98.35),
            streetViewControl: false,
            fullscreenControl: false,
            mapTypeControl: false,
            zoomControl: false,
            zoom: latitude == null ? 4 : 17,
            styles: [
                {
                    "featureType": "transit",
                    "elementType": "labels",
                    "stylers": [
                        { "visibility": "off" }
                    ]
                },
                {elementType: 'geometry', stylers: [{color: '#242f3e'}]},
                {elementType: 'labels.text.stroke', stylers: [{color: '#242f3e'}]},
                {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
                {
                    featureType: 'administrative.locality',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#d59563'}]
                },
                {
                    featureType: 'poi',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#d59563'}]
                },
                {
                    featureType: 'poi.park',
                    elementType: 'geometry',
                    stylers: [{color: '#263c3f'}]
                },
                {
                    featureType: 'poi.park',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#6b9a76'}]
                },
                {
                    featureType: 'road',
                    elementType: 'geometry',
                    stylers: [{color: '#38414e'}]
                },
                {
                    featureType: 'road',
                    elementType: 'geometry.stroke',
                    stylers: [{color: '#212a37'}]
                },
                {
                    featureType: 'road',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#9ca5b3'}]
                },
                {
                    featureType: 'road.highway',
                    elementType: 'geometry',
                    stylers: [{color: '#746855'}]
                },
                {
                    featureType: 'road.highway',
                    elementType: 'geometry.stroke',
                    stylers: [{color: '#1f2835'}]
                },
                {
                    featureType: 'road.highway',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#f3d19c'}]
                },
                {
                    featureType: 'transit',
                    elementType: 'geometry',
                    stylers: [{color: '#2f3948'}]
                },
                {
                    featureType: 'transit.station',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#d59563'}]
                },
                {
                    featureType: 'water',
                    elementType: 'geometry',
                    stylers: [{color: '#17263c'}]
                },
                {
                    featureType: 'water',
                    elementType: 'labels.text.fill',
                    stylers: [{color: '#515c6d'}]
                },
                {
                    featureType: 'water',
                    elementType: 'labels.text.stroke',
                    stylers: [{color: '#17263c'}]
                }
            ]
        });

        // this.addMarkerButtonTarget.index = -4;
        // this.map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(this.addMarkerButtonTarget);


        var myLatlng = new google.maps.LatLng(latitude || 39.5, longitude || -98.35);
        var counterProtestor = {
            path: "M248 8C111 8 0 119 0 256s111 248 248 248 248-111 248-248S385 8 248 8zm33.8 189.7l80-48c11.6-6.9 24 7.7 15.4 18L343.6 208l33.6 40.3c8.7 10.4-3.9 24.8-15.4 18l-80-48c-7.7-4.7-7.7-15.9 0-20.6zm-163-30c-8.6-10.3 3.8-24.9 15.4-18l80 48c7.8 4.7 7.8 15.9 0 20.6l-80 48c-11.5 6.8-24-7.6-15.4-18l33.6-40.3-33.6-40.3zM248 288c51.9 0 115.3 43.8 123.2 106.7 1.7 13.6-8 24.6-17.7 20.4-25.9-11.1-64.4-17.4-105.5-17.4s-79.6 6.3-105.5 17.4c-9.8 4.2-19.4-7-17.7-20.4C132.7 331.8 196.1 288 248 288z",
            fillColor: '#E32831',
            fillOpacity: 1,
            strokeWeight: 0,
            scale: 0.1
        };


        var marker = new google.maps.Marker({
            position: myLatlng,
            title:"Hello World!",
            icon: counterProtestor
        });

        var marker2 = new google.maps.Marker({
            position: new google.maps.LatLng(39.9570276, -75.2016476),
            title:"Hello World!",
            icon: counterProtestor
        });

        var infowindow = new google.maps.InfoWindow({
            content: '<div id="content" onclick="console.log(this.parentNode)">'+
                '<div id="siteNotice">'+
                '</div>'+
                '<h1 id="firstHeading" class="firstHeading">Uluru</h1>'+
                '<div id="bodyContent" >'+
                '<p><b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large ' +
                'sandstone rock formation in the southern part of the '+
                'Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) '+
                'south west of the nearest large town, Alice Springs; 450&#160;km '+
                '(280&#160;mi) by road. Kata Tjuta and Uluru are the two major '+
                'features of the Uluru - Kata Tjuta National Park. Uluru is '+
                'sacred to the Pitjantjatjara and Yankunytjatjara, the '+
                'Aboriginal people of the area. It has many springs, waterholes, '+
                'rock caves and ancient paintings. Uluru is listed as a World '+
                'Heritage Site.</p>'+
                '<p>Attribution: Uluru, <a href="https://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">'+
                'https://en.wikipedia.org/w/index.php?title=Uluru</a> '+
                '(last visited June 22, 2009).</p>'+
                '</div>'+
                '</div>'
        });

        marker.addListener('click', function() {
            infowindow.open(this.map, marker);
        });
        marker.setMap(this.map);
        this.resizeMap();
    }
}