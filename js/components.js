/**
 * SPS CODE ORBIT - Reusable UI Component Renderer
 */

function formatInlineQuestionText(text) {
  if (!text) return '';
  let str = String(text);

  // Convert raw HTML tags (opening <tag> and closing </tag>) into formatted inline code chips
  str = str.replace(/<([a-zA-Z0-9]+)(\s+[^>]*)?>/g, function(match, tagName) {
    return `<code style="background: rgba(30, 41, 59, 0.9); color: #38BDF8; border: 1px solid rgba(56, 189, 248, 0.3); padding: 0.15rem 0.45rem; border-radius: 4px; font-family: var(--font-mono, monospace); font-size: 0.85em; font-weight: 700; display: inline-block; vertical-align: middle; margin: 0 0.15rem;">&lt;${tagName}&gt;</code>`;
  });

  str = str.replace(/<\/([a-zA-Z0-9]+)>/g, function(match, tagName) {
    return `<code style="background: rgba(30, 41, 59, 0.9); color: #38BDF8; border: 1px solid rgba(56, 189, 248, 0.3); padding: 0.15rem 0.45rem; border-radius: 4px; font-family: var(--font-mono, monospace); font-size: 0.85em; font-weight: 700; display: inline-block; vertical-align: middle; margin: 0 0.15rem;">&lt;/${tagName}&gt;</code>`;
  });

  // Convert backtick syntax `code` into inline code chips
  str = str.replace(/`([^`]+)`/g, function(match, codeContent) {
    return `<code style="background: rgba(30, 41, 59, 0.9); color: #38BDF8; border: 1px solid rgba(56, 189, 248, 0.3); padding: 0.15rem 0.45rem; border-radius: 4px; font-family: var(--font-mono, monospace); font-size: 0.85em; font-weight: 700; display: inline-block; vertical-align: middle; margin: 0 0.15rem;">${codeContent}</code>`;
  });

  return str;
}

if (typeof window !== 'undefined') {
  window.formatInlineQuestionText = formatInlineQuestionText;
}

function renderSidebar(activeKey = 'dashboard') {
  const user = window.session ? window.session.user : { full_name: 'Student', role: 'student' };
  if (!user) return; // Wait for session if not loaded

  
  const avatar = user.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.full_name || 'User')}&background=E0E7FF&color=4338CA`;
  
  const navItems = [
    { key: 'dashboard', label: 'Dashboard', icon: 'layout-dashboard', href: '/student/dashboard.html' },
    { key: 'my-courses', label: 'My Courses', icon: 'book-open', href: '/student/courses.html' },
    { key: 'explore', label: 'Explore Courses', icon: 'compass', href: '/courses.html' },
    { key: 'challenges', label: 'Challenges', icon: 'trophy', href: '/student/challenges.html' },
    { key: 'progress', label: 'Progress', icon: 'bar-chart-2', href: '/student/progress.html' },
    { key: 'profile', label: 'Profile', icon: 'user', href: '/student/profile.html' }
  ];

  const sidebarEl = document.getElementById('app-sidebar');
  if (!sidebarEl) return;

  sidebarEl.className = 'sidebar';
  sidebarEl.innerHTML = `
    <a href="/index.html" class="sidebar-brand" id="sidebar-logo">
      <div class="sidebar-brand-icon">
        <i data-lucide="orbit" style="width: 26px; height: 26px;"></i>
      </div>
      <span>SPS Code Orbit</span>
    </a>

    <nav class="sidebar-nav" id="sidebar-nav-list">
      ${navItems.map(item => `
        <a href="${item.href}" class="nav-item ${activeKey === item.key ? 'active' : ''}" id="nav-item-${item.key}">
          <i data-lucide="${item.icon}"></i>
          <span>${item.label}</span>
        </a>
      `).join('')}
    </nav>

    <div class="sidebar-footer">
      <div class="theme-switch-row" id="theme-switch-row">
        <span>Theme</span>
        <div class="theme-toggle-group">
          <i data-lucide="sun" style="width: 16px; height: 16px;"></i>
          <div class="theme-toggle-pill" onclick="window.toggleTheme()" id="theme-toggle-btn" title="Toggle Light/Dark Theme">
            <div class="theme-toggle-dot"></div>
          </div>
          <i data-lucide="moon" style="width: 16px; height: 16px;"></i>
        </div>
      </div>

      <a href="/student/profile.html#settings" class="nav-item" id="nav-settings">
        <i data-lucide="settings"></i>
        <span>Settings</span>
      </a>

      <a href="/about.html#help" class="nav-item" id="nav-help">
        <i data-lucide="help-circle"></i>
        <span>Help & Support</span>
      </a>

      <a href="javascript:void(0)" onclick="window.session.logout()" class="nav-item" id="nav-logout" style="color: #EF4444;">
        <i data-lucide="log-out" style="color: #EF4444;"></i>
        <span style="color: #EF4444; font-weight: 600;">Log Out</span>
      </a>

      <div class="sidebar-user-card" onclick="window.location.href='/student/profile.html'" id="sidebar-user-profile">
        <img src="${avatar}" alt="${user.full_name}" class="sidebar-user-avatar" id="sidebar-user-img">
        <div class="sidebar-user-info">
          <div class="sidebar-user-name">${user.full_name}</div>
          <div class="sidebar-user-meta">@${user.username || 'student'}</div>
        </div>
        <i data-lucide="chevron-right" style="width: 16px; height: 16px; color: #64748B;"></i>
      </div>
    </div>
  `;

  if (window.lucide) {
    window.lucide.createIcons();
  }
}

