// Обработчик для формы комментария с использованием jQuery
document.addEventListener('DOMContentLoaded', function() {
  // Проверяем, что jQuery доступен
  if (typeof jQuery === 'undefined') {
    console.error('jQuery is not loaded');
    return;
  }
  
  // Находим все формы комментариев
  jQuery(document).on('submit', '.js-comment-form', function(event) {
    // Предотвращаем стандартное поведение формы
    event.preventDefault();
    
    // Получаем данные формы
    var form = jQuery(this);
    var url = form.attr('action');
    var formData = new FormData(this);
    
    // Отправляем AJAX-запрос
    jQuery.ajax({
      url: url,
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      dataType: 'script',
      success: function(data) {
        // Очищаем форму
        form[0].reset();
      },
      error: function(xhr, status, error) {
        console.error('Error:', error);
      }
    });
  });
});