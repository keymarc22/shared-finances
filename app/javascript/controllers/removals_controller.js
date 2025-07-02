import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="removals"
export default class extends Controller {
  connect() {
    console.log("Removals controller connected");
    setTimeout(this.remove.bind(this), 8000)
  }

  remove() {
    this.element.remove()
  }
}
