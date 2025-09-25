import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Modal controller connected")
  }

  open(event) {
    event.preventDefault()
    const modalId = event.currentTarget.getAttribute('data-bs-target')
    const modalElement = document.querySelector(modalId)
    
    if (modalElement) {
      // Используем Bootstrap API напрямую
      const modal = new bootstrap.Modal(modalElement)
      modal.show()
    }
  }
}
