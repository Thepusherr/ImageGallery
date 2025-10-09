// Rainbow Border Button Component
// Handles rainbow burst effects and button shake

export function initializeRainbowButtons() {
  const rainbowButtons = document.querySelectorAll('.start-coding-btn--rainbow:not([data-rainbow-initialized])');
  
  rainbowButtons.forEach(button => {
    button.setAttribute('data-rainbow-initialized', 'true');
    
    button.addEventListener('click', function(e) {
      e.preventDefault();
      createRainbowBurst(this);
      addButtonShake(this);
      
      // Delay navigation to show effect
      setTimeout(() => {
        window.location.href = this.href;
      }, 500);
    });
  });
}

function createRainbowBurst(button) {
  const rect = button.getBoundingClientRect();
  const centerX = rect.left + rect.width / 2;
  const centerY = rect.top + rect.height / 2;

  const colors = ['#ff0000', '#ff7300', '#fffb00', '#48ff00', '#00ffd5', '#002bff', '#7a00ff', '#ff00c8'];
  
  for (let i = 0; i < 12; i++) {
    const particle = document.createElement('div');
    const color = colors[i % colors.length];
    
    particle.style.position = 'fixed';
    particle.style.left = centerX + 'px';
    particle.style.top = centerY + 'px';
    particle.style.width = '6px';
    particle.style.height = '6px';
    particle.style.background = color;
    particle.style.borderRadius = '50%';
    particle.style.pointerEvents = 'none';
    particle.style.zIndex = '10000';
    particle.style.boxShadow = `0 0 10px ${color}`;
    
    const angle = (i / 12) * Math.PI * 2;
    const distance = 80 + Math.random() * 40;
    const endX = centerX + Math.cos(angle) * distance;
    const endY = centerY + Math.sin(angle) * distance;
    
    particle.style.animation = `rainbow-burst-${i} 0.8s ease-out forwards`;
    
    // Create unique animation for each particle
    const keyframes = `
      @keyframes rainbow-burst-${i} {
        0% {
          transform: translate(-50%, -50%) scale(1);
          opacity: 1;
        }
        100% {
          transform: translate(${endX - centerX}px, ${endY - centerY}px) scale(0);
          opacity: 0;
        }
      }
    `;
    
    const style = document.createElement('style');
    style.textContent = keyframes;
    document.head.appendChild(style);
    
    document.body.appendChild(particle);
    
    // Clean up
    setTimeout(() => {
      if (particle.parentNode) {
        particle.parentNode.removeChild(particle);
      }
      if (style.parentNode) {
        style.parentNode.removeChild(style);
      }
    }, 800);
  }
}

function addButtonShake(button) {
  button.style.animation = 'rainbow-button-shake 0.5s ease-in-out';
  
  setTimeout(() => {
    button.style.animation = '';
  }, 500);
}

// Add CSS for button shake
const style = document.createElement('style');
style.textContent = `
  @keyframes rainbow-button-shake {
    0%, 100% { transform: translateY(-2px) rotate(0deg); }
    25% { transform: translateY(-2px) rotate(-2deg); }
    75% { transform: translateY(-2px) rotate(2deg); }
  }
`;
document.head.appendChild(style);
