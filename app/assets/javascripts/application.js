// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery3
// Change the import strategy to manually import all required scripts
// require_tree .
//= require cable.js
//= require decidim
//= require custom.js


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
