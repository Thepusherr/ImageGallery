// Прямая отправка формы комментария без использования Turbo
document.addEventListener('DOMContentLoaded', function() {
  // Находим все формы комментариев
  const forms = document.querySelectorAll('.js-comment-form-ujs');
  
  forms.forEach(form => {
    form.addEventListener('submit', function(event) {
      // Предотвращаем стандартное поведение формы
      event.preventDefault();
      
      // Получаем данные формы
      const formData = new FormData(this);
      const url = this.action;
      
      // Создаем AJAX-запрос
      const xhr = new XMLHttpRequest();
      xhr.open('POST', url, true);
      xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      
      // Обрабатываем ответ
      xhr.onload = function() {
        if (xhr.status >= 200 && xhr.status < 400) {
          // Успешный ответ
          try {
            // Выполняем JavaScript из ответа
            eval(xhr.responseText);
            
            // Очищаем форму
            form.reset();
            
            // Обновляем URL, чтобы убрать .js
            if (window.history && window.history.pushState) {
              const newUrl = window.location.href.replace('/comments.js', '');
              window.history.pushState({}, '', newUrl);
            }
          } catch (e) {
            console.error('Error evaluating response:', e);
          }
        } else {
          // Ошибка
          console.error('Request failed');
          alert('Failed to create comment.');
        }
      };
      
      // Обрабатываем ошибки сети
      xhr.onerror = function() {
        console.error('Network error');
        alert('Network error occurred.');
      };
      
      // Отправляем запрос
      xhr.send(formData);
    });
  });
});