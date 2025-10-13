import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar-preview"
export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    console.log("Avatar preview controller connected");
  }

  preview(event) {
    const file = event.target.files[0];

    if (file) {
      // Validate file type
      if (!file.type.startsWith('image/')) {
        alert('Please select an image file');
        return;
      }

      // Validate file size (5MB)
      if (file.size > 5 * 1024 * 1024) {
        alert('File size must be less than 5MB');
        return;
      }

      const reader = new FileReader();
      reader.onload = (e) => {
        // Remove existing content
        this.previewTarget.innerHTML = '';

        // Create new image element
        const img = document.createElement('img');
        img.src = e.target.result;
        img.className = 'avatar-image rounded-circle';
        img.id = 'avatar-preview';

        this.previewTarget.appendChild(img);

        console.log('Avatar preview updated');
      };

      reader.readAsDataURL(file);
    }
  }
}
