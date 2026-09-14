/**
 * SPS CODE ORBIT - Gamification & Progress Engine
 * Strictly server-authoritative XP and progress tracking
 */

class GamificationManager {
  constructor() {
    this.totalXP = 0;
    this.level = 1;
    this.streak = 0;
  }

  async loadStatus() {
    try {
      const res = await fetch('/api/gamification/status.php');
      if (res.ok) {
        const json = await res.json();
        if (json.success && json.data) {
          this.totalXP = json.data.total_xp;
          this.level = json.data.level;
          this.streak = json.data.current_streak;
          this.updateUI();
          return json.data;
        }
      }
    } catch (e) {
      console.warn('Failed to load gamification status', e);
    }
    return null;
  }

  updateUI() {
    // Update top header XP pill if present
    const xpBadge = document.getElementById('user-xp-badge') || document.querySelector('.xp-badge-val');
    if (xpBadge) {
      xpBadge.textContent = `${this.totalXP} XP`;
    }

    // Update streak element if present
    const streakEl = document.getElementById('user-streak-counter') || document.querySelector('.streak-val');
    if (streakEl) {
      streakEl.textContent = this.streak;
    }
  }

  async completeLesson(lessonId) {
    if (!lessonId) return { success: false, error: 'Missing lesson ID' };
    
    try {
      const res = await window.apiFetch('/api/lessons/complete.php', {
        method: 'POST',
        body: JSON.stringify({ lesson_id: lessonId })
      });
      const data = await res.json();
      
      if (data.success && data.data) {
        this.totalXP = data.data.total_xp;
        this.streak = data.data.streak;
        this.updateUI();

        if (data.data.xp_awarded > 0) {
          if (window.showToast) {
            window.showToast(`+${data.data.xp_awarded} XP Earned! Great job!`, 'success');
          }
        } else {
          if (window.showToast) {
            window.showToast('Lesson review complete!', 'info');
          }
        }

        if (data.data.unlocked_achievements && data.data.unlocked_achievements.length > 0) {
          data.data.unlocked_achievements.forEach(achTitle => {
            setTimeout(() => {
              if (window.showToast) {
                window.showToast(`🏆 Achievement Unlocked: ${achTitle}!`, 'success');
              }
            }, 1200);
          });
        }

        return data.data;
      } else {
        if (window.showToast) {
          window.showToast(data.error || 'Failed to complete lesson', 'error');
        }
        return { success: false, error: data.error };
      }
    } catch (e) {
      console.error('completeLesson error', e);
      if (window.showToast) {
        window.showToast('Network error while saving progress', 'error');
      }
      return { success: false, error: 'Network error' };
    }
  }
}

window.gamification = new GamificationManager();
