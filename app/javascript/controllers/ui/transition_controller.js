import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["enter", "enterFrom", "enterTo", "leave", "leaveFrom", "leaveTo"]

  connect() {
    console.log("Transition controller connected")
    this.isTransitioning = false
  }

  enter(element) {
    if (this.isTransitioning) return
    this.isTransitioning = true
    element.classList.add(...this.enterClasses, ...this.enterFromClasses)
    requestAnimationFrame(() => {
      element.classList.remove(...this.enterFromClasses)
      element.classList.add(...this.enterToClasses)
      element.addEventListener("transitionend", () => {
        element.classList.remove(...this.enterClasses, ...this.enterToClasses)
        this.isTransitioning = false
      }, { once: true })
    })
  }

  leave(element) {
    if (this.isTransitioning) return
    this.isTransitioning = true
    element.classList.add(...this.leaveClasses, ...this.leaveFromClasses)
    requestAnimationFrame(() => {
      element.classList.remove(...this.leaveFromClasses)
      element.classList.add(...this.leaveToClasses)
      element.addEventListener("transitionend", () => {
        element.classList.remove(...this.leaveClasses, ...this.leaveToClasses)
        this.isTransitioning = false
      }, { once: true })
    })
  }
}