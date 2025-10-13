// Swirl Effect
function initializeSwirlEffect() {
  console.log('Initializing Swirl Effect...');

  const swirlDemo = document.getElementById('swirl-demo');
  const swirlContainer = document.getElementById('swirl-container');

  // Skip if elements don't exist on this page
  if (!swirlDemo || !swirlContainer) {
    console.log('Swirl elements not found on this page, skipping initialization');
    return;
  }

  function createSwirlDots() {
    if (!swirlContainer) return;

    // Clear existing dots
    swirlContainer.innerHTML = '';

    // Create a grid of dots (20x20 = 400 dots)
    const gridSize = 20;
    const totalDots = gridSize * gridSize;

    for (let i = 0; i < totalDots; i++) {
      const dot = document.createElement('i');

      // Calculate grid position
      const x = (i % gridSize) - (gridSize / 2 - 0.5);
      const y = (gridSize / 2 - 0.5) - Math.floor(i / gridSize);

      // Calculate properties
      const n = i / (totalDots - 1);
      const hue = (Math.sin(n * Math.PI / 2) * 360) % 360;

      const distance = Math.sqrt(x * x + y * y) / Math.sqrt(200);
      const angle = Math.atan2(x, y) / (-2 * Math.PI);
      const delay = (distance * 9 + angle * 3 - 12);

      // Set styles
      dot.style.left = `calc(50% + ${x * 20}px)`;
      dot.style.top = `calc(50% + ${y * 20}px)`;
      dot.style.backgroundColor = `hsl(${hue}, 100%, ${Math.max(20, 80 - distance * 60)}%)`;
      dot.style.animationDelay = `${delay}s`;

      swirlContainer.appendChild(dot);
    }
  }

  function restartAnimation() {
    if (!swirlContainer) return;

    // Recreate all dots with new random variations
    createSwirlDots();

    console.log('Swirl animation restarted');
  }

  // Initialize swirl dots
  createSwirlDots();

  // Add click interaction to restart animation
  if (swirlDemo) {
    swirlDemo.addEventListener('click', restartAnimation);
  }

  console.log('Swirl Effect initialized successfully');
}

// Initialize on page load and Turbo navigation
document.addEventListener('DOMContentLoaded', initializeSwirlEffect);
document.addEventListener('turbo:load', initializeSwirlEffect);
