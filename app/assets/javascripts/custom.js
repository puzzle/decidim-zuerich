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
console.log('Installing event listener on load event')
window.addEventListener("load", (event) => {
  console.log('load event was triggered');
  const announcement = document.querySelector('.process-header + .wrapper .callout.announcement');
  console.log('found announcement:', announcement);
  if (announcement == null) return;

  // Convention: Only redirect if the announcement text starts and ends with three dashes.
  const text = announcement.textContent.trim();
  console.log('announcement has text:', text);
  if (text.match(/^---.*---$/) === null) return;
  console.log('text matches the --- convention');

  const redirectLink = announcement.querySelector('a');
  console.log('found redirect link in announcement:', redirectLink);
  if (redirectLink == null || !redirectLink.getAttribute('href')) return;
  console.log('redirectLink has href', redirectLink.getAttribute('href'));

  console.log('we are currently at', window.location, 'but now we will redirect...');
  window.location.replace(redirectLink.getAttribute('href'));
  console.log('redirect command has finished');
});
console.log('finished installing event listener');
