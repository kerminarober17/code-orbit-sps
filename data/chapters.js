/**
 * SPS CODE ORBIT - Dynamic Chapters Data Layer
 * Empty fallback array; all chapter & lesson data are loaded dynamically from MySQL API endpoints.
 */

const CHAPTERS_DATA = [];

if (typeof window !== 'undefined') {
  window.CHAPTERS_DATA = CHAPTERS_DATA;
}
