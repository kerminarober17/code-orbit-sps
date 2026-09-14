/**
 * SPS CODE ORBIT — Python Level 2 Curriculum
 * Source of truth: sps_python_level2_curriculum.md (uploaded 2026-09-13)
 * COMPLETELY REPLACED — new Markdown is the single source of truth.
 * 10 chapters / 40 lessons — educational content preserved from Markdown.
 */
var PYTHON_LEVEL2_COURSE = {
  id: "course-python-level-2",
  slug: "python-level-2",
  title: "Python Level 2: Code Orbit",
  description: "By the end of this course, students will write professional-quality Python programs using dictionaries, file I/O, modules, error handling, list comprehensions, advanced functions, and the basics of Object-Oriented Programming.",
  academic_group: "Preparatory",
  academic_group_id: "ag-prep",
  image_url: "/assets/courses/algo.png",
  accent_color: "#8B5CF6",
  chapters: [

    {
      id: "chap-pyl2-01",
      slug: "strings-going-deeper",
      chapter_number: 1,
      title: `Strings — Going Deeper`,
      description: `Students already know basic strings from Level 1. This chapter goes much deeper — slicing, powerful methods, and professional output formatting.`,
      icon_symbol: "🔤",
      lessons_overview: ["1 String Indexing and Slicing", "2 Powerful String Methods", "3 Multi-line Strings and Number Formatting", "4 Mini Project — Text Analyser"],
      lessons: [

        {
          id: "lesson-pyl2-1-1",
          slug: "lesson-pyl2-1-1",
          lesson_number: 1,
          title: `String Indexing and Slicing`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I have a string: 'Shady Ahmed'. I want to extract just 'Shady' automatically — without counting and typing it manually each time. Numbered seats? Starting from what number? So I could say: give me seats 0 to 4?`,
            cody: `That's exactly what slicing is for. Every character in a string sits in a numbered seat — like passengers on a train. Starting from zero. Always zero in Python. S = seat 0, h = seat 1, a = seat 2... Exactly. And Python has a clean syntax for exactly that.`
          },
          concept: {
            title: `Every character in a string has a numbered position (index). You can extract any part of a string using slicing.`,
            body: `The student can access individual characters and extract substrings using index and slice notation.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `name = "Shady Ahmed"

print(name[0])     # S   (first character)
print(name[6])     # A   (seventh character)
print(name[-1])    # d   (last character)
print(name[-5])    # A   (fifth from the end)`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Practise string indexing and slicing
full_name = "Python Coder"

# 1. Print the first character
print(full_name[0])

# 2. Print the last character
print(full_name[-1])

# 3. Print just "Python" using slicing
print(full_name[:6])

# 4. Print "Coder" using slicing
print(full_name[7:])

# 5. Print the full name reversed
print(full_name[::-1])

# Now try with your own name:
my_name = "Your Name Here"
# Extract just the first name (assuming you know where it ends):`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a variable containing any sentence (at least 10 characters)
2. Print the first 5 characters
3. Print the last 5 characters
4. Print every second character of the whole sentence
5. Print the sentence reversed — using only slicing, one line`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`"SPS Code Orbit"[4:8]\` return?`,
              code: ``,
              options: [{ id: "A", text: `"SPS "` }, { id: "B", text: `"Code"` }, { id: "C", text: `"Cod"` }, { id: "D", text: `" Cod"` }],
              correct: "B",
              explanation: `Indexing starts at 0. \`[4:8]\` means characters at positions 4, 5, 6, 7 — which are 'C', 'o', 'd', 'e'. Position 8 is not included. Count carefully: S(0) P(1) S(2) ' '(3) C(4) o(5) d(6) e(7).`
            },
          keyPoints: [`String indexes start at **0**, not 1`, `Negative indexes count from the end: \`-1\` is the last character`, `\`[start:stop]\` extracts characters — \`stop\` is **not** included`, `\`[::-1]\` reverses any string in one step`],
          youtube: `Python string slicing and indexing tutorial`
        },

        {
          id: "lesson-pyl2-1-2",
          slug: "lesson-pyl2-1-2",
          lesson_number: 2,
          title: `Powerful String Methods`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I got a string from the user: 'ahmed.ali@school.eg' I want to check that it actually looks like an email — has an @ sign, ends with .eg, that kind of thing. Do I have to write all that logic myself? Like what? All of those are built in?`,
            cody: `Nope. Python has string methods that do most of that in one line. .find() tells you if something is inside the string. .endswith() checks what it ends with. .split() breaks it into pieces at a separator. And about twenty more. Let's go through the most useful ones.`
          },
          concept: {
            title: `Python strings come with dozens of built-in methods for searching, replacing, splitting, and checking content.`,
            body: `The student uses \`.find()\`, \`.replace()\`, \`.split()\`, \`.join()\`, \`.startswith()\`, \`.endswith()\`, \`.count()\`, \`.isdigit()\`, \`.isalpha()\` correctly.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `text = "Welcome to SPS Code Orbit!"

# .find() — returns the index of the first match, or -1 if not found
print(text.find("SPS"))       # 11
print(text.find("Python"))    # -1 (not found)

# .count() — how many times does something appear?
print(text.count("o"))        # 3

# .startswith() / .endswith() — returns True or False
print(text.startswith("Welcome"))   # True
print(text.endswith("!"))           # True
print(text.endswith("."))           # False

# in operator — quickest way to check if something is inside
print("SPS" in text)    # True
print("Java" in text)   # False`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Email validator (simplified)
email = input("Enter your email: ")

has_at = "@" in email
has_dot = "." in email
parts = email.split("@")

print(f"Contains @: {has_at}")
print(f"Contains .: {has_dot}")

if has_at and len(parts) == 2:
    username = parts[0]
    domain = parts[1]
    print(f"Username: {username}")
    print(f"Domain: {domain}")
    print(f"Ends with .eg: {email.endswith('.eg')}")
else:
    print("That doesn't look like a valid email.")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Ask the user to enter a sentence
2. Count how many times the letter 'a' appears (case-insensitive — hint: use .lower() first)
3. Replace every space with an underscore and print the result
4. Split the sentence into words and print how many words it has
5. Check if the sentence ends with a '?' or '!'`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You run \`result = "Hello".replace("l", "r")\` then \`print("Hello")\`. What prints?`,
              code: ``,
              options: [{ id: "A", text: `"Herro"` }, { id: "B", text: `"Hello"` }, { id: "C", text: `Nothing — the replace modified in place` }, { id: "D", text: `SyntaxError` }],
              correct: "B",
              explanation: `String methods **never** modify the original string — strings are immutable. \`.replace()\` returns a **new** string. Since we printed \`"Hello"\` directly (not \`result\`), we see the unchanged original.`
            },
          keyPoints: [`\`.find()\` returns the index or \`-1\` — use \`in\` for simple presence checks`, `\`.replace()\`, \`.strip()\`, \`.split()\`, \`.join()\` all return **new** strings — the original is unchanged`, `\`.split()\` → list; \`.join()\` → string (they are opposites)`, `\`.isdigit()\` and \`.isalpha()\` are great for input validation`],
          youtube: `Python string methods tutorial beginners`
        },

        {
          id: "lesson-pyl2-1-3",
          slug: "lesson-pyl2-1-3",
          lesson_number: 3,
          title: `Multi-line Strings and Number Formatting`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I'm trying to print a receipt — items on the left, prices on the right, all lined up in columns. But my numbers keep jumping around. But f-strings just substitute variables, right? Can you show me with the receipt?`,
            cody: `That's a formatting problem. f-strings can fix it. That's what you've been using them for. But they can do much more — you can control how many decimal places, how wide the field is, and whether text is left or right-aligned. That's exactly the example we'll use.`
          },
          concept: {
            title: `Triple quotes create multi-line strings. f-strings can format numbers with precise control over decimal places and alignment.`,
            body: `The student writes multi-line strings and formats numbers using f-string format specifiers.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Triple quotes let you span multiple lines
message = """
Hello!
Welcome to SPS Code Orbit.
We hope you enjoy learning Python.
"""
print(message)

# Also useful for long SQL queries, HTML snippets, or long prompts`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Generate a formatted invoice
print("=" * 35)
print(f"{'SPS Code Orbit Store':^35}")
print("=" * 35)
print(f"{'Item':<20} {'Price':>10}")
print("-" * 35)

items = [
    ("Python Textbook", 150.00),
    ("USB Cable", 25.50),
    ("Notebook (pack)", 18.75),
    ("Pen Set", 12.00),
]

total = 0
for item_name, item_price in items:
    print(f"{item_name:<20} {item_price:>10.2f}")
    total += item_price

print("-" * 35)
print(f"{'TOTAL':<20} {total:>10.2f}")
print("=" * 35)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Build a student report card using formatted output:
1. A header: "==== Student Report Card ===="
2. Student name (left-aligned, padded to 20 chars) and grade (right-aligned)
3. Print scores for 4 subjects — each score with exactly 1 decimal place
4. Print the average with 2 decimal places
5. Use - * 30 as a separator line`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`f"{3.14159:.2f}"\` produce?`,
              code: ``,
              options: [{ id: "A", text: `"3.14159"` }, { id: "B", text: `"3.14"` }, { id: "C", text: `"3.1"` }, { id: "D", text: `"3.142"` }],
              correct: "B",
              explanation: `\`:.2f\` means "format as a float with exactly 2 decimal places". Python rounds the result, so 3.14159 becomes 3.14.`
            },
          keyPoints: [`Triple quotes \`"""..."""\` create multi-line strings`, `\`\\n\` = new line, \`\\t\` = tab inside regular strings`, `\`:.2f\` = 2 decimal places; \`:<10\` = left-align in 10-wide field; \`:>10\` = right-align`, `Use width formatting to align columns in tables and receipts`],
          youtube: `Python f-string formatting numbers alignment`
        },

        {
          id: "lesson-pyl2-1-4",
          slug: "lesson-pyl2-1-4",
          lesson_number: 4,
          title: `Mini Project — Text Analyser`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to build something useful with strings — not just print practice. Something real. That sounds like something that could actually be useful.`,
            cody: `How about a text analyser? You paste in any text, and it tells you: how long it is, how many words, the most common letter, whether it's mostly uppercase, and a cleaned-up version. It is. Grammar checkers, search engines, translation tools — they all start with exactly this kind of analysis.`
          },
          concept: {
            title: `Apply all string skills together to build a real utility.`,
            body: `The student builds a program that analyses any text and reports multiple statistics about it.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `def analyse_text(text):
    # ── Basic stats ──────────────────────────────
    char_count = len(text)
    char_no_spaces = len(text.replace(" ", ""))
    word_count = len(text.split())
    line_count = text.count("\\n") + 1

    # ── Case analysis ────────────────────────────
    upper_count = sum(1 for c in text if c.isupper())
    lower_count = sum(1 for c in text if c.islower())

    # ── Most common letter ───────────────────────
    letters = [c.lower() for c in text if c.isalpha()]
    most_common = max(set(letters), key=letters.count) if letters else "N/A"
    most_common_count = letters.count(most_common) if letters else 0

    # ── Cleaned version ──────────────────────────
    cleaned = " ".join(text.split())    # collapses multiple spaces

    # ── Report ───────────────────────────────────
    print("=" * 40)
    print(f"{'TEXT ANALYSIS REPORT':^40}")
    print("=" * 40)
    print(f"{'Characters (total)':<25} {char_count:>10}")
    print(f"{'Characters (no spaces)':<25} {char_no_spaces:>10}")
    print(f"{'Words':<25} {word_count:>10}")
    print(f"{'Lines':<25} {line_count:>10}")
    print(f"{'Uppercase letters':<25} {upper_count:>10}")
    print(f"{'Lowercase letters':<25} {lower_count:>10}")
    print(f"{'Most common letter':<25} {most_common!r:>10} (×{most_common_count})")
    print("-" * 40)
    print("Cleaned text:")
    print(cleaned[:100] + ("..." if len(cleaned) > 100 else ""))
    print("=" * 40)


# ── Main ─────────────────────────────────────────
print("=== Text Analyser ===")
print("Paste your text below, then press Enter twice:\\n")

lines = []
while True:
    line = input()
    if line == "":
        break
    lines.append(line)

user_text = "\\n".join(lines)

if user_text.strip():
    analyse_text(user_text)
else:
    print("No text entered.")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Simplified text analyser — extend it!
def analyse_text(text):
    print(f"Characters: {len(text)}")
    print(f"Words: {len(text.split())}")
    print(f"Uppercase version: {text.upper()}")
    print(f"Reversed: {text[::-1]}")

    # TODO: Add — count vowels (a, e, i, o, u)
    # TODO: Add — print the most common word
    # TODO: Add — check if it contains any digits

text = input("Enter a sentence: ")
analyse_text(text)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Extend the starter code above to also:
1. Count and print the number of vowels (a, e, i, o, u — case-insensitive)
2. Print the sentence with all spaces replaced by hyphens
3. Print each unique word on its own line (no duplicates, sorted A-Z)
   Hint: convert to a list of words, then use set() and sorted()`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `A student writes \`words = sentence.split()\` then \`print(len(words))\`. What does this print?`,
              code: ``,
              options: [{ id: "A", text: `The number of characters in the sentence` }, { id: "B", text: `The number of words in the sentence` }, { id: "C", text: `The number of unique words` }, { id: "D", text: `Always 1` }],
              correct: "B",
              explanation: `\`.split()\` without arguments splits on spaces and returns a list of words. \`len()\` of that list gives the number of words.`
            },
          keyPoints: [`String methods chain beautifully: \`text.lower().strip().split()\``, `A list comprehension like \`[c for c in text if c.isalpha()]\` filters characters efficiently`, `Real tools (spell checkers, search engines) use exactly these operations at scale`],
          youtube: `Python text analysis string project beginners`
        },

      ]
    },

    {
      id: "chap-pyl2-02",
      slug: "dictionaries",
      chapter_number: 2,
      title: `Key-Value Storage — Dictionaries`,
      description: `Dictionaries are one of Python's most important structures. They store data as key-value pairs for fast, named lookup.`,
      icon_symbol: "📚",
      lessons_overview: ["1 What Is a Dictionary?", "2 Dictionary Methods", "3 Looping Through Dictionaries", "4 Mini Project — Student Grade Book"],
      lessons: [

        {
          id: "lesson-pyl2-2-1",
          slug: "lesson-pyl2-2-1",
          lesson_number: 1,
          title: `What Is a Dictionary?`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to store a student's name, grade, and score together. I used a list but it's messy — list[0] for name, list[1] for grade... I keep forgetting which index means what. Like a word dictionary? So I give each piece of data a name instead of a number?`,
            cody: `That's because a list isn't the right tool here. You want a dictionary. Same idea! You look up a word — that's the key — and you get its definition — that's the value. You look up 'score' and get 95. You look up 'name' and get 'Ahmed'. No index numbers to remember. Exactly. That's a dictionary.`
          },
          concept: {
            title: `A dictionary maps unique keys to values — like a contacts list where every name points to a phone number.`,
            body: `The student creates dictionaries, accesses values by key, adds new entries, and updates existing ones.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Curly braces, key: value pairs, separated by commas
student = {
    "name": "Ahmed",
    "grade": 10,
    "score": 95,
    "city": "Cairo"
}

print(student)
# {'name': 'Ahmed', 'grade': 10, 'score': 95, 'city': 'Cairo'}`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Student profile using a dictionary
student = {
    "name": "Shady",
    "school": "Salam Prep",
    "grade": 10,
    "favourite_subject": "Python"
}

# Print each value
print(f"Name: {student['name']}")
print(f"School: {student['school']}")

# TODO: Add "score" key with value 88
# TODO: Update "grade" to 11
# TODO: Print the number of keys in the dictionary
# TODO: Check if "email" is in the dictionary (should print False)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a dictionary representing a book: title, author, year, pages, available (True/False)
2. Print a nicely formatted "book card" using f-strings
3. Update the 'available' key to False (simulate checking it out)
4. Add a 'borrower' key with your name
5. Delete the 'pages' key
6. Print the final dictionary`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What happens when you run \`d = {"x": 1}\` then \`print(d["y"])\`?`,
              code: ``,
              options: [{ id: "A", text: `Prints \`None\`` }, { id: "B", text: `Prints \`0\`` }, { id: "C", text: `Raises a \`KeyError\`` }, { id: "D", text: `Prints \`"y"\`` }],
              correct: "C",
              explanation: `Accessing a key that doesn't exist in a dictionary raises a \`KeyError\`. The dictionary only has \`"x"\` — \`"y"\` was never added. Use \`.get()\` (next lesson) to avoid this crash.`
            },
          keyPoints: [`Dictionary = \`{key: value}\` — keys are unique, values can be anything`, `Access with \`dict["key"]\` — crashes with \`KeyError\` if key doesn't exist`, `Add with \`dict["new_key"] = value\` — update works the same way`, `\`"key" in dict\` safely checks whether a key exists`],
          youtube: `Python dictionaries beginners tutorial`
        },

        {
          id: "lesson-pyl2-2-2",
          slug: "lesson-pyl2-2-2",
          lesson_number: 2,
          title: `Dictionary Methods`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `My program crashed with KeyError again! I looked up a student who wasn't in the dictionary. What does 'safe' mean here? Doctors have a rule: first, do no harm. Seems like .get() is Python's version of that.`,
            cody: `That's why .get() exists. It's the safe version of dict[key]. Instead of crashing when the key doesn't exist, .get() just returns None — or a default you choose. Your program keeps running. Ha — not bad. And there are a few more methods that follow the same spirit.`
          },
          concept: {
            title: `Python dictionaries have built-in methods that make working with them safer and more efficient.`,
            body: `The student uses \`.get()\`, \`.keys()\`, \`.values()\`, \`.items()\`, \`.pop()\`, and \`.update()\` correctly.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `student = {"name": "Ahmed", "score": 95}

# ❌ Risky:
print(student["email"])    # KeyError — crashes!

# ✅ Safe:
print(student.get("email"))            # None  (no crash)
print(student.get("email", "N/A"))     # N/A   (custom default)
print(student.get("score", 0))         # 95    (key exists — returns the value)`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Student lookup system
database = {
    "S001": {"name": "Ahmed", "score": 95},
    "S002": {"name": "Sara", "score": 88},
    "S003": {"name": "Omar", "score": 72},
}

student_id = input("Enter student ID (e.g. S001): ")

# TODO: Use .get() to safely look up the student
# If found: print their name and score
# If not found: print "Student not found"

# Hint:
result = database.get(student_id)
if result:
    print(f"Name: {result.get('name', 'Unknown')}")
    print(f"Score: {result.get('score', 'N/A')}")
else:
    print("Student not found.")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a dictionary of 5 countries and their capitals
2. Use .get() to look up a capital — test with a country that IS in the dict and one that ISN'T
3. Use .keys() to print all countries in the dictionary
4. Use .values() to find and print the capital that comes last alphabetically
   Hint: sorted(dict.values())[-1]
5. Use .pop() to remove one country — print the removed capital`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `\`scores = {"Ali": 80}\`. What does \`scores.get("Sara", 0)\` return?`,
              code: ``,
              options: [{ id: "A", text: `\`KeyError\`` }, { id: "B", text: `\`None\`` }, { id: "C", text: `\`0\`` }, { id: "D", text: `\`"Sara"\`` }],
              correct: "C",
              explanation: `\`.get("Sara", 0)\` looks for key \`"Sara"\`. It doesn't exist, so instead of crashing, it returns the default value \`0\` that we provided as the second argument.`
            },
          keyPoints: [`\`.get(key, default)\` — safe lookup that never crashes`, `\`.keys()\`, \`.values()\`, \`.items()\` — views of the dictionary's contents`, `\`.pop(key)\` — removes a key and returns its value`, `\`.update(other_dict)\` — merges another dict in, overwriting existing keys`],
          youtube: `Python dictionary methods get pop update tutorial`
        },

        {
          id: "lesson-pyl2-2-3",
          slug: "lesson-pyl2-2-3",
          lesson_number: 3,
          title: `Looping Through Dictionaries`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I have a dictionary of 30 students and their grades. Do I have to write 30 print statements to show them all? But I know how to loop through a list. A dictionary isn't a list... Both at once — how?`,
            cody: `Of course not — that's what loops are for. You can loop through a dictionary too. In fact, there are three useful ways — through the keys, through the values, or through both at once. With .items() — it gives you the key and value together, every iteration. Let me show you.`
          },
          concept: {
            title: `You can loop through a dictionary's keys, values, or key-value pairs to process all entries automatically.`,
            body: `The student loops through a dictionary using \`.keys()\`, \`.values()\`, and \`.items()\`, and builds a formatted class report.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `grades = {"Ahmed": 95, "Sara": 88, "Omar": 72, "Nour": 91}

for student in grades:           # iterates over keys
    print(student)

# Ahmed
# Sara
# Omar
# Nour`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Inventory price checker
inventory = {
    "Notebook": 15.00,
    "Pen":       3.50,
    "Ruler":     8.00,
    "Eraser":    2.00,
    "Calculator": 75.00
}

print("All items in stock:")
for item, price in inventory.items():
    print(f"  {item:<15} {price:>8.2f} EGP")

# TODO: Print the most expensive item (hint: use max() with .items())
# TODO: Count how many items cost less than 10 EGP
# TODO: Calculate and print the total value of all inventory`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a dictionary: {'math': 85, 'english': 90, 'science': 78, 'arabic': 88}
2. Loop through it and print each subject + score on one line, formatted
3. Calculate the average of all scores using a loop
4. Find and print which subject has the highest score
   Hint: max(grades, key=grades.get)  returns the key with the max value
5. Print only the subjects where the student scored above 85`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`for key, value in my_dict.items():\` do?`,
              code: ``,
              options: [{ id: "A", text: `Loops through only the keys` }, { id: "B", text: `Loops through only the values` }, { id: "C", text: `Loops through each key-value pair together` }, { id: "D", text: `Raises a SyntaxError — you can't unpack two variables in a for loop` }],
              correct: "C",
              explanation: `\`.items()\` returns pairs like \`("Ahmed", 95)\`. Python automatically unpacks each pair into \`key\` and \`value\`. This is the standard way to loop through a dictionary when you need both.`
            },
          keyPoints: [`\`for key in dict:\` loops through keys only`, `\`for val in dict.values():\` loops through values only`, `\`for key, val in dict.items():\` loops through both — most useful pattern`, `\`max(dict, key=dict.get)\` finds the key with the highest value`],
          youtube: `Python loop through dictionary items tutorial`
        },

        {
          id: "lesson-pyl2-2-4",
          slug: "lesson-pyl2-2-4",
          lesson_number: 4,
          title: `Mini Project — Student Grade Book`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to build something teachers could actually use — add students, look them up, update grades, print a report. Sounds like a real program.`,
            cody: `Let's build it. A dictionary of student names mapping to their scores. Four operations: add, lookup, update, report. It is. Most real-world programs are a loop around a menu that calls functions. You've got everything you need.`
          },
          concept: {
            title: `Apply dictionary skills to build an interactive grade book that stores, retrieves, and reports student grades.`,
            body: `The student builds a multi-function grade book using a dictionary, demonstrating all Chapter 2 skills.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `def add_student(grade_book, name, score):
    if name in grade_book:
        print(f"  ⚠ '{name}' already exists. Use 'update' to change their score.")
    else:
        grade_book[name] = score
        print(f"  ✔ {name} added with score {score}.")

def lookup_student(grade_book, name):
    score = grade_book.get(name)
    if score is not None:
        status = "Pass" if score >= 50 else "Fail"
        print(f"  {name}: {score}/100 — {status}")
    else:
        print(f"  '{name}' not found in grade book.")

def update_student(grade_book, name, new_score):
    if name in grade_book:
        old = grade_book[name]
        grade_book[name] = new_score
        print(f"  ✔ {name}: {old} → {new_score}")
    else:
        print(f"  '{name}' not found. Use 'add' to create them.")

def print_report(grade_book):
    if not grade_book:
        print("  Grade book is empty.")
        return
    print("\\n" + "=" * 35)
    print(f"{'GRADE BOOK REPORT':^35}")
    print("=" * 35)
    print(f"  {'Name':<18} {'Score':>5} {'Result':>8}")
    print("  " + "-" * 33)
    total = 0
    passed = 0
    for name, score in sorted(grade_book.items(), key=lambda x: x[1], reverse=True):
        result = "Pass" if score >= 50 else "Fail"
        if score >= 50:
            passed += 1
        print(f"  {name:<18} {score:>5} {result:>8}")
        total += score
    average = total / len(grade_book)
    print("  " + "-" * 33)
    print(f"  Students: {len(grade_book)}   "
          f"Passed: {passed}   "
          f"Average: {average:.1f}")
    print("=" * 35)

# ── Main menu ─────────────────────────────────────
grade_book = {}

menu = """
Grade Book — Choose an action:
  1. Add student
  2. Look up student
  3. Update score
  4. Print report
  5. Exit
"""

while True:
    print(menu)
    choice = input("Your choice (1-5): ").strip()

    if choice == "1":
        name  = input("  Student name: ").strip()
        score = int(input("  Score (0-100): "))
        add_student(grade_book, name, score)

    elif choice == "2":
        name = input("  Student name: ").strip()
        lookup_student(grade_book, name)

    elif choice == "3":
        name  = input("  Student name: ").strip()
        score = int(input("  New score: "))
        update_student(grade_book, name, score)

    elif choice == "4":
        print_report(grade_book)

    elif choice == "5":
        print("Goodbye!")
        break

    else:
        print("  Invalid choice — please enter 1 to 5.")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Simplified starter — extend it yourself
grade_book = {}

def add_student(name, score):
    grade_book[name] = score
    print(f"Added: {name} — {score}")

def print_all():
    for name, score in grade_book.items():
        print(f"{name}: {score}")

# Add some students
add_student("Ahmed", 95)
add_student("Sara", 88)
add_student("Omar", 72)

print_all()

# TODO: Write a function find_top_student() that returns the name with the highest score
# TODO: Write a function class_average() that returns the mean score`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Extend the grade book so that:
1. Each student stores a LIST of scores (for multiple subjects), not just one score
   e.g.  {"Ahmed": [95, 88, 72]}
2. The lookup shows each score and the student's average
3. The report shows overall class average (average of all students' averages)`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `In the grade book program, why is \`grade_book.get(name)\` better than \`grade_book[name]\` for the lookup function?`,
              code: ``,
              options: [{ id: "A", text: `\`.get()\` is faster for large dictionaries` }, { id: "B", text: `\`.get()\` returns \`None\` instead of crashing when the name doesn't exist` }, { id: "C", text: `\`dict[key]\` only works with integer keys` }, { id: "D", text: `There is no difference` }],
              correct: "B",
              explanation: `If a teacher searches for a student not in the grade book, \`dict[key]\` would raise a \`KeyError\` and crash the program. \`.get()\` safely returns \`None\`, allowing us to print a friendly "not found" message instead.`
            },
          keyPoints: [`Real programs = a loop + a menu + functions — dictionaries hold the data`, `Always use \`.get()\` in lookup functions — never assume a key exists`, `\`sorted(dict.items(), key=lambda x: x[1], reverse=True)\` sorts by value, descending`, `\`if not dict:\` cleanly checks if a dictionary is empty`],
          youtube: `Python dictionary project grade book tutorial`
        },

      ]
    },

    {
      id: "chap-pyl2-03",
      slug: "tuples-and-sets",
      chapter_number: 3,
      title: `Tuples and Sets`,
      description: `Two more collection types with specific strengths. Tuples for fixed data, sets for unique collections.`,
      icon_symbol: "🔢",
      lessons_overview: ["1 Tuples — Immutable Sequences", "2 Sets — Collections of Unique Values", "3 Choosing the Right Data Structure", "4 Mini Project — Attendance and Roster System"],
      lessons: [

        {
          id: "lesson-pyl2-3-1",
          slug: "lesson-pyl2-3-1",
          lesson_number: 1,
          title: `Tuples — Immutable Sequences`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I'm storing GPS coordinates — latitude and longitude. I used a list but someone on my team accidentally changed the values. So it's a list... but read-only? What other data should never change?`,
            cody: `That's exactly the problem tuples solve. A tuple is like a list with a lock on it — once you create it, nobody can change it. That's a good way to think about it. The immutability isn't a limitation — it's a guarantee. It says: this data represents a fixed point. Don't touch it. RGB colours, days of the week, country codes, the options in a dropdown — anything that is fixed by definition.`
          },
          concept: {
            title: `A tuple is like a list that cannot be changed after creation. Use it for data that must stay fixed.`,
            body: `The student creates tuples, accesses elements, unpacks them, and understands why immutability is a feature.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Round brackets (or no brackets at all)
coordinates = (30.0444, 31.2357)    # Cairo lat/long
rgb_red = (255, 0, 0)
days = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

# Single-element tuple — needs a trailing comma!
single = (42,)         # ✅ tuple
not_tuple = (42)       # ❌ this is just the integer 42`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Coordinate tracker using tuples
locations = [
    ("Cairo", 30.0444, 31.2357),
    ("Alexandria", 31.2001, 29.9187),
    ("Assiut", 27.1783, 31.1859),
    ("Luxor", 25.6872, 32.6396)
]

print(f"{'City':<15} {'Latitude':>10} {'Longitude':>10}")
print("-" * 37)

for city, lat, lon in locations:
    print(f"{city:<15} {lat:>10.4f} {lon:>10.4f}")

# TODO: Add one more Egyptian city with its coordinates
# TODO: Find and print the city with the highest latitude (furthest north)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a tuple representing a student: (name, grade, score)
2. Unpack it into three separate variables using one line
3. Print a formatted sentence using the three variables
4. Try to change the score — observe the error
5. Create a list of 3 such student tuples, loop through it, and print each one formatted`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What is the output of \`a, b = (5, 10)\` then \`a, b = b, a\` then \`print(a, b)\`?`,
              code: ``,
              options: [{ id: "A", text: `\`5 10\`` }, { id: "B", text: `\`10 10\`` }, { id: "C", text: `\`10 5\`` }, { id: "D", text: `\`SyntaxError\`` }],
              correct: "C",
              explanation: `\`a, b = (5, 10)\` gives a=5, b=10. Then \`a, b = b, a\` swaps them — Python evaluates the right side first (10, 5) then assigns, giving a=10, b=5.`
            },
          keyPoints: [`Tuple = \`(a, b, c)\` — looks like a list but cannot be changed`, `Use tuples for fixed data: coordinates, RGB, config values, days of the week`, `\`x, y = (1, 2)\` unpacks a tuple into variables — clean and readable`, `A single-element tuple needs a trailing comma: \`(42,)\``],
          youtube: `Python tuples tutorial beginners`
        },

        {
          id: "lesson-pyl2-3-2",
          slug: "lesson-pyl2-3-2",
          lesson_number: 2,
          title: `Sets — Collections of Unique Values`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I have a list of students who attended Monday's class and another list for Tuesday. I want to know who attended both days. Set? Like a math set? And Python can do all of that?`,
            cody: `That's a classic set intersection problem. Exactly — same idea. Union: everyone who attended either day. Intersection: only those who came both days. Difference: who came Monday but skipped Tuesday. In one symbol each. Let me show you.`
          },
          concept: {
            title: `A set stores only unique values — duplicates are automatically removed. Great for membership checks and set operations.`,
            body: `The student creates sets, adds/removes elements, and uses union, intersection, and difference.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Sets use curly braces — but without key:value pairs
fruits = {"apple", "banana", "mango", "apple", "banana"}
print(fruits)   # {'apple', 'banana', 'mango'}  — duplicates removed!

# IMPORTANT: {} alone creates an empty DICT, not a set
empty_set = set()    # ✅ correct
empty_dict = {}      # ✅ this is a dict, not a set`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Attendance tracker
class_a = {"Ahmed", "Sara", "Omar", "Nour", "Ali"}
class_b = {"Sara", "Nour", "Maya", "Karim", "Ahmed"}

print("Class A:", class_a)
print("Class B:", class_b)
print()

# Students in both classes
print("In both:", class_a & class_b)

# All unique students across both classes
print("Total unique students:", class_a | class_b)

# In A but not B
print("Only in Class A:", class_a - class_b)

# TODO: Find students in exactly one class (not both)
# TODO: Print the total count of unique students across both classes
# TODO: Add "Layla" to class_a, then check if she's in class_b`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Given: list1 = [1, 2, 3, 2, 1, 4, 5, 4]
          list2 = [3, 4, 6, 7, 3]
2. Convert both to sets
3. Find numbers that appear in BOTH lists
4. Find numbers that appear in list1 but NOT list2
5. Find all unique numbers across both lists combined
6. Print each result with a label`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `\`s = {1, 2, 3}\`. What does \`s.discard(10)\` do?`,
              code: ``,
              options: [{ id: "A", text: `Raises a \`KeyError\`` }, { id: "B", text: `Raises a \`ValueError\`` }, { id: "C", text: `Does nothing — no error` }, { id: "D", text: `Adds 10 to the set` }],
              correct: "C",
              explanation: `\`.discard()\` is the "safe" remove — if the element doesn't exist, it quietly does nothing. Use \`.remove()\` if you want an error when the element is missing (so you know something went wrong).`
            },
          keyPoints: [`Set = \`{a, b, c}\` — no duplicates, no guaranteed order`, `Empty set = \`set()\` — NOT \`{}\` (that creates an empty dict)`, `\`|\` union, \`&\` intersection, \`-\` difference, \`^\` symmetric difference`, `Use sets to deduplicate a list: \`list(set(my_list))\``],
          youtube: `Python sets tutorial beginners`
        },

        {
          id: "lesson-pyl2-3-3",
          slug: "lesson-pyl2-3-3",
          lesson_number: 3,
          title: `Choosing the Right Data Structure`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `Now I know four different structures. When do I use which? They all seem to store data. Those four questions pick the structure?`,
            cody: `Ask yourself four questions: Does order matter? Will the data change? Do duplicates matter? Do I need to look things up by name? Pretty much. Let me map them out.`
          },
          concept: {
            title: `Lists, tuples, sets, and dictionaries each have a specific strength. Choosing the right one makes code cleaner and faster.`,
            body: `Given a scenario, the student selects the most appropriate data structure and explains why.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# ✅ List — ordered, changeable, duplicates fine
daily_temperatures = [29, 31, 28, 33, 30, 29]

# ✅ Tuple — fixed, coordinates shouldn't change
cairo_location = (30.0444, 31.2357)

# ✅ Set — unique usernames, fast membership check
registered_users = {"ahmed", "sara", "omar"}

# ✅ Dictionary — look up data by a name/key
student_profiles = {
    "S001": {"name": "Ahmed", "score": 95},
    "S002": {"name": "Sara",  "score": 88}
}`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Scenario: A quiz leaderboard system
# - Scores can change (player improves) → dict or list
# - Players are unique → dict keyed by name
# - Order of scores matters (rank) → sorted list when displaying

leaderboard = {}   # name → best_score

def record_score(name, score):
    current_best = leaderboard.get(name, 0)
    if score > current_best:
        leaderboard[name] = score
        print(f"  New best for {name}: {score}")
    else:
        print(f"  {name}'s current best ({current_best}) is still higher.")

record_score("Ahmed", 85)
record_score("Sara", 92)
record_score("Ahmed", 78)    # lower — won't update
record_score("Ahmed", 90)    # higher — updates

# Print ranked leaderboard
print("\\n=== Leaderboard ===")
ranked = sorted(leaderboard.items(), key=lambda x: x[1], reverse=True)
for rank, (name, score) in enumerate(ranked, 1):
    print(f"  #{rank}  {name:<15} {score}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `For each scenario below, choose the best data structure and write 3 lines of code using it:
1. Store the months of the year (fixed, ordered)
2. Track which students have submitted their assignment (unique, fast check)
3. Store each student's name → their list of test scores
4. Keep a log of website visits (ordered, duplicates expected)`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You need to store 1000 allowed email domains and check very quickly whether a domain is allowed. Which structure is best?`,
              code: ``,
              options: [{ id: "A", text: `List — because it's ordered` }, { id: "B", text: `Tuple — because the domains are fixed` }, { id: "C", text: `Set  — because \`in\` on a set is near-instant, even with millions of items` }, { id: "D", text: `Dictionary — because you need key-value pairs` }],
              correct: "C",
              explanation: `Set membership (\`x in set\`) is O(1) — near-instant regardless of size. \`x in list\` checks every item one by one — O(n). For fast membership testing with no duplicates, set is the right choice.`
            },
          keyPoints: [`**List** → ordered, changeable, duplicates OK`, `**Tuple** → fixed (immutable), great for coordinates, colours, config`, `**Set** → unique values, O(1) membership check, set math`, `**Dictionary** → key-value lookup by name`],
          youtube: `Python list tuple set dictionary when to use`
        },

        {
          id: "lesson-pyl2-3-4",
          slug: "lesson-pyl2-3-4",
          lesson_number: 4,
          title: `Mini Project — Attendance and Roster System`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `Can we make something where sets and dictionaries actually work together? I want to see them both doing real work. That's actually something my school needs.`,
            cody: `How about an attendance system? A dictionary holds all students — the full roster. Each day's attendance is a set — automatically no duplicates. At the end of the week, we do set operations to find perfect attendance, frequent absences, that kind of thing. Most useful programs start that way.`
          },
          concept: {
            title: `Use sets and dictionaries together to build a real attendance tracking system.`,
            body: `The student builds a multi-day attendance system using sets for per-day attendance and a dictionary for the full roster.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Full roster (dictionary: ID → name)
roster = {
    "S01": "Ahmed", "S02": "Sara",  "S03": "Omar",
    "S04": "Nour",  "S05": "Ali",   "S06": "Maya",
    "S07": "Karim", "S08": "Layla"
}

# Daily attendance sets (who was present each day)
sunday    = {"S01", "S02", "S03", "S04", "S05"}
monday    = {"S01", "S02", "S04", "S06", "S07"}
tuesday   = {"S02", "S03", "S04", "S05", "S08"}
wednesday = {"S01", "S02", "S04", "S05", "S06"}
thursday  = {"S01", "S02", "S03", "S04", "S05", "S07"}

all_days = [sunday, monday, tuesday, wednesday, thursday]
all_ids  = set(roster.keys())

def name(sid):
    return roster.get(sid, sid)

# Perfect attendance — present ALL 5 days
perfect = sunday & monday & tuesday & wednesday & thursday
print("Perfect attendance:")
for sid in perfect:
    print(f"  {name(sid)}")

# Never attended — absent all 5 days
never_came = all_ids - (sunday | monday | tuesday | wednesday | thursday)
print("\\nNever attended:")
for sid in never_came:
    print(f"  {name(sid)}")

# Attendance count per student
print("\\nAttendance summary:")
print(f"  {'Name':<12} {'Days':>5}")
print("  " + "-" * 18)
for sid in sorted(roster):
    count = sum(1 for day in all_days if sid in day)
    bar = "▓" * count + "░" * (5 - count)
    print(f"  {name(sid):<12} {count:>2}/5  {bar}")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `roster = {"S01": "Ahmed", "S02": "Sara", "S03": "Omar", "S04": "Nour"}

# Record today's attendance interactively
print("Mark attendance (enter student IDs, empty line to finish):")
today_present = set()
while True:
    sid = input("ID: ").strip().upper()
    if not sid:
        break
    if sid in roster:
        today_present.add(sid)
        print(f"  ✔ {roster[sid]} marked present")
    else:
        print(f"  ✘ ID '{sid}' not in roster")

# Who was absent?
today_absent = set(roster.keys()) - today_present

print(f"\\nPresent ({len(today_present)}):", ", ".join(roster[s] for s in today_present))
print(f"Absent  ({len(today_absent)}):",  ", ".join(roster[s] for s in today_absent))`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Extend the system so it also:
1. Asks for a second day's attendance
2. Prints who attended BOTH days
3. Prints who attended EITHER day (or both)
4. Prints who attended day 1 but was absent day 2`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `In the attendance system, why is each day's attendance stored as a \`set\` rather than a \`list\`?`,
              code: ``,
              options: [{ id: "A", text: `Sets are faster to create than lists` }, { id: "B", text: `Sets prevent a student being marked present twice, and set operations (& | -) work directly` }, { id: "C", text: `Sets are easier to print` }, { id: "D", text: `Lists can't store strings` }],
              correct: "B",
              explanation: `Sets guarantee uniqueness (can't accidentally mark someone twice) and enable clean set math: \`day1 & day2\` for who attended both, \`day1 | day2\` for either, \`all_ids - day1\` for absences — no loops needed.`
            },
          keyPoints: [`Combining structures is normal — dict of sets, list of tuples, etc.`, `Set operations replace many loops: \`&\`, \`|\`, \`-\` in one symbol each`, `\`sum(1 for x in items if condition)\` counts matching items without storing them`],
          youtube: `Python sets operations practical project`
        },

      ]
    },

    {
      id: "chap-pyl2-04",
      slug: "file-io",
      chapter_number: 4,
      title: `Working with Files — File I/O`,
      description: `Real programs save data permanently. Students learn to read and write text files.`,
      icon_symbol: "📂",
      lessons_overview: ["1 Reading Files", "2 Writing and Appending to Files", "3 Reading Structured Data from Files", "4 Mini Project — Persistent Score Tracker"],
      lessons: [

        {
          id: "lesson-pyl2-4-1",
          slug: "lesson-pyl2-4-1",
          lesson_number: 1,
          title: `Reading Files`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `My program asks users for student names every time it starts. They have to re-type everything. It's so annoying. But how does Python read a file? Why always 'with'?`,
            cody: `You need to save them to a file. Then on the next run, read the file and load them automatically. With the open() function. You give it a filename and a mode — 'r' for read, 'w' for write. And you always use the 'with' keyword to open files. Because 'with' automatically closes the file when you're done — even if something goes wrong. Without it, files can get corrupted.`
          },
          concept: {
            title: `Python can open and read text files. The \`with\` statement ensures files are always properly closed.`,
            body: `The student reads a file's contents using \`.read()\` and \`.readlines()\`, and understands why \`with\` is important.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Assume "students.txt" contains:
# Ahmed
# Sara
# Omar

# .read() — reads the ENTIRE file as one string
with open("students.txt", "r") as f:
    content = f.read()
print(content)
# Ahmed
# Sara
# Omar

# .readlines() — reads into a LIST, one item per line
with open("students.txt", "r") as f:
    lines = f.readlines()
print(lines)
# ['Ahmed\\n', 'Sara\\n', 'Omar\\n']   ← note the \\n at the end of each!

# Clean: strip the \\n from each line
with open("students.txt", "r") as f:
    lines = [line.strip() for line in f.readlines()]
print(lines)
# ['Ahmed', 'Sara', 'Omar']`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# First, let's create a sample file to read:
import os

# Create a sample file
with open("sample.txt", "w") as f:
    f.write("Line one\\nLine two\\nLine three\\nLine four\\n")

print("File created.\\n")

# Now read it back:
print("=== Using .read() ===")
with open("sample.txt", "r") as f:
    everything = f.read()
print(everything)

print("=== Using .readlines() ===")
with open("sample.txt", "r") as f:
    lines = f.readlines()
for i, line in enumerate(lines, 1):
    print(f"Line {i}: {line.strip()!r}")

# TODO: Count how many lines the file has
# TODO: Print only lines that contain the letter 'o'`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a file called "my_data.txt" with 5 lines — each line is a fruit name
   (you can write this file manually or use Python to create it — see the playground)
2. Read the file and print each fruit with its line number: "1. Apple"
3. Count how many fruits start with a vowel
4. Print the fruits in alphabetical order (read into a list, sort, then print)`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `Why should you always use \`with open(...) as f:\` instead of just \`f = open(...)\`?`,
              code: ``,
              options: [{ id: "A", text: `\`with\` is faster than \`open()\`` }, { id: "B", text: `\`with\` automatically closes the file when the block ends — even if an error occurs` }, { id: "C", text: `\`open()\` only works inside \`with\` blocks` }, { id: "D", text: `\`with\` can read multiple files at once` }],
              correct: "B",
              explanation: `The \`with\` statement is a context manager. It guarantees the file is closed when the block exits — whether it exits normally or with an exception. Unclosed files can cause data loss or corruption.`
            },
          keyPoints: [`\`with open("file.txt", "r") as f:\` — always use \`with\``, `\`.read()\` → one big string; \`.readlines()\` → list of lines (with \`\\n\`)`, `\`.strip()\` removes the \`\\n\` at the end of each line`, `\`FileNotFoundError\` — handle it, don't let it crash your program`],
          youtube: `Python read file open with statement tutorial`
        },

        {
          id: "lesson-pyl2-4-2",
          slug: "lesson-pyl2-4-2",
          lesson_number: 2,
          title: `Writing and Appending to Files`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I built a score tracker! But every time I restart the program, all the scores disappear. How? And if I run the program again with 'w' — do my old scores survive? So I should use 'a' for the score tracker.`,
            cody: `Because they're only in memory — RAM clears when the program ends. You need to write them to a file. Change the mode from 'r' to 'w'. 'w' means write. No. That's the most dangerous thing about 'w' mode. It ERASES the file and starts fresh every time. If you want to ADD to existing content, use 'a' for append. Exactly. 'a' adds to the end without touching what's already there.`
          },
          concept: {
            title: `Mode \`"w"\` creates or overwrites a file. Mode \`"a"\` adds to the end without erasing existing content.`,
            body: `The student writes data to files and appends new data correctly, understanding the difference between \`"w"\` and \`"a"\`.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Creates "scores.txt" if it doesn't exist
# ⚠ OVERWRITES it completely if it does exist!
with open("scores.txt", "w") as f:
    f.write("Ahmed: 95\\n")
    f.write("Sara: 88\\n")
    f.write("Omar: 72\\n")

# Each .write() call needs \\n if you want a new line — it's not added automatically`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Persistent session log — every time you run this, it adds to the log
import datetime

LOG_FILE = "session_log.txt"

timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

with open(LOG_FILE, "a") as f:
    f.write(f"[{timestamp}] Session started\\n")

name = input("Your name: ")

with open(LOG_FILE, "a") as f:
    f.write(f"[{timestamp}] User: {name}\\n")
    f.write(f"[{timestamp}] Session ended\\n\\n")

# Read and display the full log
print("\\n=== Full Log ===")
with open(LOG_FILE, "r") as f:
    print(f.read())`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a "diary.txt" file
2. Ask the user to enter today's note (one line of text)
3. Append it to the file with today's date as a label
   Format: "2024-03-15: I learned about file writing today."
4. After appending, read the full file and print all entries
5. Run the program 3 times — verify that entries accumulate, not overwrite`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You open a file with \`"w"\` mode that already has 500 lines of important data. What happens?`,
              code: ``,
              options: [{ id: "A", text: `Python appends to the end of the existing data` }, { id: "B", text: `Python raises a FileExistsError` }, { id: "C", text: `The existing 500 lines are permanently erased, and the file starts empty` }, { id: "D", text: `Python asks you to confirm before overwriting` }],
              correct: "C",
              explanation: `Mode \`"w"\` immediately truncates (empties) the file before writing. There is no warning and no undo. Always use \`"a"\` when you want to preserve existing content.`
            },
          keyPoints: [`\`"w"\` mode → **erases** the file and starts fresh (dangerous!)`, `\`"a"\` mode → appends to the end, existing content is safe`, `\`.write()\` does NOT add a newline automatically — you must write \`"\\n"\` yourself`, `Load on start, save on exit = the standard pattern for persistent data`],
          youtube: `Python write append file tutorial`
        },

        {
          id: "lesson-pyl2-4-3",
          slug: "lesson-pyl2-4-3",
          lesson_number: 3,
          title: `Reading Structured Data from Files`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to save my grade book to a file — not just names, but names AND scores together. Like a spreadsheet?`,
            cody: `You store structured data — multiple fields per record. A common way is CSV: Comma-Separated Values. Each line is one record. Commas separate the fields. Exactly like a spreadsheet, but in plain text. Python has a csv module for this properly, but let's start by doing it manually — so you understand what's happening.`
          },
          concept: {
            title: `Files can store structured records (like CSV) that you parse back into usable data structures.`,
            body: `The student writes structured records to a file and reads them back into a list of dictionaries.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `students = [
    {"name": "Ahmed", "grade": 10, "score": 95},
    {"name": "Sara",  "grade": 11, "score": 88},
    {"name": "Omar",  "grade": 10, "score": 72},
]

with open("students.csv", "w") as f:
    # Write header line first
    f.write("name,grade,score\\n")
    for s in students:
        f.write(f"{s['name']},{s['grade']},{s['score']}\\n")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `import csv

FILENAME = "gradebook.csv"

def save_students(students):
    with open(FILENAME, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["name", "score"])
        writer.writeheader()
        writer.writerows(students)
    print(f"Saved {len(students)} students to {FILENAME}")

def load_students():
    students = []
    try:
        with open(FILENAME, "r") as f:
            reader = csv.DictReader(f)
            for row in reader:
                row["score"] = int(row["score"])
                students.append(row)
    except FileNotFoundError:
        print("No saved file found.")
    return students

# Test it:
data = [
    {"name": "Ahmed", "score": 95},
    {"name": "Sara",  "score": 88},
]
save_students(data)
loaded = load_students()
for s in loaded:
    print(f"{s['name']}: {s['score']}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a file "inventory.csv" with columns: item, quantity, price
2. Add 5 products manually (write them line by line)
3. Read the file back and calculate:
   a. The total value of all inventory (sum of quantity × price for each item)
   b. The most expensive item
   c. Items where quantity < 5 (need restocking)`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You read a line \`"Ahmed,10,95\\n"\` from a CSV file and split it. What is \`parts[1]\` and what type is it?`,
              code: ``,
              options: [{ id: "A", text: `\`10\` (integer)` }, { id: "B", text: `\`"10"\` (string)` }, { id: "C", text: `\`10.0\` (float)` }, { id: "D", text: `\`None\`` }],
              correct: "B",
              explanation: `\`.split(",")\` returns a list of **strings** — always. Even though \`"10"\` looks like a number, it is a string until you convert it with \`int("10")\`. Always convert after reading from a file.`
            },
          keyPoints: [`CSV = one record per line, fields separated by commas`, `\`.split(",")\` parses CSV — but the \`csv\` module handles edge cases better`, `Everything read from a file is a string — convert numbers with \`int()\` / \`float()\``, `Always strip lines: \`line.strip()\` removes trailing \`\\n\``],
          youtube: `Python CSV file read write tutorial`
        },

        {
          id: "lesson-pyl2-4-4",
          slug: "lesson-pyl2-4-4",
          lesson_number: 4,
          title: `Mini Project — Persistent Score Tracker`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want a leaderboard. You run the program, add your score, and even when you quit and come back later, the scores from last time are still there. Load → Work → Save. That's the pattern?`,
            cody: `That's a persistent application — data that outlives the program. You load from the file at startup. You work in memory. You save back to the file when you're done. That's the pattern. For almost every program that stores data.`
          },
          concept: {
            title: `Combine file I/O with dictionaries and user interaction to build a program whose data survives between runs.`,
            body: `The student builds a score tracker that loads data on start, accepts new scores, and saves everything on exit.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `import csv
import os

SCORES_FILE = "leaderboard.csv"

# ── File operations ────────────────────────────────────
def load_scores():
    scores = {}
    if not os.path.exists(SCORES_FILE):
        return scores
    with open(SCORES_FILE, "r") as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) == 2:
                name, score = row
                scores[name] = int(score)
    return scores