function renderHeader(customGreeting = null, customSub = null) {
  const user = window.session ? window.session.user : { full_name: 'Student' };
  if (!user) return;
  const headerEl = document.getElementById('top-header');
  if (!headerEl) return;

  const avatar = user.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.full_name || 'User')}&background=E0E7FF&color=4338CA`;

  const titleHtml = customGreeting || `Good morning, <span style="color: var(--color-primary);">${user.full_name}.</span>`;
  const subHtml = customSub || `Ready to continue your learning journey?`;

  headerEl.className = 'top-header';
  headerEl.innerHTML = `
    <div style="display: flex; align-items: center; gap: 1rem;">
      <button class="mobile-nav-toggle" onclick="document.getElementById('app-sidebar').classList.toggle('open')" id="mobile-menu-btn" title="Menu">
        <i data-lucide="menu"></i>
      </button>
      <div class="header-greeting">
        <h1>${titleHtml}</h1>
        <p>${subHtml}</p>
      </div>
    </div>

    <div class="header-actions">
      <div class="notification-bell" onclick="showToast('You have 3 unread course announcements', 'info')" id="header-notif-bell" title="Notifications">
        <i data-lucide="bell" style="width: 20px; height: 20px;"></i>
        <span class="notification-badge">${user.notificationsCount || 0}</span>
      </div>
      <a href="/student/profile.html" id="header-profile-link">
        <img src="${avatar}" alt="${user.full_name}" class="header-user-avatar" id="header-user-img">
      </a>
    </div>
  `;

  if (window.lucide) {
    window.lucide.createIcons();
  }
}

function showToast(message, type = 'info') {
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    document.body.appendChild(container);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `
    <div style="flex: 1; font-weight: 500;">${message}</div>
    <button onclick="this.parentElement.remove()" style="color: inherit; opacity: 0.7;">&times;</button>
  `;

  container.appendChild(toast);
  setTimeout(() => {
    if (toast.parentElement) toast.remove();
  }, 4000);
}

function getDashboardUrl(user) {
  if (!user) return '/student/dashboard.html';
  if (user.role === 'admin') return '/admin/dashboard.html';
  if (user.role === 'teacher') return '/teacher/dashboard.html';
  return '/student/dashboard.html';
}

function getAccountUrl(user) {
  if (!user) return '/login.html';
  if (user.role === 'admin') return '/admin/dashboard.html';
  if (user.role === 'teacher') return '/teacher/dashboard.html';
  return '/student/profile.html';
}

function renderAuthNavHTML(user) {
  if (!user) {
    return `
      <a href="/login.html" class="login-link" id="nav-btn-login">Log In</a>
      <a href="/signup.html" class="btn-pill btn-white-pill" id="nav-btn-get-started">Get Started</a>
    `;
  }

  const avatar = user.avatar_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.full_name || user.username || 'User')}&background=38BDF8&color=070A14&bold=true`;
  const dashUrl = getDashboardUrl(user);
  const accountUrl = getAccountUrl(user);
  const displayName = user.full_name || user.username || 'Student';
  const firstName = displayName.split(' ')[0];

  return `
    <div class="nav-user-cluster" id="nav-user-profile-badge">
      <a href="${dashUrl}" class="btn-pill btn-white-pill nav-dash-btn">
        <i data-lucide="layout-dashboard" style="width: 15px; height: 15px;"></i>
        <span>Dashboard</span>
      </a>
      <a href="${accountUrl}" class="nav-user-chip" title="Account">
        <img src="${avatar}" alt="${displayName}" class="nav-user-avatar">
        <span class="nav-user-name">${firstName}</span>
      </a>
      <button type="button" class="nav-logout-btn" onclick="window.session ? window.session.logout() : (location.href='/login.html')" title="Log out" aria-label="Log out">
        <i data-lucide="log-out" style="width: 16px; height: 16px;"></i>
      </button>
    </div>
  `;
}

