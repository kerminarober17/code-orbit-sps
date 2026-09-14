const fs = require('fs');
const path = require('path');
const { CHAPTER_EXAMS } = require('../data/chapter_exams.js');

const outPath = path.join(__dirname, '../data/chapter_exams.json');
fs.writeFileSync(outPath, JSON.stringify(CHAPTER_EXAMS, null, 2), 'utf8');
console.log(`Exported ${Object.keys(CHAPTER_EXAMS).length} chapter exams to data/chapter_exams.json`);
