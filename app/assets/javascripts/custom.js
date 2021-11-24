$(() => {
  const process_nav = document.querySelector('#process-nav-content');
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
  const redirectLink = document.querySelector('.process-header + .wrapper .callout.announcement a');
  if (redirectLink != null) {
    window.location.replace(redirectLink.getAttribute('href'));
  }
});
