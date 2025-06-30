import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  connect() {
    console.log("Dropdown controller connected");
  }

  toggle(event) {
    event.preventDefault();

    const menu = event.currentTarget.nextElementSibling;
    if (menu) {
      menu.classList.toggle('hidden');
    }
  }
}
