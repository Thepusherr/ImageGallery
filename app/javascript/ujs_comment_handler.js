// Функция для обработки отправки формы комментария
function handleCommentFormSubmit(event) {
  // Предотвращаем стандартное поведение формы
  event.preventDefault();
  
  // Получаем данные формы
  const form = event.target;
  const url = form.action;
  const formData = new FormData(form);
  
  // Отправляем AJAX-запрос
  const xhr = new XMLHttpRequest();
  xhr.open('POST', url, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.setRequestHeader('Accept', 'text/javascript');
  
  xhr.onload = function() {
    if (xhr.status >= 200 && xhr.status < 300) {
      // Выполняем JavaScript-ответ
      eval(xhr.responseText);
      
      // Очищаем форму
      form.reset();
      
      // Предотвращаем переход на страницу поста
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

// Функция для добавления обработчиков событий к формам комментариев
function addCommentFormHandlers() {
  // Находим все формы комментариев
  const commentForms = document.querySelectorAll('.js-comment-form-ujs');
  
  // Добавляем обработчик события submit для каждой формы
  commentForms.forEach(form => {
    // Удаляем существующие обработчики, чтобы избежать дублирования
    form.removeEventListener('submit', handleCommentFormSubmit);
    
    // Добавляем новый обработчик
    form.addEventListener('submit', handleCommentFormSubmit);
  });
}

// Добавляем обработчики при загрузке страницы
document.addEventListener('DOMContentLoaded', addCommentFormHandlers);

// Также добавляем обработчик для динамически добавленных форм
document.addEventListener('turbo:load', addCommentFormHandlers);
document.addEventListener('turbo:render', addCommentFormHandlers);

// Глобальный обработчик для всех форм с классом js-comment-form-ujs
document.addEventListener('submit', function(event) {
  if (event.target.classList.contains('js-comment-form-ujs')) {
    handleCommentFormSubmit(event);
  }
});