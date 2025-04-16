// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "turbo_stream_handler"

// Глобальный обработчик для предотвращения переходов по умолчанию для форм с Turbo
document.addEventListener('DOMContentLoaded', () => {
  // Отключаем Turbo для форм комментариев
  document.addEventListener('submit', (event) => {
    if (event.target.dataset.controller === 'comments') {
      // Предотвращаем стандартное поведение формы
      event.preventDefault();
      
      // Получаем форму и отправляем ее через AJAX
      const form = event.target;
      const url = form.action;
      const formData = new FormData(form);
      
      fetch(url, {
        method: 'POST',
        body: formData,
        headers: {
          'Accept': 'text/vnd.turbo-stream.html, text/html, application/json',
          'X-Requested-With': 'XMLHttpRequest'
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
  });
});
import "stylesheets/active_admin"
import "stylesheets/main"

import * as FilePond from 'filepond';
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';

import AOS from 'aos';
document.addEventListener('turbo:load', () => { AOS.init() });

FilePond.registerPlugin(FilePondPluginImagePreview);

document.addEventListener("turbo:load", loadFilePond);

function loadFilePond(){
    const input = document.querySelector('.filepond');
    FilePond.create(input);
    const pond = FilePond.create(input, {
        credits: {},
        storeAsFile: true,
        allowMultiple: false,
        allowReorder: true,
    });
}