import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="barcode-scanner"
export default class extends Controller {
  static targets = ["scanner", "output"];

  connect() {
    console.log("Barcode scanner controller connected");
    this.start();

    document.addEventListener("modal:closed", this.disconnect.bind(this));
  }

  start() {
    this.html5QrcodeScanner = new Html5QrcodeScanner(this.scannerTarget.id, this.config, false);
    this.html5QrcodeScanner.render(this.onSuccess);
    // button.classList.add("items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-white transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-750 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-gray-950 text-white hover:bg-gray-800 h-10 px-4 py-2");
  }

  onSuccess = (decodedText, decodedResult) => {
    this.outputTarget.innerHTML = `Código escaneado: ${decodedText}`;
    var inputId = this.scannerTarget.dataset.input;
    var input = document.getElementById(inputId);
    input.value = decodedText;

    if (this.scannerTarget.dataset.submit === "true") {
      input.form.requestSubmit();
    }

    this.disconnect();
  }

  onScanFailure = (error) => {
    console.warn(`Code scan error: ${error}`);
  }

  disconnect() {
    if (this.html5QrcodeScanner) {
      this.html5QrcodeScanner.pause(true);
      this.html5QrcodeScanner.clear().catch(() => {});
    }

    document.getElementById("close-modal").click();
  }

  get config() {
    return { fps: 10, qrbox: {width: 250, height: 250}, formatsToSupport: [Html5QrcodeSupportedFormats.EAN_13] };
  }
}
