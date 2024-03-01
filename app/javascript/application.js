// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import * as FilePond from 'filepond';
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';

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