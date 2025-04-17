// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "turbo_stream_handler"
import "comment_form_handler"
import "jquery_comment_handler"
import "ujs_comment_handler"
import "direct_upload"
import "rails_ujs_handler"
import "vanilla_handler"
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