def save_scores(scores):
    with open(SCORES_FILE, "w", newline="") as f:
        writer = csv.writer(f)
        for name, score in scores.items():
            writer.writerow([name, score])

# ── Display ────────────────────────────────────────────
def show_leaderboard(scores, top_n=5):
    if not scores:
        print("  No scores yet.")
        return
    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)
    print(f"\\n{'═'*28}")
    print(f"{'  LEADERBOARD':^28}")
    print(f"{'═'*28}")
    medals = ["🥇", "🥈", "🥉"]
    for i, (name, score) in enumerate(ranked[:top_n]):
        medal = medals[i] if i < 3 else f"#{i+1}"
        print(f"  {medal}  {name:<14} {score:>5}")
    print(f"{'═'*28}\\n")

# ── Main ───────────────────────────────────────────────
def main():
    scores = load_scores()
    print("=== Score Tracker ===")
    print(f"Loaded {len(scores)} existing scores.\\n")

    while True:
        print("1. Add score   2. Leaderboard   3. Clear mine   4. Quit")
        choice = input("Choice: ").strip()

        if choice == "1":
            name  = input("Your name: ").strip()
            score = int(input("Your score: "))
            if name in scores:
                if score > scores[name]:
                    print(f"  New personal best! {scores[name]} → {score}")
                    scores[name] = score
                else:
                    print(f"  Your best is still {scores[name]}. Keep trying!")
            else:
                scores[name] = score
                print(f"  Welcome, {name}! Score: {score}")

        elif choice == "2":
            show_leaderboard(scores)

        elif choice == "3":
            name = input("Your name: ").strip()
            if name in scores:
                del scores[name]
                print(f"  {name} removed.")
            else:
                print(f"  '{name}' not found.")

        elif choice == "4":
            save_scores(scores)
            print(f"Scores saved. Goodbye!")
            break
        else:
            print("  Invalid choice.")

