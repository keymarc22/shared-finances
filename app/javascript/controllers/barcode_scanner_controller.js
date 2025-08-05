import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="barcode-scanner"
export default class extends Controller {
  static targets = ["scanner", "output", "toggable"];

  connect() {
    console.log("Barcode scanner controller connected");

    if (this.scannerTarget.dataset.auto_start == 'true') {
      this.start();
    }

    document.addEventListener("modal:closed", this.disconnect.bind(this));
  }

  start(ev) {
    if (ev) ev.preventDefault();

    this.html5QrcodeScanner = new Html5QrcodeScanner(this.scannerTarget.id, this.config, false);
    this.html5QrcodeScanner.render(this.onSuccess);
    this.scanning = true;

    if (this.hasToggableTarget) {
      this.toggleElements(true);

      const cancelButton = document.createElement("button");
      cancelButton.type = "button";
      cancelButton.textContent = "Volver";
      cancelButton.className = "barcode-cancel-btn";
      cancelButton.addEventListener("click", () => {
        this.scannerTarget.classList.add("hidden");
        this.toggableTarget.classList.remove("hidden");
        if (this.html5QrcodeScanner) {
          this.html5QrcodeScanner.pause(true);
          this.html5QrcodeScanner.clear().catch(() => {});
        }
      });
      this.scannerTarget.appendChild(cancelButton);
    }

  }

  onSuccess = (decodedText, decodedResult) => {
    if (this.hasOutputTarget) {
      this.outputTarget.innerHTML = `Código escaneado: ${decodedText}`;
    }

    var inputId = this.scannerTarget.dataset.input;
    var input = document.getElementById(inputId);
    input.value = decodedText;

    if (this.scannerTarget.dataset.submit === "true") {
      input.form.requestSubmit();
    }

    if (this.hasToggableTarget) {
      this.toggleElements(false);
    }

    this.disconnect();
  }

  onScanFailure = (error) => {
    console.warn(`Code scan error: ${error}`);
  }

  disconnect() {
    if (!this.scanning) return;

    if (this.html5QrcodeScanner) {
      this.html5QrcodeScanner.pause(true);
      this.html5QrcodeScanner.clear().catch(() => {});
    }

    if (!this.hasToggableTarget)
      document.getElementById("close-modal").click();

    this.scanning = false;
  }

  toggleElements(showScanner) {
    if (showScanner) {
      this.scannerTarget.classList.remove("hidden");
      this.toggableTarget.classList.add("hidden");
    }
    else {
      this.scannerTarget.classList.add("hidden");
      this.toggableTarget.classList.remove("hidden");
    }
  }

  get config() {
    return { fps: 10, qrbox: {width: 250, height: 250}, formatsToSupport: [Html5QrcodeSupportedFormats.EAN_13] };
  }
}
