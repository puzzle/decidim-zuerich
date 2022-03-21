window.addEventListener("load", (event) => {
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
  const announcement = document.querySelector('.process-header + .wrapper .callout.announcement');
  if (announcement == null) return;

  // Convention: Only redirect if the announcement text starts and ends with three dashes.
  const text = announcement.textContent.trim();
  if (text.match(/^---.*---$/) === null) return;

  const redirectLink = announcement.querySelector('a');
  if (redirectLink == null || !redirectLink.getAttribute('href')) return;

  window.location.replace(redirectLink.getAttribute('href'));
});
