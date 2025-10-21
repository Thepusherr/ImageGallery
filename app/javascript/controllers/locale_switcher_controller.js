import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="locale-switcher"
export default class extends Controller {
  static targets = ["dropdown", "item"]

  switchLanguage(event) {
    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }

    const locale = event.currentTarget.dataset.locale;
    console.log('Switching to locale:', locale);

    fetch('/switch_locale/' + locale, {
      method: 'GET',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    }).then(response => {
      console.log('Response status:', response.status);
      return response.json();
    })
    .then(data => {
      console.log('Response data:', data);

      if (data.status === 'success') {

        const dropdownToggle = document.querySelector('.dropdown-toggle');
        if (dropdownToggle) {
          dropdownToggle.innerHTML = '<i class="bi bi-globe"></i> ' + locale.toUpperCase();
        }

        document.querySelectorAll('.dropdown-item').forEach(item => {
          item.classList.remove('active');
        });

        if (event && event.target) {
          event.target.classList.add('active');
        }

        this.updatePageTranslations(data.translations);

        console.log('Language switched successfully');
      } else {
        console.error('Failed to switch language');
      }
    })
    .catch(error => {
      console.error('Error switching language:', error);
    });

    return false;
  }

  updatePageTranslations(translations) {
    console.log('Updating translations:', translations);

    const galleryTitle = document.querySelector('h2.mb-4');
    console.log('Gallery title element:', galleryTitle);
    if (galleryTitle && translations.gallery_title) {
      galleryTitle.textContent = translations.gallery_title;
      console.log('Updated gallery title to:', translations.gallery_title);
    }

    const timeUpdatesController = this.application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller*="time-updates"]'), 
      "time-updates"
    );
    if (timeUpdatesController) {
      timeUpdatesController.updatePostTimesWithLocale(translations.locale);
    }

    this.updateNavigation(translations);

    this.updateUserDropdown(translations);
  }

  updateNavigation(translations) {
    const navLinks = document.querySelectorAll('.navmenu a');
    console.log('Found nav links:', navLinks.length);

    if (translations.navigation) {
      navLinks.forEach((link, index) => {
        const href = link.getAttribute('href');
        console.log(`Link ${index}: href=${href}, text=${link.textContent}`);

        if (href && href.includes('starter_page') && translations.navigation.home) {
          link.textContent = translations.navigation.home;
          console.log('Updated home link');
        } else if (href && href.includes('profile') && translations.navigation.profile) {
          link.textContent = translations.navigation.profile;
          console.log('Updated profile link');
        } else if (href && href.includes('about') && translations.navigation.about) {
          link.textContent = translations.navigation.about;
          console.log('Updated about link');
        } else if (href && href.includes('gallery') && translations.navigation.categories) {
          const span = link.querySelector('span');
          if (span) {
            span.textContent = translations.navigation.categories;
            console.log('Updated categories link');
          }
        } else if (href && href.includes('services') && translations.navigation.services) {
          link.textContent = translations.navigation.services;
          console.log('Updated services link');
        } else if (href && href.includes('contact') && translations.navigation.contact) {
          link.textContent = translations.navigation.contact;
          console.log('Updated contact link');
        }
      });
    }
  }

  updateUserDropdown(translations) {
    if (translations.user) {
      const signInBtn = document.querySelector('a[href*="sign_in"] span, a[href*="sign_in"]');
      if (signInBtn && translations.user.sign_in) {
        if (signInBtn.tagName === 'SPAN') {
          signInBtn.textContent = translations.user.sign_in;
        } else {
          const span = signInBtn.querySelector('span');
          if (span) span.textContent = translations.user.sign_in;
        }
        console.log('Updated sign in button');
      }

      const signUpBtn = document.querySelector('a[href*="sign_up"] span, a[href*="sign_up"]');
      if (signUpBtn && translations.user.sign_up) {
        if (signUpBtn.tagName === 'SPAN') {
          signUpBtn.textContent = translations.user.sign_up;
        } else {
          const span = signUpBtn.querySelector('span');
          if (span) span.textContent = translations.user.sign_up;
        }
        console.log('Updated sign up button');
      }

      const profileLink = document.querySelector('.dropdown-item[href*="profile"]');
      if (profileLink && translations.navigation.profile) {
        const textNode = Array.from(profileLink.childNodes).find(node => node.nodeType === 3 && node.textContent.trim());
        if (textNode) {
          textNode.textContent = ' ' + translations.navigation.profile;
        }
        console.log('Updated profile link');
      }

      const editProfileLink = document.querySelector('.dropdown-item[href*="edit"]');
      if (editProfileLink && translations.user.edit_profile) {
        const textNode = Array.from(editProfileLink.childNodes).find(node => node.nodeType === 3 && node.textContent.trim());
        if (textNode) {
          textNode.textContent = ' ' + translations.user.edit_profile;
        }
        console.log('Updated edit profile link');
      }

      const signOutLink = document.querySelector('a[data-method="delete"]');
      if (signOutLink && translations.user.sign_out) {
        const textNode = Array.from(signOutLink.childNodes).find(node => node.nodeType === 3 && node.textContent.trim());
        if (textNode) {
          textNode.textContent = ' ' + translations.user.sign_out;
        }
        console.log('Updated sign out link');
      }
    }
  }
}
