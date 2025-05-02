import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Comments controller connected")
  }
  
  preventDefault(event) {
    event.preventDefault()
  }
  
  clear() {
    this.element.reset()
  }
}