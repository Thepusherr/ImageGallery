// Neon Style Button Component
// Handles color changing effects for neon buttons

export function initializeNeonButtons() {
  const neonButtons = document.querySelectorAll('.start-coding-btn--neon:not([data-neon-initialized])');
  
  neonButtons.forEach(button => {
    button.setAttribute('data-neon-initialized', 'true');
    
    // Color cycling on click
    button.addEventListener('click', function(e) {
      e.preventDefault();
      cycleNeonColor(this);
      
      // Delay navigation to show effect
      setTimeout(() => {
        window.location.href = this.href;
      }, 300);
    });
  });
}

function cycleNeonColor(button) {
  const colors = ['', 'neon-pink', 'neon-green', 'neon-orange'];
  let currentIndex = 0;
  
  // Find current color
  colors.forEach((color, index) => {
    if (color === '' && !button.classList.contains('neon-pink') && 
        !button.classList.contains('neon-green') && !button.classList.contains('neon-orange')) {
      currentIndex = index;
    } else if (button.classList.contains(color)) {
      currentIndex = index;
    }
  });
  
  // Remove current color
  colors.forEach(color => {
    if (color !== '') {
      button.classList.remove(color);
    }
  });
  
  // Add next color
  const nextIndex = (currentIndex + 1) % colors.length;
  if (colors[nextIndex] !== '') {
    button.classList.add(colors[nextIndex]);
  }
  
  // Add click effect
  button.style.transform = 'scale(0.95)';
  setTimeout(() => {
    button.style.transform = '';
  }, 150);
}
