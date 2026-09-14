const fs = require('fs');
const path = require('path');

const exportPath = path.join(__dirname, '../data/curriculum_export.json');

const { PROGRAMMING_FOUNDATIONS_COURSE } = require('../data/programming_foundations_curriculum.js');
const { PYTHON_FOUNDATIONS_COURSE } = require('../data/python_foundations_curriculum.js');

const allCourses = [
  PROGRAMMING_FOUNDATIONS_COURSE,
  PYTHON_FOUNDATIONS_COURSE
].filter(Boolean);

fs.writeFileSync(exportPath, JSON.stringify(allCourses, null, 2), 'utf8');

console.log(`Curriculum export updated! Total courses in export: ${allCourses.length}`);
