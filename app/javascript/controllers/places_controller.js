// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "field", "map", "latitude", "longitude"];

  connect() {
    if(typeof(google) != "undefined"){
      this.initMap();
    }
  }

  initMap(){
    const { location_lat, location_long } = JSON.parse(this.data.get("event"));
    // $.get('/events.json').then(data => console.log(data)); // This will let us fetch a list of events. This can be used to get mapmarkers for the current event

    console.log(location_lat, location_long)
    this.map = new google.maps.Map(this.mapTarget, {
        center: new google.maps.LatLng(location_lat || 39.5, location_long || -98.35),
        zoom: location_lat == null ? 4 : 17
    });
    this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget) // Grabs the DOM element
    this.autocomplete.bindTo('bounds', this.map);
    this.autocomplete.setFields(['address_components', 'geometry', 'icon', 'name']) // Can be customized to return only certain fields
    this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));

    this.marker = new google.maps.Marker({
      map: this.map,
      anchorPoint: new google.maps.Point(0, -29)
    })
  }

  placeChanged(){
      let place = this.autocomplete.getPlace();
      if(!place.geometry){
        window.alert(`No details available for input: ${place.name}`);
        return null;
      }

      if(place.geometry.viewport){ // If it knows where the event is, then set the bounds of the map
        this.map.fitBounds(place.geometry.viewport);
      } else { // If it does not know where the event is, then that's an issue
        this.map.setCenter(place.geometry.location);
        this.map.setZoom(17); // If doesn't know where to focus in, then zooms out
      }

      this.latitudeTarget.value = place.geometry.location.lat();
      this.longitudeTarget.value = place.geometry.location.lng();

      this.marker.setPosition(place.geometry.location);
      this.marker.setVisible(true);
  }

  keydown(event){
      if(event.key == "Enter"){
          event.preventDefault();
      }
  }
}
