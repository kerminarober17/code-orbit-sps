/**
 * SPS CODE ORBIT - Theme Engine (Elegant Dark Theme)
 */

(function initTheme() {
  const savedTheme = localStorage.getItem('sps_orbit_theme') || 'dark';
  document.documentElement.setAttribute('data-theme', savedTheme);
})();

function toggleTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
  const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', newTheme);
  localStorage.setItem('sps_orbit_theme', newTheme);
}

window.toggleTheme = toggleTheme;

