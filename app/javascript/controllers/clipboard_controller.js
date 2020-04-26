import { Controller } from 'stimulus';

export default class extends Controller {
    connect(){
        console.log("Clipboard connected!")
    }

    copy_current_link(){
        alert("copying link!")
        var url = document.createElement("url");


    }
}
