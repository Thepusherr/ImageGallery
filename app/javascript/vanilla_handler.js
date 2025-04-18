// Функция для отправки формы комментария
function submitCommentForm(form) {
  console.log('submitCommentForm called');
  
  // Предотвращаем стандартное поведение формы
  event.preventDefault();
  
  // Получаем данные формы
  const formData = new FormData(form);
  const url = form.action;
  
  console.log('Sending AJAX request to:', url);
  
  // Создаем AJAX-запрос
  const xhr = new XMLHttpRequest();
  xhr.open('POST', url, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.setRequestHeader('Accept', 'text/javascript, application/javascript');
  
  // Обрабатываем ответ
  xhr.onload = function() {
    console.log('Response received, status:', xhr.status);
    
    if (xhr.status >= 200 && xhr.status < 400) {
      // Успешный ответ
      try {
        console.log('Response text:', xhr.responseText.substring(0, 100) + '...');
        
        // Выполняем JavaScript из ответа
        eval(xhr.responseText);
        
        // Очищаем форму
        form.reset();
        
        console.log('Form reset successfully');
      } catch (e) {
        console.error('Error evaluating response:', e);
      }
    } else {
      // Ошибка
      console.error('Request failed with status:', xhr.status);
      alert('Failed to create comment.');
    }
  };
  
  // Обрабатываем ошибки сети
  xhr.onerror = function() {
    console.error('Network error occurred');
    alert('Network error occurred.');
  };
  
  // Отправляем запрос
  xhr.send(formData);
  console.log('Request sent');
  
  // Предотвращаем стандартное поведение формы
  return false;
}

// Делаем функцию глобальной
window.submitCommentForm = submitCommentForm;

// Добавляем обработчик события DOMContentLoaded для инициализации
document.addEventListener('DOMContentLoaded', function() {
  console.log('Vanilla handler loaded, submitCommentForm is available:', typeof window.submitCommentForm);
  
  // Находим все формы комментариев
  const forms = document.querySelectorAll('.js-comment-form-vanilla');
  console.log('Found', forms.length, 'vanilla comment forms');
  
  // Добавляем обработчики событий
  forms.forEach(form => {
    console.log('Adding submit handler to form:', form);
    form.addEventListener('submit', function(event) {
      console.log('Form submit event triggered');
      return submitCommentForm(this);
    });
  });
});