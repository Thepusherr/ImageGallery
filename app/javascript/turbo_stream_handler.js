// Обработчик для Turbo Stream ответов
document.addEventListener('DOMContentLoaded', () => {
  // Предотвращаем переходы по умолчанию для форм с Turbo
  document.addEventListener('turbo:before-visit', (event) => {
    // Если URL содержит /posts/ и есть форма комментария, предотвращаем переход
    if (event.detail.url.includes('/posts/') && document.querySelector('.js-comment-form')) {
      event.preventDefault();
    }
  });

  // Предотвращаем переходы по умолчанию для форм с Turbo
  document.addEventListener('turbo:before-fetch-response', (event) => {
    // Если ответ содержит редирект и есть форма комментария, предотвращаем переход
    if (event.detail.fetchResponse && event.detail.fetchResponse.response && 
        event.detail.fetchResponse.response.redirected && 
        document.querySelector('.js-comment-form')) {
      event.preventDefault();
    }
  });

  // Предотвращаем переходы по умолчанию для форм с Turbo
  document.addEventListener('turbo:before-fetch-request', (event) => {
    // Если цель - форма комментария, предотвращаем переход
    if (event.target.tagName === 'FORM' && event.target.classList.contains('js-comment-form')) {
      event.preventDefault();
    }
  });
});