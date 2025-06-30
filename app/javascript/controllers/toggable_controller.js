import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggable"
export default class extends Controller {
  connect() {
    console.log("Toggable controller connected");
  }

  toggle(event) {
    var target = event.currentTarget.dataset.target,
        el = document.querySelector(target);

    if (el) el.classList.toggle("hidden");
  }

  show(event) {
    var target = event.currentTarget.dataset.target,
        el = document.querySelector(target);

    if (el) el.classList.remove("hidden");
  }

  hide(event) {
    var target = event.currentTarget.dataset.target,
        el = document.querySelector(target);

    if (el) el.classList.add("hidden");
  }
}
