window.addEventListener("load", (event) => {
  const process_nav = document.querySelector('#process-nav-content');
  const active_child = process_nav.querySelector('li + li.is-active');

  if (active_child != null) {
    process_nav.scrollIntoView({ behavior: "smooth", block: "start", inline: "start" });
  }
});