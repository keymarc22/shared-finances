import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  connect() {
    console.log("Dropdown controller connected");
    this.handleClickOutside = this.handleClickOutside.bind(this);
  }

  toggle(event) {
    event.preventDefault();

    this.menu = event.currentTarget.nextElementSibling;
    if (this.menu) {
      this.menu.classList.toggle('hidden');
      if (!this.menu.classList.contains('hidden')) {
        document.addEventListener('click', this.handleClickOutside);
      } else {
        document.removeEventListener('click', this.handleClickOutside);
      }
    }
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      if (this.menu && !this.menu.classList.contains('hidden')) {
        this.menu.classList.add('hidden');
      }
      document.removeEventListener('click', this.handleClickOutside);
    }
  }
}
