/**
 * SPS CODE ORBIT - Lessons Data Layer (Preparatory Curriculum)
 */

const { getAllCourses, getLessonByIdOrSlug } = typeof require !== 'undefined' 
  ? require('./curriculum_index.js')
  : { getAllCourses: () => [], getLessonByIdOrSlug: () => null };

const LESSONS_DATA = {};

if (typeof window !== 'undefined') {
  window.LESSONS_DATA = LESSONS_DATA;
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { LESSONS_DATA };
}
