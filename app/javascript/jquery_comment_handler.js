// Обработчик для кнопки комментария с использованием jQuery
document.addEventListener('DOMContentLoaded', function() {
  console.log('jQuery comment handler loaded');
  
  // Проверяем, что jQuery доступен
  if (typeof jQuery === 'undefined') {
    console.error('jQuery is not loaded');
    return;
  }
  
  console.log('jQuery is available:', jQuery.fn.jquery);
  
  // Обработчик клика по ссылке "Post"
  jQuery(document).on('click', '.js-post-comment', function(event) {
    console.log('Post link clicked');
    
    // Предотвращаем стандартное поведение ссылки
    event.preventDefault();
    
    // Получаем ID поста и текст комментария
    var postId = jQuery(this).data('post-id');
    var commentText = jQuery(this).closest('.card-footer').find('input').val();
    
    console.log('Post ID:', postId, 'Comment text:', commentText);
    
    if (!commentText || commentText.trim() === '') {
      console.log('Comment text is empty, not sending request');
      return;
    }
    
    // Формируем URL для запроса
    var url = '/posts/' + postId + '/comments';
    
    console.log('Sending AJAX request to:', url);
    
    // Отправляем AJAX-запрос
    jQuery.ajax({
      url: url,
      type: 'POST',
      data: {
        text: commentText,
        authenticity_token: jQuery('meta[name="csrf-token"]').attr('content')
      },
      dataType: 'script',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      success: function(data) {
        console.log('AJAX request successful');
        // Очищаем поле ввода
        jQuery('#comment-text').val('');
      },
      error: function(xhr, status, error) {
        console.error('AJAX Error:', error);
        console.error('Status:', status);
        console.error('Response:', xhr.responseText);
        alert('Failed to create comment. Please try again.');
      }
    });
    
    return false;
  });
});