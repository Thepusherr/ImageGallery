function submitCommentForm(form) {
  console.log('submitCommentForm called');
  
  event.preventDefault();
  
  const formData = new FormData(form);
  const url = form.action;
  
  console.log('Sending AJAX request to:', url);
  
  const xhr = new XMLHttpRequest();
  xhr.open('POST', url, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.setRequestHeader('Accept', 'text/javascript, application/javascript');

  xhr.onload = function() {
    console.log('Response received, status:', xhr.status);
    
    if (xhr.status >= 200 && xhr.status < 400) {
      try {
        console.log('Response text:', xhr.responseText.substring(0, 100) + '...');
        
        eval(xhr.responseText);
        
        form.reset();
        
        console.log('Form reset successfully');
      } catch (e) {
        console.error('Error evaluating response:', e);
      }
    } else {
      console.error('Request failed with status:', xhr.status);
      alert('Failed to create comment.');
    }
  };
  
  xhr.onerror = function() {
    console.error('Network error occurred');
    alert('Network error occurred.');
  };
  
  xhr.send(formData);
  console.log('Request sent');
  
  return false;
}

window.submitCommentForm = submitCommentForm;

document.addEventListener('DOMContentLoaded', function() {
  console.log('Vanilla handler loaded, submitCommentForm is available:', typeof window.submitCommentForm);
  
  const forms = document.querySelectorAll('.js-comment-form-vanilla');
  console.log('Found', forms.length, 'vanilla comment forms');
  
  forms.forEach(form => {
    console.log('Adding submit handler to form:', form);
    form.addEventListener('submit', function(event) {
      console.log('Form submit event triggered');
      return submitCommentForm(this);
    });
  });
});