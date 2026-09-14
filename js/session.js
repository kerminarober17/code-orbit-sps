class SessionManager {
    constructor() {
        this.user = null;
        this.csrfToken = null;
        this.userProgress = {};
        try {
            const saved = localStorage.getItem('orbit_user');
            if (saved) {
                this.user = JSON.parse(saved);
            }
            const savedProg = localStorage.getItem('orbit_user_progress');
            if (savedProg) {
                this.userProgress = JSON.parse(savedProg);
            }
        } catch (e) {
            this.user = null;
            this.userProgress = {};
        }
    }

    async getCsrfToken() {
        if (!this.csrfToken) {
            await this.fetchUser();
        }
        return this.csrfToken || '';
    }

    async fetchProgress() {
        if (!this.user || !this.user.id) return {};
        try {
            const res = await fetch(`/api/student/dashboard.php?_t=${Date.now()}`, {
                headers: {
                    'X-User-Id': this.user.id,
                    'Authorization': `Bearer ${this.user.id}`
                }
            });
            if (res.ok) {
                const json = await res.json();
                if (json.success && json.data) {
                    const { courses, user_progress } = json.data;
                    const completedLessons = [];

                    if (user_progress && typeof user_progress === 'object') {
                        this.userProgress = user_progress;
                        Object.values(user_progress).forEach(up => {
                            if (up && Array.isArray(up.completed_lessons)) {
                                completedLessons.push(...up.completed_lessons);
                            }
                        });
                    }

                    if (Array.isArray(courses)) {
                        courses.forEach(c => {
                            if (c.chapters) {
                                c.chapters.forEach(ch => {
                                    (ch.lessons || []).forEach(l => {
                                        if (l.is_completed) completedLessons.push(l.id);
                                    });
                                });
                            }
                        });
                    }

                    if (completedLessons.length > 0 && window.CURRICULUM_INDEX && typeof window.CURRICULUM_INDEX.syncCompletedLessonsToStorage === 'function') {
                        window.CURRICULUM_INDEX.syncCompletedLessonsToStorage(completedLessons);
                    }

                    try {
                        localStorage.setItem('orbit_user_progress', JSON.stringify(this.userProgress));
                    } catch (e) {}

                    return this.userProgress;
                }
            }
        } catch (e) {
            console.warn('Progress fetch background sync:', e);
        }
        return this.userProgress;
    }

    async fetchUser() {
        try {
            const headers = {};
            if (this.user && this.user.id) {
                headers['X-User-Id'] = this.user.id;
                headers['Authorization'] = `Bearer ${this.user.id}`;
            }
            const res = await fetch('/api/auth/me.php', { headers });
            if (res.ok) {
                const data = await res.json();
                if (data.success && data.data) {
                    if (data.data.csrf_token) {
                        this.csrfToken = data.data.csrf_token;
                    }
                    if (data.data.user) {
                        this.user = data.data.user;
                        try {
                            localStorage.setItem('orbit_user', JSON.stringify(this.user));
                        } catch (e) {}
                        // Automatically synchronize saved database progress
                        await this.fetchProgress();
                        return this.user;
                    } else {
                        this.user = null;
                        this.userProgress = {};
                        try {
                            localStorage.removeItem('orbit_user');
                            localStorage.removeItem('orbit_user_progress');
                        } catch (e) {}
                        return null;
                    }
                }
            }
        } catch (e) {
            console.error('Session fetch failed', e);
        }
        return this.user;
    }

    async requireAuth(allowedRoles = []) {
        const user = await this.fetchUser();
        if (!user) {
            window.location.href = '/login.html';
            return null;
        }
        if (allowedRoles.length > 0 && !allowedRoles.includes(user.role)) {
            this.redirectByRole(user.role);
            return null;
        }
        return user;
    }

    async requireGuest() {
        const user = await this.fetchUser();
        if (user) {
            this.redirectByRole(user.role);
            return null;
        }
    }

    redirectByRole(role) {
        if (role === 'admin') window.location.href = '/admin/dashboard.html';
        else if (role === 'teacher') window.location.href = '/teacher/dashboard.html';
        else window.location.href = '/student/dashboard.html';
    }

    async login(username, password) {
        try {
            // If we don't have a csrf token yet, fetch me.php to initialize session cookie & token
            if (!this.csrfToken) {
                await this.fetchUser();
            }
            const headers = { 'Content-Type': 'application/json' };
            if (this.csrfToken) {
                headers['X-CSRF-Token'] = this.csrfToken;
            }
            const res = await fetch('/api/auth/login.php', {
                method: 'POST',
                headers: headers,
                body: JSON.stringify({ username, password })
            });
            const data = await res.json();
            if (data.success && data.data) {
                this.user = data.data.user;
                try {
                    localStorage.setItem('orbit_user', JSON.stringify(this.user));
                } catch (e) {}
                if (data.data.csrf_token) {
                    this.csrfToken = data.data.csrf_token;
                }
                // Instantly fetch and sync user progress from database
                await this.fetchProgress();
            }
            return data;
        } catch (e) {
            return { success: false, error: 'Network error' };
        }
    }

    async logout() {
        try {
            const headers = {};
            if (this.csrfToken) {
                headers['X-CSRF-Token'] = this.csrfToken;
            }
            if (this.user && this.user.id) {
                headers['X-User-Id'] = this.user.id;
            }
            await fetch('/api/auth/logout.php', { method: 'POST', headers });
        } catch (e) {
            console.warn('Logout network error, clearing local state', e);
        }
        this.user = null;
        this.userProgress = {};
        this.csrfToken = null;
        try {
            localStorage.clear();
            sessionStorage.clear();
        } catch (e) {}
        window.location.href = '/login.html';
    }
}

window.session = new SessionManager();

// Global secure fetch wrapper that attaches Auth User ID and CSRF tokens
window.apiFetch = async function(url, options = {}) {
    options = Object.assign({}, options);
    options.credentials = 'same-origin';
    options.headers = Object.assign({}, options.headers || {});
    
    // Attach user authentication headers
    const activeUser = window.session.user || (() => {
        try {
            const raw = localStorage.getItem('orbit_user');
            return raw ? JSON.parse(raw) : null;
        } catch (e) { return null; }
    })();

    if (activeUser && activeUser.id) {
        if (!options.headers['X-User-Id']) {
            options.headers['X-User-Id'] = activeUser.id;
        }
        if (!options.headers['Authorization']) {
            options.headers['Authorization'] = `Bearer ${activeUser.id}`;
        }
    }

    const method = (options.method || 'GET').toUpperCase();
    if (['POST', 'PUT', 'PATCH', 'DELETE'].includes(method)) {
        if (!window.session.csrfToken) {
            await window.session.fetchUser();
        }
        if (window.session.csrfToken) {
            options.headers['X-CSRF-Token'] = window.session.csrfToken;
        }
        if (!options.headers['Content-Type'] && !(options.body instanceof FormData)) {
            options.headers['Content-Type'] = 'application/json';
        }
    }
    return fetch(url, options);
};

