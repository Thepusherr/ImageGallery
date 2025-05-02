document.addEventListener('DOMContentLoaded', () => {
  document.addEventListener('turbo:before-visit', (event) => {
    if (event.detail.url.includes('/posts/') && document.querySelector('.js-comment-form')) {
      event.preventDefault();
    }
  });

  document.addEventListener('turbo:before-fetch-response', (event) => {
    if (event.detail.fetchResponse && event.detail.fetchResponse.response && 
        event.detail.fetchResponse.response.redirected && 
        document.querySelector('.js-comment-form')) {
      event.preventDefault();
    }
  });

  document.addEventListener('turbo:before-fetch-request', (event) => {
    if (event.target.tagName === 'FORM' && event.target.classList.contains('js-comment-form')) {
      event.preventDefault();
    }
  });
});