import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  static values = {
    options: Object // Para pasar opciones a Slim Select desde Rails
  }

  connect() {
    this.initializeSlimSelect();
  }

  disconnect() {
    this.destroySlimSelect();
  }

  initializeSlimSelect() {
    if (this.element.tagName === 'SELECT') {

      const defaultOptions = {
        search: true,
        placeholder: 'Seleccione una opción',
        closeOnSelect: true,
        // hideSelectedOption: true,
        showSearch: true,
        allowDeselect: true
      };
      const options = { ...defaultOptions, ...this.optionsValue };

      this.slimSelect = new SlimSelect({
        select: this.element, // El elemento <select> al que está adjunto el controlador
        ...options
      });
      console.log('Slim Select inicializado en:', this.element);
    } else {
      console.warn('El controlador slim_select_controller solo debe usarse en elementos <select>.');
    }
  }

  destroySlimSelect() {
    if (this.slimSelect) {
      this.slimSelect.destroy();
      this.slimSelect = null;
    }
  }
}