main()`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Simplified version to get started
FILENAME = "my_scores.csv"

def load():
    data = {}
    try:
        with open(FILENAME) as f:
            for line in f:
                parts = line.strip().split(",")
                if len(parts) == 2:
                    data[parts[0]] = int(parts[1])
    except FileNotFoundError:
        pass
    return data

def save(data):
    with open(FILENAME, "w") as f:
        for name, score in data.items():
            f.write(f"{name},{score}\\n")

scores = load()
name  = input("Name: ")
score = int(input("Score: "))
scores[name] = max(scores.get(name, 0), score)
save(scores)

print("\\nAll scores:")
for n, s in sorted(scores.items(), key=lambda x: x[1], reverse=True):
    print(f"  {n}: {s}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Extend the persistent score tracker:
1. Add a "reset all" option that empties the leaderboard and deletes the file
2. Show the date each score was set — save date alongside name and score in the CSV
   Hint: use datetime.date.today() (Chapter 5)
3. Add a "top 3 only" display that shows just the medal positions`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `In the score tracker, why do we load the file at the START and save at the END, rather than saving after every single change?`,
              code: ``,
              options: [{ id: "A", text: `Saving mid-program causes errors` }, { id: "B", text: `It's simpler and faster — disk I/O is slow and doing it once is more efficient` }, { id: "C", text: `Python doesn't allow saving during a loop` }, { id: "D", text: `The file would get corrupted if saved multiple times` }],
              correct: "B",
              explanation: `Disk I/O (reading and writing files) is much slower than working in memory. Load once into a dictionary, work in memory (fast), save once at the end (one disk write). This is the standard pattern.`
            },
          keyPoints: [`Pattern: Load → Work in memory → Save — used in almost every real application`, `\`os.path.exists(filename)\` — check before opening to avoid FileNotFoundError`, `Always save on exit — even if the user quits normally`, `CSV is human-readable, portable, and simple — great for small datasets`],
          youtube: `Python save load data file project beginners`
        },

      ]
    },

    {
      id: "chap-pyl2-05",
      slug: "modules-standard-library",
      chapter_number: 5,
      title: `Modules and the Standard Library`,
      description: `Python comes with hundreds of ready-made modules. Students learn to import and use the most valuable ones.`,
      icon_symbol: "🧩",
      lessons_overview: ["1 Importing Modules — math", "2 The random Module", "3 The datetime Module", "4 The os Module and Organising Imports"],
      lessons: [

        {
          id: "lesson-pyl2-5-1",
          slug: "lesson-pyl2-5-1",
          lesson_number: 1,
          title: `Importing Modules — math`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I need to calculate the hypotenuse of a right triangle. That means I need square root. Does Python have that? Module? Where is it? And then I can use everything inside it?`,
            cody: `Yes — but it's not built in like print(). It's in the math module. It came with Python — already installed, waiting to be imported. Think of it like a toolbox in storage. import math brings that toolbox into your workspace. Everything. And Python has dozens of toolboxes like this.`
          },
          concept: {
            title: `A module is a file of ready-made functions. \`import\` makes them available in your program.`,
            body: `The student imports \`math\` in three styles and uses its most important functions.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Style 1: import the whole module (most common)
import math
print(math.sqrt(16))     # 4.0
print(math.pi)           # 3.141592653589793

# Style 2: import specific items — no prefix needed
from math import sqrt, pi, ceil, floor
print(sqrt(25))          # 5.0
print(pi)                # 3.141592...

# Style 3: import with alias — for long module names
import math as m
print(m.sqrt(9))         # 3.0`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `import math

# Geometry toolkit
print("=== Geometry Calculator ===\\n")

# 1. Circle
r = float(input("Circle radius: "))
print(f"  Area:        {math.pi * r**2:.4f}")
print(f"  Perimeter:   {2 * math.pi * r:.4f}")

# 2. Right triangle
print()
a = float(input("Triangle — side a: "))
b = float(input("Triangle — side b: "))
c = math.sqrt(a**2 + b**2)
print(f"  Hypotenuse:  {c:.4f}")
print(f"  Perimeter:   {a + b + c:.4f}")
print(f"  Area:        {0.5 * a * b:.4f}")

# TODO: Add a square calculator (diagonal = side × √2)
# TODO: Add a cylinder volume calculator (π × r² × height)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Write a function that takes three sides of a triangle (a, b, c) and:
1. Checks if they can form a valid triangle (each side must be less than the sum of the other two)
2. If valid, calculate the area using Heron's formula:
   s = (a + b + c) / 2
   area = math.sqrt(s * (s-a) * (s-b) * (s-c))
3. Print the area with 2 decimal places`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What is the difference between \`import math\` and \`from math import sqrt\`?`,
              code: ``,
              options: [{ id: "A", text: `\`from math import sqrt\` is faster to execute` }, { id: "B", text: `With \`import math\` you write \`math.sqrt()\`. With \`from math import sqrt\` you write just \`sqrt()\`.` }, { id: "C", text: `\`from math import sqrt\` imports ALL math functions` }, { id: "D", text: `They are completely identical` }],
              correct: "B",
              explanation: `Both give you the \`sqrt\` function. The difference is in how you call it. \`import math\` keeps functions in the \`math\` namespace so you write \`math.sqrt()\`. \`from math import sqrt\` brings \`sqrt\` directly into your namespace, so you write just \`sqrt()\`.`
            },
          keyPoints: [`\`import module\` — use \`module.function()\` prefix`, `\`from module import func\` — use \`func()\` with no prefix`, `\`import module as alias\` — use \`alias.function()\` — good for long names`, `\`math.sqrt()\`, \`math.ceil()\`, \`math.floor()\`, \`math.pi\` are the essentials`],
          youtube: `Python math module tutorial beginners`
        },

        {
          id: "lesson-pyl2-5-2",
          slug: "lesson-pyl2-5-2",
          lesson_number: 2,
          title: `The random Module`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to make a fair lottery for the class — pick 3 random winners from 30 students. What if I just want one random item? Is it truly random?`,
            cody: `Perfect job for the random module. random.sample() picks multiple unique items from a list. random.choice(). One item from a sequence. And for random integers — random.randint(). Pseudo-random — good enough for games and lotteries. Not cryptographically secure, but fine for our purposes.`
          },
          concept: {
            title: `The \`random\` module generates pseudo-random numbers, picks random items, and shuffles sequences.`,
            body: `The student uses \`random.randint()\`, \`random.choice()\`, \`random.shuffle()\`, and \`random.sample()\` to build interactive programs.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `import random

# Random integer (inclusive on both ends)
dice = random.randint(1, 6)
print(f"Dice roll: {dice}")       # 1, 2, 3, 4, 5, or 6

# Random float between 0.0 and 1.0
chance = random.random()
print(f"Probability: {chance:.4f}")

# Random float in a range
temp = random.uniform(20.0, 40.0)
print(f"Temperature: {temp:.1f}°C")

# Random choice from a sequence
fruits = ["apple", "banana", "mango", "grape"]
pick = random.choice(fruits)
print(f"Random fruit: {pick}")

# Multiple unique picks (no repeats)
winners = random.sample(fruits, 2)
print(f"Two winners: {winners}")

# Shuffle a list in place
cards = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
random.shuffle(cards)
print(f"Shuffled: {cards}")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `import random

# Number guessing game
print("=== Guess the Number ===")
print("I'm thinking of a number between 1 and 100.\\n")

secret = random.randint(1, 100)
attempts = 0
max_attempts = 7

while attempts < max_attempts:
    remaining = max_attempts - attempts
    guess = int(input(f"Guess ({remaining} attempts left): "))
    attempts += 1

    if guess == secret:
        print(f"✅ Correct! You got it in {attempts} attempt(s)!")
        break
    elif guess < secret:
        print("  ↑ Too low!")
    else:
        print("  ↓ Too high!")
else:
    print(f"❌ Out of attempts! The number was {secret}.")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Build a "student of the day" picker:
   - Store 10 student names in a list
   - Pick one randomly each day using random.choice()
2. Build a quiz randomiser:
   - Create a list of 5 questions (each a tuple: (question, answer))
   - Use random.shuffle() to randomise the order each time
   - Ask each question and check the answer`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What is the difference between \`random.choice(lst)\` and \`random.sample(lst, 1)\`?`,
              code: ``,
              options: [{ id: "A", text: `No difference — both return one random element` }, { id: "B", text: `\`random.choice()\` returns the element directly; \`random.sample()\` returns a **list** containing one element` }, { id: "C", text: `\`random.sample()\` is faster` }, { id: "D", text: `\`random.choice()\` can pick the same element twice` }],
              correct: "B",
              explanation: `\`random.choice(lst)\` returns the element itself: \`"Ahmed"\`. \`random.sample(lst, 1)\` returns a list: \`["Ahmed"]\`. You'd need \`[0]\` to get the element from sample's result.`
            },
          keyPoints: [`\`random.randint(a, b)\` — integer from a to b inclusive`, `\`random.choice(seq)\` — one random item from a sequence`, `\`random.sample(seq, k)\` — k unique items (no repeats) — returns a list`, `\`random.shuffle(lst)\` — shuffles the list **in place** (no return value)`],
          youtube: `Python random module tutorial games`
        },

        {
          id: "lesson-pyl2-5-3",
          slug: "lesson-pyl2-5-3",
          lesson_number: 3,
          title: `The datetime Module`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want my score tracker to record when each score was set. And I want to show how many days until the end of the school year. What's in it? Can I format dates the way I want them to look?`,
            cody: `Both are easy with the datetime module. Primarily two things you'll use: datetime.date for working with just dates. datetime.datetime for both date and time. And timedelta for calculating differences — how many days between two dates. Yes — strftime() controls the format. I'll show you.`
          },
          concept: {
            title: `The \`datetime\` module handles dates, times, and time calculations.`,
            body: `The student gets the current date/time, formats it, and calculates time differences.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `import datetime

today = datetime.date.today()
now   = datetime.datetime.now()

print(today)     # 2024-09-15  (date only)
print(now)       # 2024-09-15 14:32:07.123456  (date + time)

# Access individual components
print(today.year)     # 2024
print(today.month)    # 9
print(today.day)      # 15
print(now.hour)       # 14
print(now.minute)     # 32`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `import datetime

print("=== Personal Date Calculator ===\\n")

# How many days since the school year started?
school_start = datetime.date(datetime.date.today().year, 9, 1)
today = datetime.date.today()
days_in = (today - school_start).days
print(f"School started:  {school_start.strftime('%B %d, %Y')}")
print(f"Today:           {today.strftime('%B %d, %Y')}")
print(f"Days of school:  {days_in}")

# Countdown to end of year
year_end = datetime.date(today.year, 12, 31)
days_left = (year_end - today).days
print(f"Days until year end: {days_left}")

# TODO: Ask the user for their birthday, calculate their age in days and years`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Ask the user for their birthdate (format: DD/MM/YYYY)
2. Parse it with strptime
3. Calculate and print:
   a. Their age in complete years
   b. Their age in total days
   c. The day of the week they were born (strftime %A)
   d. How many days until their next birthday`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`datetime.timedelta(days=7)\` represent?`,
              code: ``,
              options: [{ id: "A", text: `The 7th day of the month` }, { id: "B", text: `7:00 AM exactly` }, { id: "C", text: `A duration of 7 days that can be added to or subtracted from a date` }, { id: "D", text: `The 7th month of the year` }],
              correct: "C",
              explanation: `\`timedelta\` represents a duration — a difference between two dates. Adding \`timedelta(days=7)\` to a date gives you the date 7 days later. Subtracting two dates gives you a \`timedelta\`.`
            },
          keyPoints: [`\`datetime.date.today()\` → today's date; \`datetime.datetime.now()\` → date + time`, `\`strftime("%d/%m/%Y")\` formats a date → string`, `\`strptime("15/09/2024", "%d/%m/%Y")\` parses a string → date`, `Subtracting two dates gives a \`timedelta\` — use \`.days\` to get the integer`],
          youtube: `Python datetime module tutorial beginners`
        },

        {
          id: "lesson-pyl2-5-4",
          slug: "lesson-pyl2-5-4",
          lesson_number: 4,
          title: `The os Module and Organising Imports`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `My program tries to open a file and crashes if it doesn't exist. Is there a way to check before opening? os? I thought that was for operating system stuff.`,
            cody: `Yes — os.path.exists(). It returns True or False before you ever try to open the file. It is — and checking whether a file exists is exactly that kind of operating system interaction. The os module also helps you list folder contents, build file paths that work on any OS, and more.`
          },
          concept: {
            title: `The \`os\` module lets Python interact with the file system. Proper import style makes code readable and maintainable.`,
            body: `The student uses \`os.path.exists()\`, \`os.listdir()\`, \`os.path.join()\`, and follows Python import conventions.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `import os

# Does a file or folder exist?
print(os.path.exists("students.csv"))    # True or False
print(os.path.isfile("students.csv"))    # True only if it's a file
print(os.path.isdir("data"))             # True only if it's a folder

# Get the current working directory
print(os.getcwd())    # e.g. /home/shady/projects

# List files in a folder
files = os.listdir(".")    # "." means current folder
for f in files:
    print(f)`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `import os
import datetime

# File manager utility
DATA_FOLDER = "my_data"
os.makedirs(DATA_FOLDER, exist_ok=True)

def list_files():
    files = os.listdir(DATA_FOLDER)
    if not files:
        print("  No files yet.")
    for f in files:
        path = os.path.join(DATA_FOLDER, f)
        size = os.path.getsize(path)
        print(f"  {f:<30} {size:>6} bytes")

def create_file(filename, content):
    path = os.path.join(DATA_FOLDER, filename)
    with open(path, "w") as f:
        f.write(content)
    print(f"  Created: {path}")

print("Files in data folder:")
list_files()
print()
create_file("note.txt", f"Created on {datetime.date.today()}\\nHello from Python!")
print("\\nAfter creating:")
list_files()`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Build a "project setup" script that:
1. Creates a folder structure: my_project/data/, my_project/output/, my_project/logs/
2. Creates a "README.txt" in my_project/ with the creation date and a description
3. Lists all created folders to confirm they exist
4. Checks if "my_project/data/input.csv" exists — if not, prints "input file missing"`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `Why use \`os.path.join("folder", "file.txt")\` instead of just \`"folder/file.txt"\`?`,
              code: ``,
              options: [{ id: "A", text: `\`os.path.join\` is faster` }, { id: "B", text: `It automatically creates the folder if it doesn't exist` }, { id: "C", text: `It builds the correct path separator (\`/\` or \`\\\`) for the current operating system` }, { id: "D", text: `Strings cannot contain \`/\` in Python` }],
              correct: "C",
              explanation: `Windows uses \`\\\` as a path separator; Mac and Linux use \`/\`. \`os.path.join()\` uses whatever is correct for the current OS, making your code work everywhere without changes.`
            },
          keyPoints: [`\`os.path.exists(path)\` — check before opening to avoid FileNotFoundError`, `\`os.path.join(a, b, c)\` — build paths that work on all operating systems`, `\`os.makedirs(path, exist_ok=True)\` — create folder(s) safely`, `Import order: standard library → third-party → local modules`],
          youtube: `Python os module file system tutorial`
        },

      ]
    },

    {
      id: "chap-pyl2-06",
      slug: "error-handling",
      chapter_number: 6,
      title: `When Things Go Wrong — Error Handling`,
      description: `Professional programs don't crash — they handle errors gracefully. Students learn try/except to write resilient code.`,
      icon_symbol: "🛡️",
      lessons_overview: ["1 try and except — Catching Errors", "2 Multiple except Blocks and else", "3 finally and raise", "4 Mini Project — Bulletproof Input Handler"],
      lessons: [

        {
          id: "lesson-pyl2-6-1",
          slug: "lesson-pyl2-6-1",
          lesson_number: 1,
          title: `try and except — Catching Errors`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `My program crashed in front of the whole class. The user typed 'hello' when I asked for a number. ValueError: invalid literal for int()... Like a safety net? Why don't we just always use try/except on everything?`,
            cody: `That's exactly why try/except exists. You 'try' the risky code. If it fails, 'except' catches the error — and you handle it gracefully. Exactly. Without a net, one wrong input crashes everything. With a net, you catch the fall and keep going. Because it hides bugs. Use it only where you genuinely expect the code might fail for normal reasons — user input, files, network.`
          },
          concept: {
            title: `Code inside \`try\` is "attempted". If it fails, \`except\` runs instead of crashing the program.`,
            body: `The student uses try/except to handle ValueError, ZeroDivisionError, and FileNotFoundError.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# ❌ Without error handling — crashes on bad input:
age = int(input("Your age: "))    # user types "twenty" → ValueError → crash

# ✅ With error handling:
try:
    age = int(input("Your age: "))
    print(f"You are {age} years old.")
except ValueError:
    print("Please enter a valid number, not text.")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Safe calculator — handles all input errors
def safe_divide(a, b):
    try:
        result = a / b
        return result
    except ZeroDivisionError:
        print("Cannot divide by zero.")
        return None

def get_number(prompt):
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("  Please enter a valid number.")

print("=== Safe Calculator ===")
a = get_number("First number: ")
b = get_number("Second number: ")
result = safe_divide(a, b)
if result is not None:
    print(f"{a} ÷ {b} = {result:.4f}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Build an input-safe version of the grade calculator from Level 1:
1. Ask for 3 subject scores — each score must be between 0 and 100
2. If the user types text, show an error and ask again (don't crash)
3. If they enter a number outside 0-100, ask again
4. Calculate and display the average once all 3 valid scores are entered`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What is wrong with using a bare \`except:\` (no error type specified)?`,
              code: ``,
              options: [{ id: "A", text: `It's a syntax error` }, { id: "B", text: `It catches too much — including system errors and keyboard interrupts — hiding real problems` }, { id: "C", text: `It only catches TypeError` }, { id: "D", text: `Nothing — it's actually recommended` }],
              correct: "B",
              explanation: `\`except:\` with no type catches literally everything, including \`SystemExit\` and \`KeyboardInterrupt\`. This means your program won't respond to Ctrl+C, and real bugs get silently swallowed. Always name the specific exception type(s) you expect.`
            },
          keyPoints: [`\`try:\` attempts risky code; \`except ErrorType:\` handles the specific failure`, `Always name the exception type — never use bare \`except:\``, `\`except ValueError as e:\` captures the error message in \`e\``, `Combine with a \`while True\` loop to keep asking until valid input is received`],
          youtube: `Python try except error handling beginners`
        },

        {
          id: "lesson-pyl2-6-2",
          slug: "lesson-pyl2-6-2",
          lesson_number: 2,
          title: `Multiple except Blocks and else`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `In my file reader, three different things can go wrong — the file might not exist, or I might not have permission to read it, or the content might be malformed. Do I need one big except for all? Like a chain? And what if nothing goes wrong?`,
            cody: `No — you can have as many except blocks as you need. Each handles a different error type in the right way. Exactly. Python checks them in order, top to bottom, and runs the first one that matches. That's what else is for. It runs only when try succeeded — no exception at all.`
          },
          concept: {
            title: `Different errors need different responses. The \`else\` clause runs only when no error occurred.`,
            body: `The student handles multiple exception types and uses the \`else\` clause correctly.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `filename = input("File to open: ")

try:
    with open(filename, "r") as f:
        content = f.read()
        number = int(content.strip())

except FileNotFoundError:
    print(f"File '{filename}' does not exist.")
except PermissionError:
    print(f"You don't have permission to read '{filename}'.")
except ValueError:
    print(f"File exists but doesn't contain a valid number.")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# File line counter with full error handling
def count_lines(filename):
    try:
        with open(filename, "r") as f:
            lines = f.readlines()
    except FileNotFoundError:
        print(f"  Error: '{filename}' not found.")
        return None
    except PermissionError:
        print(f"  Error: No permission to read '{filename}'.")
        return None
    except Exception as e:
        print(f"  Unexpected error: {e}")
        return None
    else:
        # Only runs if the file was opened and read successfully
        count = len([l for l in lines if l.strip()])
        print(f"  '{filename}' has {count} non-empty lines.")
        return count

# Test with real and fake filenames:
count_lines("students.csv")   # should work if you ran ch.4 code
count_lines("ghost.txt")      # FileNotFoundError
count_lines("")               # FileNotFoundError or ValueError`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Write a function safe_load_number(filename) that:
1. Tries to open the file
2. If the file is missing → print a specific message, return 0
3. If the file is found but empty → print a specific message, return 0
4. If the file contains a valid integer → return that integer
5. If the file contains invalid content → print a specific message, return 0
Use separate except blocks for each case`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `In a try/except/else block, when does the \`else\` clause execute?`,
              code: ``,
              options: [{ id: "A", text: `When an exception IS raised` }, { id: "B", text: `Always — after either try or except` }, { id: "C", text: `When the try block completes WITHOUT raising any exception` }, { id: "D", text: `Only when \`else\` is the last clause` }],
              correct: "C",
              explanation: `The \`else\` clause runs only if the \`try\` block executed completely without any exception. It's a clean way to write "do this if everything worked" without putting it inside the try (where it could also trigger an exception).`
            },
          keyPoints: [`Multiple \`except\` blocks handle different error types differently`, `Most specific exceptions first — most general (Exception) last`, `\`except (A, B):\` catches either A or B`, `\`else:\` runs only when \`try\` succeeded — keeps success logic separate from error logic`],
          youtube: `Python multiple except else tutorial`
        },

        {
          id: "lesson-pyl2-6-3",
          slug: "lesson-pyl2-6-3",
          lesson_number: 3,
          title: `finally and raise`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I need a database connection to stay open during a transaction. If anything goes wrong halfway, I still need to close the connection. How do I make sure the cleanup always happens? Finally what? And raise?`,
            cody: `finally. No — the keyword 'finally'. Code in a finally block runs no matter what happens — success, error, doesn't matter. It's the guarantee. raise lets you intentionally trigger an error. Useful when you want to enforce a rule — like 'if the age is negative, that's an error, even though Python didn't detect it'.`
          },
          concept: {
            title: `\`finally\` always runs — for cleanup. \`raise\` deliberately triggers an error — for validation.`,
            body: `The student uses \`finally\` for cleanup and \`raise\` to enforce rules in functions.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `def read_data(filename):
    f = None
    try:
        f = open(filename, "r")
        data = f.read()
        return data
    except FileNotFoundError:
        print(f"File '{filename}' not found.")
        return ""
    finally:
        # Runs ALWAYS — whether try succeeded or except ran
        if f:
            f.close()
            print("File closed.")    # always prints

# Note: 'with' handles this automatically — finally is more useful
# for database connections, network sockets, and hardware resources`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Resource cleanup demonstration with finally
import time

def simulate_task(task_name, should_fail=False):
    resource = None
    try:
        print(f"  [{task_name}] Starting...")
        resource = f"Connection-{task_name}"   # simulate opening a resource
        time.sleep(0.3)

        if should_fail:
            raise RuntimeError("Something went wrong mid-task!")

        print(f"  [{task_name}] Completed successfully.")
        return True

    except RuntimeError as e:
        print(f"  [{task_name}] Error: {e}")
        return False

    finally:
        # Always runs — clean up the resource
        if resource:
            print(f"  [{task_name}] Releasing {resource}")

print("Task 1 (success):")
simulate_task("T1", should_fail=False)
print()
print("Task 2 (failure):")
simulate_task("T2", should_fail=True)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Write a function validate_email(email) that raises:
- TypeError if the input is not a string
- ValueError with message "Missing @ symbol" if there's no @
- ValueError with message "Missing domain" if there's nothing after the @
- ValueError with message "Missing extension" if the domain has no dot

If valid, return the email as lowercase.
Test it with: "Ahmed@school.eg", "notanemail", 123, "no-at-sign"`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `When does the \`finally\` block NOT execute?`,
              code: ``,
              options: [{ id: "A", text: `When an exception is raised in \`try\`` }, { id: "B", text: `When the \`try\` block returns early` }, { id: "C", text: `\`finally\` always executes — there are virtually no normal cases where it doesn't` }, { id: "D", text: `When \`except\` handles the error` }],
              correct: "C",
              explanation: `\`finally\` is designed to **always** run — even if \`try\` returns, even if \`except\` returns, even if another exception is raised. The only extreme exceptions are a power cut or \`os._exit()\` — not normal programming scenarios.`
            },
          keyPoints: [`\`finally:\` always executes — perfect for cleanup (close files, release connections)`, `\`raise ErrorType("message")\` deliberately triggers an exception from your code`, `Use \`raise\` to enforce preconditions and validate function inputs`, `\`isinstance(x, int)\` checks the type of a variable`],
          youtube: `Python finally raise exception handling`
        },

        {
          id: "lesson-pyl2-6-4",
          slug: "lesson-pyl2-6-4",
          lesson_number: 4,
          title: `Mini Project — Bulletproof Input Handler`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I keep rewriting the same 'ask the user for a number, handle the error, ask again' loop in every program I build. So I write it once and use it everywhere?`,
            cody: `That's a sign it belongs in a utility module — one place where it's written well, tested, and imported wherever you need it. That's one of the most professional things you can do as a programmer. Don't repeat yourself — extract the pattern.`
          },
          concept: {
            title: `Build a reusable module of safe input functions that never crash, no matter what the user types.`,
            body: `The student writes a complete input validation utility using all error handling skills.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# ── safe_input.py — reusable input utility ────────────────────

def get_int(prompt, min_val=None, max_val=None):
    """Get a valid integer from the user, optionally within a range."""
    while True:
        try:
            value = int(input(prompt))
            if min_val is not None and value < min_val:
                raise ValueError(f"Must be at least {min_val}")
            if max_val is not None and value > max_val:
                raise ValueError(f"Must be at most {max_val}")
            return value
        except ValueError as e:
            print(f"  ✘ Invalid: {e}. Please try again.")

def get_float(prompt, min_val=None, max_val=None):
    """Get a valid float from the user, optionally within a range."""
    while True:
        try:
            value = float(input(prompt))
            if min_val is not None and value < min_val:
                raise ValueError(f"Must be at least {min_val}")
            if max_val is not None and value > max_val:
                raise ValueError(f"Must be at most {max_val}")
            return value
        except ValueError as e:
            print(f"  ✘ Invalid: {e}. Please try again.")

def get_choice(prompt, options):
    """Get a choice from a list of allowed options."""
    options_str = "/".join(options)
    while True:
        answer = input(f"{prompt} ({options_str}): ").strip().lower()
        if answer in [o.lower() for o in options]:
            return answer
        print(f"  ✘ Please choose from: {options_str}")

def get_yes_no(prompt):
    """Get a yes/no answer — returns True for yes, False for no."""
    choice = get_choice(prompt, ["yes", "no"])
    return choice == "yes"

def get_non_empty_string(prompt, max_length=None):
    """Get a non-empty string from the user."""
    while True:
        value = input(prompt).strip()
        if not value:
            print("  ✘ This field cannot be empty.")
            continue
        if max_length and len(value) > max_length:
            print(f"  ✘ Maximum {max_length} characters.")
            continue
        return value


# ── Demo: using the utility ───────────────────────────────────
if __name__ == "__main__":
    print("=== Registration Form ===\\n")
    name  = get_non_empty_string("Your name: ", max_length=30)
    age   = get_int("Your age: ", min_val=10, max_val=100)
    score = get_float("Your score (0-100): ", min_val=0.0, max_val=100.0)
    wants_certificate = get_yes_no("Do you want a certificate?")

    print(f"\\n--- Summary ---")
    print(f"Name:        {name}")
    print(f"Age:         {age}")
    print(f"Score:       {score:.1f}")
    print(f"Certificate: {'Yes' if wants_certificate else 'No'}")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Quick version to test the concept
def get_int_safe(prompt, low=None, high=None):
    while True:
        try:
            val = int(input(prompt))
            if low is not None and val < low:
                print(f"  Must be >= {low}")
                continue
            if high is not None and val > high:
                print(f"  Must be <= {high}")
                continue
            return val
        except ValueError:
            print("  Please enter a whole number.")

# Test it:
score  = get_int_safe("Score (0-100): ", low=0, high=100)
grade  = get_int_safe("Grade (1-12):  ", low=1, high=12)
print(f"Recorded: Grade {grade}, Score {score}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Add a get_date(prompt) function to the utility that:
1. Asks the user for a date in format "DD/MM/YYYY"
2. Tries to parse it with datetime.strptime
3. If parsing fails → print "Invalid date format, use DD/MM/YYYY" and ask again
4. If the date is in the past → print "That date has passed" and ask again
5. Returns the datetime.date object when valid`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `Why is the \`while True:\` loop essential inside the safe input functions?`,
              code: ``,
              options: [{ id: "A", text: `To run the function multiple times automatically` }, { id: "B", text: `To keep asking until the user provides valid input — the loop exits only with \`return\`` }, { id: "C", text: `To prevent the function from returning \`None\`` }, { id: "D", text: `It's not essential — \`if\` statements would work the same way` }],
              correct: "B",
              explanation: `The \`while True\` loop keeps retrying after each failed attempt. When the input is valid, \`return value\` exits the loop and the function. Without the loop, a single bad input would cause the function to end with no return value.`
            },
          keyPoints: [`Reusable utility functions = write once, use everywhere — DRY principle`, `\`while True\` + \`return\` = the standard retry loop pattern for input validation`, `Default parameter values (\`min_val=None\`) make functions flexible without requiring all arguments`, `\`if __name__ == "__main__":\` — code here only runs when the file is executed directly, not when imported`],
          youtube: `Python input validation functions reusable`
        },

      ]
    },

    {
      id: "chap-pyl2-07",
      slug: "list-comprehensions",
      chapter_number: 7,
      title: `Writing Less, Doing More — List Comprehensions`,
      description: `List comprehensions are a powerful, Pythonic way to build lists in one line. Concise, readable, fast.`,
      icon_symbol: "⚡",
      lessons_overview: ["1 Basic List Comprehensions", "2 Filtered List Comprehensions", "3 Dictionary and Set Comprehensions", "4 Nested Comprehensions and When NOT to Use Them"],
      lessons: [

        {
          id: "lesson-pyl2-7-1",
          slug: "lesson-pyl2-7-1",
          lesson_number: 1,
          title: `Basic List Comprehensions`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I write this pattern constantly: result = [] for item in some_list:     result.append(transform(item)) It's four lines every time. Is there a shorter way? How does it look? That IS more readable.`,
            cody: `List comprehension. One line. [transform(item) for item in some_list] Same result, one line, reads almost like English: 'transform each item for each item in this list'. When it's simple. As it gets complex, the loop becomes clearer. Comprehensions are a tool — not a rule to apply everywhere.`
          },
          concept: {
            title: `A list comprehension creates a new list by applying an expression to each item in an iterable — in a single line.`,
            body: `The student rewrites for-loop list builders as comprehensions and understands the structure.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `numbers = [1, 2, 3, 4, 5]

# ── For loop way ───────────────────────────────────────
squares_loop = []
for n in numbers:
    squares_loop.append(n ** 2)

# ── Comprehension way ──────────────────────────────────
squares_comp = [n ** 2 for n in numbers]

print(squares_loop)    # [1, 4, 9, 16, 25]
print(squares_comp)    # [1, 4, 9, 16, 25]  — identical result`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `students = ["ahmed", "sara", "omar", "nour", "ali"]
scores = [85, 92, 68, 95, 74]

# 1. Capitalize all names
proper_names = [name.capitalize() for name in students]
print("Names:", proper_names)

# 2. Add 5 bonus points to each score
bonus_scores = [s + 5 for s in scores]
print("With bonus:", bonus_scores)

# 3. Convert scores to percentages (out of 100, already %)
labels = [f"{s}%" for s in scores]
print("Labels:", labels)

# TODO: Create a list of (name, score) tuples using zip()
# Hint: [(n, s) for n, s in zip(students, scores)]
# TODO: Create a list of all score squared
# TODO: Create a list of names in ALL CAPS`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Generate a list of all perfect squares from 1 to 100 (1, 4, 9, ... 100) — one line
2. Given a list of temperatures in Celsius, create a list of the same temperatures in Fahrenheit
3. Given a list of filenames, create a list of only the filenames (remove the path)
   Hint: ["folder/file.txt".split("/")[-1] for ...]
4. Create a list of all even numbers from 1 to 50 that are also divisible by 3`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`[x * 2 for x in range(5)]\` produce?`,
              code: ``,
              options: [{ id: "A", text: `\`[0, 2, 4, 6, 8, 10]\`` }, { id: "B", text: `\`[2, 4, 6, 8, 10]\`` }, { id: "C", text: `\`[0, 2, 4, 6, 8]\`` }, { id: "D", text: `\`[1, 2, 3, 4, 5]\`` }],
              correct: "C",
              explanation: `\`range(5)\` gives 0, 1, 2, 3, 4. Multiplied by 2: 0, 2, 4, 6, 8. That's 5 elements, starting from 0.`
            },
          keyPoints: [`\`[expr for item in iterable]\` — builds a list in one line`, `Equivalent to: \`result = []; for item in iterable: result.append(expr)\``, `Works with any iterable: list, range, string, tuple, set`, `Keep comprehensions simple — if you can't read it in 3 seconds, use a regular loop`],
          youtube: `Python list comprehension tutorial beginners`
        },

        {
          id: "lesson-pyl2-7-2",
          slug: "lesson-pyl2-7-2",
          lesson_number: 2,
          title: `Filtered List Comprehensions`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I have a list of all 30 students' scores. I want only the ones above 60. Do I need a for loop with an if inside? At the end?`,
            cody: `Or one line. Add an if condition at the end of the comprehension. Yes — [expression for item in list if condition]. The condition acts as a filter — only items that pass get included.`
          },
          concept: {
            title: `Adding an \`if\` condition to a comprehension filters which items make it into the result list.`,
            body: `The student writes comprehensions that filter items by condition.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `scores = [45, 82, 58, 90, 37, 75, 88, 62]

# ── For loop with filter ───────────────────────────────
passing = []
for s in scores:
    if s >= 60:
        passing.append(s)

# ── Comprehension with filter ──────────────────────────
passing = [s for s in scores if s >= 60]
print(passing)    # [82, 90, 75, 88, 62]`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `students = [
    {"name": "Ahmed", "score": 95, "grade": 10},
    {"name": "Sara",  "score": 42, "grade": 11},
    {"name": "Omar",  "score": 78, "grade": 10},
    {"name": "Nour",  "score": 88, "grade": 11},
    {"name": "Ali",   "score": 35, "grade": 10},
]

# Extract only passing students (score >= 50)
passing = [s for s in students if s["score"] >= 50]
print("Passing:")
for s in passing:
    print(f"  {s['name']}: {s['score']}")

# Names of grade 10 students only
grade_10 = [s["name"] for s in students if s["grade"] == 10]
print(f"\\nGrade 10: {grade_10}")

# TODO: Get names of students who failed (score < 50)
# TODO: Get scores of grade 11 students
# TODO: Create a list of "Pass"/"Fail" labels for every student (in order)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Given: numbers = [14, 27, -3, 0, 55, -8, 42, -1, 100, 6]
1. Create a list of only positive numbers
2. Create a list of numbers divisible by 7
3. Create a list of numbers that are both positive AND divisible by 7
4. Create a list where each number is replaced by its absolute value
5. Create a list of ("positive"/"negative"/"zero") labels for each number`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`[n for n in range(10) if n % 2 != 0]\` produce?`,
              code: ``,
              options: [{ id: "A", text: `\`[0, 2, 4, 6, 8]\`` }, { id: "B", text: `\`[1, 3, 5, 7, 9]\`` }, { id: "C", text: `\`[2, 4, 6, 8, 10]\`` }, { id: "D", text: `\`[]\`` }],
              correct: "B",
              explanation: `\`n % 2 != 0\` is True when n is odd. \`range(10)\` gives 0–9. The odd numbers in that range are 1, 3, 5, 7, 9.`
            },
          keyPoints: [`\`[expr for item in iterable if condition]\` — filter first, then express`, `\`["Pass" if s>=50 else "Fail" for s in scores]\` — transform (not filter): every item gets a value`, `Filters reduce the list; transforms keep the same length`, `You can filter on dict values: \`[d for d in records if d["score"] > 80]\``],
          youtube: `Python list comprehension filter condition`
        },

        {
          id: "lesson-pyl2-7-3",
          slug: "lesson-pyl2-7-3",
          lesson_number: 3,
          title: `Dictionary and Set Comprehensions`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `Can I do the same thing with dictionaries? I have a list of names and a list of scores and I want to zip them into a dict in one line. And sets?`,
            cody: `Dictionary comprehension. Same idea, different brackets. Curly braces and a key: value expression. Curly braces with just a value — no colon. The set handles the uniqueness automatically.`
          },
          concept: {
            title: `The same comprehension syntax works for creating dictionaries (\`{key: val for ...}\`) and sets (\`{expr for ...}\`).`,
            body: `The student builds dictionaries and sets using comprehension syntax.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# {key_expression: value_expression for item in iterable}

names  = ["Ahmed", "Sara", "Omar"]
scores = [95, 88, 72]

# Zip them into a dictionary
grade_book = {name: score for name, score in zip(names, scores)}
print(grade_book)
# {'Ahmed': 95, 'Sara': 88, 'Omar': 72}`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `students = ["Ahmed", "Sara", "Omar", "Nour", "Ali"]
scores   = [95, 42, 78, 88, 35]

# Build grade_book dictionary
grade_book = {name: score for name, score in zip(students, scores)}
print("Grade book:", grade_book)

# Build a letter_grade dict (A/B/C/D/F)
def letter(score):
    if score >= 90: return "A"
    if score >= 80: return "B"
    if score >= 70: return "C"
    if score >= 60: return "D"
    return "F"

letter_grades = {name: letter(score) for name, score in grade_book.items()}
print("Letter grades:", letter_grades)

# TODO: Create a set of all unique letter grades
# TODO: Create a dict of only "A" and "B" students
# TODO: Create a dict of {name: score + 10} for all failing students (score < 50)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Given a list of words, create a dict mapping each word to its length
2. Given the dict from above, create a new dict keeping only words longer than 4 characters
3. Create a set of all unique vowels found in a long string
4. Given a list of email addresses, create a dict mapping each email to its domain
   (the part after @)
   e.g. "ahmed@school.eg" → domain "school.eg"`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What does \`{n: n**2 for n in range(4) if n % 2 == 0}\` produce?`,
              code: ``,
              options: [{ id: "A", text: `\`{0, 4}\`` }, { id: "B", text: `\`{0: 0, 4: 16}\`` }, { id: "C", text: `\`{0: 0, 2: 4}\`` }, { id: "D", text: `\`{1: 1, 3: 9}\`` }],
              correct: "C",
              explanation: `\`range(4)\` is 0, 1, 2, 3. Filter \`n % 2 == 0\` keeps 0 and 2. Then \`n: n**2\` maps 0→0, 2→4. Result: \`{0: 0, 2: 4}\`.`
            },
          keyPoints: [`Dict comprehension: \`{key: val for item in iterable}\` — curly braces with a colon`, `Set comprehension: \`{expr for item in iterable}\` — curly braces, no colon`, `Both support filter conditions: \`if condition\` at the end`, `\`zip(list1, list2)\` pairs elements together — perfect for building dicts from two lists`],
          youtube: `Python dictionary set comprehension tutorial`
        },

        {
          id: "lesson-pyl2-7-4",
          slug: "lesson-pyl2-7-4",
          lesson_number: 4,
          title: `Nested Comprehensions and When NOT to Use Them`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `Can I put a comprehension inside a comprehension? Show me.`,
            cody: `Yes. Useful for 2D data — like a grid or a matrix. Here's the key rule first: if someone else can't read it in 5 seconds, use a loop. Comprehensions are for clarity, not cleverness. The moment they become hard to read, they've failed their purpose.`
          },
          concept: {
            title: `Comprehensions can be nested for 2D data, but readability has clear limits — know when to stop.`,
            body: `The student writes a simple nested comprehension for a matrix and articulates when a regular loop is the better choice.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Create a 3×3 matrix (list of lists)
matrix = [[row * 3 + col for col in range(3)] for row in range(3)]
print(matrix)
# [[0, 1, 2], [3, 4, 5], [6, 7, 8]]`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Multiplication table as a 2D list
size = 5

table = [[row * col for col in range(1, size + 1)] for row in range(1, size + 1)]

# Print it formatted
print(f"{'':>4}", end="")
for col in range(1, size + 1):
    print(f"{col:>4}", end="")
print()
print("─" * (4 * (size + 1)))

for i, row in enumerate(table):
    print(f"{i+1:>4}", end="")
    for val in row:
        print(f"{val:>4}", end="")
    print()`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Use a nested comprehension to create a 4×4 grid where each cell is (row, col)
   e.g. [[(0,0), (0,1), ...], [(1,0), ...], ...]
2. Flatten a given nested list: [[1,2],[3,4],[5]] → [1,2,3,4,5] using comprehension
3. Given the flat list [1,2,3,4,5,6,7,8,9], create a 3×3 nested list using a comprehension
   Hint: [[flat[row*3 + col] for col in range(3)] for row in range(3)]`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You have \`[[1,2],[3,4],[5,6]]\`. What does \`[x for row in data for x in row]\` produce?`,
              code: ``,
              options: [{ id: "A", text: `\`[[1,2],[3,4],[5,6]]\` — unchanged` }, { id: "B", text: `\`[1,2,3,4,5,6]\`` }, { id: "C", text: `\`[[1,3,5],[2,4,6]]\`` }, { id: "D", text: `\`SyntaxError\`` }],
              correct: "B",
              explanation: `The outer loop iterates through rows (\`[1,2]\`, \`[3,4]\`, \`[5,6]\`). The inner loop iterates through each \`x\` in each \`row\`. All \`x\` values collected in order: 1, 2, 3, 4, 5, 6.`
            },
          keyPoints: [`\`[item for row in matrix for item in row]\` flattens a 2D list — read left to right`, `\`[[expr for col in range(n)] for row in range(m)]\` creates a 2D grid`, `Comprehensions are for clarity — when they're hard to read, a loop is better`, `The rule: if you can't explain it in one breath, write a loop`],
          youtube: `Python nested list comprehension flatten 2D`
        },

      ]
    },

    {
      id: "chap-pyl2-08",
      slug: "functions-deeper",
      chapter_number: 8,
      title: `Functions — Going Deeper`,
      description: `Students know basic functions. Now: variable scope, default arguments, flexible argument lists, and lambda.`,
      icon_symbol: "🔧",
      lessons_overview: ["1 Scope — Where Variables Live", "2 Default Parameters and Keyword Arguments", "3 *args and **kwargs", "4 Lambda Functions"],
      lessons: [

        {
          id: "lesson-pyl2-8-1",
          slug: "lesson-pyl2-8-1",
          lesson_number: 1,
          title: `Scope — Where Variables Live`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I set a variable called score inside my function. Then I tried to print it outside and got NameError. But I defined it! Where did it go? Like what happens in the kitchen stays in the kitchen? So inside can see outside, but outside can't see inside?`,
            cody: `It went out of scope. Variables born inside a function live only inside that function. When the function ends, they disappear. Perfect analogy. The kitchen (function) has its own variables. The dining room (outside) can't see them. But the dining room's variables — those ARE visible inside the kitchen. Exactly. That's scope.`
          },
          concept: {
            title: `A variable created inside a function exists only inside it (local scope). Variables outside are global. Mixing them carelessly causes subtle bugs.`,
            body: `The student identifies local vs global scope, explains why scope matters, and avoids the global keyword.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `def calculate():
    result = 42     # local variable — born here
    print(result)   # ✅ works inside

calculate()
print(result)       # ❌ NameError: name 'result' is not defined
                    # result only existed inside calculate()`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Explore scope rules
total = 0   # global

def add_to_total(amount):
    # Can we read 'total' here? YES — it's global
    print(f"  Current total before: {total}")
    # Can we change 'total' directly? NO — UnboundLocalError

    # ✅ Return the new value instead:
    return total + amount

total = add_to_total(50)
print(f"After first add: {total}")

total = add_to_total(25)
print(f"After second add: {total}")

# Safe: add_to_total never modifies global directly
# The caller (main code) updates total with the returned value`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Write a function power_of(base, exponent) that returns base^exponent
2. Create a variable 'base = 3' in the global scope
3. Inside the function, what happens if you use 'base' without passing it as a parameter?
   Try it — explain what you observe
4. Fix it properly by always passing base as a parameter
5. Write a short comment explaining why functions with parameters are better than
   functions that rely on global variables`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `A variable defined inside a function can be accessed:`,
              code: ``,
              options: [{ id: "A", text: `Anywhere in the program` }, { id: "B", text: `Only inside that function — it disappears when the function returns` }, { id: "C", text: `In any function defined after this one` }, { id: "D", text: `Only if declared with the \`global\` keyword` }],
              correct: "B",
              explanation: `Variables defined inside a function are local — they exist only during that function's execution. When the function returns, all its local variables are discarded. This is intentional: it keeps functions self-contained and prevents them from interfering with each other.`
            },
          keyPoints: [`Local scope — variables inside a function; gone when function ends`, `Global scope — variables outside all functions; visible inside (read-only)`, `Avoid \`global\` — pass values in via parameters, return them out via \`return\``, `Each function call gets its own independent set of local variables`],
          youtube: `Python scope local global variables tutorial`
        },

        {
          id: "lesson-pyl2-8-2",
          slug: "lesson-pyl2-8-2",
          lesson_number: 2,
          title: `Default Parameters and Keyword Arguments`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I have a function that creates a student report — it always uses the same school name and year, but occasionally I need to change them. Do I have to pass them every single time? And keyword arguments?`,
            cody: `No. Give them default values. If the caller doesn't provide them — Python uses the default. If they do — Python uses what they passed. Those let you pass arguments by name, not by position. Useful when a function has many parameters and you want to be explicit about which is which.`
          },
          concept: {
            title: `Parameters can have default values. Arguments can be passed by name rather than position.`,
            body: `The student writes functions with default parameters and calls them using keyword arguments.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `def greet(name, greeting="Hello", punctuation="!"):
    return f"{greeting}, {name}{punctuation}"

print(greet("Ahmed"))                      # Hello, Ahmed!
print(greet("Sara", "Hi"))                 # Hi, Sara!
print(greet("Omar", "Welcome", "."))       # Welcome, Omar.`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `def generate_student_card(name, grade, score, school="Salam Prep",
                          show_grade=True, show_score=True):
    lines = [f"{'='*30}", f"  {school}", f"{'─'*30}", f"  Name:  {name}"]
    if show_grade:
        lines.append(f"  Grade: {grade}")
    if show_score:
        status = "Pass" if score >= 50 else "Fail"
        lines.append(f"  Score: {score}/100  [{status}]")
    lines.append(f"{'='*30}")
    return "\\n".join(lines)

