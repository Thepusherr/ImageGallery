// Start Coding Button Effects - Consolidated Version
// All button functionality in one file for Rails Importmap compatibility

console.log('Start Coding Button effects loading...');

document.addEventListener('DOMContentLoaded', function() {
  initializeStartCodingButtons();
});

// Also initialize on Turbo navigation
document.addEventListener('turbo:load', function() {
  initializeStartCodingButtons();
});

function initializeStartCodingButtons() {
  console.log('Initializing Start Coding Buttons...');

  // Initialize all button components
  initializeBaseButtons();
  initializeNeonButtons();
  initializeGlassButtons();
  initializeRainbowButtons();
  initializeCodePenButtons();

  console.log('All button components initialized');
}

// Base button functionality
function initializeBaseButtons() {
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

// Neon button functionality
function initializeNeonButtons() {
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

// Glass button functionality
function initializeGlassButtons() {
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

// Rainbow border button functionality
function initializeRainbowButtons() {
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

// CodePen style buttons functionality
function initializeCodePenButtons() {
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

// Add CSS animations
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

  @keyframes rainbow-button-shake {
    0%, 100% { transform: translateY(-2px) rotate(0deg); }
    25% { transform: translateY(-2px) rotate(-2deg); }
    75% { transform: translateY(-2px) rotate(2deg); }
  }

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
