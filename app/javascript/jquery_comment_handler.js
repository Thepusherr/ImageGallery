document.addEventListener('DOMContentLoaded', function() {
  console.log('jQuery comment handler loaded');
  
  if (typeof jQuery === 'undefined') {
    console.error('jQuery is not loaded');
    return;
  }
  
  console.log('jQuery is available:', jQuery.fn.jquery);
  
  jQuery(document).on('click', '.js-post-comment', function(event) {
    console.log('Post link clicked');
    
    event.preventDefault();

    var postId = jQuery(this).data('post-id');
    var commentText = jQuery(this).closest('.card-footer').find('input').val();
    
    console.log('Post ID:', postId, 'Comment text:', commentText);
    
    if (!commentText || commentText.trim() === '') {
      console.log('Comment text is empty, not sending request');
      return;
    }

    var url = '/posts/' + postId + '/comments';
    
    console.log('Sending AJAX request to:', url);

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