import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expense-form"
export default class extends Controller {
  static targets = [
    "percentage",
    "description",
    "amount",
    "date",
    "budget"
  ]

  connect() {
    console.log("ExpenseFormController connected")
  }

  clearFields(event) {
    event && event.preventDefault();
    this.descriptionTarget.value = '';
    this.amountTarget.value = '';
    this.dateTarget.value = '';
    this.budgetTarget.value = '';
  }

  fillFields(event) {
    const expenseId = event.target.value
    if (!expenseId) return this.clearFields();

    const data = event.currentTarget.querySelector(`option[value="${expenseId}"]`).dataset
    if (!data) return

    this.descriptionTarget.value = data.description;
    this.amountTarget.value = data.amount;
    this.budgetTarget.value = data.budget;

    if (data.date) {
      this.dateTarget.value = data.date;
    }
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