/** Content for mobile side drawer auth section */
function renderDrawerAuthHTML(user) {
  if (!user) {
    return `
      <a href="/login.html" class="btn-pill btn-glass drawer-link">Log In</a>
      <a href="/signup.html" class="btn-pill btn-primary-cyan drawer-link">Get Started</a>
    `;
  }
  const dashUrl = getDashboardUrl(user);
  const accountUrl = getAccountUrl(user);
  const displayName = user.full_name || user.username || 'Student';
  return `
    <a href="${dashUrl}" class="nav-link drawer-link"><i data-lucide="layout-dashboard" style="width:18px;height:18px;margin-right:0.5rem;vertical-align:middle;"></i> Dashboard</a>
    <a href="${accountUrl}" class="nav-link drawer-link"><i data-lucide="user" style="width:18px;height:18px;margin-right:0.5rem;vertical-align:middle;"></i> Account</a>
    <button type="button" class="btn-pill btn-glass drawer-link drawer-logout" onclick="window.session ? window.session.logout() : (location.href='/login.html')">
      <i data-lucide="log-out" style="width:16px;height:16px;"></i> Log out
    </button>
    <p class="drawer-user-label">${displayName}</p>
  `;
}

function applyAuthToNav(user) {
  const authGroup = document.getElementById('header-auth-group') || document.querySelector('.nav-auth');
  if (authGroup) {
    authGroup.innerHTML = renderAuthNavHTML(user);
  }
  const drawer = document.getElementById('mobile-drawer-actions');
  if (drawer) {
    drawer.innerHTML = renderDrawerAuthHTML(user);
  }
  if (window.lucide && typeof lucide.createIcons === 'function') {
    try { lucide.createIcons(); } catch (e) {}
  }
}

function initGlobalNavAuth() {
  if (window.session && window.session.user) {
    applyAuthToNav(window.session.user);
  }
  if (window.session) {
    window.session.fetchUser().then(user => {
      applyAuthToNav(user);
    }).catch(() => {
      applyAuthToNav(null);
    });
  }
}

if (typeof document !== 'undefined') {
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGlobalNavAuth);
  } else {
    initGlobalNavAuth();
  }
}

window.renderSidebar = renderSidebar;
window.renderHeader = renderHeader;
window.showToast = showToast;
window.initGlobalNavAuth = initGlobalNavAuth;
window.renderAuthNavHTML = renderAuthNavHTML;
window.applyAuthToNav = applyAuthToNav;
window.renderDrawerAuthHTML = renderDrawerAuthHTML;

