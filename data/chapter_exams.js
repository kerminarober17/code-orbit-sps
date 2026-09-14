// Chapter Exams Registry (Generated)
const CHAPTER_EXAMS = {
  "chap-pyadv-01": {
    "title": "Chapter 1 Exam: Hello, Python!",
    "chapter_id": "chap-pyadv-01",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "Which Python function is used to output text to the console?",
        "options": {
          "A": "echo()",
          "B": "print()",
          "C": "display()",
          "D": "write()"
        },
        "correct": "B",
        "explanation": "print() is Python's standard output function."
      },
      {
        "id": "q2",
        "question": "What is the correct syntax for a string containing the text: Hello Orbit?",
        "options": {
          "A": "Hello Orbit",
          "B": "\"Hello Orbit\"",
          "C": "<Hello Orbit>",
          "D": "{Hello Orbit}"
        },
        "correct": "B",
        "explanation": "Strings must be wrapped in quotation marks (' ' or \" \")."
      },
      {
        "id": "q3",
        "question": "What does len(\"Python\") return?",
        "options": {
          "A": "5",
          "B": "6",
          "C": "7",
          "D": "TypeError"
        },
        "correct": "B",
        "explanation": "'Python' has 6 characters."
      },
      {
        "id": "q4",
        "question": "Which formatted string (f-string) correctly injects the variable name = 'Shady'?",
        "options": {
          "A": "f\"Hello {name}\"",
          "B": "\"Hello {name}\"",
          "C": "f\"Hello name\"",
          "D": "str(\"Hello\" + name)"
        },
        "correct": "A",
        "explanation": "f-strings use f before quotes and {variable} inside."
      }
    ]
  },
  "chap-pyadv-02": {
    "title": "Chapter 2 Exam: Memory Boxes — Variables",
    "chapter_id": "chap-pyadv-02",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "Which of the following is a valid variable name in Python?",
        "options": {
          "A": "2nd_player",
          "B": "player_score",
          "C": "player-score",
          "D": "for"
        },
        "correct": "B",
        "explanation": "player_score follows snake_case and doesn't start with digits or hyphens."
      },
      {
        "id": "q2",
        "question": "What data type is the value 95.5?",
        "options": {
          "A": "int",
          "B": "float",
          "C": "str",
          "D": "bool"
        },
        "correct": "B",
        "explanation": "Numbers with decimal points are float data types."
      },
      {
        "id": "q3",
        "question": "What is the value of score after: score = 50; score += 20; score -= 10?",
        "options": {
          "A": "50",
          "B": "60",
          "C": "70",
          "D": "80"
        },
        "correct": "B",
        "explanation": "50 + 20 = 70. 70 - 10 = 60."
      },
      {
        "id": "q4",
        "question": "What does type(True) return?",
        "options": {
          "A": "<class 'int'>",
          "B": "<class 'bool'>",
          "C": "<class 'str'>",
          "D": "<class 'float'>"
        },
        "correct": "B",
        "explanation": "True and False are boolean (bool) literals."
      }
    ]
  },
  "chap-pyadv-03": {
    "title": "Chapter 3 Exam: Numbers and Calculations",
    "chapter_id": "chap-pyadv-03",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "What is the result of 19 // 4 in Python?",
        "options": {
          "A": "4.75",
          "B": "4",
          "C": "3",
          "D": "5"
        },
        "correct": "B",
        "explanation": "// computes floor division, returning integer quotient 4."
      },
      {
        "id": "q2",
        "question": "What is 19 % 4?",
        "options": {
          "A": "3",
          "B": "4",
          "C": "4.75",
          "D": "1"
        },
        "correct": "A",
        "explanation": "4 * 4 = 16. Remainder 19 - 16 = 3."
      },
      {
        "id": "q3",
        "question": "What is the output of 2 + 3 * 4?",
        "options": {
          "A": "20",
          "B": "14",
          "C": "24",
          "D": "10"
        },
        "correct": "B",
        "explanation": "Multiplication before addition: 3 * 4 = 12. 2 + 12 = 14."
      },
      {
        "id": "q4",
        "question": "What does round(3.14159, 2) return?",
        "options": {
          "A": "3.14",
          "B": "3.1",
          "C": "3.142",
          "D": "3"
        },
        "correct": "A",
        "explanation": "Rounds to 2 decimal places: 3.14."
      }
    ]
  },
  "chap-pyadv-04": {
    "title": "Chapter 4 Exam: The Student Speaks — User Input",
    "chapter_id": "chap-pyadv-04",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "What data type is returned by the input() function?",
        "options": {
          "A": "int",
          "B": "str",
          "C": "float",
          "D": "dynamic"
        },
        "correct": "B",
        "explanation": "input() always yields a string."
      },
      {
        "id": "q2",
        "question": "How do you convert a string input into an integer for math?",
        "options": {
          "A": "int(input())",
          "B": "str(input())",
          "C": "float(input())",
          "D": "num(input())"
        },
        "correct": "A",
        "explanation": "int() casts the string to a whole integer."
      },
      {
        "id": "q3",
        "question": "What error happens if you do int('orbit')?",
        "options": {
          "A": "SyntaxError",
          "B": "ValueError",
          "C": "TypeError",
          "D": "NameError"
        },
        "correct": "B",
        "explanation": "Invalid numeric literal conversion raises a ValueError."
      },
      {
        "id": "q4",
        "question": "Which construct catches runtime errors safely?",
        "options": {
          "A": "if / else",
          "B": "try / except",
          "C": "for / while",
          "D": "def / return"
        },
        "correct": "B",
        "explanation": "try / except prevents application crashes."
      }
    ]
  },
  "chap-pyadv-05": {
    "title": "Chapter 5 Exam: Making Decisions — Conditionals",
    "chapter_id": "chap-pyadv-05",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "Which operator tests whether two values are equal in Python?",
        "options": {
          "A": "=",
          "B": "==",
          "C": "===",
          "D": "equals"
        },
        "correct": "B",
        "explanation": "== tests equality."
      },
      {
        "id": "q2",
        "question": "What follows the condition on an if statement?",
        "options": {
          "A": ";",
          "B": ": (colon)",
          "C": "then",
          "D": "{}"
        },
        "correct": "B",
        "explanation": "Conditionals end with a colon (:)."
      },
      {
        "id": "q3",
        "question": "When does the else block run?",
        "options": {
          "A": "When all previous if / elif conditions are False",
          "B": "Always",
          "C": "Only when True",
          "D": "Never"
        },
        "correct": "A",
        "explanation": "else catches cases where conditions are False."
      },
      {
        "id": "q4",
        "question": "What is elif short for?",
        "options": {
          "A": "else if",
          "B": "element if",
          "C": "end if",
          "D": "early if"
        },
        "correct": "A",
        "explanation": "elif stands for 'else if'."
      }
    ]
  },
  "chap-pyadv-06": {
    "title": "Chapter 6 Exam: Repetition — Loops",
    "chapter_id": "chap-pyadv-06",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "What numbers are generated by range(1, 4)?",
        "options": {
          "A": "1, 2, 3, 4",
          "B": "1, 2, 3",
          "C": "0, 1, 2, 3",
          "D": "2, 3, 4"
        },
        "correct": "B",
        "explanation": "range(1, 4) produces 1, 2, 3."
      },
      {
        "id": "q2",
        "question": "Which statement terminates a loop immediately?",
        "options": {
          "A": "continue",
          "B": "break",
          "C": "stop",
          "D": "exit"
        },
        "correct": "B",
        "explanation": "break halts the loop."
      },
      {
        "id": "q3",
        "question": "Which statement skips to the next loop iteration?",
        "options": {
          "A": "continue",
          "B": "break",
          "C": "skip",
          "D": "pass"
        },
        "correct": "A",
        "explanation": "continue advances to the next iteration."
      },
      {
        "id": "q4",
        "question": "When is a while loop preferred?",
        "options": {
          "A": "When looping until a condition changes",
          "B": "Only for fixed 10 steps",
          "C": "Never",
          "D": "Only with strings"
        },
        "correct": "A",
        "explanation": "while repeats as long as a condition is True."
      }
    ]
  },
  "chap-pyadv-07": {
    "title": "Chapter 7 Exam: Organised Data — Lists",
    "chapter_id": "chap-pyadv-07",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "What is the index of the first element of a list?",
        "options": {
          "A": "1",
          "B": "0",
          "C": "-1",
          "D": "None"
        },
        "correct": "B",
        "explanation": "Lists use zero-based indexing (0)."
      },
      {
        "id": "q2",
        "question": "Which method adds an element to the end of a list?",
        "options": {
          "A": "push()",
          "B": "append()",
          "C": "insert()",
          "D": "add()"
        },
        "correct": "B",
        "explanation": "append() attaches an element to the list end."
      },
      {
        "id": "q3",
        "question": "What does list[-1] access?",
        "options": {
          "A": "First element",
          "B": "Last element",
          "C": "Second element",
          "D": "Error"
        },
        "correct": "B",
        "explanation": "-1 references the last element."
      },
      {
        "id": "q4",
        "question": "Which keyword checks if an element exists in a list?",
        "options": {
          "A": "has",
          "B": "in",
          "C": "contains",
          "D": "find"
        },
        "correct": "B",
        "explanation": "in tests sequence membership."
      }
    ]
  },
  "chap-pyadv-08": {
    "title": "Chapter 8 Exam: Making Choices Smarter",
    "chapter_id": "chap-pyadv-08",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "When does 'a and b' evaluate to True?",
        "options": {
          "A": "When both a and b are True",
          "B": "When either is True",
          "C": "When both are False",
          "D": "Never"
        },
        "correct": "A",
        "explanation": "'and' requires all operands to be True."
      },
      {
        "id": "q2",
        "question": "When does 'a or b' evaluate to True?",
        "options": {
          "A": "When at least one of a or b is True",
          "B": "Only when both are True",
          "C": "Only when both are False",
          "D": "Never"
        },
        "correct": "A",
        "explanation": "'or' evaluates to True if at least one condition holds."
      },
      {
        "id": "q3",
        "question": "What does not True evaluate to?",
        "options": {
          "A": "True",
          "B": "False",
          "C": "None",
          "D": "Error"
        },
        "correct": "B",
        "explanation": "not inverts boolean state (not True = False)."
      },
      {
        "id": "q4",
        "question": "Is 10 <= score <= 100 valid syntax in Python?",
        "options": {
          "A": "Yes, chained comparisons are supported",
          "B": "No, must use and",
          "C": "Only in Python 2",
          "D": "SyntaxError"
        },
        "correct": "A",
        "explanation": "Python natively supports chained comparisons."
      }
    ]
  },
  "chap-pyadv-09": {
    "title": "Chapter 9 Exam: Reusable Code — Functions",
    "chapter_id": "chap-pyadv-09",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "Which keyword defines a function in Python?",
        "options": {
          "A": "func",
          "B": "def",
          "C": "function",
          "D": "define"
        },
        "correct": "B",
        "explanation": "def defines a function."
      },
      {
        "id": "q2",
        "question": "What is the role of the return statement?",
        "options": {
          "A": "Sends computed data back to caller",
          "B": "Prints text to console",
          "C": "Restarts computer",
          "D": "Deletes variables"
        },
        "correct": "A",
        "explanation": "return passes calculated values back."
      },
      {
        "id": "q3",
        "question": "Where are local variables accessible?",
        "options": {
          "A": "Anywhere in the program",
          "B": "Only inside the function where created",
          "C": "In all files",
          "D": "Nowhere"
        },
        "correct": "B",
        "explanation": "Local variables are scoped strictly to their containing function."
      },
      {
        "id": "q4",
        "question": "What is a default argument?",
        "options": {
          "A": "A fallback value used when no argument is passed",
          "B": "An error argument",
          "C": "A global constant",
          "D": "A print statement"
        },
        "correct": "A",
        "explanation": "Default arguments supply initial parameter values."
      }
    ]
  },
  "chap-pyadv-10": {
    "title": "Chapter 10 Exam: Capstone Graduation",
    "chapter_id": "chap-pyadv-10",
    "pass_score": 75,
    "questions": [
      {
        "id": "q1",
        "question": "What is software decomposition?",
        "options": {
          "A": "Breaking complex problems into modular functions",
          "B": "Deleting files",
          "C": "Compiling bytecode",
          "D": "Infinite loops"
        },
        "correct": "A",
        "explanation": "Decomposition organizes complex logic into focused functions."
      },
      {
        "id": "q2",
        "question": "How do you clamp a resource value between 0 and 100 in Python?",
        "options": {
          "A": "max(0, min(100, val))",
          "B": "val % 100",
          "C": "round(val)",
          "D": "abs(val)"
        },
        "correct": "A",
        "explanation": "max(0, min(100, val)) bounds numbers between 0 and 100."
      },
      {
        "id": "q3",
        "question": "What pattern runs continuous interactive terminal commands?",
        "options": {
          "A": "A while loop command dispatcher",
          "B": "1000 print statements",
          "C": "Recursive functions",
          "D": "Static HTML"
        },
        "correct": "A",
        "explanation": "while loop command dispatchers power interactive CLI tools."
      },
      {
        "id": "q4",
        "question": "Why is testing edge cases important before deployment?",
        "options": {
          "A": "To ensure boundary values don't cause unexpected crashes",
          "B": "To increase line count",
          "C": "It is optional",
          "D": "To slow down code"
        },
        "correct": "A",
        "explanation": "Edge case testing confirms resilience across boundary conditions."
      }
    ]
  }
};

