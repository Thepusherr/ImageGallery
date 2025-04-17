// Функция для обработки отправки формы комментария
function handleCommentFormSubmit(event) {
  // Предотвращаем стандартное поведение формы
  event.preventDefault();
  
  // Получаем данные формы
  const form = event.target;
  const formData = new FormData(form);
  const url = form.action;
  
  // Отправляем AJAX-запрос
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
    // Обрабатываем ответ в формате Turbo Stream
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const turboStreamElements = doc.querySelectorAll('turbo-stream');
    
    if (turboStreamElements.length > 0) {
      // Применяем каждый Turbo Stream элемент
      turboStreamElements.forEach(element => {
        document.body.appendChild(element);
      });
    }
    
    // Очищаем форму
    form.reset();
  })
  .catch(error => {
    console.error('Error:', error);
  });
}

// Функция для добавления обработчиков событий к формам комментариев
function addCommentFormHandlers() {
  // Находим все формы комментариев
  const commentForms = document.querySelectorAll('.js-comment-form');
  
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

// Добавляем обработчики при загрузке через Turbo
document.addEventListener('turbo:load', addCommentFormHandlers);

// Добавляем обработчики при рендеринге через Turbo Frame
document.addEventListener('turbo:frame-render', addCommentFormHandlers);

// Добавляем обработчики при рендеринге через Turbo Stream
document.addEventListener('turbo:before-stream-render', addCommentFormHandlers);