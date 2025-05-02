function handleCommentFormSubmit(event) {
  event.preventDefault();
  
  const form = event.target;
  const formData = new FormData(form);
  const url = form.action;
  
  fetch(url, {
    method: 'POST',
    body: formData,
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Accept': 'text/javascript, text/vnd.turbo-stream.html, text/html'
    },
    credentials: 'same-origin'
  })
  .then(response => {
    if (response.ok) {
      return response.text();
    }
    throw new Error('Network response was not ok');
  })
  .then(html => {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const turboStreamElements = doc.querySelectorAll('turbo-stream');
    
    if (turboStreamElements.length > 0) {
      turboStreamElements.forEach(element => {
        document.body.appendChild(element);
      });
    }
    
    form.reset();
  })
  .catch(error => {
    console.error('Error:', error);
  });
}

function addCommentFormHandlers() {
  const commentForms = document.querySelectorAll('.js-comment-form');
  
  commentForms.forEach(form => {
    form.removeEventListener('submit', handleCommentFormSubmit);
    
    form.addEventListener('submit', handleCommentFormSubmit);
  });
}

document.addEventListener('DOMContentLoaded', addCommentFormHandlers);

document.addEventListener('turbo:load', addCommentFormHandlers);

document.addEventListener('turbo:frame-render', addCommentFormHandlers);

document.addEventListener('turbo:before-stream-render', addCommentFormHandlers);