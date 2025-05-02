document.addEventListener('DOMContentLoaded', function() {
  const forms = document.querySelectorAll('.js-comment-form-rails-ujs');
  
  forms.forEach(form => {
    form.addEventListener('ajax:beforeSend', function(event) {
      event.preventDefault();
    });
    
    form.addEventListener('ajax:success', function(event) {
      this.reset();
      
      if (window.history && window.history.pushState) {
        const newUrl = window.location.href.replace('/comments.js', '');
        window.history.pushState({}, '', newUrl);
      }
    });
    
    form.addEventListener('ajax:error', function(event) {
      console.error('Error:', event);
      alert('Failed to create comment.');
    });
    
    form.addEventListener('submit', function(event) {
      event.preventDefault();
      
      const formData = new FormData(this);
      const url = this.action;
      
      const xhr = new XMLHttpRequest();
      xhr.open('POST', url, true);
      xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      xhr.setRequestHeader('Accept', 'text/javascript');
      
      xhr.onload = function() {
        if (xhr.status >= 200 && xhr.status < 400) {
          try {
            eval(xhr.responseText);
            
            form.reset();
            
            if (window.history && window.history.pushState) {
              const newUrl = window.location.href.replace('/comments.js', '');
              window.history.pushState({}, '', newUrl);
            }
          } catch (e) {
            console.error('Error evaluating response:', e);
          }
        } else {
          console.error('Request failed');
          alert('Failed to create comment.');
        }
      };
      
      xhr.onerror = function() {
        console.error('Network error');
        alert('Network error occurred.');
      };
      
      xhr.send(formData);
    });
  });
});