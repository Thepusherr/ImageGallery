function handleCommentFormSubmit(event) {
  event.preventDefault();
  
  const form = event.target;
  const url = form.action;
  const formData = new FormData(form);
  
  const xhr = new XMLHttpRequest();
  xhr.open('POST', url, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.setRequestHeader('Accept', 'text/javascript');
  
  xhr.onload = function() {
    if (xhr.status >= 200 && xhr.status < 300) {
      eval(xhr.responseText);
      
      form.reset();
      
      if (window.history && window.history.pushState) {
        window.history.pushState({}, "", window.location.href);
      }
    } else {
      console.error('Error:', xhr.statusText);
      alert('Failed to create comment.');
    }
  };
  
  xhr.onerror = function() {
    console.error('Network Error');
    alert('Network error occurred.');
  };
  
  xhr.send(formData);
}

function addCommentFormHandlers() {
  const commentForms = document.querySelectorAll('.js-comment-form-ujs');
  
  commentForms.forEach(form => {
    form.removeEventListener('submit', handleCommentFormSubmit);
    
    form.addEventListener('submit', handleCommentFormSubmit);
  });
}

document.addEventListener('DOMContentLoaded', addCommentFormHandlers);

document.addEventListener('turbo:load', addCommentFormHandlers);
document.addEventListener('turbo:render', addCommentFormHandlers);

document.addEventListener('submit', function(event) {
  if (event.target.classList.contains('js-comment-form-ujs')) {
    handleCommentFormSubmit(event);
  }
});