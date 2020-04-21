import { Controller } from 'stimulus';

export default class extends Controller {

    static targets = ["field", "latitude", "longitude"];

    initialize(){
        if(typeof(google) != "undefined"){
            this.initAutoComplete();
        }
    }

    initAutoComplete(){
        this.autocomplete = new google.maps.places.Autocomplete(this.fieldTarget); // Grabs the DOM element
        this.autocomplete.setFields(['address_components', 'geometry', 'icon', 'name']) // Can be customized to return only certain fields
        this.autocomplete.addListener('place_changed', this.placeChanged.bind(this));
    }

    placeChanged(){
        let place = this.autocomplete.getPlace();
        if(!place.geometry){
            window.alert(`No details available for input: ${place.name}`);
            return null;
        }

        this.latitudeTarget.value = place.geometry.location.lat();
        this.longitudeTarget.value = place.geometry.location.lng();
    }

    keydown(event){
        if(event.key == "Enter"){
            event.preventDefault();
        }
    }
}