import { Controller } from "stimulus"

let id;

export default class extends Controller {
    connect() {
        this.getUserLocation();
    }

    getUserLocation() {
        id = navigator.geolocation.watchPosition((position) => {
            $.ajax({
                type: 'POST',
                url: '/setUserLocation',
                data: { coordinates: position.coords}
            });
        }, (error) => console.log(error), {
            enableHighAccuracy: true,
            maximumAge: Infinity
        });
    }

    disconnect(){
        navigator.geolocation.clearWatch(id);
    }
}