import "@hotwired/turbo-rails"
import "controllers"
import "channels"

// Visual effects
import "tubes_cursor"
import "snow_effect"
import "swirl_effect"
import "start_coding_button"

console.log('Application.js loading...');

// Ensure Turbo is properly initialized
document.addEventListener('DOMContentLoaded', function() {
  console.log('DOM loaded, Turbo should be active');
  console.log('Turbo object:', window.Turbo);
});

// Add Turbo event listeners for debugging
document.addEventListener('turbo:before-fetch-request', function(event) {
  console.log('Turbo request starting:', event.detail.url);
});

document.addEventListener('turbo:before-fetch-response', function(event) {
  console.log('Turbo response received:', event.detail.fetchResponse);
});

