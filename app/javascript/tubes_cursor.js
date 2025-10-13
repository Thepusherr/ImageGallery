// Tubes Cursor Effect
function generateRandomColors(count) {
  return new Array(count)
    .fill(0)
    .map(() => "#" + Math.floor(Math.random() * 16777215).toString(16).padStart(6, '0'));
}

let tubesApp = null; // Store reference for cleanup

async function initializeTubesCursor() {
  console.log('Starting Tubes Cursor initialization...');

  try {
    const canvas = document.getElementById('tubes-canvas');
    const container = document.getElementById('tubes-demo');

    console.log('Canvas element:', canvas);
    console.log('Container element:', container);

    // Skip if elements don't exist on this page
    if (!canvas || !container) {
      console.log('Tubes elements not found on this page, skipping initialization');
      return;
    }

    // Clean up previous instance if it exists
    if (tubesApp && typeof tubesApp.destroy === 'function') {
      tubesApp.destroy();
      tubesApp = null;
    }

    if (canvas && container) {
      container.classList.add('loading');
      console.log('Loading TubesCursor library...');

      const { default: TubesCursor } = await import("https://cdn.jsdelivr.net/npm/threejs-components@0.0.19/build/cursors/tubes1.min.js");
      console.log('TubesCursor library loaded:', TubesCursor);

      tubesApp = TubesCursor(canvas, {
        tubes: {
          colors: ["#f967fb", "#53bc28", "#6958d5"],
          lights: {
            intensity: 200,
            colors: ["#83f36e", "#fe8a2e", "#ff008a", "#60aed5"]
          }
        }
      });

      console.log('TubesCursor app created:', tubesApp);
      container.classList.remove('loading');

      // Add click interaction
      container.addEventListener('click', () => {
        const colors = generateRandomColors(3);
        const lightsColors = generateRandomColors(4);
        console.log('Changing colors:', colors, lightsColors);
        try {
          tubesApp.tubes.setColors(colors);
          tubesApp.tubes.setLightsColors(lightsColors);
        } catch (e) {
          console.warn('Error changing colors:', e);
        }
      });

      // Add keyboard interaction
      document.addEventListener('keydown', (event) => {
        if (event.code === 'Space' && event.target === document.body) {
          event.preventDefault();
          container.click();
        }
      });

      console.log('TubesCursor initialized successfully');
    } else {
      console.error('Canvas or container element not found');
    }
  } catch (error) {
    console.error('Failed to load TubesCursor:', error);
    const container = document.getElementById('tubes-demo');
    if (container) {
      container.classList.remove('loading');
      container.classList.add('error');
      console.log('Set error state on container');
    }
  }
}

// Clean up function for Turbo navigation
function cleanupTubesCursor() {
  if (tubesApp && typeof tubesApp.destroy === 'function') {
    console.log('Cleaning up TubesCursor...');
    tubesApp.destroy();
    tubesApp = null;
  }
}

// Initialize on page load and Turbo navigation
document.addEventListener('DOMContentLoaded', initializeTubesCursor);
document.addEventListener('turbo:load', initializeTubesCursor);
document.addEventListener('turbo:before-cache', cleanupTubesCursor);
