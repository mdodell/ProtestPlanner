import { Controller } from 'stimulus';
import copy from 'copy-to-clipboard';

export default class extends Controller {
    copy_current_link(){
        copy(window.location.href);
    }
}
