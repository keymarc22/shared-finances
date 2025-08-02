import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login-form"
export default class extends Controller {
  static targets = ["form", "password_field"]

  connect() {
    console.log("Login form controller connected");
  }

  togglePassword() {
    const passwordField = this.password_fieldTarget;
    const type = passwordField.type === "password" ? "text" : "password";
    passwordField.type = type;
  }
}
