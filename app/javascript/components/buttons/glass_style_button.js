// Glass Style Button Component
// Handles parallax effects for glass buttons

export function initializeGlassButtons() {
  const glassButtons = document.querySelectorAll('.start-coding-btn--glass:not([data-glass-initialized])');
  
  glassButtons.forEach(button => {
    button.setAttribute('data-glass-initialized', 'true');
    
    // Parallax effect on mouse move
    button.addEventListener('mousemove', function(e) {
      createParallaxEffect(this, e);
    });
    
    // Reset on mouse leave
    button.addEventListener('mouseleave', function() {
      resetParallaxEffect(this);
    });
  });
}

function createParallaxEffect(button, event) {
  const rect = button.getBoundingClientRect();
  const centerX = rect.left + rect.width / 2;
  const centerY = rect.top + rect.height / 2;
  
  const deltaX = (event.clientX - centerX) / (rect.width / 2);
  const deltaY = (event.clientY - centerY) / (rect.height / 2);
  
  const rotateX = deltaY * 10; // Max 10 degrees
  const rotateY = deltaX * 10; // Max 10 degrees
  
  button.style.transform = `perspective(1000px) rotateX(${-rotateX}deg) rotateY(${rotateY}deg) translateY(-2px)`;
}

function resetParallaxEffect(button) {
  button.style.transform = '';
}
