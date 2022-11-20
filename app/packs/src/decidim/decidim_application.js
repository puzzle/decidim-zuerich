// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack
//
//

// Maybe not needed if all are replacing existing files
// import app/packs/src/application.js;
// import app/packs/src/cable.js;
// import app/packs/src/custom.js;

// Load images
require.context("../../images", true);

/**
 * Make the search bar (topbar) in the page header scroll out of sight AFTER
 * the logobar below it. This is acheived by the following setup:
 *
 * - The topbar comes AFTER the logobar in the HTML markup
 * - Initially, the topbar is visually moved above the logobar using position:fixed and
 *   padding-top on the containing header div. This way, the topbar sticks to the top of
 *   the screen.
 * - As soon as the user scrolls so far that the logobar is completely out of sight,
 *   we remove the fixed position and the top padding, so the topbar is now visually
 *   below the (out of sight) logobar.
 * - When the user scrolls back up, we restore the positioning from before.
 *
 */
window.addEventListener('scroll', () => {
  const currentScroll = window.pageYOffset

  // The bar containing the search box
  const topbar = document.getElementById('topbar')
  // The bar containing the application logo
  const logobar = document.getElementById('logobar')
  // The header div that wraps both the above bars
  const header = document.getElementById('header')

  if (currentScroll > logobar.offsetHeight) {
    topbar.style.position = 'static'
    header.style.paddingTop = 0
  } else {
    topbar.style.position = 'fixed'
    header.style.paddingTop = '3.75rem'
  }
})

window.addEventListener("load", (event) => {
  const process_nav = document.querySelector('#process-nav-content > ul');
  if (process_nav == null) {
    return;
  }

  const active_child = process_nav.querySelector('li + li.is-active');

  if (active_child != null) {
    process_nav.scrollIntoView({ behavior: "smooth", block: "start", inline: "start" });
  }
});

/**
 * Redirect to external participatory processes
 */
window.addEventListener("load", (event) => {
  const announcement = document.querySelector('.process-header + .wrapper .callout.announcement');
  if (announcement == null) return;

  // Convention: Only redirect if the announcement text starts and ends with three dashes.
  const text = announcement.textContent.trim();
  if (text.match(/^---.*---$/) === null) return;

  const redirectLink = announcement.querySelector('a');
  if (redirectLink == null || !redirectLink.getAttribute('href')) return;

  window.location.replace(redirectLink.getAttribute('href'));
});

/**
 * Scroll to beginning of step in a questionnaire
 */

document.addEventListener("DOMContentLoaded", () => {
  function scrollToStep() {
    setTimeout(() => {
      const step = $('.questionnaire-step:not(.hide)')[0];
      step.scrollIntoView({behavior: "smooth"});
    }, 1)
  }

  const buttons = document.querySelectorAll('.questionnaire-step a[data-toggle]');

  buttons.forEach(button => {
    button.removeAttribute('href');
    $(button).on('click', () => scrollToStep());
  });

});