/**
 * Mobile side-drawer nav — works when #mobile-nav-btn and #primary-nav-links exist.
 */
(function () {
  function init() {
    var btn = document.getElementById('mobile-nav-btn');
    var nav = document.getElementById('primary-nav-links');
    var backdrop = document.getElementById('mobile-nav-backdrop');
    if (!btn || !nav) return;

    function setOpen(open) {
      nav.classList.toggle('is-open', open);
      btn.setAttribute('aria-expanded', open ? 'true' : 'false');
      btn.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
      if (backdrop) {
        backdrop.hidden = !open;
        backdrop.classList.toggle('is-open', open);
      }
      document.body.style.overflow = open ? 'hidden' : '';
      var icon = btn.querySelector('[data-lucide]');
      if (icon) {
        icon.setAttribute('data-lucide', open ? 'x' : 'menu');
        if (window.lucide && typeof lucide.createIcons === 'function') {
          try { lucide.createIcons({ nodes: [btn] }); } catch (e) {}
        }
      }
    }

    btn.addEventListener('click', function () {
      setOpen(!nav.classList.contains('is-open'));
    });
    if (backdrop) backdrop.addEventListener('click', function () { setOpen(false); });
    nav.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () { setOpen(false); });
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') setOpen(false);
    });
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
