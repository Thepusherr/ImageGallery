// Обработчик для Turbo Stream ответов
document.addEventListener('DOMContentLoaded', () => {
  // Предотвращаем переходы по умолчанию для форм с Turbo
  document.addEventListener('turbo:before-visit', (event) => {
    // Если URL содержит /posts/ и есть форма комментария, предотвращаем переход
    if (event.detail.url.includes('/posts/') && document.querySelector('form[data-controller="comments"]')) {
      event.preventDefault();
    }
  });

  // Предотвращаем переходы по умолчанию для форм с Turbo
  document.addEventListener('turbo:before-fetch-response', (event) => {
    // Если ответ содержит редирект и есть форма комментария, предотвращаем переход
    if (event.detail.fetchResponse.response.redirected && document.querySelector('form[data-controller="comments"]')) {
      event.preventDefault();
    }
  });

  // Предотвращаем переходы по умолчанию для форм с Turbo
  document.addEventListener('turbo:before-fetch-request', (event) => {
    // Если цель - форма комментария, предотвращаем переход
    if (event.target.tagName === 'FORM' && event.target.dataset.controller === 'comments') {
      event.preventDefault();
    }
  });
});