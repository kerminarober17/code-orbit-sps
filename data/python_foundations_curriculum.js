/**
 * SPS CODE ORBIT — CURRICULUM DATA
 * Course: Python Foundations (Preparatory Level)
 * Complete 10 Chapters with 4 Lessons each + Capstone Project + Predict Questions + Bug Hunts
 */

var PYTHON_FOUNDATIONS_COURSE = {
  id: "course-python-foundations",
  slug: "python-foundations",
  title: "Python Foundations",
  description: "Build robust programming fundamentals from scratch using Python. Master variables, data types, operators, branching logic, loops, collections, and structured problem-solving.",
  academic_group: "Preparatory",
  academic_group_id: "ag-prep",
  image_url: "/assets/courses/algo.png",
  accent_color: "#0EA5E9",
  chapters: [
    // Chapter 1
    {
      id: "chap-pyf-01",
      slug: "interpreter-and-execution",
      chapter_number: 1,
      title: "The Python Interpreter & Script Execution",
      description: "Learn how the Python runtime executes code line by line, formatted console output, comments, and syntax error diagnosis.",
      icon_symbol: "⚡",
      lessons_overview: [
        "1.1 The Interpreter & Line-by-Line Execution",
        "1.2 Output Customization with sep and end",
        "1.3 Comments and Code Readability",
        "1.4 Syntax Errors vs Execution Flow"
      ],
      project_title: "Terminal Welcome Banner",
      concept_code: `# System Startup Sequence
print("Code Orbit Core", "Version 2.0", sep=" - ")
print("Status: Active", end=" | ")
print("Systems: Nominal")`,
      predict_question: {
        question: "What does print('A', 'B', sep='-') output?",
        options: {
          A: "A B",
          B: "A-B",
          C: "AB",
          D: "Error"
        },
        correct: "B",
        explanation: "The sep parameter defines the string inserted between items in print(). Here '-' separates 'A' and 'B'."
      },
      bug_hunt: {
        title: "Fix Mismatched Quotes",
        instruction: "Ensure the string begins and ends with matching double quotes.",
        broken_code: `print("Cosmic Flight Initialized')`,
        fixed_code: `print("Cosmic Flight Initialized")`,
        hint: "Opening and closing quote styles must match exactly in Python string literals."
      },
      lessons: [
        {
          id: "lesson-pyf-1-1",
          slug: "interpreter-execution-flow",
          lesson_number: 1,
          title: "The Interpreter & Line-by-Line Execution",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Cody, what happens when I hit run on a Python script?",
            cody: "The Python interpreter reads your program from top to bottom, translates each statement, and executes it immediately!"
          },
          concept: {
            title: "Interpreted Execution",
            body: "<p>Python executes programs sequentially. If an error occurs on line 5, lines 1 through 4 have already completed successfully.</p>"
          },
          showcase: {
            title: "Sequential Execution",
            language: "Python",
            code: `print("Step 1: Check fuel")\nprint("Step 2: Engage thrusters")\nprint("Step 3: Orbit achieved")`,
            explanation: "Prints each mission step in exact top-to-bottom sequence."
          },
          challenge: {
            title: "Sequence Three Milestones",
            instruction: "Print three lines: 'Initiate', 'Calibrate', 'Launch'.",
            language: "Python",
            initialCode: `print("Initiate")\nprint("Launch")`,
            solutionCode: `print("Initiate")\nprint("Calibrate")\nprint("Launch")`,
            expectedOutput: "Initiate\nCalibrate\nLaunch"
          }
        },
        {
          id: "lesson-pyf-1-2",
          slug: "output-sep-end",
          lesson_number: 2,
          title: "Output Customization with sep and end",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I print multiple items on the same line without an automatic newline?",
            cody: "Use the 'end' parameter! By default end='\\n', but you can set end=' ' to stay on the same line!"
          },
          concept: {
            title: "Customizing print()",
            body: "<p><code>sep</code> controls the separator between comma-delimited items. <code>end</code> controls what prints at the very end of the line.</p>"
          },
          showcase: {
            title: "Formatting Output",
            language: "Python",
            code: `print("2026", "09", "12", sep="-")\nprint("Loading", end="...")\nprint("Done!")`,
            explanation: "sep='-' produces '2026-09-12', and end='...' keeps 'Done!' on the same line."
          },
          challenge: {
            title: "Create Hyphenated Coordinates",
            instruction: "Print 'Sector', '4', 'Alpha' with sep='-'.",
            language: "Python",
            initialCode: `print("Sector", "4", "Alpha")`,
            solutionCode: `print("Sector", "4", "Alpha", sep="-")`,
            expectedOutput: "Sector-4-Alpha"
          }
        },
        {
          id: "lesson-pyf-1-3",
          slug: "comments-code-documentation",
          lesson_number: 3,
          title: "Comments & Code Documentation",
          duration: 8,
          xp: 25,
          dialogue: {
            shady: "How do I leave notes for myself or my team without Python trying to run them as code?",
            cody: "Use the hash symbol #! The interpreter ignores everything on that line after the #."
          },
          concept: {
            title: "Python Comments",
            body: "<p>Comments explain the 'why' behind your code. Single-line comments start with <code>#</code> and are invisible during runtime.</p>"
          },
          showcase: {
            title: "Self-Documenting Code",
            language: "Python",
            code: `# Calculate total orbital velocity\nvelocity = 28000  # km/h\nprint(velocity)`,
            explanation: "Comments clarify values and purposes without interfering with execution."
          },
          challenge: {
            title: "Document and Print Telemetry",
            instruction: "Add a comment '# Sensor reading' and print telemetry = 98.",
            language: "Python",
            initialCode: `telemetry = 98\nprint(telemetry)`,
            solutionCode: `# Sensor reading\ntelemetry = 98\nprint(telemetry)`,
            expectedOutput: "98"
          }
        },
        {
          id: "lesson-pyf-1-4",
          slug: "syntax-errors-vs-runtime",
          lesson_number: 4,
          title: "Syntax Errors vs Execution Flow",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "What is the difference between a SyntaxError and a logical error?",
            cody: "A SyntaxError violates Python grammar so code won't even start. A logic bug runs, but gives the wrong result!"
          },
          concept: {
            title: "Error Categorization",
            body: "<p>Syntax errors occur during parsing before any line runs. Runtime errors occur while executing (e.g. dividing by zero).</p>"
          },
          showcase: {
            title: "Clean Syntax Structure",
            language: "Python",
            code: `# Perfectly formed syntax\nprint("System diagnostics verified: 0 errors")`,
            explanation: "Valid grammar allows the parser to pass the script directly to execution."
          },
          challenge: {
            title: "Fix Parenthesis Syntax",
            instruction: "Fix the syntax error to print 'All clear'.",
            language: "Python",
            initialCode: `print "All clear"`,
            solutionCode: `print("All clear")`,
            expectedOutput: "All clear"
          }
        }
      ]
    },
    // Chapter 2
    {
      id: "chap-pyf-02",
      slug: "variables-types-memory",
      chapter_number: 2,
      title: "Variables, Types & Memory Binding",
      description: "Explore dynamic typing in Python, int, float, str, bool data types, explicit type casting, and modern f-string formatting.",
      icon_symbol: "🏷️",
      lessons_overview: [
        "2.1 Dynamic Typing: int, float, str, bool",
        "2.2 Variable Reassignment & Memory References",
        "2.3 Explicit Type Conversion (int, float, str)",
        "2.4 Modern String Interpolation with f-Strings"
      ],
      project_title: "Telemetry Data Formatter",
      concept_code: `altitude = 12500.75
passengers = 4
in_orbit = True
flight_id = "CO-902"

print(f"Flight {flight_id}: Altitude {altitude}m | In Orbit: {in_orbit}")`,
      predict_question: {
        question: "What is type(42.0) in Python?",
        options: {
          A: "<class 'int'>",
          B: "<class 'float'>",
          C: "<class 'str'>",
          D: "<class 'number'>"
        },
        correct: "B",
        explanation: "Numbers with a decimal point are classified as float (floating-point numbers) in Python."
      },
      bug_hunt: {
        title: "Fix f-string Syntax",
        instruction: "Prefix the string with 'f' so Python evaluates the expression inside the curly braces {}.",
        broken_code: `name = "Apollo"\nprint("Ship: {name}")`,
        fixed_code: `name = "Apollo"\nprint(f"Ship: {name}")`,
        hint: "An f-string must start with an f immediately before the quotation mark: f\"...{variable}..\""
      },
      lessons: [
        {
          id: "lesson-pyf-2-1",
          slug: "dynamic-typing-primitives",
          lesson_number: 1,
          title: "Dynamic Typing: int, float, str, bool",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Do I have to declare whether a variable is a number or text before creating it?",
            cody: "Nope! Python is dynamically typed. It inspects the value you assign and assigns the type automatically!"
          },
          concept: {
            title: "Primitive Data Types",
            body: "<p>Python's core primitive types are <code>int</code> (integers), <code>float</code> (decimals), <code>str</code> (text), and <code>bool</code> (True/False).</p>"
          },
          showcase: {
            title: "Inspecting Data Types",
            language: "Python",
            code: `score = 98\nratio = 3.14\ntag = "Orbit"\nprint(type(score))\nprint(type(ratio))`,
            explanation: "type() reports the internal class of any variable."
          },
          challenge: {
            title: "Define Primitive Types",
            instruction: "Declare distance = 450.5 and print type(distance).",
            language: "Python",
            initialCode: `distance = 450\nprint(type(distance))`,
            solutionCode: `distance = 450.5\nprint(type(distance))`,
            expectedOutput: "<class 'float'>"
          }
        },
        {
          id: "lesson-pyf-2-2",
          slug: "reassignment-and-references",
          lesson_number: 2,
          title: "Variable Reassignment & Memory References",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Can a variable start as a number and later become a string?",
            cody: "Yes! In Python, variables are labels bound to memory objects. Reassigning changes what the label points to."
          },
          concept: {
            title: "Memory Binding",
            body: "<p>Assignment <code>=</code> binds a variable name to a value in memory. Subsequent assignments re-bind that name to a new value.</p>"
          },
          showcase: {
            title: "Rebinding Variables",
            language: "Python",
            code: `data = 100\ndata = "Calibrated"\nprint(data)`,
            explanation: "data now points to the string 'Calibrated'."
          },
          challenge: {
            title: "Update Speed Reading",
            instruction: "Assign speed = 500, reassign speed = 750, and print speed.",
            language: "Python",
            initialCode: `speed = 500\nprint(speed)`,
            solutionCode: `speed = 500\nspeed = 750\nprint(speed)`,
            expectedOutput: "750"
          }
        },
        {
          id: "lesson-pyf-2-3",
          slug: "explicit-type-conversion",
          lesson_number: 3,
          title: "Explicit Type Conversion (int, float, str)",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I turn a string like '42' into a number I can use in calculations?",
            cody: "Use type casting functions: int('42'), float('3.5'), or str(100)!"
          },
          concept: {
            title: "Type Casting",
            body: "<p><code>int()</code> truncates decimals or converts numeric strings to integers. <code>float()</code> converts to decimal numbers. <code>str()</code> converts anything to text.</p>"
          },
          showcase: {
            title: "Casting Data",
            language: "Python",
            code: `raw_input = "25"\nnum = int(raw_input)\ntotal = num + 5\nprint(total)`,
            explanation: "Converts '25' to 25 and adds 5 to produce 30."
          },
          challenge: {
            title: "Convert and Add Decimals",
            instruction: "Convert val = '12.5' to float, add 2.5, and print the result.",
            language: "Python",
            initialCode: `val = "12.5"\nprint(val + 2.5)`,
            solutionCode: `val = "12.5"\nprint(float(val) + 2.5)`,
            expectedOutput: "15.0"
          }
        },
        {
          id: "lesson-pyf-2-4",
          slug: "modern-fstrings",
          lesson_number: 4,
          title: "Modern String Interpolation with f-Strings",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "Concatenating strings with + and str() gets messy! Is there a cleaner way?",
            cody: "Yes, f-strings! Just put an f in front of the quotes and write {variables} directly inside curly braces!"
          },
          concept: {
            title: "Formatted String Literals (f-Strings)",
            body: "<p>Introduced in Python 3.6, f-strings provide an elegant, readable syntax for embedding expressions inside strings: <code>f\"Value: {x}\"</code>.</p>"
          },
          showcase: {
            title: "Clean Formatting with f-Strings",
            language: "Python",
            code: `rover = "Curiosity"\nsols = 3000\nprint(f"Rover {rover} active for {sols} Martian sols.")`,
            explanation: "Variables inside { } are automatically evaluated and inserted into the string."
          },
          challenge: {
            title: "Format Probe Status",
            instruction: "Using an f-string, print f'Probe {probe_id} battery: {battery}%'.",
            language: "Python",
            initialCode: `probe_id = "V-1"\nbattery = 95\nprint("Probe " + probe_id + " battery: " + str(battery) + "%")`,
            solutionCode: `probe_id = "V-1"\nbattery = 95\nprint(f"Probe {probe_id} battery: {battery}%")`,
            expectedOutput: "Probe V-1 battery: 95%"
          }
        }
      ]
    },
    // Chapter 3
    {
      id: "chap-pyf-03",
      slug: "arithmetic-modulo-expressions",
      chapter_number: 3,
      title: "Arithmetic, Modulo & Expressions",
      description: "Master operator precedence (PEMDAS), floor division (//), the remainder operator (%), and compound assignment shortcuts (+=, -=).",
      icon_symbol: "➗",
      lessons_overview: [
        "3.1 Operator Precedence & PEMDAS",
        "3.2 Floor Division (//) & Modulo (%)",
        "3.3 Compound Assignment (+=, -=, *=)",
        "3.4 Calculating Averages & Unit Conversions"
      ],
      project_title: "Metric Orbital Calculator",
      concept_code: `total_seconds = 3675
hours = total_seconds // 3600
minutes = (total_seconds % 3600) // 60
seconds = total_seconds % 60

print(f"Time: {hours}h {minutes}m {seconds}s")`,
      predict_question: {
        question: "What is the result of 17 % 5 in Python?",
        options: {
          A: "3",
          B: "2",
          C: "3.4",
          D: "0"
        },
        correct: "B",
        explanation: "17 divided by 5 is 3 with a remainder of 2. Modulo (%) calculates the remainder."
      },
      bug_hunt: {
        title: "Fix Integer Division Truncation",
        instruction: "Use standard division / instead of floor division // to keep decimal precision for the average.",
        broken_code: `total = 15\ncount = 2\navg = total // count\nprint(avg)`,
        fixed_code: `total = 15\ncount = 2\navg = total / count\nprint(avg)`,
        hint: "// chops off decimal parts. Use / to calculate accurate float averages."
      },
      lessons: [
        {
          id: "lesson-pyf-3-1",
          slug: "operator-precedence-pemdas",
          lesson_number: 1,
          title: "Operator Precedence & PEMDAS",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Why did 10 + 2 * 5 equal 20 instead of 60?",
            cody: "PEMDAS! Multiplication happens before addition. Use parentheses (10 + 2) * 5 if you want addition first!"
          },
          concept: {
            title: "Mathematical Precedence",
            body: "<p>Python evaluates: Parentheses <code>()</code>, Exponents <code>**</code>, Multiplication/Division <code>* / // %</code>, then Addition/Subtraction <code>+ -</code>.</p>"
          },
          showcase: {
            title: "Controlling Precedence",
            language: "Python",
            code: `val1 = 10 + 2 * 5\nval2 = (10 + 2) * 5\nprint(val1)\nprint(val2)`,
            explanation: "val1 evaluates to 20, whereas val2 evaluates to 60."
          },
          challenge: {
            title: "Calculate Correct Trajectory",
            instruction: "Compute res = (20 - 4) / 2 and print it.",
            language: "Python",
            initialCode: `res = 20 - 4 / 2\nprint(res)`,
            solutionCode: `res = (20 - 4) / 2\nprint(res)`,
            expectedOutput: "8.0"
          }
        },
        {
          id: "lesson-pyf-3-2",
          slug: "floor-division-and-modulo",
          lesson_number: 2,
          title: "Floor Division (//) & Modulo (%)",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I know if a number is even or odd in code?",
            cody: "Use the modulo operator %! If num % 2 == 0, the remainder is zero, so it's even!"
          },
          concept: {
            title: "Floor Division & Modulo",
            body: "<p><code>//</code> discards the fractional part and returns an integer quotient. <code>%</code> returns the remainder of the division.</p>"
          },
          showcase: {
            title: "Modulo and Floor Division",
            language: "Python",
            code: `total_items = 14\nbox_size = 4\nboxes_filled = total_items // box_size\nleftovers = total_items % box_size\nprint(f"Boxes: {boxes_filled}, Leftovers: {leftovers}")`,
            explanation: "14 // 4 = 3 full boxes, with 14 % 4 = 2 leftovers."
          },
          challenge: {
            title: "Find Even Remainder",
            instruction: "Calculate remainder = 28 % 5 and print remainder.",
            language: "Python",
            initialCode: `remainder = 28 / 5\nprint(remainder)`,
            solutionCode: `remainder = 28 % 5\nprint(remainder)`,
            expectedOutput: "3"
          }
        },
        {
          id: "lesson-pyf-3-3",
          slug: "compound-assignment-operators",
          lesson_number: 3,
          title: "Compound Assignment (+=, -=, *=)",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Is there a shortcut for writing score = score + 10?",
            cody: "Yes! Write score += 10. You can do the same with -=, *=, and /=!"
          },
          concept: {
            title: "Augmented Assignment",
            body: "<p><code>x += y</code> is shorthand for <code>x = x + y</code>. It modifies the existing variable in place concisely.</p>"
          },
          showcase: {
            title: "Accumulating Values",
            language: "Python",
            code: `shield = 100\nshield -= 25\nshield += 10\nprint(shield)`,
            explanation: "100 - 25 = 75, then 75 + 10 = 85."
          },
          challenge: {
            title: "Boost Booster Power",
            instruction: "Start thrust = 50, use thrust += 30, and print thrust.",
            language: "Python",
            initialCode: `thrust = 50\nthrust = 30\nprint(thrust)`,
            solutionCode: `thrust = 50\nthrust += 30\nprint(thrust)`,
            expectedOutput: "80"
          }
        },
        {
          id: "lesson-pyf-3-4",
          slug: "averages-and-unit-conversions",
          lesson_number: 4,
          title: "Calculating Averages & Unit Conversions",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "Let's build a real tool that takes 3 sensor readings and calculates the average temperature!",
            cody: "Sum them up with parentheses, divide by 3, and format with an f-string!"
          },
          concept: {
            title: "Applied Arithmetic",
            body: "<p>Mathematical expressions power data analysis, sensor filtering, and physics simulations.</p>"
          },
          showcase: {
            title: "Sensor Average",
            language: "Python",
            code: `s1, s2, s3 = 20, 24, 28\naverage = (s1 + s2 + s3) / 3\nprint(f"Average: {average:.1f}°C")`,
            explanation: "Computes the exact float average and formats to 1 decimal place."
          },
          challenge: {
            title: "Compute Speed Average",
            instruction: "Calculate avg = (100 + 200 + 300) / 3 and print avg.",
            language: "Python",
            initialCode: `avg = 100 + 200 + 300 / 3\nprint(avg)`,
            solutionCode: `avg = (100 + 200 + 300) / 3\nprint(avg)`,
            expectedOutput: "200.0"
          }
        }
      ]
    },
    // Chapter 4
    {
      id: "chap-pyf-04",
      slug: "boolean-logic-conditionals",
      chapter_number: 4,
      title: "Boolean Expressions & Conditional Branching",
      description: "Explore comparison operators, logical and/or/not operators, multi-way if-elif-else branching, and numerical range validation.",
      icon_symbol: "🧭",
      lessons_overview: [
        "4.1 Comparison Operators (==, !=, <, >, <=, >=)",
        "4.2 Logical Operators (and, or, not)",
        "4.3 Multi-Way Branching with if-elif-else",
        "4.4 Validating Numerical Ranges"
      ],
      project_title: "Orbital Clearance Verification System",
      concept_code: `altitude = 150
speed = 7800
shields_nominal = True

if (altitude >= 100 and speed >= 7000) and shields_nominal:
    print("STATUS: Orbit Stable")
else:
    print("STATUS: Course Correction Required")`,
      predict_question: {
        question: "What does (True and not False) evaluate to?",
        options: {
          A: "False",
          B: "True",
          C: "None",
          D: "Error"
        },
        correct: "B",
        explanation: "not False is True. True and True evaluates to True."
      },
      bug_hunt: {
        title: "Fix Assignment in Condition",
        instruction: "Use == for comparison instead of = which is for assignment.",
        broken_code: `status = "READY"\nif status = "READY":\n    print("Go")`,
        fixed_code: `status = "READY"\nif status == "READY":\n    print("Go")`,
        hint: "= assigns values, == checks equality in condition expressions."
      },
      lessons: [
        {
          id: "lesson-pyf-4-1",
          slug: "comparison-operators-deep-dive",
          lesson_number: 1,
          title: "Comparison Operators (==, !=, <, >, <=, >=)",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I check if two values are NOT equal in Python?",
            cody: "Use exclamation mark equals !=! For example, if current_state != 'SHUTDOWN': proceed!"
          },
          concept: {
            title: "Relational Operators",
            body: "<p>Comparisons return Boolean results: <code>==</code> (equal), <code>!=</code> (not equal), <code>&lt;=</code> (less/equal), <code>&gt;=</code> (greater/equal).</p>"
          },
          showcase: {
            title: "Evaluating Comparisons",
            language: "Python",
            code: `target_lock = True\nenemy_distance = 150\nprint(enemy_distance <= 200)\nprint(enemy_distance != 100)`,
            explanation: "Both evaluate to True because 150 <= 200 and 150 != 100."
          },
          challenge: {
            title: "Check Not Equal",
            instruction: "If code != 9999, print 'Valid code'. Set code = 1234.",
            language: "Python",
            initialCode: `code = 9999\nif code != 9999:\n    print("Valid code")`,
            solutionCode: `code = 1234\nif code != 9999:\n    print("Valid code")`,
            expectedOutput: "Valid code"
          }
        },
        {
          id: "lesson-pyf-4-2",
          slug: "logical-operators-and-or-not",
          lesson_number: 2,
          title: "Logical Operators (and, or, not)",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I check two conditions at the exact same time, like having a key AND having enough energy?",
            cody: "Use the 'and' keyword! Both must be True. If you only need one of them, use 'or'!"
          },
          concept: {
            title: "Boolean Logic Gates",
            body: "<p><code>and</code> requires both operands to be True. <code>or</code> requires at least one to be True. <code>not</code> inverts the truth value.</p>"
          },
          showcase: {
            title: "Combining Conditions",
            language: "Python",
            code: `has_card = True\npasscode = 1234\nif has_card and passcode == 1234:\n    print("Vault Open")`,
            explanation: "Both conditions are True, satisfying the and statement."
          },
          challenge: {
            title: "Verify Security Clearance",
            instruction: "Check if auth == True and level >= 2. If so, print 'Access granted'.",
            language: "Python",
            initialCode: `auth = True\nlevel = 1\nif auth and level >= 2:\n    print("Access granted")`,
            solutionCode: `auth = True\nlevel = 3\nif auth and level >= 2:\n    print("Access granted")`,
            expectedOutput: "Access granted"
          }
        },
        {
          id: "lesson-pyf-4-3",
          slug: "multi-way-branching",
          lesson_number: 3,
          title: "Multi-Way Branching with if-elif-else",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "If the first condition is True, does Python still check the elif conditions below it?",
            cody: "No! As soon as one branch succeeds, Python executes its block and skips all remaining elif and else branches."
          },
          concept: {
            title: "Exclusive Branching",
            body: "<p>In an <code>if-elif-else</code> ladder, only the first matching branch executes, ensuring mutually exclusive execution.</p>"
          },
          showcase: {
            title: "Grade Scale Evaluator",
            language: "Python",
            code: `score = 82\nif score >= 90:\n    print("Tier A")\nelif score >= 80:\n    print("Tier B")\nelse:\n    print("Tier C")`,
            explanation: "Matches score >= 80, prints 'Tier B', and skips the else branch."
          },
          challenge: {
            title: "Select Flight Mode",
            instruction: "For mode = 2, print 'Hyperdrive' when mode == 2.",
            language: "Python",
            initialCode: `mode = 1\nif mode == 1:\n    print("Cruising")\nelif mode == 2:\n    print("Hyperdrive")`,
            solutionCode: `mode = 2\nif mode == 1:\n    print("Cruising")\nelif mode == 2:\n    print("Hyperdrive")`,
            expectedOutput: "Hyperdrive"
          }
        },
        {
          id: "lesson-pyf-4-4",
          slug: "validating-numerical-ranges",
          lesson_number: 4,
          title: "Validating Numerical Ranges",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "Can I check if a temperature is between 20 and 30 degrees in one statement?",
            cody: "Python has a super cool feature: chained comparisons! You can write 20 <= temp <= 30 directly!"
          },
          concept: {
            title: "Chained Comparisons",
            body: "<p>Python allows mathematical chaining: <code>10 &lt;= pressure &lt;= 50</code> is shorthand for <code>pressure &gt;= 10 and pressure &lt;= 50</code>.</p>"
          },
          showcase: {
            title: "Safe Pressure Range",
            language: "Python",
            code: `pressure = 35\nif 20 <= pressure <= 50:\n    print("Cabin pressure optimal.")`,
            explanation: "35 falls between 20 and 50, so the condition evaluates to True."
          },
          challenge: {
            title: "Validate Safe Speed",
            instruction: "Check if 50 <= speed <= 100 for speed = 75 and print 'Safe speed'.",
            language: "Python",
            initialCode: `speed = 30\nif 50 <= speed <= 100:\n    print("Safe speed")`,
            solutionCode: `speed = 75\nif 50 <= speed <= 100:\n    print("Safe speed")`,
            expectedOutput: "Safe speed"
          }
        }
      ]
    },
    // Chapter 5
    {
      id: "chap-pyf-05",
      slug: "iteration-sequences-for-loops",
      chapter_number: 5,
      title: "Iteration & Sequences with for Loops",
      description: "Traverse sequences, control loops with range(start, stop, step), apply accumulator patterns, and construct nested loops.",
      icon_symbol: "🔄",
      lessons_overview: [
        "5.1 Sequence Traversal with for",
        "5.2 Controlling Ranges: start, stop, step",
        "5.3 The Accumulator Pattern: Summing & Counting",
        "5.4 Nested Loops & Coordinate Grids"
      ],
      project_title: "Orbital Sensor Grid Simulator",
      concept_code: `total_power = 0
for generator in range(1, 5):
    output = generator * 25
    total_power += output
    print(f"Generator {generator}: {output}MW")

print(f"Total Grid Output: {total_power}MW")`,
      predict_question: {
        question: "What is the output of list(range(2, 10, 3))?",
        options: {
          A: "[2, 5, 8]",
          B: "[2, 4, 6, 8]",
          C: "[3, 6, 9]",
          D: "[2, 5, 8, 11]"
        },
        correct: "A",
        explanation: "Starts at 2, steps by 3 (2, 5, 8), and stops before reaching 10."
      },
      bug_hunt: {
        title: "Fix Accumulator Re-initialization",
        instruction: "Move total = 0 outside the loop so it does not reset on every iteration.",
        broken_code: `for i in [10, 20, 30]:\n    total = 0\n    total += i\nprint(total)`,
        fixed_code: `total = 0\nfor i in [10, 20, 30]:\n    total += i\nprint(total)`,
        hint: "Initialize accumulator variables before entering the loop body."
      },
      lessons: [
        {
          id: "lesson-pyf-5-1",
          slug: "traversing-sequences-for",
          lesson_number: 1,
          title: "Sequence Traversal with for",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Can a for loop iterate directly over items in a list without index numbers?",
            cody: "Yes! That's called direct sequence iteration: 'for item in items:' grabs each item directly!"
          },
          concept: {
            title: "Direct Iteration",
            body: "<p>Python's <code>for</code> loop acts as a 'for-each' loop, visiting every element in any iterable sequence automatically.</p>"
          },
          showcase: {
            title: "Iterating Names",
            language: "Python",
            code: `planets = ["Mars", "Saturn", "Neptune"]\nfor p in planets:\n    print(f"Target: {p}")`,
            explanation: "Assigns 'Mars', then 'Saturn', then 'Neptune' to variable p."
          },
          challenge: {
            title: "Iterate Station Modules",
            instruction: "For m in ['Lab', 'Dock'], print 'Module: ' + m.",
            language: "Python",
            initialCode: `modules = ["Lab", "Dock"]\nfor m in modules:\n    print(m)`,
            solutionCode: `modules = ["Lab", "Dock"]\nfor m in modules:\n    print("Module: " + m)`,
            expectedOutput: "Module: Lab\nModule: Dock"
          }
        },
        {
          id: "lesson-pyf-5-2",
          slug: "range-start-stop-step",
          lesson_number: 2,
          title: "Controlling Ranges: start, stop, step",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Can range() count backwards or jump by tens?",
            cody: "Yes! range(start, stop, step). To count down: range(10, 0, -1)! To jump: range(0, 50, 10)!"
          },
          concept: {
            title: "The Three Arguments of range()",
            body: "<p><code>range(start, stop, step)</code> generates numbers from start up to stop-1 incrementing by step each time.</p>"
          },
          showcase: {
            title: "Stepping by 5",
            language: "Python",
            code: `for val in range(0, 15, 5):\n    print(val)`,
            explanation: "Generates 0, 5, 10."
          },
          challenge: {
            title: "Count Even Numbers",
            instruction: "Use range(2, 8, 2) to print 2, 4, 6.",
            language: "Python",
            initialCode: `for i in range(2, 6, 2):\n    print(i)`,
            solutionCode: `for i in range(2, 8, 2):\n    print(i)`,
            expectedOutput: "2\n4\n6"
          }
        },
        {
          id: "lesson-pyf-5-3",
          slug: "accumulator-patterns",
          lesson_number: 3,
          title: "The Accumulator Pattern: Summing & Counting",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do computers calculate the total score of 1,000 players?",
            cody: "The Accumulator Pattern! Initialize total = 0 before the loop, then add each score to total inside the loop!"
          },
          concept: {
            title: "The Accumulator Pattern",
            body: "<p>A running total or count variable is created outside the loop and incremented during each iteration.</p>"
          },
          showcase: {
            title: "Summing Numbers",
            language: "Python",
            code: `numbers = [5, 10, 15]\ntotal = 0\nfor n in numbers:\n    total += n\nprint(f"Grand Total: {total}")`,
            explanation: "Accumulates 5 + 10 + 15 = 30."
          },
          challenge: {
            title: "Accumulate 1 to 3",
            instruction: "Sum numbers 1, 2, 3 using a for loop and print the total.",
            language: "Python",
            initialCode: `total = 0\nfor i in [1, 2]:\n    total += i\nprint(total)`,
            solutionCode: `total = 0\nfor i in [1, 2, 3]:\n    total += i\nprint(total)`,
            expectedOutput: "6"
          }
        },
        {
          id: "lesson-pyf-5-4",
          slug: "nested-loops-grids",
          lesson_number: 4,
          title: "Nested Loops & Coordinate Grids",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "Can we put a loop inside another loop? What does that do?",
            cody: "It's a nested loop! For every single step of the outer loop, the inner loop runs completely. Perfect for rows and columns!"
          },
          concept: {
            title: "Nested Iteration",
            body: "<p>Used to iterate over 2D grids, matrices, tables, and coordinates: outer loop represents rows, inner loop represents columns.</p>"
          },
          showcase: {
            title: "Printing 2D Coordinates",
            language: "Python",
            code: `for x in range(2):\n    for y in range(2):\n        print(f"({x}, {y})")`,
            explanation: "Outputs (0, 0), (0, 1), (1, 0), (1, 1)."
          },
          challenge: {
            title: "Generate Coordinate Pairs",
            instruction: "Print pairs (0, 0) and (0, 1) using nested loops.",
            language: "Python",
            initialCode: `for x in range(1):\n    for y in range(1):\n        print(f"({x}, {y})")`,
            solutionCode: `for x in range(1):\n    for y in range(2):\n        print(f"({x}, {y})")`,
            expectedOutput: "(0, 0)\n(0, 1)"
          }
        }
      ]
    },
    // Chapter 6
    {
      id: "chap-pyf-06",
      slug: "while-loops-and-state",
      chapter_number: 6,
      title: "Event-Driven & State-Based while Loops",
      description: "Understand sentinel-controlled loops, state flags, break and continue statements, and robust input validation loops.",
      icon_symbol: "🎛️",
      lessons_overview: [
        "6.1 Sentinel-Controlled Loops",
        "6.2 Flag Variables & State Tracking",
        "6.3 Loop Flow Control: break and continue",
        "6.4 Input Validation Loops"
      ],
      project_title: "Automated Life Support Monitor",
      concept_code: `battery = 100
cycles = 0

while battery > 20:
    battery -= 25
    cycles += 1
    print(f"Cycle {cycles}: Battery at {battery}%")

print("ALERT: Backup generator engaged.")`,
      predict_question: {
        question: "What does the 'continue' keyword do inside a loop?",
        options: {
          A: "Stops the loop completely",
          B: "Skips the rest of the current iteration and jumps to the next one",
          C: "Restarts the whole program",
          D: "Nothing"
        },
        correct: "B",
        explanation: "continue aborts the remainder of the current loop iteration and proceeds immediately to the next iteration."
      },
      bug_hunt: {
        title: "Fix Missing Loop Decrement",
        instruction: "Decrement timer by 1 inside the while loop so the condition timer > 0 terminates.",
        broken_code: `timer = 3\nwhile timer > 0:\n    print(timer)`,
        fixed_code: `timer = 3\nwhile timer > 0:\n    print(timer)\n    timer -= 1`,
        hint: "Without modifying the sentinel variable, the while loop will loop infinitely."
      },
      lessons: [
        {
          id: "lesson-pyf-6-1",
          slug: "sentinel-controlled-loops",
          lesson_number: 1,
          title: "Sentinel-Controlled Loops",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "What is a 'sentinel value' in programming?",
            cody: "A sentinel is a special signal value—like typing 'quit' or reaching 0—that tells a while loop to stop!"
          },
          concept: {
            title: "Sentinel Patterns",
            body: "<p>A loop runs until a specific sentinel value appears in the monitored state variable.</p>"
          },
          showcase: {
            title: "Countdown Sentinel",
            language: "Python",
            code: `pressure = 30\nwhile pressure > 0:\n    pressure -= 10\n    print(f"Pressure: {pressure}")`,
            explanation: "Terminates when pressure drops to 0."
          },
          challenge: {
            title: "Deplete Energy to Zero",
            instruction: "Start energy = 40. While energy > 0, subtract 20 and print energy.",
            language: "Python",
            initialCode: `energy = 40\nwhile energy > 20:\n    energy -= 20\n    print(energy)`,
            solutionCode: `energy = 40\nwhile energy > 0:\n    energy -= 20\n    print(energy)`,
            expectedOutput: "20\n0"
          }
        },
        {
          id: "lesson-pyf-6-2",
          slug: "flag-variables-state",
          lesson_number: 2,
          title: "Flag Variables & State Tracking",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do game engines keep running until the player clicks Exit?",
            cody: "A boolean flag! is_running = True. Inside the loop, when you click Exit, is_running = False and the game finishes cleanly!"
          },
          concept: {
            title: "State Flag Variables",
            body: "<p>Boolean flags represent system states (e.g. <code>system_active = True</code>) that govern overarching loop lifecycles.</p>"
          },
          showcase: {
            title: "State Flag in Action",
            language: "Python",
            code: `scanning = True\nchecks = 0\nwhile scanning:\n    checks += 1\n    if checks == 2:\n        scanning = False\n    print(f"Scan {checks} complete")`,
            explanation: "Sets scanning to False after 2 checks, terminating the loop."
          },
          challenge: {
            title: "Stop Scanner with Flag",
            instruction: "Set active = False when count == 1 to print 'Scanning 1' and stop.",
            language: "Python",
            initialCode: `active = True\ncount = 0\nwhile active:\n    count += 1\n    print(f"Scanning {count}")`,
            solutionCode: `active = True\ncount = 0\nwhile active:\n    count += 1\n    active = False\n    print(f"Scanning {count}")`,
            expectedOutput: "Scanning 1"
          }
        },
        {
          id: "lesson-pyf-6-3",
          slug: "break-and-continue",
          lesson_number: 3,
          title: "Loop Flow Control: break and continue",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "What if an emergency happens and I must exit the loop right NOW without waiting for the next check?",
            cody: "Use 'break'! It instantly terminates the enclosing loop. To skip just the current round, use 'continue'!"
          },
          concept: {
            title: "Altering Loop Flow",
            body: "<p><code>break</code> immediately breaks out of the loop. <code>continue</code> skips directly to the next iteration.</p>"
          },
          showcase: {
            title: "Emergency Break",
            language: "Python",
            code: `for val in range(1, 10):\n    if val == 3:\n        break\n    print(val)`,
            explanation: "Prints 1 and 2, then encounters break at 3 and exits immediately."
          },
          challenge: {
            title: "Break at 2",
            instruction: "Break when i == 2 so only 1 prints.",
            language: "Python",
            initialCode: `for i in range(1, 5):\n    if i == 4:\n        break\n    print(i)`,
            solutionCode: `for i in range(1, 5):\n    if i == 2:\n        break\n    print(i)`,
            expectedOutput: "1"
          }
        },
        {
          id: "lesson-pyf-6-4",
          slug: "input-validation-loops",
          lesson_number: 4,
          title: "Input Validation Loops",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "How do we prevent users from entering negative fuel or invalid choices?",
            cody: "Validation loops! While the input is invalid, prompt the user repeatedly until they provide valid data!"
          },
          concept: {
            title: "Defensive Input Validation",
            body: "<p>Validation loops enforce business logic constraints before allowing the application to process inputs.</p>"
          },
          showcase: {
            title: "Simulated Validation Loop",
            language: "Python",
            code: `valid = False\nattempt = 0\nwhile not valid:\n    attempt += 1\n    if attempt == 2:\n        valid = True\n        print("Input verified successfully")`,
            explanation: "Loops until input criteria are met."
          },
          challenge: {
            title: "Verify Calibration Input",
            instruction: "Loop until calibrated is True and print 'System calibrated'.",
            language: "Python",
            initialCode: `calibrated = False\nwhile not calibrated:\n    print("System calibrated")`,
            solutionCode: `calibrated = False\nwhile not calibrated:\n    calibrated = True\n    print("System calibrated")`,
            expectedOutput: "System calibrated"
          }
        }
      ]
    },
    // Chapter 7
    {
      id: "chap-pyf-07",
      slug: "string-manipulation-slicing",
      chapter_number: 7,
      title: "String Manipulation & Slicing",
      description: "Master string immutability, index notation, slicing with [start:stop:step], and essential string methods (lower, upper, replace, split).",
      icon_symbol: "✂️",
      lessons_overview: [
        "7.1 String Immutability & Indexing",
        "7.2 Slicing with [start:stop:step]",
        "7.3 Case Transformation & Replacement (.upper, .replace)",
        "7.4 Splitting & Joining Strings (.split, .join)"
      ],
      project_title: "Sub-Orbital Message Decoder",
      concept_code: `encoded = "ERR_NAV_SYSTEM_NOMINAL"
clean_code = encoded.replace("ERR_", "")
tokens = clean_code.split("_")
print("Status Tokens:", tokens)`,
      predict_question: {
        question: "What is the result of 'PYTHON'[1:4]?",
        options: {
          A: "'PYT'",
          B: "'YTH'",
          C: "'YTHO'",
          D: "'THO'"
        },
        correct: "B",
        explanation: "Index 1 is 'Y', index 2 is 'T', index 3 is 'H'. Stop index 4 is excluded, resulting in 'YTH'."
      },
      bug_hunt: {
        title: "Fix String Immutability Error",
        instruction: "Strings are immutable. Assign the replaced result back to a variable instead of trying to mutate in-place.",
        broken_code: `word = "mars"\nword[0] = "M"\nprint(word)`,
        fixed_code: `word = "mars"\nword = "M" + word[1:]\nprint(word)`,
        hint: "In Python, string characters cannot be reassigned via index. Create a new string instead."
      },
      lessons: [
        {
          id: "lesson-pyf-7-1",
          slug: "string-immutability-indexing",
          lesson_number: 1,
          title: "String Immutability & Indexing",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Can I grab negative index numbers from a string like word[-1]?",
            cody: "Yes! Negative indexing counts backwards from the end. [-1] is the very last character, [-2] is second-to-last!"
          },
          concept: {
            title: "String Immutability & Indexing",
            body: "<p>Strings are immutable sequences of characters. Negative indices allow easy access from the end of the text.</p>"
          },
          showcase: {
            title: "Character Extraction",
            language: "Python",
            code: `station = "ORBIT-9"\nprint(station[0])\nprint(station[-1])`,
            explanation: "Outputs 'O' (first) and '9' (last)."
          },
          challenge: {
            title: "Extract Last Character",
            instruction: "Print signal[-1] from signal = 'BEACON-X'.",
            language: "Python",
            initialCode: `signal = "BEACON-X"\nprint(signal[0])`,
            solutionCode: `signal = "BEACON-X"\nprint(signal[-1])`,
            expectedOutput: "X"
          }
        },
        {
          id: "lesson-pyf-7-2",
          slug: "string-slicing-notation",
          lesson_number: 2,
          title: "Slicing with [start:stop:step]",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I extract just the year from a date string like '2026-09-12'?",
            cody: "Slice it! string[0:4] extracts characters from index 0 up to 3!"
          },
          concept: {
            title: "String Slicing",
            body: "<p><code>string[start:stop]</code> extracts a substring. Leaving start blank defaults to 0; leaving stop blank defaults to the end.</p>"
          },
          showcase: {
            title: "Slicing Examples",
            language: "Python",
            code: `code = "TELEMETRY"\nprint(code[0:4])\nprint(code[4:])`,
            explanation: "Outputs 'TELE' then 'METRY'."
          },
          challenge: {
            title: "Extract Sector Prefix",
            instruction: "Extract the first 3 letters from sector = 'SEC-88'.",
            language: "Python",
            initialCode: `sector = "SEC-88"\nprint(sector[0:2])`,
            solutionCode: `sector = "SEC-88"\nprint(sector[0:3])`,
            expectedOutput: "SEC"
          }
        },
        {
          id: "lesson-pyf-7-3",
          slug: "case-transformation-methods",
          lesson_number: 3,
          title: "Case Transformation & Replacement (.upper, .replace)",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I make user input case-insensitive so 'yes', 'Yes', and 'YES' all work?",
            cody: "Call .lower() or .upper()! For example, if answer.lower() == 'yes':"
          },
          concept: {
            title: "Built-In String Methods",
            body: "<p><code>.lower()</code>, <code>.upper()</code>, and <code>.strip()</code> normalize text. <code>.replace(old, new)</code> substitutes text fragments.</p>"
          },
          showcase: {
            title: "String Method Chaining",
            language: "Python",
            code: `raw = "  Apollo 11  "\nclean = raw.strip().upper()\nprint(clean)`,
            explanation: "Strips whitespace and converts to uppercase: 'APOLLO 11'."
          },
          challenge: {
            title: "Clean and Capitalize",
            instruction: "Convert ship = 'falcon' to uppercase and print it.",
            language: "Python",
            initialCode: `ship = "falcon"\nprint(ship)`,
            solutionCode: `ship = "falcon"\nprint(ship.upper())`,
            expectedOutput: "FALCON"
          }
        },
        {
          id: "lesson-pyf-7-4",
          slug: "splitting-and-joining",
          lesson_number: 4,
          title: "Splitting & Joining Strings (.split, .join)",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "How do I take a sentence and break it into individual words?",
            cody: "Use .split()! It cuts the string at every space and gives you a list of words!"
          },
          concept: {
            title: "Tokenization with split and join",
            body: "<p><code>.split(sep)</code> divides text into a list. <code>delimiter.join(list)</code> glues a list back into a single string.</p>"
          },
          showcase: {
            title: "Split and Join",
            language: "Python",
            code: `data = "alpha,beta,gamma"\nitems = data.split(",")\nprint(items)\nprint(" - ".join(items))`,
            explanation: "Splits into a list, then rejoins with hyphens."
          },
          challenge: {
            title: "Split CSV Values",
            instruction: "Split coords = 'X10:Y20' by ':' and print the list.",
            language: "Python",
            initialCode: `coords = "X10:Y20"\nprint(coords)`,
            solutionCode: `coords = "X10:Y20"\nprint(coords.split(":"))`,
            expectedOutput: "['X10', 'Y20']"
          }
        }
      ]
    },
    // Chapter 8
    {
      id: "chap-pyf-08",
      slug: "lists-and-sequence-operations",
      chapter_number: 8,
      title: "Lists & Sequence Operations",
      description: "Master list mutability, modification methods (append, insert, pop, remove), searching and aggregation (min, max, sum), and sorting.",
      icon_symbol: "📋",
      lessons_overview: [
        "8.1 List Mutability & Memory Representation",
        "8.2 List Modifications: append, insert, pop, remove",
        "8.3 Searching & Aggregation: min, max, sum, in",
        "8.4 Sorting & Reversing Sequences (.sort, sorted)"
      ],
      project_title: "Leaderboard & Inventory Engine",
      concept_code: `scores = [85, 92, 78, 99, 88]
scores.sort(reverse=True)
top_score = max(scores)
avg_score = sum(scores) / len(scores)

print(f"Top: {top_score} | Average: {avg_score:.1f}")`,
      predict_question: {
        question: "What does list.pop() with no arguments do?",
        options: {
          A: "Removes and returns the first item",
          B: "Removes and returns the last item",
          C: "Clears the entire list",
          D: "Does nothing"
        },
        correct: "B",
        explanation: "pop() without an index removes and returns the last element from the list."
      },
      bug_hunt: {
        title: "Fix Non-Existent List Item Removal",
        instruction: "Use 'in' to check if an item exists before calling .remove() to prevent ValueError.",
        broken_code: `items = ["Battery", "Radio"]\nitems.remove("Scanner")`,
        fixed_code: `items = ["Battery", "Radio"]\nif "Scanner" in items:\n    items.remove("Scanner")\nprint(items)`,
        hint: "Calling remove() on an item not present in the list throws a runtime ValueError."
      },
      lessons: [
        {
          id: "lesson-pyf-8-1",
          slug: "list-mutability",
          lesson_number: 1,
          title: "List Mutability & Memory Representation",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Unlike strings, can I change elements inside a list directly using index assignment?",
            cody: "Yes! Lists are mutable. items[0] = 'New Value' updates that slot in place!"
          },
          concept: {
            title: "Mutable Collections",
            body: "<p>Lists can be modified after creation: items can be updated, inserted, deleted, and reordered in memory.</p>"
          },
          showcase: {
            title: "Modifying Elements",
            language: "Python",
            code: `crew = ["Alex", "Sam"]\ncrew[1] = "Kira"\nprint(crew)`,
            explanation: "Replaces 'Sam' at index 1 with 'Kira'."
          },
          challenge: {
            title: "Update First Module",
            instruction: "Set modules[0] = 'Command' for modules = ['Basic', 'Life']. Print modules.",
            language: "Python",
            initialCode: `modules = ["Basic", "Life"]\nprint(modules)`,
            solutionCode: `modules = ["Basic", "Life"]\nmodules[0] = "Command"\nprint(modules)`,
            expectedOutput: "['Command', 'Life']"
          }
        },
        {
          id: "lesson-pyf-8-2",
          slug: "list-modifications-methods",
          lesson_number: 2,
          title: "List Modifications: append, insert, pop, remove",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "What is the difference between append and insert?",
            cody: ".append(x) always adds to the very end. .insert(index, x) injects an item at any specific position!"
          },
          concept: {
            title: "Adding and Removing Items",
            body: "<p><code>.append()</code> adds to end. <code>.insert(i, x)</code> adds at index i. <code>.pop()</code> removes by index. <code>.remove(val)</code> removes by value.</p>"
          },
          showcase: {
            title: "List Operations",
            language: "Python",
            code: `queue = ["Ship1", "Ship2"]\nqueue.append("Ship3")\nlaunched = queue.pop(0)\nprint(f"Launched: {launched}, Waiting: {queue}")`,
            explanation: "Adds Ship3, pops Ship1 from the front."
          },
          challenge: {
            title: "Pop Last Item",
            instruction: "Pop the last item from items = ['A', 'B', 'C'] and print items.",
            language: "Python",
            initialCode: `items = ["A", "B", "C"]\nprint(items)`,
            solutionCode: `items = ["A", "B", "C"]\nitems.pop()\nprint(items)`,
            expectedOutput: "['A', 'B']"
          }
        },
        {
          id: "lesson-pyf-8-3",
          slug: "searching-aggregation-functions",
          lesson_number: 3,
          title: "Searching & Aggregation: min, max, sum, in",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Do I have to write a loop every time I want to find the highest score in a list?",
            cody: "Not at all! Python has built-in super functions: max(list), min(list), sum(list), and len(list)!"
          },
          concept: {
            title: "Built-In Aggregation",
            body: "<p><code>max()</code>, <code>min()</code>, <code>sum()</code>, and <code>len()</code> analyze list data in O(N) linear time.</p>"
          },
          showcase: {
            title: "Aggregating Telemetry",
            language: "Python",
            code: `temps = [21, 24, 19, 26, 22]\nprint(f"Max: {max(temps)}, Min: {min(temps)}, Sum: {sum(temps)}")`,
            explanation: "Calculates maximum, minimum, and total sum directly."
          },
          challenge: {
            title: "Calculate List Sum",
            instruction: "Print sum(fuel_cells) for fuel_cells = [10, 20, 30].",
            language: "Python",
            initialCode: `fuel_cells = [10, 20, 30]\nprint(len(fuel_cells))`,
            solutionCode: `fuel_cells = [10, 20, 30]\nprint(sum(fuel_cells))`,
            expectedOutput: "60"
          }
        },
        {
          id: "lesson-pyf-8-4",
          slug: "sorting-reversing-sequences",
          lesson_number: 4,
          title: "Sorting & Reversing Sequences (.sort, sorted)",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "What is the difference between list.sort() and sorted(list)?",
            cody: "list.sort() modifies the original list in place! sorted(list) creates a brand new sorted copy and leaves the original untouched!"
          },
          concept: {
            title: "In-Place vs Out-of-Place Sorting",
            body: "<p>Use <code>.sort()</code> when you don't need the original order. Use <code>sorted()</code> when you want to preserve the source collection.</p>"
          },
          showcase: {
            title: "Sorting Lists",
            language: "Python",
            code: `nums = [5, 2, 8, 1]\nnums.sort()\nprint(nums)`,
            explanation: "Sorts in ascending order: [1, 2, 5, 8]."
          },
          challenge: {
            title: "Sort Numbers Descending",
            instruction: "Sort vals = [3, 1, 4] with vals.sort(reverse=True) and print vals.",
            language: "Python",
            initialCode: `vals = [3, 1, 4]\nvals.sort()\nprint(vals)`,
            solutionCode: `vals = [3, 1, 4]\nvals.sort(reverse=True)\nprint(vals)`,
            expectedOutput: "[4, 3, 1]"
          }
        }
      ]
    },
    // Chapter 9
    {
      id: "chap-pyf-09",
      slug: "dictionaries-key-value-mapping",
      chapter_number: 9,
      title: "Dictionaries & Key-Value Mapping",
      description: "Understand associative mapping with key-value pairs, accessing and mutating dictionary entries, iterating keys/values, and structuring records.",
      icon_symbol: "📖",
      lessons_overview: [
        "9.1 Key-Value Pair Mechanics",
        "9.2 Accessing & Mutating Dictionary Entries",
        "9.3 Iterating Keys, Values, and Items",
        "9.4 Structuring Student & Astronaut Records"
      ],
      project_title: "Astronaut Profile Database",
      concept_code: `astronaut = {
    "name": "Nova Scott",
    "rank": "Commander",
    "missions": 3,
    "certified": True
}

for key, value in astronaut.items():
    print(f"{key.capitalize()}: {value}")`,
      predict_question: {
        question: "What happens when you access dict['missing_key'] if 'missing_key' is not in the dictionary?",
        options: {
          A: "Returns None",
          B: "Raises a KeyError",
          C: "Creates the key automatically",
          D: "Returns False"
        },
        correct: "B",
        explanation: "Square bracket access dict[k] raises a KeyError if the key does not exist. Use dict.get(k) for safe lookup."
      },
      bug_hunt: {
        title: "Fix Safe Dictionary Lookup",
        instruction: "Use .get('speed', 0) to avoid KeyError on missing dictionary keys.",
        broken_code: `ship = {"name": "Atlas"}\nprint(ship["speed"])`,
        fixed_code: `ship = {"name": "Atlas"}\nprint(ship.get("speed", 0))`,
        hint: ".get(key, default) safely returns a fallback value if the key does not exist."
      },
      lessons: [
        {
          id: "lesson-pyf-9-1",
          slug: "key-value-mechanics",
          lesson_number: 1,
          title: "Key-Value Pair Mechanics",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I store information where each piece has a name, like 'name': 'Alex', 'age': 14?",
            cody: "Use a dictionary! Defined with curly braces { }, it pairs keys with values!"
          },
          concept: {
            title: "Python Dictionaries",
            body: "<p>A dictionary stores associative mappings in <code>{key: value}</code> pairs. Keys must be immutable types (like strings or integers).</p>"
          },
          showcase: {
            title: "Creating a Dictionary",
            language: "Python",
            code: `pilot = {"callsign": "Falcon", "rank": "Captain"}\nprint(pilot["callsign"])`,
            explanation: "Looks up the value associated with 'callsign'."
          },
          challenge: {
            title: "Create Base Station Dict",
            instruction: "Create station = {'sector': 7, 'active': True} and print station['sector'].",
            language: "Python",
            initialCode: `station = {"sector": 5}\nprint(station["sector"])`,
            solutionCode: `station = {"sector": 7, "active": True}\nprint(station["sector"])`,
            expectedOutput: "7"
          }
        },
        {
          id: "lesson-pyf-9-2",
          slug: "mutating-dictionary-entries",
          lesson_number: 2,
          title: "Accessing & Mutating Dictionary Entries",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I add a new key-value pair to an existing dictionary?",
            cody: "Just assign to it! dict['new_key'] = new_value. If it exists, it updates; if not, it adds it!"
          },
          concept: {
            title: "Dictionary Mutation",
            body: "<p>Assigning to <code>d[key] = val</code> inserts or updates the entry. <code>del d[key]</code> removes an entry.</p>"
          },
          showcase: {
            title: "Updating Records",
            language: "Python",
            code: `stats = {"hp": 100}\nstats["hp"] = 80\nstats["shield"] = 50\nprint(stats)`,
            explanation: "Updates hp to 80 and inserts shield: 50."
          },
          challenge: {
            title: "Add Fuel to Specs",
            instruction: "Add specs['fuel'] = 100 for specs = {'speed': 500} and print specs.",
            language: "Python",
            initialCode: `specs = {"speed": 500}\nprint(specs)`,
            solutionCode: `specs = {"speed": 500}\nspecs["fuel"] = 100\nprint(specs)`,
            expectedOutput: "{'speed': 500, 'fuel': 100}"
          }
        },
        {
          id: "lesson-pyf-9-3",
          slug: "iterating-dict-items",
          lesson_number: 3,
          title: "Iterating Keys, Values, and Items",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "How do I loop over both the keys and the values at the same time?",
            cody: "Use .items()! It returns (key, value) pairs that you can unpack in your loop!"
          },
          concept: {
            title: "Dictionary Iteration",
            body: "<p><code>d.keys()</code> yields keys, <code>d.values()</code> yields values, and <code>d.items()</code> yields key-value tuples.</p>"
          },
          showcase: {
            title: "Iterating Items",
            language: "Python",
            code: `cargo = {"ore": 50, "water": 100}\nfor item, qty in cargo.items():\n    print(f"{item}: {qty}")`,
            explanation: "Unpacks item and qty on each iteration."
          },
          challenge: {
            title: "Print Inventory Items",
            instruction: "For k, v in {'gem': 5}.items(), print k + ': ' + str(v).",
            language: "Python",
            initialCode: `inv = {"gem": 5}\nfor k in inv:\n    print(k)`,
            solutionCode: `inv = {"gem": 5}\nfor k, v in inv.items():\n    print(k + ": " + str(v))`,
            expectedOutput: "gem: 5"
          }
        },
        {
          id: "lesson-pyf-9-4",
          slug: "structuring-records",
          lesson_number: 4,
          title: "Structuring Student & Astronaut Records",
          duration: 12,
          xp: 25,
          dialogue: {
            shady: "Can we have a list of dictionaries to represent multiple crew members?",
            cody: "Yes! That's how real databases and APIs work: a list of structured records!"
          },
          concept: {
            title: "Lists of Dictionaries",
            body: "<p>A list containing dictionary objects models tables, databases, and JSON API payloads standard in web engineering.</p>"
          },
          showcase: {
            title: "Crew Roster",
            language: "Python",
            code: `crew = [\n    {"name": "Leo", "role": "Pilot"},\n    {"name": "Zara", "role": "Engineer"}\n]\nfor member in crew:\n    print(f"{member['name']} - {member['role']}")`,
            explanation: "Iterates through records and formats output."
          },
          challenge: {
            title: "Print Roster Names",
            instruction: "For m in roster = [{'name': 'Cody'}], print m['name'].",
            language: "Python",
            initialCode: `roster = [{"name": "Cody"}]\nprint(roster)`,
            solutionCode: `roster = [{"name": "Cody"}]\nfor m in roster:\n    print(m["name"])`,
            expectedOutput: "Cody"
          }
        }
      ]
    },
    // Chapter 10
    {
      id: "chap-pyf-10",
      slug: "modular-functions-reusable-logic",
      chapter_number: 10,
      title: "Modular Functions & Reusable Logic",
      description: "Decompose programs into pure functions, understand return values vs side effects, scope rules (local vs global), and build the capstone console app.",
      icon_symbol: "🧩",
      lessons_overview: [
        "10.1 Defining Functions with Parameters",
        "10.2 Return Values vs Side Effects",
        "10.3 Variable Scope: Local vs Global",
        "10.4 Capstone: Interactive Orbital Console Application"
      ],
      project_title: "Orbit Station Command Console",
      concept_code: `def calculate_burn(mass, delta_v):
    thrust_constant = 9.81
    fuel_needed = (mass * delta_v) / thrust_constant
    return round(fuel_needed, 2)

required = calculate_burn(1200, 150)
print(f"Propellant Required: {required} kg")`,
      predict_question: {
        question: "Can code outside a function access a variable defined inside that function?",
        options: {
          A: "Yes, always",
          B: "No, variables defined inside functions are local to that function",
          C: "Only if the variable is a number",
          D: "Only if imported"
        },
        correct: "B",
        explanation: "Variables created inside a function have local scope and cannot be accessed from the outside global scope."
      },
      bug_hunt: {
        title: "Fix Missing Return Statement",
        instruction: "Add 'return result' inside the function so it passes the answer back to the caller.",
        broken_code: `def add(a, b):\n    result = a + b\n\nval = add(10, 20)\nprint(val)`,
        fixed_code: `def add(a, b):\n    result = a + b\n    return result\n\nval = add(10, 20)\nprint(val)`,
        hint: "Without a return statement, a Python function automatically returns None."
      },
      lessons: [
        {
          id: "lesson-pyf-10-1",
          slug: "function-parameters-arguments",
          lesson_number: 1,
          title: "Defining Functions with Parameters",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "What is the difference between a parameter and an argument?",
            cody: "Parameters are the variable names in the function definition. Arguments are the actual values you pass in when calling it!"
          },
          concept: {
            title: "Functional Abstraction",
            body: "<p>Functions allow you to isolate logic, reduce duplication (DRY principle), and make software modular and testable.</p>"
          },
          showcase: {
            title: "Velocity Calculator Function",
            language: "Python",
            code: `def compute_speed(distance, time):\n    return distance / time\n\nresult = compute_speed(100, 2)\nprint(f"Speed: {result} km/h")`,
            explanation: "distance and time are parameters; 100 and 2 are arguments."
          },
          challenge: {
            title: "Create Multiply Function",
            instruction: "Define def multiply(a, b): return a * b. Print multiply(4, 5).",
            language: "Python",
            initialCode: `def multiply(a, b):\n    return a + b\nprint(multiply(4, 5))`,
            solutionCode: `def multiply(a, b):\n    return a * b\nprint(multiply(4, 5))`,
            expectedOutput: "20"
          }
        },
        {
          id: "lesson-pyf-10-2",
          slug: "return-values-vs-side-effects",
          lesson_number: 2,
          title: "Return Values vs Side Effects",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "Why shouldn't every function just use print() inside?",
            cody: "Because printing is a side effect! Returning a value lets other parts of your program reuse, store, or calculate with that answer!"
          },
          concept: {
            title: "Pure Functions & Return Values",
            body: "<p>A function that returns a value without modifying global state is predictable, testable, and reusable.</p>"
          },
          showcase: {
            title: "Pure Function Pattern",
            language: "Python",
            code: `def is_even(num):\n    return num % 2 == 0\n\nprint(is_even(8))\nprint(is_even(7))`,
            explanation: "Returns True or False directly to the caller."
          },
          challenge: {
            title: "Return Square Value",
            instruction: "Define def square(x): return x * x. Print square(6).",
            language: "Python",
            initialCode: `def square(x):\n    print(x * x)\nsquare(6)`,
            solutionCode: `def square(x):\n    return x * x\nprint(square(6))`,
            expectedOutput: "36"
          }
        },
        {
          id: "lesson-pyf-10-3",
          slug: "variable-scope-rules",
          lesson_number: 3,
          title: "Variable Scope: Local vs Global",
          duration: 10,
          xp: 25,
          dialogue: {
            shady: "If I create x = 10 inside a function, can my other functions see it?",
            cody: "No! That's local scope. It only exists while that function is running and disappears when it returns!"
          },
          concept: {
            title: "Local and Global Scope",
            body: "<p>Variables defined inside functions are local. Variables defined at the top level of the file are global.</p>"
          },
          showcase: {
            title: "Scope Isolation",
            language: "Python",
            code: `system_mode = "AUTO"  # Global\n\ndef run_check():\n    sensor = 99       # Local\n    return sensor\n\nprint(f"Mode: {system_mode}, Reading: {run_check()}")`,
            explanation: "system_mode is accessible everywhere, while sensor is confined to run_check()."
          },
          challenge: {
            title: "Demonstrate Local Scope",
            instruction: "Define def get_val(): x = 42; return x. Print get_val().",
            language: "Python",
            initialCode: `def get_val():\n    return 10\nprint(get_val())`,
            solutionCode: `def get_val():\n    x = 42\n    return x\nprint(get_val())`,
            expectedOutput: "42"
          }
        },
        {
          id: "lesson-pyf-10-4",
          slug: "capstone-orbital-console",
          lesson_number: 4,
          title: "Capstone: Interactive Orbital Console Application",
          duration: 15,
          xp: 50,
          dialogue: {
            shady: "We mastered variables, types, loops, lists, dictionaries, and functions!",
            cody: "You have built true Python foundations. Let's assemble our Capstone Station Manager!"
          },
          concept: {
            title: "The Preparatory Capstone",
            body: "<p>Integrate data structures, modular functions, control flow, and formatted reporting into a comprehensive terminal application.</p>"
          },
          showcase: {
            title: "Station Manager Capstone",
            language: "Python",
            code: `def station_report(name, power, shields):\n    status = "READY" if (power > 50 and shields) else "ALERT"\n    return f"Station {name}: {status}"\n\nprint(station_report("Alpha", 80, True))`,
            explanation: "Combines functions, conditionals, parameters, and f-string formatting."
          },
          challenge: {
            title: "Assemble Final Report",
            instruction: "Define def evaluate(score): return 'Pass' if score >= 70 else 'Review'. Print evaluate(85).",
            language: "Python",
            initialCode: `def evaluate(score):\n    return "Review"\nprint(evaluate(85))`,
            solutionCode: `def evaluate(score):\n    return "Pass" if score >= 70 else "Review"\nprint(evaluate(85))`,
            expectedOutput: "Pass"
          }
        }
      ]
    }
  ]
};

if (typeof window !== 'undefined') {
  window.PYTHON_FOUNDATIONS_COURSE = PYTHON_FOUNDATIONS_COURSE;
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = { PYTHON_FOUNDATIONS_COURSE };
}
