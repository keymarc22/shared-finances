import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="barcode-scanner"
export default class extends Controller {
  static targets = ["reader", "output"]

  connect() {
    console.log("Barcode scanner controller connected");
    this.start();
  }

  start() {
    const videoElement = document.getElementById('video');
    const outputElement = document.getElementById('output');
    const hints = new Map();
    hints.set(ZXing.DecodeHintType.POSSIBLE_FORMATS, [
        ZXing.BarcodeFormat.EAN_13
    ]);
    const codeReader = new ZXing.BrowserMultiFormatReader(hints);
    codeReader
      .listVideoInputDevices()
      .then(videoInputDevices => {
        // Usar la primera cámara encontrada
        const deviceId = videoInputDevices[0].deviceId;
        codeReader.decodeFromVideoDevice(
          deviceId,
          videoElement,
          (result, err, controls) => {
            if (result && result.getBarcodeFormat() === 'EAN_13') {
              outputElement.innerHTML = result.getText();
              controls.stop();
            }
          }
        );
      })
      .catch(err => console.error(err));

    // var button = document.querySelector("#html5-qrcode-button-camera-start");
    // button.classList.add("items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-white transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-gray-750 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-gray-950 text-white hover:bg-gray-800 h-10 px-4 py-2");
  }

  disconnect() {
    if (this.qrScanner) {
      this.qrScanner.clear().catch(() => {});
    }
  }
}
