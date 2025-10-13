import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="time-updates"
export default class extends Controller {
  connect() {
    // Обновляем сразу при загрузке
    setTimeout(() => this.updatePostTimes(), 1000);

    // Затем каждую минуту
    this.intervalId = setInterval(() => this.updatePostTimes(), 60000);
  }

  disconnect() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
    }
  }

  // Обновление времени постов каждую минуту
  updatePostTimes() {
    this.updatePostTimesWithLocale();
  }

  // Обновление времени постов с учетом локали
  updatePostTimesWithLocale(locale = null) {
    const timeElements = document.querySelectorAll('[id$="time"]');

    timeElements.forEach(element => {
      const postId = element.id.replace('post', '').replace('time', '');
      if (postId) {
        // Отправляем AJAX запрос для получения обновленного времени
        const url = locale ?
          `/posts/${postId}/time_update?locale=${locale}` :
          `/posts/${postId}/time_update`;

        fetch(url, {
          method: 'GET',
          headers: {
            'Accept': 'text/html',
            'X-Requested-With': 'XMLHttpRequest'
          }
        })
        .then(response => response.text())
        .then(html => {
          if (html.trim()) {
            element.outerHTML = html;
          }
        })
        .catch(error => console.log('Time update error:', error));
      }
    });
  }
}
