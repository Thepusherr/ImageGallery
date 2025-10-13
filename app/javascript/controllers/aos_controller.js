import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="aos"
export default class extends Controller {
  connect() {
    // Initialize AOS when the controller connects
    if (typeof AOS !== 'undefined') {
      AOS.init();
      console.log('AOS initialized');
    } else {
      console.warn('AOS library not loaded');
    }
  }

  disconnect() {
    // Refresh AOS when the controller disconnects (for Turbo navigation)
    if (typeof AOS !== 'undefined') {
      AOS.refresh();
    }
  }
}