# Default card
print(generate_student_card("Ahmed", 10, 85))
print()

# Custom card — different school, no score shown
print(generate_student_card("Sara", 11, 92, school="Cairo STEM", show_score=False))
print()

# TODO: Call it with only name, grade, score — observe the defaults at work
# TODO: Call it with grade=10, score=55, name="Omar" using keyword arguments (wrong order)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Write a function format_currency(amount, currency="EGP", decimal_places=2, show_symbol=True)
that formats a number as a currency string.
Examples:
  format_currency(1500)           → "1500.00 EGP"
  format_currency(1500, "USD")    → "1500.00 USD"
  format_currency(1500, decimal_places=0)  → "1500 EGP"
  format_currency(1500, show_symbol=False) → "1500.00"`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `\`def greet(name, msg="Hello"):\` is called as \`greet(msg="Hi", name="Shady")\`. What prints?`,
              code: ``,
              options: [{ id: "A", text: `SyntaxError — wrong order` }, { id: "B", text: `"Hello, Shady" — msg is ignored` }, { id: "C", text: `"Hi, Shady"` }, { id: "D", text: `"Hi, msg"` }],
              correct: "C",
              explanation: `Keyword arguments can be passed in any order — Python matches them by name. \`msg="Hi"\` overrides the default, \`name="Shady"\` provides the required argument.`
            },
          keyPoints: [`Default values: \`def func(param=default):\` — used when caller doesn't provide it`, `Non-default parameters must come before default ones`, `Keyword arguments: \`func(param_name=value)\` — pass by name, in any order`, `Mix positional and keyword: positional ones must come first`],
          youtube: `Python default arguments keyword arguments functions`
        },

        {
          id: "lesson-pyl2-8-3",
          slug: "lesson-pyl2-8-3",
          lesson_number: 3,
          title: `*args and **kwargs`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to write a sum function that works whether I pass it 2 numbers or 10. Do I need to write a different function for each case? Like Python's built-in sum()? And **kwargs?`,
            cody: `No. Use *args. It collects however many arguments you pass into a tuple. Exactly — except sum() takes a list. With *args, you don't even need the brackets. You just pass the numbers directly. For keyword arguments. Collects all name=value pairs into a dictionary. Great when you don't know in advance which settings someone might pass.`
          },
          concept: {
            title: `\`*args\` collects any number of positional arguments as a tuple. \`**kwargs\` collects any number of keyword arguments as a dictionary.`,
            body: `The student writes functions that accept a flexible number of arguments using \`*args\` and \`**kwargs\`.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `def my_sum(*args):
    # args is a tuple of all positional arguments passed
    print(f"args = {args}")
    return sum(args)

print(my_sum(1, 2))           # args = (1, 2) → 3
print(my_sum(1, 2, 3, 4, 5))  # args = (1, 2, 3, 4, 5) → 15
print(my_sum())               # args = () → 0`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Flexible report generator
def generate_report(title, *sections, separator="─"*30, **metadata):
    print("=" * 30)
    print(f"  {title}")
    print("=" * 30)

    if metadata:
        for key, val in metadata.items():
            print(f"  {key.replace('_', ' ').title()}: {val}")
        print(separator)

    for i, section in enumerate(sections, 1):
        print(f"  {i}. {section}")

    print("=" * 30)

generate_report(
    "Student Report",
    "Completed Chapter 1",
    "Completed Chapter 2",
    "Passed Chapter 2 Exam",
    student="Ahmed",
    date="2024-09-15",
    overall_grade="B+"
)`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Write my_max(*args) that returns the largest value from any number of arguments
   (don't use the built-in max() inside it — use a loop)
2. Write describe(**attributes) that prints each attribute on a line: "colour: blue"
3. Write format_table(*rows, headers=None) that prints a simple text table
   Each row is a tuple. If headers is provided, print them first.`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `In \`def func(*args, **kwargs)\`, if you call \`func(1, 2, name="Shady")\`, what is \`kwargs\`?`,
              code: ``,
              options: [{ id: "A", text: `\`(1, 2, "Shady")\`` }, { id: "B", text: `\`{"name": "Shady"}\`` }, { id: "C", text: `\`{"1": None, "2": None, "name": "Shady"}\`` }, { id: "D", text: `\`[1, 2]\`` }],
              correct: "B",
              explanation: `\`args\` collects positional arguments: \`(1, 2)\`. \`kwargs\` collects keyword arguments: \`{"name": "Shady"}\`. They're separate — positional in the tuple, keyword in the dict.`
            },
          keyPoints: [`\`*args\` = tuple of all extra positional arguments — iterate with a for loop`, `\`**kwargs\` = dict of all extra keyword arguments — access like a dict`, `The names "args" and "kwargs" are convention — the \`*\` and \`**\` are what matter`, `Order: \`def f(required, *args, **kwargs)\` — required first, then \`*args\`, then \`**kwargs\``],
          youtube: `Python args kwargs tutorial functions`
        },

        {
          id: "lesson-pyl2-8-4",
          slug: "lesson-pyl2-8-4",
          lesson_number: 4,
          title: `Lambda Functions`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to sort my list of student dictionaries by their score. I know sorted() takes a key argument — but what do I pass? Lambda sounds complicated. That's... actually simple.`,
            cody: `A function that takes one element and returns the sort key. You could write a full def — or use a lambda for a quick one-liner. It's the simplest possible function. No name, no def, one expression, one line. lambda x: x['score'] means 'a function that takes x and returns x[\\ That's the whole point.`
          },
          concept: {
            title: `A lambda is a compact, anonymous (nameless) one-line function — useful as a throwaway function for sorting, filtering, and mapping.`,
            body: `The student writes lambda functions and uses them as the \`key\` argument in \`sorted()\`.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Regular function:
def square(x):
    return x ** 2

# Lambda equivalent:
square = lambda x: x ** 2

print(square(5))    # 25`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `products = [
    {"name": "Notebook",   "price": 15.00, "stock": 100},
    {"name": "Pen",        "price":  3.50, "stock":  50},
    {"name": "Ruler",      "price":  8.00, "stock":  75},
    {"name": "Calculator", "price": 75.00, "stock":  20},
    {"name": "Eraser",     "price":  2.00, "stock": 200},
]

# Sort by price
by_price = sorted(products, key=lambda p: p["price"])
print("By price (cheapest first):")
for p in by_price:
    print(f"  {p['name']:<15} {p['price']:>7.2f} EGP")

# Filter: items costing less than 10 EGP
cheap = list(filter(lambda p: p["price"] < 10, products))
print(f"\\nUnder 10 EGP: {[p['name'] for p in cheap]}")

# TODO: Sort by stock (most in stock first)
# TODO: Filter: items with stock > 50
# TODO: Create a list of all prices using map() and lambda`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Given a list of strings representing filenames:
["report.pdf", "notes.txt", "image.png", "data.csv", "backup.txt"]
1. Sort them alphabetically — one line with lambda
2. Sort by file extension — one line with lambda (Hint: filename.split(".")[-1])
3. Filter to show only .txt files — one line with filter + lambda
4. Use map + lambda to add "2024_" prefix to all filenames`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What is the output of \`list(map(lambda x: x.upper(), ["a", "b", "c"]))\`?`,
              code: ``,
              options: [{ id: "A", text: `\`["a", "b", "c"]\`` }, { id: "B", text: `\`["A", "B", "C"]\`` }, { id: "C", text: `\`"ABC"\`` }, { id: "D", text: `\`[True, True, True]\`` }],
              correct: "B",
              explanation: `\`map()\` applies the lambda to each element. \`lambda x: x.upper()\` converts each string to uppercase. \`list()\` converts the map object to a list. Result: \`["A", "B", "C"]\`.`
            },
          keyPoints: [`\`lambda params: expression\` — one-line, anonymous function`, `Primary use: \`key=\` argument in \`sorted()\`, \`min()\`, \`max()\``, `Also used with \`filter()\` and \`map()\` — though comprehensions are often cleaner`, `If the logic is complex or reused — use \`def\`, not \`lambda\``],
          youtube: `Python lambda functions sorted key tutorial`
        },

      ]
    },

    {
      id: "chap-pyl2-09",
      slug: "oop-intro",
      chapter_number: 9,
      title: `Object-Oriented Programming — Introduction`,
      description: `OOP is a different way to organise code. Everything is an object with its own data and behaviour. The most important chapter in Level 2.`,
      icon_symbol: "🏗️",
      lessons_overview: ["1 Classes and Objects — The Mental Model", "2 __init__ and Attributes", "3 Methods — Objects That Do Things", "4 Mini Project — Class Roster System"],
      lessons: [

        {
          id: "lesson-pyl2-9-1",
          slug: "lesson-pyl2-9-1",
          lesson_number: 1,
          title: `Classes and Objects — The Mental Model`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I've been writing functions and data in separate places. There must be a better way to keep related things together. What's an object? And a class? So the class is like the cookie cutter and objects are the cookies?`,
            cody: `There is. Object-Oriented Programming. Instead of data over here and functions over there, you bundle them together into an object. Think of a student. A student has data: name, grade, scores. A student can do things: take an exam, get a report card, introduce themselves. That's an object — data AND behaviour, together. The class is the blueprint — the definition. 'What does every student have and what can every student do?' An object is one specific student built from that blueprint. Perfect. Write the cutter once, make infinite cookies.`
          },
          concept: {
            title: `A class is a blueprint. An object is something built from that blueprint. Every object has its own data and behaviour.`,
            body: `The student explains the difference between a class and an object using real-world analogies before writing a single line of OOP code.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `class Student:
    pass    # empty class — valid Python

# Create two objects from the blueprint
s1 = Student()
s2 = Student()

print(type(s1))          # <class '__main__.Student'>
print(s1 == s2)          # False — they are different objects
print(isinstance(s1, Student))    # True`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Before OOP — the messy way
names  = ["Ahmed", "Sara", "Omar"]
scores = [95, 88, 72]
grades = [10, 11, 10]

# To get Ahmed's score, I need to remember he's at index 0
print(f"{names[0]}: {scores[0]}")    # fragile — breaks if list order changes

# ──────────────────────────────────────────────────────
# With OOP (preview — we'll implement __init__ next lesson)
class Student:
    pass

s = Student()
s.name  = "Ahmed"     # manually adding attributes for now
s.score = 95
s.grade = 10

print(f"{s.name}: {s.score}")    # clean — data belongs to the object

# Create three students
students = []
for name, score, grade in zip(names, scores, grades):
    obj = Student()
    obj.name, obj.score, obj.grade = name, score, grade
    students.append(obj)

for s in students:
    print(f"{s.name} (Grade {s.grade}): {s.score}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `In your own words (written as a comment in Python), explain:
1. What is the difference between a class and an object?
2. Give TWO real-world examples of a class and what its objects would be
3. What is the difference between "attributes" and "methods"?
Then create a simple class called 'Book' using pass.
Create 2 Book objects and manually set author, title, and pages on each.
Print a summary of each book.`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `If \`Car\` is a class and \`my_car = Car()\`, then \`my_car\` is:`,
              code: ``,
              options: [{ id: "A", text: `The class itself` }, { id: "B", text: `A copy of the class` }, { id: "C", text: `An instance (object) built from the Car blueprint` }, { id: "D", text: `A variable that refers to the Car class` }],
              correct: "C",
              explanation: `\`Car()\` creates a new object — an instance — of the Car class. \`my_car\` is that specific object. The class is the blueprint; \`my_car\` is one thing built from that blueprint.`
            },
          keyPoints: [`Class = blueprint (the definition), Object = instance (the thing)`, `One class → unlimited objects, each with their own data`, `Attributes = the data an object stores`, `Methods = the things an object can do (functions that belong to a class)`],
          youtube: `Python classes objects OOP beginners explained`
        },

        {
          id: "lesson-pyl2-9-2",
          slug: "lesson-pyl2-9-2",
          lesson_number: 2,
          title: `__init__ and Attributes`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `Manually setting s.name = 'Ahmed' after creating the object is messy. Can I provide the name when I create the object — like Student('Ahmed', 95)? And what's self? Always self, even if I don't use it?`,
            cody: `Yes. That's what __init__ is for. It runs automatically the moment you call Student(). Whatever arguments you pass — __init__ receives them and sets up the object. self is the object itself. When you write self.name = name, you're saying: 'this particular object's name attribute = the name I was given.' Every method needs self as the first parameter — always. Always. Python passes it automatically. You just declare it.`
          },
          concept: {
            title: `\`__init__\` is the constructor — it automatically runs when an object is created and sets up its initial data. \`self\` refers to the specific object being created.`,
            body: `The student writes a class with \`__init__\`, understands \`self\`, and creates multiple objects with different data.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `class Student:
    def __init__(self, name, grade, score):
        # 'self' = this specific student object
        # These lines create the object's attributes:
        self.name  = name
        self.grade = grade
        self.score = score

# Create objects — arguments go to __init__
s1 = Student("Ahmed", 10, 95)
s2 = Student("Sara",  11, 88)
s3 = Student("Omar",  10, 72)

# Access attributes with dot notation
print(s1.name)     # Ahmed
print(s2.score)    # 88
print(s3.grade)    # 10`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `class Student:
    def __init__(self, name, grade, score):
        self.name  = name
        self.grade = grade
        self.score = score

# Create your class roster
roster = [
    Student("Ahmed", 10, 95),
    Student("Sara",  11, 88),
    Student("Omar",  10, 72),
    Student("Nour",  11, 91),
    Student("Ali",   10, 35),
]

# Print all students
print(f"{'Name':<12} {'Grade':>6} {'Score':>6}")
print("─" * 26)
for s in roster:
    print(f"{s.name:<12} {s.grade:>6} {s.score:>6}")

# TODO: Find the student with the highest score
# Hint: max(roster, key=lambda s: s.score)

# TODO: Print only Grade 10 students`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `1. Create a class 'Product' with attributes: name, price, stock
2. Add a default value: stock=0
3. Create 4 products — at least one with stock=0
4. Print all products formatted as: "Notebook — 15.00 EGP (100 in stock)"
5. Create a list comprehension that returns only products currently in stock (stock > 0)`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `Why must \`self\` always be the first parameter of every method in a class?`,
              code: ``,
              options: [{ id: "A", text: `It's optional — Python works fine without it` }, { id: "B", text: `Python automatically passes the object instance as the first argument when a method is called` }, { id: "C", text: `\`self\` stores the class name` }, { id: "D", text: `It initialises the object` }],
              correct: "B",
              explanation: `When you call \`s.greet()\`, Python translates it to \`Student.greet(s)\` — it passes the object \`s\` as the first argument automatically. The method receives it as \`self\`. Without declaring \`self\`, the method gets the object as an unnamed argument and Python raises a TypeError.`
            },
          keyPoints: [`\`__init__\` is the constructor — runs automatically at \`ClassName()\``, `\`self\` = the specific object being created or used — always the first parameter`, `\`self.attribute = value\` creates the object's data`, `Each object gets its own copy of all \`self.\` attributes — they don't share data`],
          youtube: `Python __init__ self class constructor tutorial`
        },

        {
          id: "lesson-pyl2-9-3",
          slug: "lesson-pyl2-9-3",
          lesson_number: 3,
          title: `Methods — Objects That Do Things`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `My Student object has data — name, score, grade. But it can't actually DO anything yet. So the function and its data are in the same place.`,
            cody: `That's what methods are for. Methods are functions that belong to the class — and they can use self. To check if a student is passing — self.score >= 50. To introduce themselves — use self.name, self.grade. The object has everything it needs. That's the core idea of OOP. Instead of passing student data to a function, the function lives inside the student and uses its own data.`
          },
          concept: {
            title: `Methods are functions defined inside a class. They define what an object can do, using its own data.`,
            body: `The student adds multiple methods to a class, calls them on objects, and builds a useful Student class.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `class Student:
    def __init__(self, name, grade, score):
        self.name  = name
        self.grade = grade
        self.score = score

    def is_passing(self):
        return self.score >= 50

    def grade_letter(self):
        if self.score >= 90: return "A"
        if self.score >= 80: return "B"
        if self.score >= 70: return "C"
        if self.score >= 60: return "D"
        return "F"

    def introduce(self):
        status = "passing" if self.is_passing() else "failing"
        return (f"Hi! I'm {self.name}, Grade {self.grade}. "
                f"My score is {self.score}/100 — grade {self.grade_letter()}. "
                f"Currently {status}.")

    def apply_bonus(self, points):
        self.score = min(100, self.score + points)
        return self.score`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `class Student:
    def __init__(self, name, grade, score):
        self.name  = name
        self.grade = grade
        self.score = score

    def is_passing(self):
        return self.score >= 50

    def grade_letter(self):
        # TODO: Implement grade_letter (A/B/C/D/F)
        pass

    def status_report(self):
        # TODO: Return a formatted string with name, score, letter, and pass/fail
        pass

    def __str__(self):
        return f"{self.name}: {self.score}/100"

# Test your methods
students = [
    Student("Ahmed", 10, 95),
    Student("Sara",  11, 42),
    Student("Omar",  10, 78),
]

for s in students:
    print(s)
    print(f"  Passing: {s.is_passing()}")
    print(f"  Report:  {s.status_report()}")
    print()`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Add these methods to the Student class:
1. add_score(subject, score) — store subject scores in a dict: self.subject_scores
2. average() — return the average of all subject scores
3. best_subject() — return the subject with the highest score
4. full_report() — return a formatted multi-line string showing all subjects, average, and status
Test with at least 3 subjects per student`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You call \`student.introduce()\`. How does the method get access to \`self.name\`?`,
              code: ``,
              options: [{ id: "A", text: `\`self.name\` is a global variable` }, { id: "B", text: `\`name\` is passed as an argument when calling \`introduce()\`` }, { id: "C", text: `Python automatically passes the object as \`self\` — so \`self.name\` is this student's name` }, { id: "D", text: `All methods share one common \`self\` object` }],
              correct: "C",
              explanation: `When you call \`student.introduce()\`, Python translates it to \`Student.introduce(student)\`. Inside the method, \`self\` is \`student\` — so \`self.name\` is \`student.name\`. Each object's method call uses that specific object's data.`
            },
          keyPoints: [`Methods are functions inside a class — always take \`self\` as first parameter`, `\`self.attribute\` accesses the object's own data from inside a method`, `Methods can call other methods: \`self.is_passing()\` from inside \`introduce()\``, `\`__str__(self)\` controls what \`print(object)\` displays`],
          youtube: `Python class methods self tutorial OOP`
        },

        {
          id: "lesson-pyl2-9-4",
          slug: "lesson-pyl2-9-4",
          lesson_number: 4,
          title: `Mini Project — Class Roster System`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `Can classes work together? Like a Classroom that contains Students? The objects talk to each other.`,
            cody: `That's exactly how OOP scales. One class manages objects of another class. A Classroom holds a list of Student objects. When you call classroom.add_student(), it creates a Student and stores it. When you call classroom.report(), it loops through all Student objects and calls their own methods. That's OOP in practice. Let's build it.`
          },
          concept: {
            title: `Build a complete system using OOP: a \`Student\` class and a \`Classroom\` class that manages a roster of Student objects.`,
            body: `The student implements two interacting classes with multiple methods to build a functional class roster system.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `class Student:
    def __init__(self, name, grade, score):
        self.name  = name
        self.grade = grade
        self.score = score

    def is_passing(self):    return self.score >= 50

    def grade_letter(self):
        for threshold, letter in [(90,"A"),(80,"B"),(70,"C"),(60,"D")]:
            if self.score >= threshold:
                return letter
        return "F"

    def __str__(self):
        return (f"{self.name:<15} Grade {self.grade}  "
                f"{self.score:>3}/100  {self.grade_letter()}  "
                f"{'✔' if self.is_passing() else '✘'}")


class Classroom:
    def __init__(self, class_name, teacher):
        self.class_name = class_name
        self.teacher    = teacher
        self.students   = []        # list of Student objects

    def add_student(self, name, grade, score):
        student = Student(name, grade, score)
        self.students.append(student)
        print(f"  Added: {name}")

    def find_student(self, name):
        for s in self.students:
            if s.name.lower() == name.lower():
                return s
        return None

    def remove_student(self, name):
        s = self.find_student(name)
        if s:
            self.students.remove(s)
            print(f"  Removed: {name}")
        else:
            print(f"  '{name}' not found.")

    def class_average(self):
        if not self.students:
            return 0
        return sum(s.score for s in self.students) / len(self.students)

    def top_students(self, n=3):
        return sorted(self.students, key=lambda s: s.score, reverse=True)[:n]

    def print_report(self):
        print(f"\\n{'═'*55}")
        print(f"  Class: {self.class_name}  |  Teacher: {self.teacher}")
        print(f"{'═'*55}")
        print(f"  {'Name':<15} {'Grade':>6} {'Score':>7} {'Ltr':>4} {'OK':>4}")
        print(f"  {'─'*50}")
        for s in sorted(self.students, key=lambda x: x.score, reverse=True):
            print(f"  {s}")
        print(f"  {'─'*50}")
        avg = self.class_average()
        passed = sum(1 for s in self.students if s.is_passing())
        print(f"  Students: {len(self.students)}  "
              f"Passed: {passed}  "
              f"Failed: {len(self.students)-passed}  "
              f"Average: {avg:.1f}")
        print(f"{'═'*55}")

        if self.students:
            top = self.top_students(1)[0]
            print(f"\\n  🏆 Top student: {top.name} ({top.score}/100)\\n")


# ── Demo ──────────────────────────────────────────────
room = Classroom("10-A", "Mr. Cody")
room.add_student("Ahmed", 10, 95)
room.add_student("Sara",  10, 42)
room.add_student("Omar",  10, 78)
room.add_student("Nour",  10, 88)
room.add_student("Ali",   10, 35)
room.add_student("Maya",  10, 91)

room.print_report()

# Look up a student
s = room.find_student("omar")
if s:
    print(f"\\nFound: {s.name} — Grade letter: {s.grade_letter()}")

# Remove one
room.remove_student("Ali")
print(f"\\nAfter removal — Students: {len(room.students)}")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `class Student:
    def __init__(self, name, score):
        self.name  = name
        self.score = score

    def is_passing(self):
        return self.score >= 50

    def __str__(self):
        return f"{self.name}: {self.score} ({'Pass' if self.is_passing() else 'Fail'})"


class Classroom:
    def __init__(self):
        self.students = []

    def add(self, name, score):
        self.students.append(Student(name, score))

    def average(self):
        # TODO: Return the class average
        pass

    def report(self):
        # TODO: Print all students using __str__
        # TODO: Print the class average
        pass


room = Classroom()
room.add("Ahmed", 95)
room.add("Sara", 42)
room.add("Omar", 78)
room.report()`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Extend the Classroom class:
1. Add a method grade_distribution() that returns a dict:
   {"A": 2, "B": 1, "C": 0, "D": 1, "F": 1}
   (count how many students got each letter grade)
2. Add apply_bonus(points) that adds points to every failing student's score
3. Add to_csv(filename) that saves the roster to a CSV file
   (reuse your file writing skills from Chapter 4)`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `In the Classroom class, \`self.students.append(Student(name, grade, score))\` does what?`,
              code: ``,
              options: [{ id: "A", text: `Prints the student's data` }, { id: "B", text: `Creates a new Student object and adds it to the Classroom's list of students` }, { id: "C", text: `Adds a copy of the Classroom to the Student` }, { id: "D", text: `Raises a NameError — Student is not defined` }],
              correct: "B",
              explanation: `\`Student(name, grade, score)\` creates a new Student object (calls \`__init__\`). \`self.students.append(...)\` adds that object to the classroom's list. This is how one class manages a collection of another class's objects.`
            },
          keyPoints: [`A class can contain objects of another class: \`Classroom\` holds \`Student\` objects`, `Methods can call methods on other objects: \`s.grade_letter()\` inside \`Classroom.print_report()\``, `\`sorted(self.students, key=lambda s: s.score)\` sorts objects by an attribute`, `\`sum(s.score for s in self.students)\` — generator expression works on objects`],
          youtube: `Python OOP multiple classes working together`
        },

      ]
    },

    {
      id: "chap-pyl2-10",
      slug: "capstone",
      chapter_number: 10,
      title: `Capstone — Building a Real Python Project`,
      description: `Apply everything from Level 2 to build a complete Student Management System.`,
      icon_symbol: "🎓",
      lessons_overview: ["1 Project Planning", "2 Building the Core — Student and Classroom Classes", "3 File I/O and Full System Integration", "4 Polish and What's Next"],
      lessons: [

        {
          id: "lesson-pyl2-10-1",
          slug: "lesson-pyl2-10-1",
          lesson_number: 1,
          title: `Project Planning`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I want to build a proper Student Management System — not just practice code. Something that could actually be used. What do we plan?`,
            cody: `Then let's plan it properly. Professional programmers spend real time planning before touching a keyboard. A clear plan catches most problems in 10 minutes instead of discovering them 3 hours into coding. Requirements — what must it do? Classes — what objects exist and what data do they hold? Methods — what can each object do? Data flow — how does information move through the system? Persistence — what gets saved and how?`
          },
          concept: {
            title: `Real projects are designed before they're coded. Planning prevents wasted effort and reveals problems early.`,
            body: `The student plans a multi-class project by identifying requirements, classes, methods, and data flow before writing code.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# Class: Student
#   Attributes: name, grade, scores (list)
#   Methods: add_score(), average(), grade_letter(),
#            is_passing(), status_report(), __str__

# Class: Classroom
#   Attributes: name, teacher, students (list of Student objects)
#   Methods: add_student(), find_student(), remove_student(),
#            class_average(), top_students(), failing_students(),
#            print_report(), save_to_file(), load_from_file()`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Planning document — write this BEFORE the code

"""
PROJECT: Student Management System
DEVELOPER: [Your name]
DATE: [Today]

CLASSES:
─────────
Student:
  init: name (str), grade (int), scores (list = [])
  Methods:
    add_score(score)     — validates and adds to self.scores
    average()            — returns mean of scores, or 0 if empty
    grade_letter()       — A/B/C/D/F based on average
    is_passing()         — average >= 50
    status_report()      — formatted string summary
    __str__()            — "Ahmed (Grade 10) — Avg: 85.3 [B]"

Classroom:
  init: class_name, teacher, students=[]
  Methods:
    add_student(name, grade, *scores)
    find_student(name)       — case-insensitive search
    remove_student(name)
    class_average()
    top_students(n=3)
    failing_students()
    print_report()
    save_to_file(filename)
    load_from_file(filename)

ERRORS TO HANDLE:
─────────────────
  File not found on startup → start with empty roster
  Invalid score input → ask again
  Student not found → friendly message, no crash
  Empty roster → "No students" message in report
"""

print("Plan written. Now let's build it.")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Write the full planning document for the SMS in a Python file as a docstring or comments.
Include:
1. All requirements (at least 8)
2. Both class designs with all attributes and methods listed
3. The file format you'll use
4. Three error cases you'll handle
5. What Level 3 could add on top of this (APIs, web interface, database, etc.)
This document becomes the blueprint for the next 3 lessons.`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `Why is time spent planning before coding considered professional practice, not wasted time?`,
              code: ``,
              options: [{ id: "A", text: `Companies require documentation for legal reasons` }, { id: "B", text: `Planning reveals design problems early — when they're cheap to fix in comments, not expensive to fix in code` }, { id: "C", text: `Clients want to see planning documents` }, { id: "D", text: `Python requires a plan file before running` }],
              correct: "B",
              explanation: `Problems found in a plan take seconds to fix (edit the comment). Problems found after coding take hours to fix (refactor the code). The earlier you find a problem, the cheaper it is.`
            },
          keyPoints: [`Plan before you code — requirements, classes, methods, data flow`, `Design the file format before writing the save/load functions`, `List the errors you'll handle before writing try/except blocks`, `A good plan means the code writes itself — each method is already described`],
          youtube: `Python project planning OOP design beginners`
        },

        {
          id: "lesson-pyl2-10-2",
          slug: "lesson-pyl2-10-2",
          lesson_number: 2,
          title: `Building the Core — Student and Classroom Classes`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `We have the plan. Let's code.`,
            cody: `We'll build from the inside out. Student class first — it doesn't depend on anything. Classroom next — it uses Student objects. File I/O last — it uses both. Test each layer before building the next.`
          },
          concept: {
            title: `Implement the planned classes from Lesson 10.1 with all core methods.`,
            body: `The student builds working Student and Classroom classes, integrating everything from Chapters 8 and 9.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `# ── student.py (or include inline) ────────────────────
class Student:
    def __init__(self, name, grade, scores=None):
        self.name   = name
        self.grade  = int(grade)
        self.scores = scores if scores is not None else []

    def add_score(self, score):
        try:
            s = float(score)
            if 0 <= s <= 100:
                self.scores.append(s)
                return True
            else:
                print(f"  Score must be 0-100, got {s}")
                return False
        except (ValueError, TypeError):
            print(f"  Invalid score: {score!r}")
            return False

    def average(self):
        return sum(self.scores) / len(self.scores) if self.scores else 0

    def grade_letter(self):
        avg = self.average()
        for threshold, letter in [(90,"A"),(80,"B"),(70,"C"),(60,"D")]:
            if avg >= threshold:
                return letter
        return "F"

    def is_passing(self):
        return self.average() >= 50

    def status_report(self):
        scores_str = ", ".join(f"{s:.0f}" for s in self.scores) or "No scores"
        return (f"{'─'*40}\\n"
                f"  Name:    {self.name}\\n"
                f"  Grade:   {self.grade}\\n"
                f"  Scores:  {scores_str}\\n"
                f"  Average: {self.average():.1f}\\n"
                f"  Letter:  {self.grade_letter()}\\n"
                f"  Status:  {'Passing ✔' if self.is_passing() else 'Failing ✘'}")

    def __str__(self):
        return (f"{self.name:<15} Gr.{self.grade}  "
                f"Avg:{self.average():5.1f}  "
                f"{self.grade_letter()}  "
                f"{'✔' if self.is_passing() else '✘'}")`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Test Student class thoroughly before building Classroom
class Student:
    def __init__(self, name, grade, scores=None):
        self.name   = name
        self.grade  = int(grade)
        self.scores = scores if scores else []

    def add_score(self, score):
        self.scores.append(float(score))

    def average(self):
        return sum(self.scores) / len(self.scores) if self.scores else 0

    def grade_letter(self):
        avg = self.average()
        for t, l in [(90,"A"),(80,"B"),(70,"C"),(60,"D")]:
            if avg >= t: return l
        return "F"

    def is_passing(self): return self.average() >= 50

    def __str__(self):
        return f"{self.name} — Avg: {self.average():.1f} [{self.grade_letter()}]"

# ── Tests ──────────────────────────────────────────────
s = Student("Ahmed", 10)
s.add_score(85)
s.add_score(92)
s.add_score(78)
print(s)
print(f"Passing: {s.is_passing()}")

s2 = Student("Sara", 11, [42, 38, 55])
print(s2)
print(f"Passing: {s2.is_passing()}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Implement the Classroom class with at least:
1. __init__(self, class_name, teacher)
2. add_student(name, grade, *scores)
3. find_student(name) — case-insensitive
4. remove_student(name)
5. class_average()
6. print_report()
Test it with at least 5 students`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `What Python data structure best represents a single student with a name, grade, and list of scores?`,
              code: ``,
              options: [{ id: "A", text: `A list like ["Shady", 10, [95, 87, 92]]` }, { id: "B", text: `A class with name, grade, and scores attributes` }, { id: "C", text: `A dictionary with random keys` }, { id: "D", text: `A tuple — because it is immutable` }],
              correct: "B",
              explanation: `A class bundles data (attributes) and behavior (methods) together. A Student class with name, grade, and scores is exactly what OOP is designed for — it is cleaner, more readable, and more extensible than a list or dict.`
            },
          keyPoints: [],
          youtube: ``
        },

        {
          id: "lesson-pyl2-10-3",
          slug: "lesson-pyl2-10-3",
          lesson_number: 3,
          title: `File I/O and Full System Integration`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `The classes work. But if I restart, everything's gone again. What about all the places where the user could crash the program?`,
            cody: `File I/O — the last piece. Save on exit, load on start. We'll use CSV and os.path.exists to handle the first run. try/except around every user input. The get_int() and get_float() functions from Chapter 6. Import datetime to timestamp the report. Everything you've learned — all in one program.`
          },
          concept: {
            title: `Add persistence (save/load) and error handling to complete the Student Management System.`,
            body: `The student adds file I/O to the Classroom class and wraps the whole system in a menu-driven main loop.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `import csv, os, datetime
from safe_input import get_int, get_float, get_non_empty_string   # ch.6 utility

FILENAME = "classroom_data.csv"

class Classroom:
    # ... (add_student, find_student, etc. from 10.2)

    def save_to_file(self, filename=FILENAME):
        with open(filename, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["name", "grade", "scores"])
            for s in self.students:
                scores_str = ",".join(str(sc) for sc in s.scores)
                writer.writerow([s.name, s.grade, scores_str])
        print(f"  Saved {len(self.students)} students to {filename}")

    def load_from_file(self, filename=FILENAME):
        if not os.path.exists(filename):
            return
        try:
            with open(filename, "r") as f:
                reader = csv.reader(f)
                next(reader)    # skip header
                for row in reader:
                    if len(row) >= 2:
                        name, grade = row[0], row[1]
                        scores = [float(x) for x in row[2].split(",") if x] if len(row) > 2 else []
                        self.students.append(Student(name, grade, scores))
            print(f"  Loaded {len(self.students)} students from {filename}")
        except Exception as e:
            print(f"  Load error: {e}")


# ── Main application ───────────────────────────────────
def main():
    room = Classroom("10-A", "Mr. Cody")
    room.load_from_file()

    menu = """
╔═══════════════════════════╗
║  Student Management SMS   ║
╠═══════════════════════════╣
║  1. Add student           ║
║  2. Look up student       ║
║  3. Add scores            ║
║  4. Remove student        ║
║  5. Class report          ║
║  6. Top students          ║
║  7. Failing students      ║
║  8. Save & exit           ║
╚═══════════════════════════╝"""

    while True:
        print(menu)
        choice = input("Choice (1-8): ").strip()

        if choice == "1":
            name  = get_non_empty_string("  Name: ")
            grade = get_int("  Grade (1-12): ", 1, 12)
            student = room.add_student(name, grade)

        elif choice == "2":
            name = input("  Name: ").strip()
            s = room.find_student(name)
            if s: print(s.status_report())
            else: print(f"  '{name}' not found.")

        elif choice == "3":
            name = input("  Student name: ").strip()
            s = room.find_student(name)
            if s:
                score = get_float("  Score (0-100): ", 0, 100)
                s.add_score(score)
                print(f"  New average: {s.average():.1f}")
            else:
                print(f"  '{name}' not found.")

        elif choice == "4":
            name = input("  Name to remove: ").strip()
            room.remove_student(name)

        elif choice == "5":
            room.print_report()

        elif choice == "6":
            n = get_int("  How many top students? ", 1, len(room.students) or 1)
            for i, s in enumerate(room.top_students(n), 1):
                print(f"  #{i} {s}")

        elif choice == "7":
            failing = room.failing_students()
            if failing:
                print(f"  Failing ({len(failing)}):")
                for s in failing: print(f"    {s}")
            else:
                print("  All students are passing!")

        elif choice == "8":
            room.save_to_file()
            print(f"\\n  Saved at {datetime.datetime.now().strftime('%H:%M:%S')}")
            print("  Goodbye!")
            break

        else:
            print("  Invalid choice — 1 to 8.")

main()`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Test your Student Management System integration
# Add file I/O to your Classroom class

import os

# Simulate save/load cycle
def save_students(filename, students):
    with open(filename, "w") as f:
        for name, avg in students:
            f.write(f"{name},{avg}\\n")
    print(f"Saved {len(students)} students to {filename}")

def load_students(filename):
    if not os.path.exists(filename):
        print("No save file found — starting fresh.")
        return []
    students = []
    with open(filename) as f:
        for line in f:
            parts = line.strip().split(",")
            if len(parts) == 2:
                students.append((parts[0], float(parts[1])))
    print(f"Loaded {len(students)} students")
    return students

# Test the cycle
test_data = [("Shady", 88.5), ("Ali", 92.0), ("Nour", 75.5)]
save_students("test_roster.csv", test_data)
loaded = load_students("test_roster.csv")
for name, avg in loaded:
    print(f"  {name}: {avg:.1f}")`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Add two more features to the system:
1. Export report to a text file (choice 9):
   - Same content as print_report() but written to "report_YYYY-MM-DD.txt"
   - Include a timestamp in the file header
2. Show grade distribution (choice 10):
   - How many A, B, C, D, F grades in the class
   - Show as both counts and percentages
   - Bonus: show a text bar chart using ▓ characters`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `When saving student data to CSV and reloading it, which function should you call FIRST on startup?`,
              code: ``,
              options: [{ id: "A", text: `save_to_file() — to make sure the file exists` }, { id: "B", text: `load_from_file() — to restore previous session data` }, { id: "C", text: `print_report() — to display what is saved` }, { id: "D", text: `add_student() — to add a test student first` }],
              correct: "B",
              explanation: `On startup, load_from_file() restores any previously saved data. If no file exists, os.path.exists() catches that and the program starts with an empty roster. Saving happens only on exit (choice 8 in the menu).`
            },
          keyPoints: [],
          youtube: ``
        },

        {
          id: "lesson-pyl2-10-4",
          slug: "lesson-pyl2-10-4",
          lesson_number: 4,
          title: `Polish and What's Next`,
          duration: 22,
          xp: 25,
          dialogue: {
            shady: `I built a real program. Not practice code — a real program. What's Level 3?`,
            cody: `Run it. Does it work? That's the difference between code that works in theory and code that works in production. You added error handling. You added validation. The program is resilient. You did. And more importantly — you understand everything in it. Every line. Every class. Every file operation. That's what Level 2 was for. The same solid foundation — applied to bigger things.`
          },
          concept: {
            title: `Final refinements, reflection on everything learned, and a clear preview of what Level 3 adds.`,
            body: `The student completes, tests, and reflects on the capstone project, and understands what Python mastery looks like next.`
          },
          showcase: {
            title: "Example",
            language: "Python",
            code: `"""
PYTHON FOUNDATIONS — LEVEL 2 — COMPLETE

Ch.1  Strings Deep Dive
      → slicing, all methods, formatting, text analyser

Ch.2  Dictionaries
      → key-value pairs, .get(), .items(), grade book

Ch.3  Tuples and Sets
      → immutability, set operations, choosing structures

Ch.4  File I/O
      → read/write/append, CSV, persistent data

Ch.5  Modules
      → math, random, datetime, os, import styles

Ch.6  Error Handling
      → try/except, finally, raise, bulletproof input

Ch.7  Comprehensions
      → list, dict, set comprehensions, filtering

Ch.8  Advanced Functions
      → scope, default args, *args/**kwargs, lambda

Ch.9  OOP Introduction
      → classes, objects, __init__, self, methods

Ch.10 Capstone
      → Student Management System using everything above
"""`,
            explanation: "Study the example and try it in the playground."
          },
          playground: {
            title: "Playground",
            language: "Python",
            code: `# Final checklist — test your complete SMS against these cases

test_cases = [
    ("Add valid student",     "Normal operation — should work"),
    ("Add student duplicate", "Should handle gracefully"),
    ("Look up missing name",  "Should say 'not found', not crash"),
    ("Score = 101",           "Should reject with message"),
    ("Score = 'hello'",       "Should ask again"),
    ("Empty roster report",   "Should print 'No students'"),
    ("Save and reload",       "Data should persist between runs"),
    ("Remove last student",   "Roster becomes empty — all functions still work"),
]

print("Run your SMS and test each scenario below:")
for i, (test, expected) in enumerate(test_cases, 1):
    print(f"  {i:2}. Test: {test}")
    print(f"       Expected: {expected}")
    print()`,
            instruction: "Edit the values freely and press Run Code to experiment."
          },
          challenge: {
            title: "Mission",
            instruction: `Write the final version of your Student Management System that:
1. Passes ALL 8 test cases from the playground above
2. Has at least 10 choices in the menu
3. Saves data persistently between sessions
4. Never crashes on any user input
5. Has a properly formatted class report with aligned columns
Submit the complete, working program as your Level 2 Capstone.`,
            language: "Python",
            initialCode: `# Write your solution here\n`,
            solutionCode: ``
          },
          quickCheck: {
              question: `You built the SMS in Python using OOP, file I/O, and error handling. What makes it a "real program" rather than just practice code?`,
              code: ``,
              options: [{ id: "A", text: `It has more than 100 lines` }, { id: "B", text: `It uses classes` }, { id: "C", text: `It persists data, handles all user errors gracefully, and solves a genuine real-world problem` }, { id: "D", text: `It imports modules` }],
              correct: "C",
              explanation: `A "real program" is defined by its reliability and usefulness, not its length. Persistence (data survives restarts), robustness (no crashes from bad input), and solving a real problem — those are the marks of production-quality code.`
            },
          keyPoints: [`Level 2 complete: strings, dicts, tuples, sets, files, modules, errors, comprehensions, functions, OOP`, `Level 3 adds: web APIs, decorators, generators, inheritance, regex, databases, data analysis`, `The foundation you built here is the foundation every Python developer uses`, `Testing your code against edge cases is as important as writing it`],
          youtube: `Python intermediate projects next steps learning`
        },

      ]
    },

  ]
};

if (typeof window !== 'undefined') {
  window.PYTHON_LEVEL2_COURSE = PYTHON_LEVEL2_COURSE;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { PYTHON_LEVEL2_COURSE };
}
