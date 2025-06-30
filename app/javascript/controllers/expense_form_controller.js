import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expense-form"
export default class extends Controller {
  static targets = ["percentage"]

  connect() {
    console.log("ExpenseFormController connected")
  }

  getSplitsFields(ev) {
    var shared = ev.currentTarget.value == 'shared',
        persisted = this.percentageTarget.dataset.persisted == 'true';

    if (shared) {
      fetch('/expenses/splits_fields')
        .then(response => response.text())
        .then(html => {
          this.percentageTarget.innerHTML = html;
        });
    } else if (persisted) {
      this.percentageTarget.querySelectorAll('.split-destroy').forEach(function(input){
        input.value = true;
      })
    } else {
      this.percentageTarget.innerHTML = '';
    }
  }


}
