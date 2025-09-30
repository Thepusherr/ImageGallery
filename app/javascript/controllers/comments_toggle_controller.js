import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comments-toggle"
export default class extends Controller {
  static targets = ["chevron"]

  toggle(event) {
    const chevron = this.chevronTarget
    const collapseElement = event.currentTarget.getAttribute('data-bs-target')
    const collapse = document.querySelector(collapseElement)
    
    collapse.addEventListener('show.bs.collapse', () => {
      chevron.classList.remove('bi-chevron-down')
      chevron.classList.add('bi-chevron-up')
    })
    
    collapse.addEventListener('hide.bs.collapse', () => {
      chevron.classList.remove('bi-chevron-up')
      chevron.classList.add('bi-chevron-down')
    })
  }
}

