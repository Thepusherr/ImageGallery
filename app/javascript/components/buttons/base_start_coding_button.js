// Base Start Coding Button Component
// Handles basic ripple effects and common functionality

export function initializeBaseButtons() {
  const buttons = document.querySelectorAll('.start-coding-btn:not([data-initialized])');
  
  buttons.forEach(button => {
    button.setAttribute('data-initialized', 'true');
    
    // Add ripple effect
    button.addEventListener('click', function(e) {
      createRippleEffect(this, e);
    });
  });
}

function createRippleEffect(button, event) {
  const rect = button.getBoundingClientRect();
  const size = Math.max(rect.width, rect.height);
  const x = event.clientX - rect.left - size / 2;
  const y = event.clientY - rect.top - size / 2;
  
  const ripple = document.createElement('div');
  ripple.style.position = 'absolute';
  ripple.style.left = x + 'px';
  ripple.style.top = y + 'px';
  ripple.style.width = size + 'px';
  ripple.style.height = size + 'px';
  ripple.style.background = 'rgba(255, 255, 255, 0.3)';
  ripple.style.borderRadius = '50%';
  ripple.style.transform = 'scale(0)';
  ripple.style.animation = 'ripple-effect 0.6s ease-out';
  ripple.style.pointerEvents = 'none';
  ripple.style.zIndex = '1000';
  
  button.appendChild(ripple);
  
  // Remove ripple after animation
  setTimeout(() => {
    if (ripple.parentNode) {
      ripple.parentNode.removeChild(ripple);
    }
  }, 600);
}

// Add CSS for ripple effect
const style = document.createElement('style');
style.textContent = `
  @keyframes ripple-effect {
    0% {
      transform: scale(0);
      opacity: 1;
    }
    100% {
      transform: scale(2);
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);
