// Snow Effect
document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing Snow Effect...');

  const snowContainer = document.getElementById('snow-container');
  const snowDemo = document.getElementById('snow-demo');

  if (!snowContainer || !snowDemo) {
    console.error('Snow containers not found');
    return;
  }

  function createSnowflake() {
    const snowflake = document.createElement('i');
    snowflake.className = 'snow-container__item';
    const offset = Math.random() * 2 + 0.5;
    snowflake.style.cssText = `
      left: ${Math.random() * 100}%;
      animation-delay: ${Math.random() * 5}s;
      --offset: ${offset};
    `;
    snowContainer.appendChild(snowflake);

    // Remove snowflake after animation
    setTimeout(() => {
      if (snowflake.parentNode) {
        snowflake.parentNode.removeChild(snowflake);
      }
    }, 75000 / offset);
  }

  // Create initial snowflakes
  for (let i = 0; i < 10; i++) {
    setTimeout(() => createSnowflake(), i * 1000);
  }

  // Add click interaction
  snowDemo.addEventListener('click', function() {
    for (let i = 0; i < 5; i++) {
      setTimeout(() => createSnowflake(), i * 200);
    }
  });

  console.log('Snow Effect initialized successfully');
});
