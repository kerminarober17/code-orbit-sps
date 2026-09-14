-- SPS Code Orbit 2-Course Production Curriculum SQL Dump
-- Authoritative production curriculum (Programming Foundations + Python Foundations)

SET FOREIGN_KEY_CHECKS = 0;

-- Ensure standard Academic Groups exist
INSERT INTO academic_groups (id, name, description) VALUES
('ag-prep', 'Preparatory', 'Interactive coding and web adventures for preparatory students'),
('ag-p34', 'Primary 3 & 4', 'Visual programming logic and computational thinking'),
('ag-p56', 'Primary 5 & 6', 'Creative coding and interactive Python adventures'),
('ag-sec', 'Secondary', 'Advanced computer science and full-stack software development')
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description);

SET FOREIGN_KEY_CHECKS = 1;

-- Course: Programming Foundations — Start Here
INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at) VALUES (
  'course-programming-foundations',
  'ag-prep',
  'Programming Foundations — Start Here',
  'programming-foundations',
  'The complete foundational course: discover what programming truly is, how computers and the internet work, and master algorithmic thinking before writing code in any language.',
  '/assets/courses/prog.png',
  '#70D6FF',
  1, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), description = VALUES(description), is_published = 1, image_url = VALUES(image_url), accent_color = VALUES(accent_color);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-01',
  'course-programming-foundations',
  'chap-pf-01-technology-around-us',
  1,
  'Chapter 1: Technology All Around Us',
  'Technology isn\'t magic — it is smart tools built with code. Discover hardware vs. software, the Input/Process/Output cycle, and the binary language of 0s and 1s.',
  '💡',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-1',
  'chap-pf-01',
  'pf-1-1-technology-in-our-lives',
  1,
  '1.1: Technology in Everyday Life',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-1',
  'lesson-pf-1-1',
  'dialogue',
  1,
  '{"shady":"I woke up to my phone\'s alarm, took the elevator down, waited at the pedestrian traffic light, and hopped on the bus. Just an ordinary morning! 😅","cody":"Look closely, Shady! Every single moment of your morning was powered by technology running code written by programmers!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-2',
  'lesson-pf-1-1',
  'dialogue',
  2,
  '{"shady":"Wait, the elevator and traffic lights are programmed with code too?!","cody":"Absolutely! Every modern device follows instructions written by software engineers to know when to open doors, change light signals, and navigate routes. Code is everywhere around you!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-3',
  'lesson-pf-1-1',
  'text',
  3,
  '{"title":"What is Technology Really?","body":"Technology is any tool, system, or machine created by humans to solve problems and make daily life easier.<br><br>Most modern technology runs on <strong>Software</strong> — precise programs written by programmers:<br>• 📱 <strong>Smartphones:</strong> Run thousands of complex apps seamlessly.<br>• 🚦 <strong>Traffic Lights:</strong> Smart algorithms adjust timings to prevent traffic jams.<br>• 🏧 <strong>ATM Machines:</strong> Secure banking code verifies your account and dispenses cash in seconds.<br>• 🎮 <strong>Video Games:</strong> Millions of lines of code calculate physics, render 3D graphics, and create immersive worlds.<br>• 🏥 <strong>Hospital Equipment:</strong> Life-saving monitors track patient vitals around the clock."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-4',
  'lesson-pf-1-1',
  'quick_check',
  4,
  '{"title":"Quick Check: Identify Technology","question":"Which of the following devices relies on a computer program (software) to function?","options":{"A":"A standard wooden pencil","B":"A digital microwave oven with preset timers","C":"A ceramic coffee mug","D":"A metal paperclip"},"correct":"B","explanation":"A digital microwave uses an embedded microchip running software routines to read inputs, manage cook times, and control power."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-5',
  'lesson-pf-1-1',
  'text',
  5,
  '{"title":"Hands-on Exercise: Classify Your World","body":"Think about items around your room right now and classify them:<br>1. A tree branch outside your window → Natural object, not technology.<br>2. A regular wooden ruler → Mechanical measuring tool without code.<br>3. A smart thermostat that adjusts room temperature automatically → Digital technology powered by code.<br>4. Wireless Bluetooth headphones → Advanced technology running communication protocols."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-2',
  'chap-pf-01',
  'pf-1-2-hardware-vs-software',
  2,
  '1.2: Hardware vs. Software — What\'s the Difference?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-1',
  'lesson-pf-1-2',
  'dialogue',
  1,
  '{"shady":"Cody! My computer suddenly froze and showed a strange error message! Did something physically break inside?","cody":"First step, Shady: did a wire disconnect or did a physical piece snap off?"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-2',
  'lesson-pf-1-2',
  'dialogue',
  2,
  '{"shady":"No, the computer itself looks totally fine. Just the app crashed and closed!","cody":"Aha! Physical damage = Hardware issue. Application crashes and error dialogs = Software issue. They work together as one team!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-3',
  'lesson-pf-1-2',
  'text',
  3,
  '{"title":"Crucial Comparison: Hardware vs. Software","body":"<strong>1. Hardware (The Physical Machine):</strong><br>Every tangible component you can physically touch with your hands:<br>• The Screen/Monitor, Keyboard, and Mouse.<br>• Central Processing Unit (CPU): The \'brain\' that executes billions of calculations per second.<br>• RAM (Random Access Memory): Super-fast temporary workspace for open apps.<br>• Storage Drive (SSD / HDD): Permanent storage for files, photos, and operating systems.<br><br><strong>2. Software (The Digital Instructions):</strong><br>The programs and code that bring hardware to life:<br>• Operating Systems (Windows, macOS, iOS, Android).<br>• Applications: Web browsers, WhatsApp, Photoshop, VS Code.<br>• Video games and graphical rendering engines.<br><br><strong>The Golden Rule:</strong><br><em>Hardware without Software = A lifeless box of metal and silicon.<br>Software without Hardware = Ideas and instructions with no machine to execute them!</em>"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-4',
  'lesson-pf-1-2',
  'quick_check',
  4,
  '{"title":"Quick Check: Hardware or Software?","question":"If WhatsApp crashes due to a coding bug in an update, this is an issue with:","options":{"A":"Hardware","B":"Software","C":"The phone\'s glass screen","D":"The charging cable"},"correct":"B","explanation":"WhatsApp is a software application. An application crash caused by a code bug is purely a software issue."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-3',
  'chap-pf-01',
  'pf-1-3-input-process-output',
  3,
  '1.3: What Does a Computer Actually Do? (Input → Process → Output)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-3-1',
  'lesson-pf-1-3',
  'dialogue',
  1,
  '{"shady":"I typed a query into Google and hit Enter... and in less than half a second, millions of results appeared! What just happened inside the computer?","cody":"Great question, Shady! Every computing operation on planet Earth passes through three fundamental stations: Input → Process → Output!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-3-2',
  'lesson-pf-1-3',
  'text',
  2,
  '{"title":"The Universal Computing Cycle: Input → Process → Output","body":"<strong>1. Input (Feeding Data In):</strong><br>Information and commands you provide to the computer via keyboard, mouse, touchscreen, microphone, or camera.<br><br><strong>2. Process (Computing & Thinking):</strong><br>The Central Processing Unit (CPU) performs operations step-by-step according to software rules: comparing, calculating, searching, sorting, and transforming data.<br><br><strong>3. Output (Delivering Results):</strong><br>The final outcome displayed to you: graphics on a screen, sound through speakers, or text printed on paper.<br><br><strong>Real-World Examples:</strong><br>• <strong>Calculator:</strong> You press 5 + 3 (Input) → CPU adds them together (Process) → Screen displays 8 (Output).<br>• <strong>Racing Game:</strong> You tap the right arrow key (Input) → Game engine calculates physics and steering angle (Process) → Car turns smoothly on the track (Output)."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-3-3',
  'lesson-pf-1-3',
  'quick_check',
  3,
  '{"title":"Quick Check: IPO Cycle","question":"In a gaming console: pressing the jump button is ______, while seeing your character leap on screen is ______:","options":{"A":"Output / Input","B":"Input / Output","C":"Process / Input","D":"Output / Process"},"correct":"B","explanation":"Pressing the button inputs a command into the system, and the visual animation displayed on screen is the output."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-4',
  'chap-pf-01',
  'pf-1-4-how-computers-think-binary',
  4,
  '1.4: How Computers Think (Binary: 0 and 1)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-4-1',
  'lesson-pf-1-4',
  'dialogue',
  1,
  '{"shady":"Cody, if computers are so smart, why can\'t I just tell it in plain English: \'Calculate my exam grades\' without any code?","cody":"Because deep down inside, a computer is an electronic machine! It doesn\'t understand letters or words — it only understands tiny electrical signals: ON (1) and OFF (0)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-4-2',
  'lesson-pf-1-4',
  'text',
  2,
  '{"title":"The Machine\'s True Language: The Binary System","body":"A computer\'s processor is built with billions of microscopic electrical switches called <strong>transistors</strong>.<br>Each transistor can only be in one of two states:<br>• Switch ON / Current flowing = <strong>1</strong><br>• Switch OFF / No current = <strong>0</strong><br><br><strong>How Does Everything Turn Into 0s and 1s?</strong><br>• The letter \'A\' is represented in standard ASCII binary as: <code>01000001</code><br>• The number 7 is represented in binary as: <code>00000111</code><br>• Colors, images, audio, and 4K videos are all broken down into vast sequences of 0s and 1s.<br><br><strong>Why Do We Need Programming Languages?</strong><br>Instead of manually typing thousands of binary digits like <code>01110000 01110010 01101001 01101110 01110100</code>, we write an elegant Python command: <code>print(\\"Hello\\")</code>. The programming language translates our command into binary in a fraction of a millisecond!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-4-3',
  'lesson-pf-1-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Binary System","question":"In digital circuits, the \'ON\' state represents the digit ____, and the \'OFF\' state represents the digit ____:","options":{"A":"0 then 1","B":"1 then 0","C":"2 then 1","D":"1 then 2"},"correct":"B","explanation":"In binary logic, electricity flowing (ON) is represented by 1, and electricity stopped (OFF) is represented by 0."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-02',
  'course-programming-foundations',
  'chap-pf-02-what-is-a-program',
  2,
  'Chapter 2: What is a Program?',
  'A program is a precise step-by-step recipe. Master sequential execution (Sequence), decision-making with conditions (IF/ELSE), and repetition with loops (Loops).',
  '📜',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-1',
  'chap-pf-02',
  'pf-2-1-programs-like-recipes',
  1,
  '2.1: Programs Are Exact Recipes',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-1-1',
  'lesson-pf-2-1',
  'dialogue',
  1,
  '{"shady":"Cody, I told a robot to \'make me a sandwich\', and it put a sealed cheese wrapper right between two bread slices without opening it! 😅","cody":"Haha! That\'s because you didn\'t say \'open the wrapper first\'! A computer follows instructions literally — it never assumes anything!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-1-2',
  'lesson-pf-2-1',
  'text',
  2,
  '{"title":"A Program = An Unambiguous Recipe","body":"Imagine writing a recipe for someone who has never seen a kitchen in their life:<br>• If you tell them \'bake a cake\', they will stand there confused!<br>• But an exact, step-by-step recipe works every time:<br>&nbsp;&nbsp;1. Take a clean mixing bowl.<br>&nbsp;&nbsp;2. Add 2 cups of flour.<br>&nbsp;&nbsp;3. Add 2 eggs and whisk for 3 minutes.<br>&nbsp;&nbsp;4. Preheat the oven to 180°C and bake for 25 minutes.<br><br><strong>In Programming:</strong><br>A program is an ordered list of exact, unambiguous instructions. If you miss a step or leave room for ambiguity, the program encounters an error called a <strong>Bug</strong>!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-1-3',
  'lesson-pf-2-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Precise Instructions","question":"If you command a robot \'Walk forward\' without giving a distance or stop condition, what happens?","options":{"A":"It walks two steps and stops politely","B":"It continues walking until it hits a wall because no stop condition was specified","C":"It walks backward","D":"It asks you for clarification"},"correct":"B","explanation":"Computers lack human intuition; without a specific boundary or stopping condition, it repeats the command indefinitely."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-2',
  'chap-pf-02',
  'pf-2-2-order-matters-sequence',
  2,
  '2.2: Order Matters — Sequence',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-2-1',
  'lesson-pf-2-2',
  'dialogue',
  1,
  '{"shady":"Once when I was in a rush, I put my shoes on before my socks... It was a total disaster and I couldn\'t walk! 😂","cody":"A great real-life lesson, Shady! Order is everything. In computer science, this foundational rule is called: Sequence!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-2-2',
  'lesson-pf-2-2',
  'text',
  2,
  '{"title":"The Principle of Sequence in Code","body":"Computers read code just like humans read an English book: <strong>line by line, from top to bottom</strong>.<br><br><strong>Logical Sequence Example:</strong><br>❌ Incorrect order breaking logic:<br>1. Squeeze toothpaste onto brush.<br>2. Unscrew the toothpaste cap.<br>3. Pick up the toothbrush from the cup.<br><br>✅ Correct logical Sequence:<br>1. Pick up the toothbrush from the cup.<br>2. Unscrew the toothpaste cap.<br>3. Squeeze toothpaste onto brush.<br><br><strong>In Code:</strong> If you try to display or print a calculation before calculating it, the program will crash with an error!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-2-3',
  'lesson-pf-2-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Sequence in Code","question":"In a program: Line 1 calculates \'total = 5 + 3\', and Line 2 displays \'print(total)\'. What happens if you swap their order?","options":{"A":"The program works normally","B":"An error occurs because the program tries to print a variable before it exists","C":"The result doubles to 16","D":"The computer waits until Line 2 is calculated"},"correct":"B","explanation":"Due to sequential execution, you cannot use or display a variable before it has been created and assigned in a previous line."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-3',
  'chap-pf-02',
  'pf-2-3-programs-make-decisions-conditions',
  3,
  '2.3: Programs Make Decisions (Conditions: IF / ELSE)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-3-1',
  'lesson-pf-2-3',
  'dialogue',
  1,
  '{"shady":"Every morning I check the weather: if it\'s raining, I grab an umbrella; otherwise, I put on sunglasses!","cody":"That is pure programmer logic, Shady! You just executed a condition: IF it is raining THEN take umbrella ELSE wear sunglasses!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-3-2',
  'lesson-pf-2-3',
  'text',
  2,
  '{"title":"Conditional Logic: How Programs Make Smart Decisions","body":"Smart programs don\'t just blindly repeat the same actions. They evaluate a situation by asking a question whose answer is either <strong>True (Yes)</strong> or <strong>False (No)</strong>.<br><br><strong>Structure of an IF / ELSE Statement:</strong><br><code>IF (a specific condition is True):<br>&nbsp;&nbsp;&nbsp;&nbsp;Execute Path A<br>ELSE:<br>&nbsp;&nbsp;&nbsp;&nbsp;Execute Path B</code><br><br><strong>Everyday Real Examples:</strong><br>• <strong>ATM Machine:</strong> IF your account balance ≥ withdrawal amount ← Dispense cash ELSE display \'Insufficient funds\'.<br>• <strong>School Portal:</strong> IF student score ≥ 50 ← Display \'Congratulations, you passed!\' ELSE display \'Please retake the quiz\'."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-3-3',
  'lesson-pf-2-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Decision Making","question":"In a video game: \'If player coins reach 100, award an extra life.\' What programming concept is this?","options":{"A":"A Loop","B":"A Condition (IF Statement)","C":"Hardware component","D":"Compiler"},"correct":"B","explanation":"This is a conditional statement: when the condition (coins >= 100) becomes True, the reward is granted."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-4',
  'chap-pf-02',
  'pf-2-4-programs-repeat-loops',
  4,
  '2.4: Programs Repeat — Loops',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-4-1',
  'lesson-pf-2-4',
  'dialogue',
  1,
  '{"shady":"Every day I wake up, brush my teeth, eat breakfast, go to school, study, sleep... and repeat tomorrow! Repetition is exhausting 😴","cody":"You\'re living in a loop, Shady! Repetition is tiring for humans, but it\'s a computer\'s superpower! Programs can repeat tasks millions of times per second without ever getting tired!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-4-2',
  'lesson-pf-2-4',
  'text',
  2,
  '{"title":"Loops: The Power of Automation","body":"A <strong>Loop</strong> repeatedly executes a block of code multiple times without needing to write the code over and over again.<br><br><strong>Visual Comparison:</strong><br>❌ Without a Loop (Exhausting and messy):<br><code>print(\\"Hello\\")<br>print(\\"Hello\\")<br>print(\\"Hello\\")<br>print(\\"Hello\\")<br>print(\\"Hello\\")</code><br><br>✅ With a Loop (Clean and scalable):<br><code>REPEAT 5 times:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(\\"Hello\\")</code><br><br><strong>Two Main Types of Loops:</strong><br>1. <strong>Count-controlled Loop:</strong> Runs a predetermined number of times (e.g., send report cards to 30 students).<br>2. <strong>Condition-controlled Loop:</strong> Runs until a specific condition becomes True or False (e.g., keep ringing the alarm until the user hits the snooze button)."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-4-3',
  'lesson-pf-2-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Loops","question":"Which scenario represents the best use of a loop with a stopping condition?","options":{"A":"Adding two numbers together once","B":"Continuing to prompt the user for their password until they enter the correct one","C":"Displaying the title of a website","D":"Closing a laptop lid"},"correct":"B","explanation":"The attempt repeats continuously in a loop and stops only when the condition (password is correct) is satisfied."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-03',
  'course-programming-foundations',
  'chap-pf-03-algorithms-problem-solving',
  3,
  'Chapter 3: Algorithms — The Art of Problem Solving',
  'An algorithm is the logical plan before writing code. Learn the 3 rules of an algorithm, visual flowcharts, pseudocode planning, and how to debug errors.',
  '🧩',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-1',
  'chap-pf-03',
  'pf-3-1-what-is-an-algorithm',
  1,
  '3.1: What is an Algorithm?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-1-1',
  'lesson-pf-3-1',
  'dialogue',
  1,
  '{"shady":"Google searches through billions of web pages and finds what I want in a fraction of a second! How is that even possible?!","cody":"No accidents in computer science, Shady! It is powered by brilliant algorithms! Great programmers design the plan and solution first, then write the code!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-1-2',
  'lesson-pf-3-1',
  'text',
  2,
  '{"title":"The Algorithm: The Blueprint Before the Code","body":"Named after the historic Persian mathematician <strong>Muhammad ibn Musa al-Khwarizmi</strong>, an algorithm is: <em>A finite, step-by-step procedure designed to solve a problem or accomplish a task</em>.<br><br><strong>3 Mandatory Conditions for a Valid Algorithm:</strong><br>1. <strong>Clear & Unambiguous:</strong> Every instruction leaves no room for confusion or multiple interpretations.<br>2. <strong>Finite (Has a definite end):</strong> It cannot run in an endless void forever; it must finish and produce a result.<br>3. <strong>Effective:</strong> Every step must be realistically executable and actually solve the problem.<br><br><strong>Example: Finding the Tallest Student in Class:</strong><br>1. Assume the first student is currently the \'Tallest\'.<br>2. Stand in front of the next student and compare their height with \'Tallest\'.<br>3. If this student is taller, update \'Tallest\' to be this student.<br>4. Repeat step 2 and 3 for all remaining students.<br>5. The student left in the \'Tallest\' spot is the tallest in class!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-1-3',
  'lesson-pf-3-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Algorithms","question":"Navigation apps like Google Maps finding the fastest route to avoid traffic rely on:","options":{"A":"A smart pathfinding algorithm (like Dijkstra\'s algorithm)","B":"Random guessing","C":"Turning off street lights","D":"Coin flips"},"correct":"A","explanation":"Navigation software utilizes pathfinding algorithms to compute the shortest and fastest route across complex road networks."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-2',
  'chap-pf-03',
  'pf-3-2-flowcharts-visual-logic',
  2,
  '3.2: Visualizing Logic — Flowcharts',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-2-1',
  'lesson-pf-3-2',
  'dialogue',
  1,
  '{"shady":"I wrote out an algorithm in a whole page of text, but my friend got lost trying to follow the decision paths!","cody":"A picture is worth a thousand words, Shady! In software engineering, we map algorithms visually using a diagram called a Flowchart!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-2-2',
  'lesson-pf-3-2',
  'text',
  2,
  '{"title":"Flowcharts: The Visual Map of Program Flow","body":"A <strong>Flowchart</strong> is a visual diagram that illustrates the sequence of steps and decision paths in a program from start to finish.<br><br><strong>Universal Flowchart Symbols:</strong><br>• ⭕ <strong>Oval (Terminal):</strong> Represents the START or END of the program.<br>• ⬜ <strong>Rectangle (Process):</strong> Represents an action or calculation (e.g., total = a + b).<br>• ▱ <strong>Parallelogram (Input / Output):</strong> Represents receiving user input or displaying output to the screen.<br>• 🔷 <strong>Diamond (Decision):</strong> Represents a condition or question with two arrows branching out: one for (YES) and one for (NO).<br>• ➡️ <strong>Flowline Arrows:</strong> Connect symbols and indicate the direction of execution."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-2-3',
  'lesson-pf-3-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Flowchart Shapes","question":"Which geometric shape should you use to represent: \'Enter Username and Password\'?","options":{"A":"Diamond (Decision)","B":"Parallelogram (Input / Output)","C":"Oval (Terminal)","D":"Hexagon"},"correct":"B","explanation":"Parallelograms are reserved specifically for Input (entering credentials) and Output operations."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-3',
  'chap-pf-03',
  'pf-3-3-pseudocode-planning-logic',
  3,
  '3.3: Pseudocode — Planning Before Code',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-3-1',
  'lesson-pf-3-3',
  'dialogue',
  1,
  '{"shady":"Cody, I want to code my project, but I get overwhelmed worrying about brackets, colons, and semicolons!","cody":"Professional programmers use a secret weapon: Pseudocode! It\'s an informal way to write program logic using simple plain English before typing actual code."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-3-2',
  'lesson-pf-3-3',
  'text',
  2,
  '{"title":"What is Pseudocode and Why Do Engineers Love It?","body":"<strong>Pseudocode</strong> (\'pseudo\' meaning imitation) is an informal, human-readable outline of a program that mimics code structure without strict syntax rules.<br><br><strong>Key Benefits of Pseudocode:</strong><br>• No compiler errors: no editor will yell at you for missing a colon.<br>• Uses intuitive keywords: START, INPUT, IF, ELSE, REPEAT, PRINT, END.<br>• Bridges the gap between an idea in your head and code in an editor.<br><br><strong>Example: Student Pass/Fail Checker:</strong><br><pre style=\\"background:#0F172A; padding:12px; border-radius:8px; color:#38BDF8;\\">START\\n  INPUT student_score\\n  IF student_score >= 50 THEN\\n      PRINT \\"Congratulations! You passed! 🎉\\"\\n  ELSE\\n      PRINT \\"Keep practicing and try again! 💪\\"\\n  END IF\\nEND</pre>"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-3-3',
  'lesson-pf-3-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Pseudocode","question":"Can a computer execute pseudocode directly?","options":{"A":"Yes, because computers understand all human writing","B":"No, pseudocode is written for humans to plan logic and must be converted to a real programming language to run","C":"Yes, if written in capital letters","D":"Yes, if it has no spelling errors"},"correct":"B","explanation":"Pseudocode is an informal design tool for human readers; machines require actual programming languages."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-4',
  'chap-pf-03',
  'pf-3-4-debugging-fixing-errors',
  4,
  '3.4: Debugging — When Things Go Wrong',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-4-1',
  'lesson-pf-3-4',
  'dialogue',
  1,
  '{"shady":"Cody! I ran my code and scary red error text popped up! Does this mean I\'m terrible at programming? 😞","cody":"Not at all, Shady! Every programmer on Earth — even senior engineers at Google — gets errors every day! Bugs aren\'t failures; they are puzzles waiting to be solved through Debugging!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-4-2',
  'lesson-pf-3-4',
  'text',
  2,
  '{"title":"The Story of the Very First Computer Bug!","body":"In 1947, computer pioneer <strong>Grace Hopper</strong> was working on the Harvard Mark II computer (a machine that filled an entire room). Suddenly, the system malfunctioned.<br>When technicians inspected the relays, they discovered an actual <strong>moth</strong> trapped inside! They taped the insect into their logbook with the caption: <em>\'First actual case of bug being found\'</em>. From then on, computer errors were called <strong>Bugs</strong>, and fixing them was called <strong>Debugging</strong>!<br><br><strong>The 3 Major Types of Programming Errors:</strong><br>1. <strong>Syntax Error (Grammar Mistake):</strong><br>Typing an invalid command like <code>prnt(\\"Hello\\")</code> instead of <code>print</code>, or forgetting quotes.<br>→ Result: The computer refuses to run the program at all.<br><br>2. <strong>Logic Error (Flawed Thinking):</strong><br>The program runs completely, but the outcome is wrong (e.g., calculating average by adding numbers without dividing).<br>→ Result: Misleading answers without any crash.<br><br>3. <strong>Runtime Error (Crash While Running):</strong><br>The code starts fine, then hits an impossible operation like dividing by zero or opening a deleted file.<br>→ Result: The program crashes mid-execution."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-4-3',
  'lesson-pf-3-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Bug Types","question":"Forgetting to close a parenthesis ) or quotation mark \\" is what type of error?","options":{"A":"Syntax Error","B":"Logic Error","C":"Hardware failure","D":"Network Error"},"correct":"A","explanation":"Missing punctuation or misspelling commands violates the syntax rules of the programming language."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-04',
  'course-programming-foundations',
  'chap-pf-04-programming-languages',
  4,
  'Chapter 4: Programming Languages',
  'Why are there hundreds of programming languages? High-level vs. low-level, compilers vs. interpreters, and a first hands-on look at real code.',
  '🗣️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-1',
  'chap-pf-04',
  'pf-4-1-why-not-human-languages',
  1,
  '4.1: Why Can\'t We Just Talk to Computers in Plain English?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-1-1',
  'lesson-pf-4-1',
  'dialogue',
  1,
  '{"shady":"If computers only understand 0 and 1, and humans think in spoken languages, how do we ever communicate?","cody":"Through programming languages! A programming language is an ingenious translator that takes readable human instructions and turns them into binary for the machine to execute!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-1-2',
  'lesson-pf-4-1',
  'text',
  2,
  '{"title":"Language Levels: From Human Thought to Silicon Gates","body":"<strong>1. High-Level Languages:</strong><br>• Examples: Python, JavaScript, Java, C#.<br>• Characteristics: Easy to read and write, using familiar words like <code>print, if, while</code>. You build apps quickly without worrying about computer transistors or RAM memory addresses.<br><br><strong>2. Low-Level Languages:</strong><br>• Examples: Assembly and Machine Code (Binary).<br>• Characteristics: Extremely close to the physical architecture of the CPU. Difficult for humans to read, but blazing fast because it communicates directly with hardware.<br><br><strong>The Full Translation Pipeline:</strong><br>Human Idea → High-Level Code → Compiler/Interpreter → Binary (0s & 1s) → CPU executes!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-1-3',
  'lesson-pf-4-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Language Levels","question":"Which of the following is easiest for a beginner human to read and understand?","options":{"A":"Machine Code (01001000 01100101)","B":"Assembly Language","C":"Python (print(\'Hello\'))","D":"Hexadecimal memory dumps"},"correct":"C","explanation":"Python was intentionally designed with clean, English-like syntax to maximize human readability."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-2',
  'chap-pf-04',
  'pf-4-2-world-of-programming-languages',
  2,
  '4.2: The Universe of Programming Languages',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-2-1',
  'lesson-pf-4-2',
  'dialogue',
  1,
  '{"shady":"I see so many language names: Python, JavaScript, C++, Java, Swift... Why can\'t there just be one single language for everything?!","cody":"Imagine a carpentry toolbox with a hammer, saw, and screwdriver. Could you use a hammer to unscrew a tiny screw? Different programming languages are specialized tools tailored for different jobs!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-2-2',
  'lesson-pf-4-2',
  'text',
  2,
  '{"title":"Guide to Major Languages & Their Real-World Uses","body":"<strong>🐍 Python:</strong><br>The most popular language in the world! Renowned for readability. Dominates Artificial Intelligence (AI), Machine Learning, Data Science, and backend automation (Google, Netflix, NASA).<br><br><strong>🌐 JavaScript:</strong><br>The undisputed ruler of the Web! Runs natively inside every web browser, powering interactive websites, web games, and full-stack servers.<br><br><strong>☕ Java & Kotlin:</strong><br>Powerhouse languages behind Android mobile applications and enterprise banking infrastructure.<br><br><strong>🍎 Swift:</strong><br>Apple\'s official modern language designed for building iOS, iPadOS, and macOS apps.<br><br><strong>🎮 C++ & Rust:</strong><br>Ultra-high-performance languages delivering maximum speed. Power 3D game engines (Fortnite, Unreal Engine), aerospace guidance systems, and operating systems.<br><br><strong>🏗️ HTML & CSS:</strong><br>The foundational languages defining the structure and visual styling of web pages."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-2-3',
  'lesson-pf-4-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Language Matching","question":"Which programming language is the global #1 choice for Artificial Intelligence (AI) and Data Science?","options":{"A":"Python","B":"HTML","C":"CSS","D":"Swift"},"correct":"A","explanation":"Python\'s massive ecosystem of AI libraries (like TensorFlow and PyTorch) makes it the worldwide standard for AI."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-3',
  'chap-pf-04',
  'pf-4-3-compiler-vs-interpreter',
  3,
  '4.3: How Does Code Actually Run? (Compiler vs. Interpreter)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-3-1',
  'lesson-pf-4-3',
  'dialogue',
  1,
  '{"shady":"Cody, when I hit Run in Python, it runs instantly! What actually converts my text into machine execution?","cody":"There are two major kinds of translators in computer science: line-by-line live translators (Interpreters), and translators that compile the whole book before publishing (Compilers)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-3-2',
  'lesson-pf-4-3',
  'text',
  2,
  '{"title":"Two Translation Approaches: Compilers vs. Interpreters","body":"<strong>1. The Interpreter (Live, Line-by-Line):</strong><br>• Examples: Python and JavaScript.<br>• How it works: Acts like a live speech interpreter! Reads line 1 → translates to machine code → executes it immediately → moves to line 2.<br>• Advantages: Instant testing, easy debugging, interactive experimentation.<br>• Trade-off: Slightly slower execution on massive mathematical computations compared to pre-compiled binaries.<br><br><strong>2. The Compiler (Ahead-of-Time Translation):</strong><br>• Examples: C++, Rust, Go.<br>• How it works: Acts like translating an entire book and printing a finished executable file (like a <code>.exe</code> file). Scans the entire project first. If a single syntax error exists, compilation fails.<br>• Advantages: Maximum raw execution speed and efficiency.<br>• Trade-off: You must re-compile after every change before running."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-3-3',
  'lesson-pf-4-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Interpreter Behavior","question":"If your Python code has a syntax mistake on Line 10, what will the Python interpreter do?","options":{"A":"Execute Lines 1 through 9 successfully, then stop at Line 10 and display an error","B":"Refuse to run Line 1 at all","C":"Skip Line 10 silently and run Line 11","D":"Fix the mistake automatically"},"correct":"A","explanation":"Because an interpreter executes line-by-line, it runs preceding lines until it encounters the invalid instruction."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-4',
  'chap-pf-04',
  'pf-4-4-first-look-real-code',
  4,
  '4.4: First Look at Real Code',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-1',
  'lesson-pf-4-4',
  'dialogue',
  1,
  '{"shady":"Cody, looking at a black screen filled with lines of code used to intimidate me. It looked like ancient hieroglyphics!","cody":"No mystery at all, Shady! Real code reads like simple English sentences. Today, we\'ll read a complete real script line by line and see how clean it is!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-2',
  'lesson-pf-4-4',
  'code_example',
  2,
  '{"title":"Student Welcome Card — First Real Python Script","language":"Python","code":"# Welcome program for a new student in SPS Code Orbit\\nstudent_name = \\"Shady\\"\\nstudent_age = 16\\nschool_name = \\"Salam Prep\\"\\n\\nprint(\\"=== WELCOME TO CODE ORBIT! ===\\")\\nprint(\\"Student Name: \\" + student_name)\\nprint(\\"Student Age: \\" + str(student_age))\\nprint(\\"School: \\" + school_name)","explanation":"Notice how readable this is: we store the name, age, and school in labeled variables, then display them to the screen using print()!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-3',
  'lesson-pf-4-4',
  'text',
  3,
  '{"title":"Anatomy of Real Code Lines","body":"• Lines starting with <code>#</code> are <strong>Comments</strong>: explanatory notes written for human developers. The computer ignores them.<br>• <code>student_name = \\"Shady\\"</code>: We create a labeled memory container named <code>student_name</code> and store the text \\"Shady\\" inside.<br>• <code>print(...)</code>: The built-in output function that displays messages on the user\'s screen.<br>• <code>str(student_age)</code>: Converts the number 16 into text format so it can be combined with words."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-4',
  'lesson-pf-4-4',
  'quick_check',
  4,
  '{"title":"Quick Check: Code Reading","question":"If we edit Line 2 to be: student_name = \\"Omar\\", what will the program output for Student Name?","options":{"A":"Student Name: Shady","B":"Student Name: Omar","C":"Student Name: student_name","D":"The program crashes"},"correct":"B","explanation":"The variable now stores the new value \\"Omar\\", which will be output when print() references it."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-05',
  'course-programming-foundations',
  'chap-pf-05-the-world-of-web',
  5,
  'Chapter 5: The World of the Web',
  'How does the global internet actually work? Understand the Client-Server model, packets, subsea cables, and the Holy Trinity: HTML, CSS & JavaScript.',
  '🌐',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-1',
  'chap-pf-05',
  'pf-5-1-what-is-the-internet',
  1,
  '5.1: What is the Internet?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-1-1',
  'lesson-pf-5-1',
  'dialogue',
  1,
  '{"shady":"I click a link in Cairo and a website hosted in California appears in less than a second! Is it magic?","cody":"Not magic, Shady! It is the largest physical engineering achievement in human history: thousands of kilometers of fiber-optic cables running across ocean floors at the speed of light!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-1-2',
  'lesson-pf-5-1',
  'text',
  2,
  '{"title":"The Internet: The Physical Global Network","body":"The internet is not an invisible cloud in the sky. It is a physical global infrastructure consisting of:<br>• Billions of interconnected computers, routers, and data center servers.<br>• Giant subsea fiber-optic cables traversing thousands of kilometers across ocean floors carrying light pulses.<br>• Every connected device has a unique numerical address called an <strong>IP Address</strong> (e.g., <code>192.168.1.1</code>).<br><br><strong>How Does Data Travel?</strong><br>Files and web pages are broken into tiny chunks called <strong>Packets</strong>. Each packet travels along the fastest available physical path across routers and reassembles in perfect order on your screen in milliseconds!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-1-3',
  'lesson-pf-5-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Internet Protocol","question":"The unique digital address assigned to every device connected to the internet is known as an:","options":{"A":"IP Address","B":"RAM Number","C":"CPU Clock","D":"Binary Tag"},"correct":"A","explanation":"An IP (Internet Protocol) address acts as a unique digital street address routing data packets directly to your device."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-2',
  'chap-pf-05',
  'pf-5-2-how-websites-reach-you',
  2,
  '5.2: How Do Websites Reach You? (Client-Server Model)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-2-1',
  'lesson-pf-5-2',
  'dialogue',
  1,
  '{"shady":"I type www.google.com in my browser... how does the webpage arrive so fast?","cody":"Think of dining at a restaurant! You are the customer (Client), and the kitchen is the Server. You order a dish (HTTP Request), and the kitchen prepares and serves it to your table (HTTP Response)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-2-2',
  'lesson-pf-5-2',
  'text',
  2,
  '{"title":"The Client-Server Architecture","body":"Everything on the modern web relies on this architecture:<br><br><strong>1. The Client:</strong><br>Your device and web browser (Chrome, Safari, Firefox). Its job: send requests (Requests), receive web files, and render them on your screen.<br><br><strong>2. The Server:</strong><br>A high-performance computer running 24/7 in a secure data center. Its job: listen for requests, locate the requested files or database data, and send back a response (Response).<br><br><strong>Step-by-Step in One Second:</strong><br>1. You type a website domain into your browser.<br>2. DNS (Domain Name System) translates the domain name into the server\'s IP address.<br>3. Your browser sends an <strong>HTTP Request</strong>.<br>4. The server responds with page files: HTML + CSS + JavaScript.<br>5. Your browser parses the files and renders the interactive page on your screen!<br><br><em>Security tip: Always look for the lock icon 🔒 in your address bar — it means the connection is encrypted via HTTPS!</em>"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-2-3',
  'lesson-pf-5-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Web Security","question":"What does the \'S\' stand for in HTTPS (https://)?","options":{"A":"Speed","B":"Secure (Encrypted connection)","C":"Software","D":"Server"},"correct":"B","explanation":"HTTPS stands for HyperText Transfer Protocol Secure, meaning data transmitted between client and server is encrypted."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-3',
  'chap-pf-05',
  'pf-5-3-html-css-javascript-trinity',
  3,
  '5.3: HTML, CSS & JavaScript — The Holy Trinity of Web',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-3-1',
  'lesson-pf-5-3',
  'dialogue',
  1,
  '{"shady":"Cody, every website mentions HTML, CSS, and JavaScript... what does each of them actually do?","cody":"Imagine building a house, Shady: HTML is the bricks and foundation (Structure). CSS is the paint, wallpaper, and interior design (Styling). JavaScript is the electricity, elevators, and smart lights (Interactivity)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-3-2',
  'lesson-pf-5-3',
  'text',
  2,
  '{"title":"The Holy Trinity of Web Development","body":"<strong>1. HTML (Structure & Content):</strong><br>Defines <em>what</em> is on the page: headings, paragraphs, images, buttons, and links.<br><code>&lt;h1&gt;Welcome to SPS!&lt;/h1&gt;<br>&lt;p&gt;Start your journey into web development.&lt;/p&gt;<br>&lt;button&gt;Click Here&lt;/button&gt;</code><br><br><strong>2. CSS (Presentation & Style):</strong><br>Defines <em>how it looks</em>: colors, fonts, spacing, layout grids, and responsiveness across phones and desktops.<br><code>h1 { color: #38BDF8; font-size: 32px; }<br>button { background: #10B981; border-radius: 8px; }</code><br><br><strong>3. JavaScript (Behavior & Interactivity):</strong><br>Defines <em>what happens</em> when users interact: opening modals, playing sound effects, sending form data, and updating content without reloading the page!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-3-3',
  'lesson-pf-5-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Web Roles","question":"A button reads \'Buy Now\', is styled in vibrant green, and displays a popup \'Item Added!\' when clicked. What handles each piece in order?","options":{"A":"HTML creates the button → CSS styles it green → JavaScript handles the click popup","B":"CSS creates the button → JavaScript styles it → HTML handles the click","C":"JavaScript handles all three","D":"HTML handles all three"},"correct":"A","explanation":"HTML supplies the button element, CSS applies the green styling, and JavaScript responds to the click event."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-4',
  'chap-pf-05',
  'pf-5-4-what-can-you-build',
  4,
  '5.4: What Can You Build with Code?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-4-1',
  'lesson-pf-5-4',
  'dialogue',
  1,
  '{"shady":"Cody, once I learn programming, what kind of real-world projects can I actually build myself?","cody":"Almost anything that exists on a screen, Shady! Websites like YouTube, games like Minecraft, smart AI chatbots, mobile apps, and even autonomous robots and spacecraft controls!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-4-2',
  'lesson-pf-5-4',
  'text',
  2,
  '{"title":"Limitless Horizons: What Programming Empowers You to Build","body":"Programming is not just about writing syntax; it is a <strong>superpower for creative innovation</strong>:<br><br>🌐 <strong>Web Applications:</strong><br>Build educational platforms, social communities, and global e-commerce portals.<br><br>📱 <strong>Mobile Apps:</strong><br>Create smartphone apps for chat, fitness, study organizers, and games used by people worldwide.<br><br>🤖 <strong>Artificial Intelligence (AI & Data):</strong><br>Train machine learning models that analyze photos, understand speech, and assist doctors in diagnosing medical conditions.<br><br>🎮 <strong>Video Game Development:</strong><br>Design 3D physics engines, character mechanics, and interactive game worlds.<br><br>🚀 <strong>Robotics & Space Exploration:</strong><br>Program drones, self-driving cars, and robotic rovers exploring the surface of Mars!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-4-3',
  'lesson-pf-5-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Developer Mindset","question":"Every tech industry titan and master programmer started their journey at:","options":{"A":"Born with innate coding knowledge","B":"The exact same starting line you are at right now: curiosity, hands-on practice, and learning from mistakes","C":"Only by buying supercomputers","D":"Memorizing textbooks without touching a keyboard"},"correct":"B","explanation":"Every great engineer started with the simplest \'Hello World\' program and built skills gradually through curiosity and practice."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-06',
  'course-programming-foundations',
  'chap-pf-06-choose-your-track',
  6,
  'Chapter 6: Choose Your Track',
  'Congratulations! You have mastered all foundational concepts. Compare Python vs. JavaScript, understand Frontend vs. Backend, and confidently pick your Level 1 track!',
  '🎯',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-1',
  'chap-pf-06',
  'pf-6-1-why-python-first',
  1,
  '6.1: Python — The Language Everyone Loves',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-1-1',
  'lesson-pf-6-1',
  'dialogue',
  1,
  '{"shady":"Cody, everyone keeps telling me: if you want to start coding, start with Python Adventures! Why is Python so universally recommended?","cody":"Because Python was built on a brilliant philosophy: \'Readable code is better than complex code\'. It reads like plain English without the confusing syntax traps of older languages!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-1-2',
  'lesson-pf-6-1',
  'text',
  2,
  '{"title":"Side-by-Side Comparison: The Magic of Python","body":"Let\'s compare the exact same task: printing \'Hello World\' in two different languages:<br><br><strong>In Java (Intimidating for a beginner):</strong><br><pre style=\\"background:#0F172A; padding:10px; border-radius:6px; color:#F87171;\\">public class Main {\\n    public static void main(String[] args) {\\n        System.out.println(\\"Hello World\\");\\n    }\\n}</pre><br><strong>In Python (Clean and intuitive):</strong><br><pre style=\\"background:#0F172A; padding:10px; border-radius:6px; color:#34D399;\\">print(\\"Hello World\\")</pre><br>One single, elegant line in Python achieves what requires 5 complex lines in Java! Furthermore, Python is the global #1 language for Artificial Intelligence, Data Science, and automation."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-1-3',
  'lesson-pf-6-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Python Strengths","question":"In which of the following technological domains does Python lead the entire industry?","options":{"A":"Artificial Intelligence (AI) and Data Science","B":"Creating phone wallpaper designs only","C":"Video editing software","D":"Old TV hardware"},"correct":"A","explanation":"Python is the undisputed leader in AI and Data Science thanks to top libraries like PyTorch and TensorFlow."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-2',
  'chap-pf-06',
  'pf-6-2-javascript-web-language',
  2,
  '6.2: JavaScript — The Language of the Internet',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-2-1',
  'lesson-pf-6-2',
  'dialogue',
  1,
  '{"shady":"Cody, if my true passion is building interactive websites like YouTube and Facebook that friends can open in their browsers, what should I choose?","cody":"Then JavaScript is your golden path! JavaScript runs through the veins of the web. You can write code, hit save, and see visual results live on your screen instantly!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-2-2',
  'lesson-pf-6-2',
  'text',
  2,
  '{"title":"JavaScript: The Engine of the Modern Web","body":"Open any web browser, press F12 to open Developer Tools, and click Console: you can type JavaScript commands right there and watch the page react immediately!<br><br><strong>Where Does JavaScript Run Today?</strong><br>• <strong>In the Browser (Frontend):</strong> Building interactive UI, web animations, and browser games.<br>• <strong>On Servers (Backend):</strong> Powered by Node.js, JavaScript builds fast, scalable server APIs.<br>• <strong>Mobile Apps:</strong> With frameworks like React Native, you can build iOS and Android apps with a single codebase!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-2-3',
  'lesson-pf-6-2',
  'quick_check',
  3,
  '{"title":"Quick Check: JavaScript Execution","question":"To test a line of JavaScript right now, do you need to install heavy software?","options":{"A":"Yes, you must buy specialized hardware","B":"No, your web browser already contains a high-speed JavaScript engine built right in","C":"Yes, you need a paid subscription","D":"It only runs inside Google servers"},"correct":"B","explanation":"Modern browsers like Chrome, Edge, and Safari have built-in JS engines (like V8) ready to run code immediately."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-3',
  'chap-pf-06',
  'pf-6-3-frontend-vs-backend',
  3,
  '6.3: Frontend vs. Backend — Who Does What?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-3-1',
  'lesson-pf-6-3',
  'dialogue',
  1,
  '{"shady":"I keep hearing people say \'I\'m a Frontend developer\' or \'I do Backend\'... Are they working at totally different companies?!","cody":"No, Shady! They are two sides of the exact same product! Think of a restaurant: Frontend is the dining room, menus, and decor. Backend is the kitchen, pantry, and secure safe behind the scenes!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-3-2',
  'lesson-pf-6-3',
  'text',
  2,
  '{"title":"Comprehensive Comparison: Frontend vs. Backend","body":"<strong>1. Frontend (The Client-Side User Experience):</strong><br>• Everything the user sees, touches, and clicks on their screen.<br>• Responsible for: Visual layout, responsive design, animations, and typography.<br>• Core technologies: HTML, CSS, JavaScript, React.<br><br><strong>2. Backend (Behind-the-Scenes Architecture):</strong><br>• The hidden, secure engine running on cloud servers.<br>• Responsible for: User authentication, saving student scores, database queries, and payment processing.<br>• Core technologies: Python, Node.js, PHP, PostgreSQL, Cloud databases.<br><br><strong>The Full-Stack Developer:</strong><br>An engineer who masters both frontend and backend development to build complete applications independently!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-3-3',
  'lesson-pf-6-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Specialization","question":"Designing how video thumbnails appear on Instagram and styling the heart like button is the job of:","options":{"A":"Frontend Developer","B":"Backend Developer","C":"Database Administrator only","D":"Hardware engineer"},"correct":"A","explanation":"Everything visual and interactive that users see and touch on screen is crafted by frontend developers."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-4',
  'chap-pf-06',
  'pf-6-4-your-journey-begins',
  4,
  '6.4: Your Journey Begins — Choose Your Track!',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-4-1',
  'lesson-pf-6-4',
  'dialogue',
  1,
  '{"shady":"Cody! I can\'t believe I finished all 24 lessons in Programming Foundations and truly understand concepts that used to scare me! I\'m ready to write real code!","cody":"Congratulations, champion! You now possess a rock-solid algorithmic and conceptual foundation. Pick your Level 1 track and launch into the orbit of coding creativity!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-4-2',
  'lesson-pf-6-4',
  'text',
  2,
  '{"title":"Golden Review: Everything You Mastered in Foundations","body":"Let\'s review the major pillars of computer science you now master:<br>• <strong>Technology & Hardware:</strong> Hardware vs. software, and the Input → Process → Output cycle.<br>• <strong>Machine Language:</strong> The binary system of 0s and 1s and how electrical switches represent data.<br>• <strong>Program Architecture:</strong> Sequence (order), Conditions (decision-making), and Loops (automation).<br>• <strong>Algorithmic Thinking:</strong> Designing algorithms, drawing Flowcharts, writing Pseudocode, and Debugging errors.<br>• <strong>The Internet & Web:</strong> Subsea cable infrastructure, the Client-Server model, and the HTML/CSS/JS trinity.<br><br><strong>Your Available Level 1 Tracks on SPS Code Orbit:</strong><br>1. 🐍 <strong>Python Adventures (Level 1):</strong> Cleanest syntax, interactive terminal games, and entry into Artificial Intelligence.<br>2. 🌐 <strong>Web Explorers (Level 1):</strong> Build real web pages with HTML5 & CSS3 and see visual designs live.<br>3. ⚡ <strong>JavaScript Adventures (Level 1):</strong> Dive into browser interactivity and web logic."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-4-3',
  'lesson-pf-6-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Ready to Launch","question":"What is the best mindset when writing your first lines of real code?","options":{"A":"Giving up whenever an error message appears","B":"Reading error messages calmly, experimenting with hands-on practice, and knowing that every bug is a learning step","C":"Copy-pasting without understanding","D":"Avoiding running code"},"correct":"B","explanation":"Great programmers embrace challenges, learn from debugging, and build expertise through active practice."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);