function getQuestionsForChapter(chapterId, chapterSlug, chapterNumber = 1) {
  // Merge Python Level 2 exams if present
  if (typeof PYTHON_LEVEL2_EXAMS !== 'undefined' && PYTHON_LEVEL2_EXAMS) {
    Object.assign(CHAPTER_EXAMS, PYTHON_LEVEL2_EXAMS);
  }
  if (typeof window !== 'undefined' && window.PYTHON_LEVEL2_EXAMS) {
    Object.assign(CHAPTER_EXAMS, window.PYTHON_LEVEL2_EXAMS);
  }

  if (!chapterId && !chapterSlug) {
    chapterId = 'chap-web-01';
  }

  const cid = String(chapterId || '').toLowerCase();
  const cslug = String(chapterSlug || '').toLowerCase();

  // Try direct lookup
  let foundKey = Object.keys(CHAPTER_EXAMS).find(k => {
    const lk = k.toLowerCase();
    return lk === cid || lk === cslug || lk === `exam-${cid}` || lk === `exam-${cslug}` || lk === `chap-${cid}` || lk === `chap-${cslug}`;
  });

  // Try fuzzy match
  if (!foundKey) {
    foundKey = Object.keys(CHAPTER_EXAMS).find(k => {
      const lk = k.toLowerCase();
      return (cid && lk.includes(cid)) || (cslug && lk.includes(cslug));
    });
  }

  if (foundKey && CHAPTER_EXAMS[foundKey] && Array.isArray(CHAPTER_EXAMS[foundKey].questions) && CHAPTER_EXAMS[foundKey].questions.length > 0) {
    return CHAPTER_EXAMS[foundKey].questions;
  }

  // Fallback default 6 questions (5 multiple choice + 1 essay)
  return [
    {
      id: "q1",
      question_type: "multiple_choice",
      points: 15,
      question_text: "What is the primary role of core programming concepts taught in this chapter?",
      options: [
        { key: "A", text: "To structure logic and solve computational problems efficiently." },
        { key: "B", text: "To make code execute without a computer." },
        { key: "C", text: "To delete unused browser caches automatically." },
        { key: "D", text: "To format raw text documents." }
      ],
      correct_answer: "A",
      explanation: "Core concepts provide structural logic to solve software problems efficiently."
    },
    {
      id: "q2",
      question_type: "multiple_choice",
      points: 15,
      question_text: "Which of the following represents valid syntax and logical structure?",
      options: [
        { key: "A", text: "Matching opening and closing delimiters or proper statement syntax." },
        { key: "B", text: "Unterminated string literals." },
        { key: "C", text: "Random spacing inside keywords." },
        { key: "D", text: "Using reserved keywords as variable names." }
      ],
      correct_answer: "A",
      explanation: "Proper syntax requires balanced delimiters and compliant identifiers."
    },
    {
      id: "q3",
      question_type: "multiple_choice",
      points: 15,
      question_text: "Why is modularity important when designing software features?",
      options: [
        { key: "A", text: "It isolates components for reusability, testing, and debugging." },
        { key: "B", text: "It forces all code into a single 10,000 line file." },
        { key: "C", text: "It prevents browsers from loading scripts." },
        { key: "D", text: "It increases memory usage." }
      ],
      correct_answer: "A",
      explanation: "Modularity breaks complex systems into manageable, testable components."
    },
    {
      id: "q4",
      question_type: "multiple_choice",
      points: 15,
      question_text: "When debugging an unexpected issue, what is the best initial step?",
      options: [
        { key: "A", text: "Inspect error messages, isolate variables, and trace input/output." },
        { key: "B", text: "Randomly delete lines of code." },
        { key: "C", text: "Ignore the error and re-run." },
        { key: "D", text: "Close the editor immediately." }
      ],
      correct_answer: "A",
      explanation: "Systematic debugging starts with examining error outputs and tracing data flow."
    },
    {
      id: "q5",
      question_type: "multiple_choice",
      points: 20,
      question_text: "What ensures code readability and maintainability for team collaboration?",
      options: [
        { key: "A", text: "Consistent naming conventions, clear comments, and clean indentation." },
        { key: "B", text: "Using single-letter variable names everywhere." },
        { key: "C", text: "Omitting spaces and line breaks." },
        { key: "D", text: "Hiding source files." }
      ],
      correct_answer: "A",
      explanation: "Clean formatting and meaningful naming allow developers to understand and maintain code."
    },
    {
      id: "q6",
      question_type: "essay",
      points: 20,
      question_text: "Describe how you would apply the concepts learned in this chapter to build a practical application. Explain your approach step-by-step.",
      model_answer: "First, break down the project into key components. Define inputs, state requirements, and core logic. Implement step-by-step, testing each feature before integrating.",
      explanation: "A structured engineering workflow involves requirement analysis, modular implementation, and iterative testing."
    }
  ];
}

if (typeof window !== 'undefined') {
  window.CHAPTER_EXAMS = CHAPTER_EXAMS;
  window.getQuestionsForChapter = getQuestionsForChapter;
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { CHAPTER_EXAMS, getQuestionsForChapter };
}
