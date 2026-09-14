/**
 * SPS CODE ORBIT — CURRICULUM INDEX & REGISTRY
 * Aggregates all courses, chapters, and lessons for fast instant lookups,
 * persistent completion tracking, dynamic sequence unlocking, and API fallbacks.
 */

let dbStore = null;
let getQuestionsForChapter = null;

if (typeof window !== 'undefined') {
  getQuestionsForChapter = window.getQuestionsForChapter || null;
}

if (typeof require === 'function') {
  try {
    if (!getQuestionsForChapter) {
      getQuestionsForChapter = require('./chapter_exams.js').getQuestionsForChapter;
    }
  } catch (e) {}
}

const STORAGE_COMPLETED_KEY = 'sps_orbit_completed_lessons';
const STORAGE_XP_KEY = 'sps_orbit_user_xp';

function getCompletedLessonsMap(userId = 'student-alex-id') {
  if (typeof window === 'undefined' && dbStore) {
    return dbStore.getLessonProgress(userId);
  }

  if (typeof localStorage === 'undefined') return {};
  try {
    const raw = localStorage.getItem(STORAGE_COMPLETED_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch (e) {
    return {};
  }
}

function isLessonCompleted(lessonId, userId = 'student-alex-id') {
  if (!lessonId) return false;
  const map = getCompletedLessonsMap(userId);
  return !!(map[lessonId] && map[lessonId].completed);
}

function markLessonCompleted(lessonId, xpReward = 25, userId = 'student-alex-id') {
  if (!lessonId) return;

  if (typeof window === 'undefined' && dbStore) {
    dbStore.completeLesson(userId, lessonId, xpReward);
    return;
  }

  const map = getCompletedLessonsMap(userId);
  map[lessonId] = {
    completed: true,
    status: 'completed',
    completedAt: new Date().toISOString()
  };
  try {
    localStorage.setItem(STORAGE_COMPLETED_KEY, JSON.stringify(map));
    const currentXp = parseInt(localStorage.getItem(STORAGE_XP_KEY) || '0', 10);
    localStorage.setItem(STORAGE_XP_KEY, String(currentXp + (xpReward || 25)));
  } catch (e) {
    console.warn('LocalStorage save warning:', e);
  }
}

function getUserXp(userId = 'student-alex-id') {
  if (typeof window === 'undefined' && dbStore) {
    return dbStore.getGamification(userId).total_xp || 0;
  }
  if (typeof localStorage === 'undefined') return 0;
  return parseInt(localStorage.getItem(STORAGE_XP_KEY) || '0', 10);
}

function syncUserXpToStorage(xp) {
  if (typeof localStorage === 'undefined') return;
  try {
    localStorage.setItem(STORAGE_XP_KEY, String(xp || 0));
  } catch (e) {}
}

function getRawCourseList() {
  let progFound = null;
  let pyFound = null;
  let pyLevel2 = null;

  if (typeof window !== 'undefined') {
    progFound = window.PROGRAMMING_FOUNDATIONS_COURSE || (typeof PROGRAMMING_FOUNDATIONS_COURSE !== 'undefined' ? PROGRAMMING_FOUNDATIONS_COURSE : null);
    pyFound = window.PYTHON_FOUNDATIONS_COURSE || (typeof PYTHON_FOUNDATIONS_COURSE !== 'undefined' ? PYTHON_FOUNDATIONS_COURSE : null);
    pyLevel2 = window.PYTHON_LEVEL2_COURSE || (typeof PYTHON_LEVEL2_COURSE !== 'undefined' ? PYTHON_LEVEL2_COURSE : null);
  }

  if (!progFound && typeof require === 'function') {
    try { progFound = require('./programming_foundations_curriculum.js').PROGRAMMING_FOUNDATIONS_COURSE; } catch (e) {}
  }
  if (!pyFound && typeof require === 'function') {
    try { pyFound = require('./python_foundations_curriculum.js').PYTHON_FOUNDATIONS_COURSE; } catch (e) {}
  }
  if (!pyLevel2 && typeof require === 'function') {
    try { pyLevel2 = require('./python_level2_curriculum.js').PYTHON_LEVEL2_COURSE; } catch (e) {}
  }

  return [progFound, pyFound, pyLevel2].filter(Boolean);
}

function getAllCourses(userId = 'student-alex-id') {
  const rawList = getRawCourseList();

  return rawList.map(c => {
    const detailed = getCourseByIdOrSlug(c.id, userId);
    const totalLessons = detailed ? detailed.total_lessons : 50;
    const completedLessons = detailed ? detailed.completed_lessons : 0;
    const progressPct = detailed ? detailed.progress : 0;

    let currChapterLabel = (c.chapters && c.chapters[0]) ? `Chapter 1: ${c.chapters[0].title}` : 'Chapter 1';
    if (detailed && detailed.chapters) {
      const activeCh = detailed.chapters.find(ch => ch.badge === 'IN_PROGRESS' || ch.badge === 'EXAM_UNLOCKED' || ch.badge === 'UNLOCKED') || detailed.chapters[0];
      if (activeCh) {
        currChapterLabel = `Chapter ${activeCh.chapter_number}: ${activeCh.title}`;
      }
    }

    return {
      id: c.id,
      slug: c.slug,
      title: c.title,
      description: c.description,
      image: c.image_url,
      image_url: c.image_url,
      accent_color: c.accent_color,
      academic_group_name: c.academic_group,
      academicGroupLabel: c.academic_group,
      academic_group_id: c.academic_group_id,
      chaptersCount: c.chapters ? c.chapters.length : 10,
      lessonsCount: totalLessons,
      total_lessons: totalLessons,
      completed_lessons: completedLessons,
      progress: progressPct,
      currentChapter: currChapterLabel,
      is_published: 1
    };
  });
}

function getNextLessonInSequence(currentLessonId, userId = 'student-alex-id', preferredCourseId = null) {
  if (!currentLessonId) return null;
  const rawList = getRawCourseList();
  const searchId = String(currentLessonId).trim();

  // Infer course from lesson id prefix when not provided (prevents cross-course jumps)
  let forcedCourseId = preferredCourseId || null;
  if (!forcedCourseId) {
    if (searchId.includes('pyl2') || searchId.includes('python-level-2')) forcedCourseId = 'course-python-level-2';
    else if (searchId.includes('pyf') || searchId.includes('python-found')) forcedCourseId = 'course-python-foundations';
    else if (searchId.includes('pf-') || searchId.includes('programming-found')) forcedCourseId = 'course-programming-foundations';
  }

  let targetCourseId = null;
  let targetChapterId = null;
  let allFormattedLessonsInChapter = [];
  let currentIndex = -1;

  const coursesToSearch = forcedCourseId
    ? rawList.filter(c => c.id === forcedCourseId)
    : rawList;

  for (const course of coursesToSearch) {
    const courseDetails = getCourseByIdOrSlug(course.id, userId);
    if (!courseDetails || !courseDetails.chapters) continue;

    for (const ch of courseDetails.chapters) {
      const lessons = ch.lessons || [];
      const idx = lessons.findIndex(l => {
        // Exact id / slug only — never short "1-1" forms (cross-course collisions)
        if (l.id === searchId || l.slug === searchId) return true;
        if (String(l.id) === `exam-${ch.id}` && (searchId === `exam-${ch.id}` || searchId === `exam-${ch.slug}`)) return true;
        return false;
      });
      if (idx !== -1) {
        targetCourseId = course.id;
        targetChapterId = ch.id;
        allFormattedLessonsInChapter = lessons;
        currentIndex = idx;
        break;
      }
    }
    if (currentIndex !== -1) break;
  }

  if (currentIndex === -1) return null;

  // Case 1: Next lesson within the same chapter (e.g. Lesson 4 -> Lesson 5 Exam)
  if (currentIndex < allFormattedLessonsInChapter.length - 1) {
    const nxt = allFormattedLessonsInChapter[currentIndex + 1];
    if (nxt && !nxt.course_id) nxt.course_id = targetCourseId;
    return nxt;
  }

  // Case 2: Last item in chapter (e.g. Lesson 5 Exam) completed -> Next Chapter's 1st Lesson!
  const courseDetails = getCourseByIdOrSlug(targetCourseId, userId);
  if (courseDetails && courseDetails.chapters) {
    const chIdx = courseDetails.chapters.findIndex(ch => ch.id === targetChapterId);
    if (chIdx !== -1 && chIdx < courseDetails.chapters.length - 1) {
      const nextChapter = courseDetails.chapters[chIdx + 1];
      if (nextChapter && nextChapter.lessons && nextChapter.lessons.length > 0) {
        const nxt = nextChapter.lessons[0];
        if (nxt && !nxt.course_id) nxt.course_id = targetCourseId;
        return nxt;
      }
    }
  }

  return null;
}

function getCourseByIdOrSlug(idOrSlug, userId = 'student-alex-id') {
  const rawList = getRawCourseList();
  if (!rawList || rawList.length === 0) return null;

  let target = null;
  if (!idOrSlug) {
    target = rawList[0];
  } else {
    const low = String(idOrSlug).toLowerCase().trim();
    // 1. Exact match on ID or Slug
    target = rawList.find(c => c.id === idOrSlug || c.slug === idOrSlug || c.id.toLowerCase() === low || (c.slug && c.slug.toLowerCase() === low));
    
    // 2. Alias matches for production courses (order matters: Level 2 before Level 1)
    if (!target) {
      if (low.includes('level-2') || low.includes('level2') || low.includes('pyl2') || low === 'python-level-2') {
        target = rawList.find(c => c.id === 'course-python-level-2');
      } else if (low.includes('prog') || low.includes('programming') || low.startsWith('pf-')) {
        target = rawList.find(c => c.id === 'course-programming-foundations');
      } else if (low.includes('python') || low.startsWith('pyf-') || low.startsWith('py-')) {
        target = rawList.find(c => c.id === 'course-python-foundations');
      }
    }

    // 3. Substring match on id, slug, or title
    if (!target) {
      target = rawList.find(c => c.id.toLowerCase().includes(low) || (c.slug && c.slug.toLowerCase().includes(low)) || c.title.toLowerCase().includes(low));
    }

    if (!target) {
      target = rawList[0];
    }
  }

  if (!target) return null;

  const completedMap = getCompletedLessonsMap(userId);
  let totalLessonsCount = 0;
  let totalCompletedCount = 0;

  // Chapter unlocking rule:
  // Chapter 1 is unlocked by default.
  // Chapter N unlocks ONLY IF Chapter N-1's exam was passed (highest_score >= 60% or exam passed).
  let previousChapterExamPassed = true;

  const chaptersFormatted = (target.chapters || []).map((ch, idx) => {
    const rawLessons = (ch.lessons || []).filter(l => !l.is_exam && l.lesson_number !== 5 && String(l.id).indexOf('exam-') !== 0);
    let chapterCompletedCount = 0;

    const isChapterUnlocked = (idx === 0) || previousChapterExamPassed;

    let previousLessonCompletedInChapter = true;

    const formattedLessons = rawLessons.map((l, lIdx) => {
      totalLessonsCount++;
      const isCompleted = !!(completedMap[l.id] && completedMap[l.id].completed);

      // Lesson unlocking rule:
      // Lesson 1 of an unlocked chapter is unlocked.
      // Completed lessons stay unlocked forever.
      // The lesson immediately following a completed lesson in an unlocked chapter is unlocked.
      const isUnlocked = isCompleted || (isChapterUnlocked && ((lIdx === 0) || previousLessonCompletedInChapter));

      if (isCompleted) {
        totalCompletedCount++;
        chapterCompletedCount++;
        previousLessonCompletedInChapter = true;
      } else {
        previousLessonCompletedInChapter = false;
      }

      return {
        id: l.id,
        chapter_id: ch.id,
        slug: l.slug,
        lesson_number: l.lesson_number || lIdx + 1,
        title: l.title,
        duration_minutes: l.duration || 10,
        xp_reward: l.xp || 25,
        is_completed: isCompleted,
        is_unlocked: isUnlocked,
        is_current: !isCompleted && isUnlocked,
        status: isCompleted ? 'completed' : (isUnlocked ? 'unlocked' : 'locked')
      };
    });

    // Check Chapter Exam status from dbStore
    let examAttempts = [];
    let highestScore = null;
    let highestBadge = null;
    let examPassed = false;

    if (dbStore) {
      examAttempts = dbStore.getExamAttempts(userId, ch.id);
      highestScore = dbStore.getHighestExamScore(userId, ch.id);
      if (highestScore !== null) {
        examPassed = highestScore >= 60;
        if (highestScore >= 90) highestBadge = 'PERFECT';
        else if (highestScore >= 60) highestBadge = 'CLEAR';
        else highestBadge = 'NEEDS_IMPROVEMENT';
      }
    }

    // All regular lessons in chapter completed?
    const allRegularCompleted = (chapterCompletedCount === rawLessons.length && rawLessons.length > 0);
    const examUnlocked = isChapterUnlocked && allRegularCompleted;

    // Append Chapter Assessment / Exam as the Final Lesson
    const examLessonId = `exam-${ch.id}`;
    const isExamCompleted = examPassed;
    const isExamUnlocked = isExamCompleted || examUnlocked;

    totalLessonsCount++;
    if (isExamCompleted) {
      totalCompletedCount++;
    }

    formattedLessons.push({
      id: examLessonId,
      chapter_id: ch.id,
      slug: `exam-${ch.slug}`,
      lesson_number: rawLessons.length + 1,
      title: `Lesson ${rawLessons.length + 1}: Chapter ${ch.chapter_number || idx + 1} Final Exam & Assessment`,
      duration_minutes: 15,
      xp_reward: 50,
      is_exam: true,
      is_completed: isExamCompleted,
      is_unlocked: isExamUnlocked,
      is_current: !isExamCompleted && isExamUnlocked,
      status: isExamCompleted ? 'completed' : (isExamUnlocked ? 'unlocked' : 'locked')
    });

    // ONLY passing the chapter exam unlocks Chapter N+1
    previousChapterExamPassed = examPassed;

    let chapterBadge = 'LOCKED';
    if (!isChapterUnlocked) {
      chapterBadge = 'LOCKED';
    } else if (highestBadge) {
      chapterBadge = highestBadge;
    } else if (examPassed) {
      chapterBadge = 'CLEAR';
    } else if (chapterCompletedCount > 0) {
      chapterBadge = 'IN_PROGRESS';
    } else {
      chapterBadge = 'UNLOCKED';
    }

    const chExamQuestions = getQuestionsForChapter ? getQuestionsForChapter(ch.id, ch.slug, ch.chapter_number || idx + 1) : [];

    return {
      id: ch.id,
      course_id: target.id,
      slug: ch.slug,
      chapter_number: ch.chapter_number || idx + 1,
      title: ch.title,
      description: ch.description,
      icon_symbol: ch.icon_symbol || '🚀',
      xp_reward: 100,
      badge: chapterBadge,
      status_label: examPassed ? 'Completed' : (isChapterUnlocked ? 'In Progress' : 'Locked'),
      is_unlocked: isChapterUnlocked,
      exam_status: {
        attempts_count: examAttempts.length,
        attempts_left: Math.max(0, 3 - examAttempts.length),
        max_attempts: 3,
        highest_score: highestScore,
        highest_badge: highestBadge,
        passed: examPassed,
        can_attempt: Math.max(0, 3 - examAttempts.length) > 0 && allRegularCompleted
      },
      exam: {
        id: `exam-${ch.id}`,
        title: `${ch.title} — Final Exam`,
        description: `Final assessment testing concepts from ${ch.title}`,
        passing_score_percent: 60,
        questions: chExamQuestions
      },
      examQuestions: chExamQuestions,
      lessons_overview: ch.lessons_overview,
      completed_count: chapterCompletedCount + (isExamCompleted ? 1 : 0),
      total_count: rawLessons.length + 1,
      lessons: formattedLessons
    };
  });

  const progressPct = totalLessonsCount > 0 ? Math.round((totalCompletedCount / totalLessonsCount) * 100) : 0;

  return {
    id: target.id,
    slug: target.slug,
    title: target.title,
    description: target.description,
    image_url: target.image_url,
    accent_color: target.accent_color,
    academic_group_name: target.academic_group,
    academicGroupLabel: target.academic_group,
    academic_group_id: target.academic_group_id,
    is_published: 1,
    total_lessons: totalLessonsCount || 40,
    completed_lessons: totalCompletedCount,
    progress: progressPct,
    chapters: chaptersFormatted
  };
}

function getLessonByIdOrSlug(idOrSlug, userId = 'student-alex-id') {
  if (!idOrSlug) idOrSlug = 'lesson-web-1-1';
  const rawList = getRawCourseList();
  const searchKey = String(idOrSlug).toLowerCase().trim();
  const searchAliases = [searchKey];
  // Only map aliases for the 2 active production courses
  if (searchKey.includes('python-found')) searchAliases.push(searchKey.replace('python-found', 'pyf'));
  if (searchKey.includes('pyf-')) searchAliases.push(searchKey.replace('pyf-', 'python-found-'));

  let targetLesson = null;
  let targetChapter = null;
  let targetCourse = null;

  // Pass 1: Exact or lowercased match (with aliases)
  for (const course of rawList) {
    for (const chapter of (course.chapters || [])) {
      for (const lesson of (chapter.lessons || [])) {
        const lid = String(lesson.id).toLowerCase();
        const lslug = String(lesson.slug || '').toLowerCase();
        if (searchAliases.includes(lid) || searchAliases.includes(lslug)) {
          targetLesson = lesson;
          targetChapter = chapter;
          targetCourse = course;
          break;
        }
      }
      if (targetLesson) break;
    }
    if (targetLesson) break;
  }

  // Pass 2: Fuzzy numeric or substring match e.g. "web-1-1", "1-1", "js-1-1"
  if (!targetLesson) {
    for (const course of rawList) {
      for (const chapter of (course.chapters || [])) {
        for (const lesson of (chapter.lessons || [])) {
          const lid = String(lesson.id).toLowerCase();
          if (lid.includes(searchKey) || searchKey.includes(lid)) {
            targetLesson = lesson;
            targetChapter = chapter;
            targetCourse = course;
            break;
          }
        }
        if (targetLesson) break;
      }
      if (targetLesson) break;
    }
  }

  // Pass 3: Fallback to first lesson of first course if not found
  if (!targetLesson && rawList.length > 0 && rawList[0].chapters && rawList[0].chapters.length > 0) {
    targetCourse = rawList[0];
    targetChapter = rawList[0].chapters[0];
    targetLesson = targetChapter.lessons ? targetChapter.lessons[0] : null;
  }

  if (!targetLesson) return null;

  // Check locking state using full course tree
  const courseDetails = getCourseByIdOrSlug(targetCourse ? targetCourse.id : 'course-programming-foundations', userId);
  let isUnlocked = false;
  let isCompleted = false;

  if (courseDetails && courseDetails.chapters) {
    for (const ch of courseDetails.chapters) {
      for (const l of ch.lessons) {
        if (l.id === targetLesson.id || l.slug === targetLesson.slug) {
          isUnlocked = !!l.is_unlocked;
          isCompleted = !!l.is_completed;
          break;
        }
      }
    }
  }

  // Universal Guarantee: Lesson 1 of Chapter 1 of every course is ALWAYS unlocked.
  // In any unlocked chapter, Lesson 1 is ALWAYS unlocked.
  const isCh1 = (targetChapter && (targetChapter.chapter_number === 1 || String(targetChapter.id).endsWith('-01') || String(targetChapter.id).endsWith('-1')));
  const isL1 = (targetLesson && (targetLesson.lesson_number === 1 || String(targetLesson.id).endsWith('-1-1') || String(targetLesson.id).endsWith('-01-1')));
  if (isCh1 && isL1) {
    isUnlocked = true;
  }
  if (isL1 && courseDetails && courseDetails.chapters) {
    const chObj = courseDetails.chapters.find(c => c.id === (targetChapter ? targetChapter.id : ''));
    if (chObj && chObj.is_unlocked) {
      isUnlocked = true;
    }
  }
  if (isCompleted) {
    isUnlocked = true;
  }

  let lessonBlocks = [];
  let sortIdx = 1;

  if (Array.isArray(targetLesson.blocks) && targetLesson.blocks.length > 0) {
    lessonBlocks = targetLesson.blocks.map((b, bIdx) => ({
      id: b.id || `blk-${targetLesson.id}-${bIdx + 1}`,
      block_type: b.block_type,
      sort_order: b.sort_order || bIdx + 1,
      content: b.content || b.content_json || {}
    }));
  } else {
    // Block 1: Dialogue (Story / Shady & Cody)
    lessonBlocks.push({
      id: `blk-${targetLesson.id}-${sortIdx}`,
      block_type: 'dialogue',
      sort_order: sortIdx++,
      content: {
        shady: targetLesson.dialogue ? targetLesson.dialogue.shady : 'Welcome to this lesson!',
        cody: targetLesson.dialogue ? targetLesson.dialogue.cody : 'Let us master this concept together!'
      }
    });

    // Block 3: Simple Explanation (Concept)
    lessonBlocks.push({
      id: `blk-${targetLesson.id}-${sortIdx}`,
      block_type: 'text',
      sort_order: sortIdx++,
      content: {
        title: targetLesson.concept ? targetLesson.concept.title : targetLesson.title,
        body: targetLesson.concept ? targetLesson.concept.body : ''
      }
    });

    // Block 4: Code Example (Syntax Highlighted Showcase)
    lessonBlocks.push({
      id: `blk-${targetLesson.id}-${sortIdx}`,
      block_type: 'code_example',
      sort_order: sortIdx++,
      content: {
        title: targetLesson.showcase ? targetLesson.showcase.title : 'Example',
        language: targetLesson.showcase ? targetLesson.showcase.language : 'HTML',
        code: targetLesson.showcase ? targetLesson.showcase.code : '',
        explanation: targetLesson.showcase ? targetLesson.showcase.explanation : ''
      }
    });

    // Block 5: Live Code Playground (Sandbox Experimentation)
    if (targetLesson.playground) {
      lessonBlocks.push({
        id: `blk-${targetLesson.id}-${sortIdx}`,
        block_type: 'playground',
        sort_order: sortIdx++,
        content: targetLesson.playground
      });
    }

    // Block 6: Coding Challenge (Hands-on Mission)
    lessonBlocks.push({
      id: `blk-${targetLesson.id}-${sortIdx}`,
      block_type: 'exercise',
      sort_order: sortIdx++,
      content: {
        title: targetLesson.challenge ? targetLesson.challenge.title : 'Coding Challenge',
        instruction: targetLesson.challenge ? targetLesson.challenge.instruction : '',
        language: targetLesson.challenge ? targetLesson.challenge.language : 'HTML',
        initialCode: targetLesson.challenge ? targetLesson.challenge.initialCode : '',
        solutionCode: targetLesson.challenge ? targetLesson.challenge.solutionCode : '',
        expectedOutput: targetLesson.challenge ? targetLesson.challenge.expectedOutput : '',
        hint: (targetLesson.challenge && targetLesson.challenge.hint) || `Check your syntax carefully for ${targetLesson.title}.`,
        successMessage: (targetLesson.challenge && targetLesson.challenge.successMessage) || `Awesome! You mastered ${targetLesson.title}!`
      }
    });

    // Block 7: Visual Summary (Cheat Sheet / Takeaways)
    if (targetLesson.summary) {
      lessonBlocks.push({
        id: `blk-${targetLesson.id}-${sortIdx}`,
        block_type: 'summary',
        sort_order: sortIdx++,
        content: targetLesson.summary
      });
    }

    // Block 8: Quick Check (Micro Quiz / Formative Assessment)
    if (targetLesson.quick_check) {
      lessonBlocks.push({
        id: `blk-${targetLesson.id}-${sortIdx}`,
        block_type: 'quick_check',
        sort_order: sortIdx++,
        content: targetLesson.quick_check
      });
    }
  }

  return {
    id: targetLesson.id,
    slug: targetLesson.slug,
    title: targetLesson.title,
    duration_minutes: targetLesson.duration || 10,
    xp_reward: targetLesson.xp || targetLesson.xp_reward || 25,
    course_id: targetCourse ? targetCourse.id : 'course-programming-foundations',
    course_title: targetCourse ? targetCourse.title : 'Programming Foundations — Start Here',
    chapter_id: targetChapter ? targetChapter.id : 'chap-pf-01',
    chapter_number: targetChapter ? targetChapter.chapter_number : 1,
    chapter_title: targetChapter ? targetChapter.title : 'Chapter 1: Technology All Around Us',
    chapter_icon: targetChapter ? (targetChapter.icon_symbol || '💡') : '💡',
    project_title: targetChapter ? targetChapter.project_title : '',
    predict_question: targetLesson.predict_question || targetLesson.checkpoint_question || (targetChapter ? targetChapter.predict_question : null),
    youtube_query: targetLesson.youtube_query || '',
    key_points: targetLesson.key_points || [],
    bug_hunt: targetChapter ? targetChapter.bug_hunt : null,
    concept_code: targetChapter ? targetChapter.concept_code : '',
    banner_image_url: targetLesson.banner_image_url || targetLesson.banner_image || targetLesson.visual_summary_image || targetLesson.summary_image || '',
    summary_image: targetLesson.summary_image || targetLesson.banner_image_url || '',
    summary: targetLesson.summary || targetLesson.visual_summary || null,
    concept: targetLesson.concept || null,
    showcase: targetLesson.showcase || null,
    challenge: targetLesson.challenge || null,
    playground: targetLesson.playground || null,
    dialogue: targetLesson.dialogue || null,
    is_completed: isCompleted,
    is_unlocked: isUnlocked,
    blocks: lessonBlocks
  };
}



function syncCompletedLessonsToStorage(lessonsArrayOrMap) {
  if (typeof localStorage === 'undefined' || !lessonsArrayOrMap) return;
  try {
    const currentMap = {};
    if (Array.isArray(lessonsArrayOrMap)) {
      lessonsArrayOrMap.forEach(lid => {
        if (lid) {
          currentMap[lid] = { completed: true, status: 'completed', completedAt: new Date().toISOString() };
        }
      });
    } else if (typeof lessonsArrayOrMap === 'object') {
      Object.keys(lessonsArrayOrMap).forEach(lid => {
        if (lessonsArrayOrMap[lid]) {
          currentMap[lid] = { completed: true, status: 'completed', completedAt: new Date().toISOString() };
        }
      });
    }
    localStorage.setItem(STORAGE_COMPLETED_KEY, JSON.stringify(currentMap));
  } catch (e) {
    console.warn('Sync completed lessons warning:', e);
  }
}

if (typeof window !== 'undefined') {
  window.CURRICULUM_INDEX = {
    getRawCourseList,
    getAllCourses,
    getCourseByIdOrSlug,
    getLessonByIdOrSlug,
    isLessonCompleted,
    markLessonCompleted,
    getNextLessonInSequence,
    getUserXp,
    getCompletedLessonsMap,
    syncCompletedLessonsToStorage,
    syncUserXpToStorage
  };
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    getRawCourseList,
    getAllCourses,
    getCourseByIdOrSlug,
    getLessonByIdOrSlug,
    isLessonCompleted,
    markLessonCompleted,
    getNextLessonInSequence,
    getUserXp,
    getCompletedLessonsMap,
    syncCompletedLessonsToStorage,
    syncUserXpToStorage
  };
}
