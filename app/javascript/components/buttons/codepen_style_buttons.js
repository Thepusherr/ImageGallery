// CodePen Style Buttons Component
// Handles hover-only and static rainbow buttons

export function initializeCodePenButtons() {
  const codePenButtons = document.querySelectorAll('.start-coding-btn--codepen-hover-only, .start-coding-btn--static-rainbow');
  
  codePenButtons.forEach(button => {
    if (button.getAttribute('data-codepen-initialized')) return;
    button.setAttribute('data-codepen-initialized', 'true');
    
    button.addEventListener('click', function(e) {
      e.preventDefault();
      createCodePenClickEffect(this);
      
      // Delay navigation to show effect
      setTimeout(() => {
        window.location.href = this.href;
      }, 400);
    });

    // Add subtle glow effect on hover
    button.addEventListener('mouseenter', function() {
      this.style.filter = 'brightness(1.1) drop-shadow(0 0 8px rgba(255, 221, 64, 0.3))';
    });

    button.addEventListener('mouseleave', function() {
      this.style.filter = '';
    });
  });
}

function createCodePenClickEffect(button) {
  const rect = button.getBoundingClientRect();
  const centerX = rect.left + rect.width / 2;
  const centerY = rect.top + rect.height / 2;

  // Create a pulsing ring effect
  const ring = document.createElement('div');
  ring.style.position = 'fixed';
  ring.style.left = centerX + 'px';
  ring.style.top = centerY + 'px';
  ring.style.width = '0';
  ring.style.height = '0';
  ring.style.border = '3px solid #ffdd40';
  ring.style.borderRadius = '50%';
  ring.style.transform = 'translate(-50%, -50%)';
  ring.style.pointerEvents = 'none';
  ring.style.zIndex = '10000';
  ring.style.animation = 'codepen-click-ring 0.6s ease-out forwards';
  
  document.body.appendChild(ring);

  // Create sparkle particles
  const colors = ['#ffdd40', '#ff6b6b', '#4ecdc4', '#45b7d1'];
  
  for (let i = 0; i < 8; i++) {
    const sparkle = document.createElement('div');
    const color = colors[i % colors.length];
    
    sparkle.style.position = 'fixed';
    sparkle.style.left = centerX + 'px';
    sparkle.style.top = centerY + 'px';
    sparkle.style.width = '4px';
    sparkle.style.height = '4px';
    sparkle.style.background = color;
    sparkle.style.borderRadius = '50%';
    sparkle.style.pointerEvents = 'none';
    sparkle.style.zIndex = '10000';
    sparkle.style.boxShadow = `0 0 6px ${color}`;
    
    const angle = (i / 8) * Math.PI * 2;
    const distance = 60 + Math.random() * 30;
    const endX = centerX + Math.cos(angle) * distance;
    const endY = centerY + Math.sin(angle) * distance;
    
    sparkle.style.animation = `codepen-sparkle-${i} 0.8s ease-out forwards`;
    
    // Create unique animation for each sparkle
    const keyframes = `
      @keyframes codepen-sparkle-${i} {
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
    
    document.body.appendChild(sparkle);
    
    // Clean up
    setTimeout(() => {
      if (sparkle.parentNode) {
        sparkle.parentNode.removeChild(sparkle);
      }
      if (style.parentNode) {
        style.parentNode.removeChild(style);
      }
    }, 800);
  }

  // Clean up ring
  setTimeout(() => {
    if (ring.parentNode) {
      ring.parentNode.removeChild(ring);
    }
  }, 600);

  // Add button press effect
  button.style.transform = 'translateY(1px) scale(0.98)';
  setTimeout(() => {
    button.style.transform = '';
  }, 150);
}

// Add CSS animation for ring effect
const style = document.createElement('style');
style.textContent = `
  @keyframes codepen-click-ring {
    0% {
      width: 0;
      height: 0;
      opacity: 1;
    }
    100% {
      width: 120px;
      height: 120px;
      opacity: 0;
    }
  }
`;
document.head.appendChild(style);