-- Course: Python Foundations
INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at) VALUES (
  'course-python-foundations',
  'ag-prep',
  'Python Foundations',
  'python-foundations',
  'Build robust programming fundamentals from scratch using Python. Master variables, data types, operators, branching logic, loops, collections, and structured problem-solving.',
  '/assets/courses/algo.png',
  '#0EA5E9',
  1, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), description = VALUES(description), is_published = 1, image_url = VALUES(image_url), accent_color = VALUES(accent_color);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-01',
  'course-python-foundations',
  'interpreter-and-execution',
  1,
  'The Python Interpreter & Script Execution',
  'Learn how the Python runtime executes code line by line, formatted console output, comments, and syntax error diagnosis.',
  '⚡',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-1',
  'chap-pyf-01',
  'interpreter-execution-flow',
  1,
  'The Interpreter & Line-by-Line Execution',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-2',
  'chap-pyf-01',
  'output-sep-end',
  2,
  'Output Customization with sep and end',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-3',
  'chap-pyf-01',
  'comments-code-documentation',
  3,
  'Comments & Code Documentation',
  8,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-4',
  'chap-pyf-01',
  'syntax-errors-vs-runtime',
  4,
  'Syntax Errors vs Execution Flow',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-02',
  'course-python-foundations',
  'variables-types-memory',
  2,
  'Variables, Types & Memory Binding',
  'Explore dynamic typing in Python, int, float, str, bool data types, explicit type casting, and modern f-string formatting.',
  '🏷️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-1',
  'chap-pyf-02',
  'dynamic-typing-primitives',
  1,
  'Dynamic Typing: int, float, str, bool',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-2',
  'chap-pyf-02',
  'reassignment-and-references',
  2,
  'Variable Reassignment & Memory References',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-3',
  'chap-pyf-02',
  'explicit-type-conversion',
  3,
  'Explicit Type Conversion (int, float, str)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-4',
  'chap-pyf-02',
  'modern-fstrings',
  4,
  'Modern String Interpolation with f-Strings',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-03',
  'course-python-foundations',
  'arithmetic-modulo-expressions',
  3,
  'Arithmetic, Modulo & Expressions',
  'Master operator precedence (PEMDAS), floor division (//), the remainder operator (%), and compound assignment shortcuts (+=, -=).',
  '➗',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-1',
  'chap-pyf-03',
  'operator-precedence-pemdas',
  1,
  'Operator Precedence & PEMDAS',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-2',
  'chap-pyf-03',
  'floor-division-and-modulo',
  2,
  'Floor Division (//) & Modulo (%)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-3',
  'chap-pyf-03',
  'compound-assignment-operators',
  3,
  'Compound Assignment (+=, -=, *=)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-4',
  'chap-pyf-03',
  'averages-and-unit-conversions',
  4,
  'Calculating Averages & Unit Conversions',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-04',
  'course-python-foundations',
  'boolean-logic-conditionals',
  4,
  'Boolean Expressions & Conditional Branching',
  'Explore comparison operators, logical and/or/not operators, multi-way if-elif-else branching, and numerical range validation.',
  '🧭',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-1',
  'chap-pyf-04',
  'comparison-operators-deep-dive',
  1,
  'Comparison Operators (==, !=, <, >, <=, >=)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-2',
  'chap-pyf-04',
  'logical-operators-and-or-not',
  2,
  'Logical Operators (and, or, not)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-3',
  'chap-pyf-04',
  'multi-way-branching',
  3,
  'Multi-Way Branching with if-elif-else',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-4',
  'chap-pyf-04',
  'validating-numerical-ranges',
  4,
  'Validating Numerical Ranges',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-05',
  'course-python-foundations',
  'iteration-sequences-for-loops',
  5,
  'Iteration & Sequences with for Loops',
  'Traverse sequences, control loops with range(start, stop, step), apply accumulator patterns, and construct nested loops.',
  '🔄',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-1',
  'chap-pyf-05',
  'traversing-sequences-for',
  1,
  'Sequence Traversal with for',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-2',
  'chap-pyf-05',
  'range-start-stop-step',
  2,
  'Controlling Ranges: start, stop, step',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-3',
  'chap-pyf-05',
  'accumulator-patterns',
  3,
  'The Accumulator Pattern: Summing & Counting',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-4',
  'chap-pyf-05',
  'nested-loops-grids',
  4,
  'Nested Loops & Coordinate Grids',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-06',
  'course-python-foundations',
  'while-loops-and-state',
  6,
  'Event-Driven & State-Based while Loops',
  'Understand sentinel-controlled loops, state flags, break and continue statements, and robust input validation loops.',
  '🎛️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-1',
  'chap-pyf-06',
  'sentinel-controlled-loops',
  1,
  'Sentinel-Controlled Loops',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-2',
  'chap-pyf-06',
  'flag-variables-state',
  2,
  'Flag Variables & State Tracking',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-3',
  'chap-pyf-06',
  'break-and-continue',
  3,
  'Loop Flow Control: break and continue',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-4',
  'chap-pyf-06',
  'input-validation-loops',
  4,
  'Input Validation Loops',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-07',
  'course-python-foundations',
  'string-manipulation-slicing',
  7,
  'String Manipulation & Slicing',
  'Master string immutability, index notation, slicing with [start:stop:step], and essential string methods (lower, upper, replace, split).',
  '✂️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-1',
  'chap-pyf-07',
  'string-immutability-indexing',
  1,
  'String Immutability & Indexing',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-2',
  'chap-pyf-07',
  'string-slicing-notation',
  2,
  'Slicing with [start:stop:step]',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-3',
  'chap-pyf-07',
  'case-transformation-methods',
  3,
  'Case Transformation & Replacement (.upper, .replace)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-4',
  'chap-pyf-07',
  'splitting-and-joining',
  4,
  'Splitting & Joining Strings (.split, .join)',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-08',
  'course-python-foundations',
  'lists-and-sequence-operations',
  8,
  'Lists & Sequence Operations',
  'Master list mutability, modification methods (append, insert, pop, remove), searching and aggregation (min, max, sum), and sorting.',
  '📋',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-1',
  'chap-pyf-08',
  'list-mutability',
  1,
  'List Mutability & Memory Representation',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-2',
  'chap-pyf-08',
  'list-modifications-methods',
  2,
  'List Modifications: append, insert, pop, remove',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-3',
  'chap-pyf-08',
  'searching-aggregation-functions',
  3,
  'Searching & Aggregation: min, max, sum, in',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-4',
  'chap-pyf-08',
  'sorting-reversing-sequences',
  4,
  'Sorting & Reversing Sequences (.sort, sorted)',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-09',
  'course-python-foundations',
  'dictionaries-key-value-mapping',
  9,
  'Dictionaries & Key-Value Mapping',
  'Understand associative mapping with key-value pairs, accessing and mutating dictionary entries, iterating keys/values, and structuring records.',
  '📖',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-1',
  'chap-pyf-09',
  'key-value-mechanics',
  1,
  'Key-Value Pair Mechanics',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-2',
  'chap-pyf-09',
  'mutating-dictionary-entries',
  2,
  'Accessing & Mutating Dictionary Entries',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-3',
  'chap-pyf-09',
  'iterating-dict-items',
  3,
  'Iterating Keys, Values, and Items',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-4',
  'chap-pyf-09',
  'structuring-records',
  4,
  'Structuring Student & Astronaut Records',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-10',
  'course-python-foundations',
  'modular-functions-reusable-logic',
  10,
  'Modular Functions & Reusable Logic',
  'Decompose programs into pure functions, understand return values vs side effects, scope rules (local vs global), and build the capstone console app.',
  '🧩',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-1',
  'chap-pyf-10',
  'function-parameters-arguments',
  1,
  'Defining Functions with Parameters',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-2',
  'chap-pyf-10',
  'return-values-vs-side-effects',
  2,
  'Return Values vs Side Effects',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-3',
  'chap-pyf-10',
  'variable-scope-rules',
  3,
  'Variable Scope: Local vs Global',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-4',
  'chap-pyf-10',
  'capstone-orbital-console',
  4,
  'Capstone: Interactive Orbital Console Application',
  15,
  50,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);


