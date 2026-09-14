/**
 * SPS CODE ORBIT - Progressive Curriculum Courses Dataset
 * Authoritative courses synchronized with MySQL database
 */

const COURSES_DATA = [
  // FOUNDATION TRACK
  {
    id: "course-programming-foundations",
    slug: "programming-foundations",
    title: "Programming Foundations — Start Here",
    subtitle: "Understand Programming Before You Code",
    description: "The complete foundational course: discover what programming truly is, how computers and the internet work, and master algorithmic thinking before writing code in any language.",
    track: "Foundation Track",
    track_id: "track-foundation",
    level: "Foundation",
    level_number: 0,
    difficulty: "Absolute Beginner",
    prerequisite: "None",
    academic_group_name: "Preparatory",
    academicGroupLabel: "Foundation",
    image: "/assets/courses/prog.png",
    image_url: "/assets/courses/prog.png",
    accent_color: "#70D6FF",
    chaptersCount: 6,
    lessonsCount: 24,
    total_lessons: 24,
    is_published: 1
  },

  // PYTHON TRACK
  {
    id: "course-python-foundations",
    slug: "python-foundations",
    title: "Python Level 1: Foundations",
    subtitle: "Build Robust Fundamentals",
    description: "Build robust programming fundamentals from scratch using Python. Master variables, data types, operators, branching logic, loops, collections, and structured problem-solving.",
    track: "Python Track",
    track_id: "track-python",
    level: "Level 1: Foundations",
    level_number: 1,
    difficulty: "Beginner",
    prerequisite: "Programming Foundations",
    academic_group_name: "Preparatory",
    academicGroupLabel: "Python Track",
    image: "/assets/courses/algo.png",
    image_url: "/assets/courses/algo.png",
    accent_color: "#0EA5E9",
    chaptersCount: 10,
    lessonsCount: 40,
    total_lessons: 40,
    is_published: 1
  },
  {
    id: "course-python-level-2",
    slug: "python-level-2",
    title: "Python Level 2: Code Orbit",
    subtitle: "Organize, Reuse, Protect, Scale",
    description: "Continue from Python Level 1. Master text power-ups, smarter collections, list comprehensions, dictionaries, scope & functions, files, modules, errors, and first steps into OOP — then build a real application.",
    track: "Python Track",
    track_id: "track-python",
    level: "Level 2: Foundations+",
    level_number: 2,
    difficulty: "Intermediate",
    prerequisite: "Python Level 1: Foundations",
    academic_group_name: "Preparatory",
    academicGroupLabel: "Python Track",
    image: "/assets/courses/algo.png",
    image_url: "/assets/courses/algo.png",
    accent_color: "#8B5CF6",
    chaptersCount: 10,
    lessonsCount: 40,
    total_lessons: 40,
    is_published: 1
  }
];

if (typeof window !== 'undefined') {
  window.COURSES_DATA = COURSES_DATA;
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { COURSES_DATA };
}
