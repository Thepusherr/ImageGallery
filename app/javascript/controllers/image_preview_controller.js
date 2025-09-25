import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "container"]

  connect() {
    this.inputTarget.addEventListener('change', this.previewImage.bind(this))
  }

  previewImage(event) {
    const file = event.target.files[0]
    
    if (file) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        // Remove existing preview if any
        const existingPreview = this.containerTarget.querySelector('.image-preview')
        if (existingPreview) {
          existingPreview.remove()
        }
        
        // Create new preview image
        const img = document.createElement('img')
        img.src = e.target.result
        img.className = 'image-preview img-fluid'
        img.alt = 'Image preview'
        
        // Add preview after the file input
        this.inputTarget.parentNode.appendChild(img)
        
        // Add animation
        img.style.opacity = '0'
        img.style.transform = 'scale(0.8)'
        
        setTimeout(() => {
          img.style.transition = 'all 0.3s ease'
          img.style.opacity = '1'
          img.style.transform = 'scale(1)'
        }, 10)
      }
      
      reader.readAsDataURL(file)
    }
  }
}
