import { Controller } from 'stimulus';
import consumer from "../channels/consumer";
import { RALLY_ICON, POLICE_ICON, ROAD_BLOCKED, COUNTER_PROTESTORS, END, MAP_MARKER } from '../icons/map_icons';

let google_map = null;

export default class extends Controller {

    static targets = ["map", "topNav", "bottomNav", "addMarkerButton"]

    initialize(){
        consumer.subscriptions.create({ channel: 'MarkersChannel'}, {
            received(data){
                const newMarkerData = JSON.parse(data);
                const latLng = new google.maps.LatLng(newMarkerData.latitude, newMarkerData.longitude);
                let icon = {
                    path: "M248 8C111 8 0 119 0 256s111 248 248 248 248-111 248-248S385 8 248 8zm33.8 189.7l80-48c11.6-6.9 24 7.7 15.4 18L343.6 208l33.6 40.3c8.7 10.4-3.9 24.8-15.4 18l-80-48c-7.7-4.7-7.7-15.9 0-20.6zm-163-30c-8.6-10.3 3.8-24.9 15.4-18l80 48c7.8 4.7 7.8 15.9 0 20.6l-80 48c-11.5 6.8-24-7.6-15.4-18l33.6-40.3-33.6-40.3zM248 288c51.9 0 115.3 43.8 123.2 106.7 1.7 13.6-8 24.6-17.7 20.4-25.9-11.1-64.4-17.4-105.5-17.4s-79.6 6.3-105.5 17.4c-9.8 4.2-19.4-7-17.7-20.4C132.7 331.8 196.1 288 248 288z",
                    fillColor: '#77D353',
                    fillOpacity: 1,
                    strokeWeight: 0,
                    scale: 0.1
                };

                switch(newMarkerData.marker_type){
                    case 'police':
                        icon = {
                            path: POLICE_ICON,
                            fillColor: '#17a2b8',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'rally_point':
                        icon = {
                            path: RALLY_ICON,
                            fillColor: '#77D353',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'road_blocked':
                        icon = {
                            path: ROAD_BLOCKED,
                            fillColor: '#6c757d',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'counter_protestors':
                        icon = {
                            path: COUNTER_PROTESTORS,
                            fillColor: '#dc3545',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'end':
                        icon = {
                            path: END,
                            fillColor: '#dc3545',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                }
                const new_marker = new google.maps.Marker({
                    position: latLng,
                    icon: icon
                });
                new_marker.setMap(google_map);
            }
        })
    }

    connect(){
        if(typeof(google) != "undefined"){
            this.initMap();
        }
    }

    resizeMap(){
        const topNavHeight = $(this.topNavTarget).outerHeight();
        const bottomNavHeight = $(this.bottomNavTarget).outerHeight();
        $(this.mapTarget).height(`calc(${window.innerHeight}px - ${topNavHeight + bottomNavHeight}px)`);
    }

    addMarker(){
        const protest_event = JSON.parse(this.data.get("event"));
        let marker_params = {};
        switch(event.target.id) {
            case "rally_point":
                marker_params = {
                    marker_type: "rally_point"
                };
                break;
            case "police":
                marker_params = {
                    marker_type: "police"
                };
                break;
            case "counter_protestors":
                marker_params = {
                    marker_type: "counter_protestors"
                };
                break;
            case "road_blocked":
                marker_params = {
                    marker_type: "road_blocked"
                };
                break;
            case "end":
                marker_params = {
                    marker_type: "end"
                };
                break;
        }

        $.post(`/events/${protest_event.id}/map/marker`, {
            ...marker_params,
            event_id: protest_event.id
        }).catch(error => console.log(error));
    }

    loadMarkers(id, map){
        $.get(`/events/${id}/map/marker`, {
            event_id: id
        }).then((map_markers) => {
            map_markers.forEach(marker => {
                let latLng = new google.maps.LatLng(marker.latitude, marker.longitude);
                let icon = {
                    path: "M248 8C111 8 0 119 0 256s111 248 248 248 248-111 248-248S385 8 248 8zm33.8 189.7l80-48c11.6-6.9 24 7.7 15.4 18L343.6 208l33.6 40.3c8.7 10.4-3.9 24.8-15.4 18l-80-48c-7.7-4.7-7.7-15.9 0-20.6zm-163-30c-8.6-10.3 3.8-24.9 15.4-18l80 48c7.8 4.7 7.8 15.9 0 20.6l-80 48c-11.5 6.8-24-7.6-15.4-18l33.6-40.3-33.6-40.3zM248 288c51.9 0 115.3 43.8 123.2 106.7 1.7 13.6-8 24.6-17.7 20.4-25.9-11.1-64.4-17.4-105.5-17.4s-79.6 6.3-105.5 17.4c-9.8 4.2-19.4-7-17.7-20.4C132.7 331.8 196.1 288 248 288z",
                    fillColor: '#77D353',
                    fillOpacity: 1,
                    strokeWeight: 0,
                    scale: 0.1
                };

                switch(marker.marker_type){
                    case 'police':
                        icon = {
                            path: POLICE_ICON,
                            fillColor: '#17a2b8',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'rally_point':
                        icon = {
                            path: RALLY_ICON,
                            fillColor: '#77D353',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'road_blocked':
                        icon = {
                            path: ROAD_BLOCKED,
                            fillColor: '#6c757d',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'counter_protestors':
                        icon = {
                            path: COUNTER_PROTESTORS,
                            fillColor: '#dc3545',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                    case 'end':
                        icon = {
                            path: END,
                            fillColor: '#dc3545',
                            fillOpacity: 1,
                            strokeWeight: 0,
                            scale: 0.1
                        };
                        break;
                }
                let new_marker = new google.maps.Marker({
                    position: latLng,
                    icon: icon
                });
                new_marker.setMap(map);
            })
        }).catch(err => console.log(err));
    }

    initMap(){
        const { latitude, longitude, id} = JSON.parse(this.data.get("event"));
        this.map = new google.maps.Map(this.mapTarget, {
            center: new google.maps.LatLng(latitude || 39.5, longitude || -98.35),
            streetViewControl: false,
            fullscreenControl: false,
            mapTypeControl: false,
            zoomControl: false,
            zoom: latitude == null ? 4 : 17,
            styles: [
                {
                    "featureType": "poi",
                    "elementType": "labels",
                    "stylers": [
                        { "visibility": "off" }
                    ]
                },
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

        google_map = this.map;

        this.loadMarkers(id, this.map);

        const eventStartLatlng = new google.maps.LatLng(latitude || 39.5, longitude || -98.35);

        var startMarker = {
            path: MAP_MARKER,
            fillColor: '#ffc107',
            fillOpacity: 1,
            strokeWeight: 0,
            scale: 0.1
        };

        var marker = new google.maps.Marker({
            position: eventStartLatlng,
            icon: startMarker,
        });

        marker.setMap(this.map);
        this.resizeMap();
    }
}