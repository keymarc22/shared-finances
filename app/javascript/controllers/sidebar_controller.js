import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  connect() {
    this.element.querySelectorAll('.sidebar-nav-item').forEach(link => {
      link.addEventListener('click', () => {
        if (window.innerWidth <= 768) {
          this.close()
        }
      })
    })

  }

  toggle() {
     document.body.classList.toggle('sidebar-expanded');
    document.body.classList.toggle('sidebar-collapsed');

    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.toggle('sidebar-open')
    }
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.toggle('sidebar-open')
    }
  }

  // Para desktop: colapsar/expandir
  toggleCollapse() {
    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.toggle('sidebar-collapsed')
    }
  }

  // Cerrar sidebar
  close() {
    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.remove('sidebar-open')
    }
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove('sidebar-open')
    }
  }
}