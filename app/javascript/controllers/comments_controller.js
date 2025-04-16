import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Comments controller connected")
  }
  
  preventDefault(event) {
    // Предотвращаем стандартное поведение формы
    event.preventDefault()
  }
  
  clear() {
    // Очищаем поле ввода комментария после успешной отправки
    this.element.reset()
  }
}