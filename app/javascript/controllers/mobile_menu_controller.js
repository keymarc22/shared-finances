import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile-menu"
export default class extends Controller {
  static targets = ["drawer"]

  connect() {
    console.log('mobile-menu controller connected')
  }

  open(event) {
    event.preventDefault()
    this.drawerTarget.classList.remove("translate-x-full")
    this.drawerTarget.classList.add("translate-x-0")
  }

  close(event) {
    event.preventDefault()
    this.drawerTarget.classList.add("translate-x-full")
    this.drawerTarget.classList.remove("translate-x-0")
  }
}
