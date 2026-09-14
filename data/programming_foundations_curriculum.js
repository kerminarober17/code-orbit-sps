/**
 * SPS CODE ORBIT — CURRICULUM MASTER PLAN (ENGLISH EDITION)
 * Course: Programming Foundations — Start Here
 * Level: Foundation (Pre-Level 1)
 * Prerequisites: None — No prior experience required
 * Structure: 6 Chapters × 4 Lessons = 24 In-Depth Comprehensive Lessons
 */

const PROGRAMMING_FOUNDATIONS_COURSE = {
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
  academic_group_name: "Foundation Track",
  academicGroupLabel: "Foundation",
  image: "/assets/courses/prog.png",
  image_url: "/assets/courses/prog.png",
  accent_color: "#70D6FF",
  chaptersCount: 6,
  lessonsCount: 24,
  total_lessons: 24,
  is_published: 1,
  chapters: [

    // =========================================================================
    // CHAPTER 1 — Technology All Around Us
    // =========================================================================
    {
      id: "chap-pf-01",
      slug: "chap-pf-01-technology-around-us",
      title: "Chapter 1: Technology All Around Us",
      english_title: "Chapter 1: Technology All Around Us",
      description: "Technology isn't magic — it is smart tools built with code. Discover hardware vs. software, the Input/Process/Output cycle, and the binary language of 0s and 1s.",
      chapter_number: 1,
      lessons_count: 4,
      icon_symbol: "💡",
      lessons: [
        {
          id: "lesson-pf-1-1",
          slug: "pf-1-1-technology-in-our-lives",
          title: "1.1: Technology in Everyday Life",
          lesson_number: 1,
          duration: 12,
          xp_reward: 25,
          youtube_query: "how technology works for beginners",
          summary_image: "/assets/summaries/tech_overview.png",
          predict_question: {
            question: "What makes a pocket calculator 'technology' compared to paper and pencil?",
            options: {
              A: "It is smaller in size",
              B: "It runs software that computes mathematical operations automatically",
              C: "It is more expensive",
              D: "It has a glass screen"
            },
            correct: "B",
            explanation: "A calculator contains a microchip running programmed software instructions to process numbers automatically, whereas paper and pencil are passive tools."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I woke up to my phone's alarm, took the elevator down, waited at the pedestrian traffic light, and hopped on the bus. Just an ordinary morning! 😅",
                cody: "Look closely, Shady! Every single moment of your morning was powered by technology running code written by programmers!"
              }
            },
            {
              block_type: "dialogue",
              content: {
                shady: "Wait, the elevator and traffic lights are programmed with code too?!",
                cody: "Absolutely! Every modern device follows instructions written by software engineers to know when to open doors, change light signals, and navigate routes. Code is everywhere around you!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "What is Technology Really?",
                body: "Technology is any tool, system, or machine created by humans to solve problems and make daily life easier.<br><br>Most modern technology runs on <strong>Software</strong> — precise programs written by programmers:<br>• 📱 <strong>Smartphones:</strong> Run thousands of complex apps seamlessly.<br>• 🚦 <strong>Traffic Lights:</strong> Smart algorithms adjust timings to prevent traffic jams.<br>• 🏧 <strong>ATM Machines:</strong> Secure banking code verifies your account and dispenses cash in seconds.<br>• 🎮 <strong>Video Games:</strong> Millions of lines of code calculate physics, render 3D graphics, and create immersive worlds.<br>• 🏥 <strong>Hospital Equipment:</strong> Life-saving monitors track patient vitals around the clock."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Identify Technology",
                question: "Which of the following devices relies on a computer program (software) to function?",
                options: {
                  A: "A standard wooden pencil",
                  B: "A digital microwave oven with preset timers",
                  C: "A ceramic coffee mug",
                  D: "A metal paperclip"
                },
                correct: "B",
                explanation: "A digital microwave uses an embedded microchip running software routines to read inputs, manage cook times, and control power."
              }
            },
            {
              block_type: "text",
              content: {
                title: "Hands-on Exercise: Classify Your World",
                body: "Think about items around your room right now and classify them:<br>1. A tree branch outside your window → Natural object, not technology.<br>2. A regular wooden ruler → Mechanical measuring tool without code.<br>3. A smart thermostat that adjusts room temperature automatically → Digital technology powered by code.<br>4. Wireless Bluetooth headphones → Advanced technology running communication protocols."
              }
            }
          ],
          checkpoint_question: {
            question: "Which statement accurately describes the role of computer programming in modern life?",
            options: {
              A: "Programming is only used for old video games",
              B: "Programming provides the instructions that power smart electronic devices around us every day",
              C: "Computers work automatically without needing any human instructions",
              D: "Programming is only found on office desktop computers"
            },
            correct: "B",
            explanation: "Software programs created by programmers are the driving force behind the smart devices we interact with daily."
          },
          key_points: [
            "Technology consists of human-designed tools, machines, and systems that solve everyday problems.",
            "Most modern electronic devices run on software programs written by programmers.",
            "Code powers everyday essentials: from morning alarms and elevators to navigation and medical systems."
          ]
        },

        {
          id: "lesson-pf-1-2",
          slug: "pf-1-2-hardware-vs-software",
          title: "1.2: Hardware vs. Software — What's the Difference?",
          lesson_number: 2,
          duration: 15,
          xp_reward: 25,
          youtube_query: "hardware vs software explained simply",
          summary_image: "/assets/summaries/hardware_software.png",
          predict_question: {
            question: "When you open Google Chrome and type on your keyboard, which is hardware and which is software?",
            options: {
              A: "Chrome is hardware; the keyboard is software",
              B: "The keyboard is hardware; Google Chrome is software",
              C: "Both are hardware components",
              D: "Both are software programs"
            },
            correct: "B",
            explanation: "The keyboard is a physical, tangible device (Hardware), while Google Chrome is a program running digital code (Software)."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody! My computer suddenly froze and showed a strange error message! Did something physically break inside?",
                cody: "First step, Shady: did a wire disconnect or did a physical piece snap off?"
              }
            },
            {
              block_type: "dialogue",
              content: {
                shady: "No, the computer itself looks totally fine. Just the app crashed and closed!",
                cody: "Aha! Physical damage = Hardware issue. Application crashes and error dialogs = Software issue. They work together as one team!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Crucial Comparison: Hardware vs. Software",
                body: "<strong>1. Hardware (The Physical Machine):</strong><br>Every tangible component you can physically touch with your hands:<br>• The Screen/Monitor, Keyboard, and Mouse.<br>• Central Processing Unit (CPU): The 'brain' that executes billions of calculations per second.<br>• RAM (Random Access Memory): Super-fast temporary workspace for open apps.<br>• Storage Drive (SSD / HDD): Permanent storage for files, photos, and operating systems.<br><br><strong>2. Software (The Digital Instructions):</strong><br>The programs and code that bring hardware to life:<br>• Operating Systems (Windows, macOS, iOS, Android).<br>• Applications: Web browsers, WhatsApp, Photoshop, VS Code.<br>• Video games and graphical rendering engines.<br><br><strong>The Golden Rule:</strong><br><em>Hardware without Software = A lifeless box of metal and silicon.<br>Software without Hardware = Ideas and instructions with no machine to execute them!</em>"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Hardware or Software?",
                question: "If WhatsApp crashes due to a coding bug in an update, this is an issue with:",
                options: {
                  A: "Hardware",
                  B: "Software",
                  C: "The phone's glass screen",
                  D: "The charging cable"
                },
                correct: "B",
                explanation: "WhatsApp is a software application. An application crash caused by a code bug is purely a software issue."
              }
            }
          ],
          checkpoint_question: {
            question: "Which of the following is an example of computer Hardware?",
            options: {
              A: "Microsoft Windows 11",
              B: "Minecraft",
              C: "The Central Processing Unit (CPU) and RAM memory chips",
              D: "Google Chrome browser"
            },
            correct: "C",
            explanation: "The CPU and RAM chips are physical electronic components inside the computer casing, making them hardware."
          },
          key_points: [
            "Hardware refers to the physical, touchable parts of a computer (CPU, RAM, screen, keyboard).",
            "Software refers to digital programs and operating systems that instruct the hardware what to do.",
            "Hardware and software are interdependent: neither can function usefully without the other."
          ]
        },

        {
          id: "lesson-pf-1-3",
          slug: "pf-1-3-input-process-output",
          title: "1.3: What Does a Computer Actually Do? (Input → Process → Output)",
          lesson_number: 3,
          duration: 15,
          xp_reward: 25,
          youtube_query: "input process output computers explained",
          summary_image: "/assets/summaries/ipo_cycle.png",
          predict_question: {
            question: "When you speak to Siri or Google Assistant and it speaks back with an answer, what is the Input?",
            options: {
              A: "The spoken voice coming from the speaker",
              B: "Your voice and question captured through the microphone",
              C: "The processor calculating the answer",
              D: "The phone's screen turning on"
            },
            correct: "B",
            explanation: "Your voice recorded through the microphone is the input data. Processing decodes your request, and the speaker output delivers the spoken answer."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I typed a query into Google and hit Enter... and in less than half a second, millions of results appeared! What just happened inside the computer?",
                cody: "Great question, Shady! Every computing operation on planet Earth passes through three fundamental stations: Input → Process → Output!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Universal Computing Cycle: Input → Process → Output",
                body: "<strong>1. Input (Feeding Data In):</strong><br>Information and commands you provide to the computer via keyboard, mouse, touchscreen, microphone, or camera.<br><br><strong>2. Process (Computing & Thinking):</strong><br>The Central Processing Unit (CPU) performs operations step-by-step according to software rules: comparing, calculating, searching, sorting, and transforming data.<br><br><strong>3. Output (Delivering Results):</strong><br>The final outcome displayed to you: graphics on a screen, sound through speakers, or text printed on paper.<br><br><strong>Real-World Examples:</strong><br>• <strong>Calculator:</strong> You press 5 + 3 (Input) → CPU adds them together (Process) → Screen displays 8 (Output).<br>• <strong>Racing Game:</strong> You tap the right arrow key (Input) → Game engine calculates physics and steering angle (Process) → Car turns smoothly on the track (Output)."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: IPO Cycle",
                question: "In a gaming console: pressing the jump button is ______, while seeing your character leap on screen is ______:",
                options: {
                  A: "Output / Input",
                  B: "Input / Output",
                  C: "Process / Input",
                  D: "Output / Process"
                },
                correct: "B",
                explanation: "Pressing the button inputs a command into the system, and the visual animation displayed on screen is the output."
              }
            }
          ],
          checkpoint_question: {
            question: "Which component inside a computer is primarily responsible for the 'Process' phase of the computing cycle?",
            options: {
              A: "The Keyboard",
              B: "The Monitor",
              C: "The Central Processing Unit (CPU)",
              D: "The Power Cable"
            },
            correct: "C",
            explanation: "The CPU is the primary computational brain that handles processing calculations and logical instructions."
          },
          key_points: [
            "Every computer operation follows the Input → Process → Output (IPO) cycle.",
            "The Central Processing Unit (CPU) is solely responsible for executing the processing stage.",
            "Outputs can be visual (screen), auditory (speakers), or digital (saved files)."
          ]
        },

        {
          id: "lesson-pf-1-4",
          slug: "pf-1-4-how-computers-think-binary",
          title: "1.4: How Computers Think (Binary: 0 and 1)",
          lesson_number: 4,
          duration: 15,
          xp_reward: 25,
          youtube_query: "binary numbers computers explained for beginners",
          summary_image: "/assets/summaries/binary_explained.png",
          predict_question: {
            question: "Why do programmers write code in high-level languages like Python instead of writing 0s and 1s directly?",
            options: {
              A: "Because high-level languages are slower than 0s and 1s",
              B: "Because programming languages are close to human language and are translated automatically into binary",
              C: "Because computers cannot actually understand binary",
              D: "Because 0s and 1s are forbidden in modern software"
            },
            correct: "B",
            explanation: "High-level languages allow humans to write readable, logical code, while compilers and interpreters translate that code into binary (0s and 1s) for the computer."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, if computers are so smart, why can't I just tell it in plain English: 'Calculate my exam grades' without any code?",
                cody: "Because deep down inside, a computer is an electronic machine! It doesn't understand letters or words — it only understands tiny electrical signals: ON (1) and OFF (0)!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Machine's True Language: The Binary System",
                body: "A computer's processor is built with billions of microscopic electrical switches called <strong>transistors</strong>.<br>Each transistor can only be in one of two states:<br>• Switch ON / Current flowing = <strong>1</strong><br>• Switch OFF / No current = <strong>0</strong><br><br><strong>How Does Everything Turn Into 0s and 1s?</strong><br>• The letter 'A' is represented in standard ASCII binary as: <code>01000001</code><br>• The number 7 is represented in binary as: <code>00000111</code><br>• Colors, images, audio, and 4K videos are all broken down into vast sequences of 0s and 1s.<br><br><strong>Why Do We Need Programming Languages?</strong><br>Instead of manually typing thousands of binary digits like <code>01110000 01110010 01101001 01101110 01110100</code>, we write an elegant Python command: <code>print(\"Hello\")</code>. The programming language translates our command into binary in a fraction of a millisecond!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Binary System",
                question: "In digital circuits, the 'ON' state represents the digit ____, and the 'OFF' state represents the digit ____:",
                options: {
                  A: "0 then 1",
                  B: "1 then 0",
                  C: "2 then 1",
                  D: "1 then 2"
                },
                correct: "B",
                explanation: "In binary logic, electricity flowing (ON) is represented by 1, and electricity stopped (OFF) is represented by 0."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the primary role of modern programming languages like Python and JavaScript?",
            options: {
              A: "To disable the processor to save power",
              B: "To act as a bridge translating human-readable logic into the computer's binary language",
              C: "To force programmers to memorize binary tables manually",
              D: "To change monitor colors"
            },
            correct: "B",
            explanation: "Programming languages provide a human-friendly syntax that translates complex logic into machine-executable binary code."
          },
          key_points: [
            "Computers natively understand only the binary system: 0 and 1.",
            "Every letter, number, pixel color, and audio sample is stored as a sequence of binary bits.",
            "Modern programming languages serve as the essential bridge between human thinking and binary execution."
          ]
        }
      ]
    },

    // =========================================================================
    // CHAPTER 2 — What is a Program?
    // =========================================================================
    {
      id: "chap-pf-02",
      slug: "chap-pf-02-what-is-a-program",
      title: "Chapter 2: What is a Program?",
      english_title: "Chapter 2: What is a Program?",
      description: "A program is a precise step-by-step recipe. Master sequential execution (Sequence), decision-making with conditions (IF/ELSE), and repetition with loops (Loops).",
      chapter_number: 2,
      lessons_count: 4,
      icon_symbol: "📜",
      lessons: [
        {
          id: "lesson-pf-2-1",
          slug: "pf-2-1-programs-like-recipes",
          title: "2.1: Programs Are Exact Recipes",
          lesson_number: 1,
          duration: 12,
          xp_reward: 25,
          youtube_query: "what is a computer program for beginners",
          summary_image: "/assets/summaries/program_recipe.png",
          predict_question: {
            question: "Why do computers require far more precise instructions than human beings?",
            options: {
              A: "Because computers are smarter than humans and prefer details",
              B: "Because computers follow instructions literally and cannot guess, assume, or infer missing steps",
              C: "Because computer screens are small",
              D: "Because commands must be in Latin"
            },
            correct: "B",
            explanation: "Humans use common sense and context to fill in missing gaps, whereas computers follow instructions with 100% literal precision without assumptions."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, I told a robot to 'make me a sandwich', and it put a sealed cheese wrapper right between two bread slices without opening it! 😅",
                cody: "Haha! That's because you didn't say 'open the wrapper first'! A computer follows instructions literally — it never assumes anything!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "A Program = An Unambiguous Recipe",
                body: "Imagine writing a recipe for someone who has never seen a kitchen in their life:<br>• If you tell them 'bake a cake', they will stand there confused!<br>• But an exact, step-by-step recipe works every time:<br>&nbsp;&nbsp;1. Take a clean mixing bowl.<br>&nbsp;&nbsp;2. Add 2 cups of flour.<br>&nbsp;&nbsp;3. Add 2 eggs and whisk for 3 minutes.<br>&nbsp;&nbsp;4. Preheat the oven to 180°C and bake for 25 minutes.<br><br><strong>In Programming:</strong><br>A program is an ordered list of exact, unambiguous instructions. If you miss a step or leave room for ambiguity, the program encounters an error called a <strong>Bug</strong>!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Precise Instructions",
                question: "If you command a robot 'Walk forward' without giving a distance or stop condition, what happens?",
                options: {
                  A: "It walks two steps and stops politely",
                  B: "It continues walking until it hits a wall because no stop condition was specified",
                  C: "It walks backward",
                  D: "It asks you for clarification"
                },
                correct: "B",
                explanation: "Computers lack human intuition; without a specific boundary or stopping condition, it repeats the command indefinitely."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the most accurate definition of a computer program?",
            options: {
              A: "A random collection of graphics and colors",
              B: "A precise, ordered sequence of instructions guiding a computer to solve a task or achieve a goal",
              C: "A metal wire placed inside the screen",
              D: "An audio song file"
            },
            correct: "B",
            explanation: "A computer program is a systematic, sequential set of instructions designed to direct a machine toward a specific outcome."
          },
          key_points: [
            "A computer program functions like an exact recipe with zero room for ambiguity.",
            "Computers execute instructions literally without guessing or assuming intent.",
            "Precision in writing instructions is the foundation of bug-free programming."
          ]
        },

        {
          id: "lesson-pf-2-2",
          slug: "pf-2-2-order-matters-sequence",
          title: "2.2: Order Matters — Sequence",
          lesson_number: 2,
          duration: 12,
          xp_reward: 25,
          youtube_query: "sequence in programming explained",
          summary_image: "/assets/summaries/sequence_concept.png",
          predict_question: {
            question: "In what order does a computer read and execute code instructions by default?",
            options: {
              A: "Randomly depending on processor temperature",
              B: "From bottom to top",
              C: "Line-by-line from top to bottom in strict sequence",
              D: "All lines simultaneously at the same instant"
            },
            correct: "C",
            explanation: "Computers execute instructions sequentially, starting from the first line down to the last line in order."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Once when I was in a rush, I put my shoes on before my socks... It was a total disaster and I couldn't walk! 😂",
                cody: "A great real-life lesson, Shady! Order is everything. In computer science, this foundational rule is called: Sequence!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Principle of Sequence in Code",
                body: "Computers read code just like humans read an English book: <strong>line by line, from top to bottom</strong>.<br><br><strong>Logical Sequence Example:</strong><br>❌ Incorrect order breaking logic:<br>1. Squeeze toothpaste onto brush.<br>2. Unscrew the toothpaste cap.<br>3. Pick up the toothbrush from the cup.<br><br>✅ Correct logical Sequence:<br>1. Pick up the toothbrush from the cup.<br>2. Unscrew the toothpaste cap.<br>3. Squeeze toothpaste onto brush.<br><br><strong>In Code:</strong> If you try to display or print a calculation before calculating it, the program will crash with an error!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Sequence in Code",
                question: "In a program: Line 1 calculates 'total = 5 + 3', and Line 2 displays 'print(total)'. What happens if you swap their order?",
                options: {
                  A: "The program works normally",
                  B: "An error occurs because the program tries to print a variable before it exists",
                  C: "The result doubles to 16",
                  D: "The computer waits until Line 2 is calculated"
                },
                correct: "B",
                explanation: "Due to sequential execution, you cannot use or display a variable before it has been created and assigned in a previous line."
              }
            }
          ],
          checkpoint_question: {
            question: "Changing the order of code lines inside a program usually causes:",
            options: {
              A: "An increase in RAM memory",
              B: "Incorrect results or program failure",
              C: "Faster internet speed",
              D: "No effect because order does not matter"
            },
            correct: "B",
            explanation: "Sequence determines logic; disrupting the order changes what happens or crashes the program entirely."
          },
          key_points: [
            "Sequence is the strict sequential order in which instructions are executed.",
            "Computers process code line-by-line from top to bottom.",
            "Maintaining the correct sequence prevents errors and ensures predictable results."
          ]
        },

        {
          id: "lesson-pf-2-3",
          slug: "pf-2-3-programs-make-decisions-conditions",
          title: "2.3: Programs Make Decisions (Conditions: IF / ELSE)",
          lesson_number: 3,
          duration: 15,
          xp_reward: 25,
          youtube_query: "if else conditions programming beginners",
          summary_image: "/assets/summaries/conditions_branch.png",
          predict_question: {
            question: "In an app checking login credentials, what is the core Condition being evaluated?",
            options: {
              A: "The color of the login button",
              B: "The logical question: Does the entered password match the stored password?",
              C: "The user's screen brightness",
              D: "The internet cable color"
            },
            correct: "B",
            explanation: "The condition is the True/False check that determines whether to grant access or show an error."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Every morning I check the weather: if it's raining, I grab an umbrella; otherwise, I put on sunglasses!",
                cody: "That is pure programmer logic, Shady! You just executed a condition: IF it is raining THEN take umbrella ELSE wear sunglasses!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Conditional Logic: How Programs Make Smart Decisions",
                body: "Smart programs don't just blindly repeat the same actions. They evaluate a situation by asking a question whose answer is either <strong>True (Yes)</strong> or <strong>False (No)</strong>.<br><br><strong>Structure of an IF / ELSE Statement:</strong><br><code>IF (a specific condition is True):<br>&nbsp;&nbsp;&nbsp;&nbsp;Execute Path A<br>ELSE:<br>&nbsp;&nbsp;&nbsp;&nbsp;Execute Path B</code><br><br><strong>Everyday Real Examples:</strong><br>• <strong>ATM Machine:</strong> IF your account balance ≥ withdrawal amount ← Dispense cash ELSE display 'Insufficient funds'.<br>• <strong>School Portal:</strong> IF student score ≥ 50 ← Display 'Congratulations, you passed!' ELSE display 'Please retake the quiz'."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Decision Making",
                question: "In a video game: 'If player coins reach 100, award an extra life.' What programming concept is this?",
                options: {
                  A: "A Loop",
                  B: "A Condition (IF Statement)",
                  C: "Hardware component",
                  D: "Compiler"
                },
                correct: "B",
                explanation: "This is a conditional statement: when the condition (coins >= 100) becomes True, the reward is granted."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the primary benefit of using conditions (IF / ELSE) in software?",
            options: {
              A: "Allowing programs to take different paths and make dynamic decisions based on user input and data",
              B: "Shutting down the monitor to save battery",
              C: "Converting numbers into letters only",
              D: "Making code harder to read"
            },
            correct: "A",
            explanation: "Conditions give software intelligence, enabling programs to react dynamically to changing inputs and states."
          },
          key_points: [
            "Conditions allow software to evaluate data and make dynamic choices (IF / ELSE).",
            "A condition evaluates to either True or False.",
            "Conditional branching is the core logic behind authentication, gaming rules, and AI."
          ]
        },

        {
          id: "lesson-pf-2-4",
          slug: "pf-2-4-programs-repeat-loops",
          title: "2.4: Programs Repeat — Loops",
          lesson_number: 4,
          duration: 15,
          xp_reward: 25,
          youtube_query: "loops in programming explained simply",
          summary_image: "/assets/summaries/loops_concept.png",
          predict_question: {
            question: "If you need to print 'Great job!' 1,000 times, what is the best way to do it in code?",
            options: {
              A: "Type the print command manually 1,000 times",
              B: "Use a loop (Loop) in just 2 lines of code to repeat the command 1,000 times automatically",
              C: "Restart the computer 1,000 times",
              D: "Ask a friend to copy-paste it"
            },
            correct: "B",
            explanation: "Loops automate repetitive tasks, running thousands or millions of iterations in milliseconds with just a couple lines of code."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Every day I wake up, brush my teeth, eat breakfast, go to school, study, sleep... and repeat tomorrow! Repetition is exhausting 😴",
                cody: "You're living in a loop, Shady! Repetition is tiring for humans, but it's a computer's superpower! Programs can repeat tasks millions of times per second without ever getting tired!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Loops: The Power of Automation",
                body: "A <strong>Loop</strong> repeatedly executes a block of code multiple times without needing to write the code over and over again.<br><br><strong>Visual Comparison:</strong><br>❌ Without a Loop (Exhausting and messy):<br><code>print(\"Hello\")<br>print(\"Hello\")<br>print(\"Hello\")<br>print(\"Hello\")<br>print(\"Hello\")</code><br><br>✅ With a Loop (Clean and scalable):<br><code>REPEAT 5 times:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(\"Hello\")</code><br><br><strong>Two Main Types of Loops:</strong><br>1. <strong>Count-controlled Loop:</strong> Runs a predetermined number of times (e.g., send report cards to 30 students).<br>2. <strong>Condition-controlled Loop:</strong> Runs until a specific condition becomes True or False (e.g., keep ringing the alarm until the user hits the snooze button)."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Loops",
                question: "Which scenario represents the best use of a loop with a stopping condition?",
                options: {
                  A: "Adding two numbers together once",
                  B: "Continuing to prompt the user for their password until they enter the correct one",
                  C: "Displaying the title of a website",
                  D: "Closing a laptop lid"
                },
                correct: "B",
                explanation: "The attempt repeats continuously in a loop and stops only when the condition (password is correct) is satisfied."
              }
            }
          ],
          checkpoint_question: {
            question: "Why are loops considered one of the most powerful tools in software development?",
            options: {
              A: "They make code much longer and harder to read",
              B: "They eliminate repetitive manual code and automate huge workloads with speed and efficiency",
              C: "They turn monitors into touchscreens",
              D: "They remove the need for a processor"
            },
            correct: "B",
            explanation: "Loops eliminate redundant code and allow programmers to process thousands of items effortlessly."
          },
          key_points: [
            "A loop repeats a block of instructions automatically without rewriting code.",
            "Loops can repeat a fixed number of times or continue until a condition is met.",
            "Loops power video game rendering, database searches, and data processing."
          ]
        }
      ]
    },

    // =========================================================================
    // CHAPTER 3 — Algorithms: The Art of Problem Solving
    // =========================================================================
    {
      id: "chap-pf-03",
      slug: "chap-pf-03-algorithms-problem-solving",
      title: "Chapter 3: Algorithms — The Art of Problem Solving",
      english_title: "Chapter 3: Algorithms — The Art of Problem Solving",
      description: "An algorithm is the logical plan before writing code. Learn the 3 rules of an algorithm, visual flowcharts, pseudocode planning, and how to debug errors.",
      chapter_number: 3,
      lessons_count: 4,
      icon_symbol: "🧩",
      lessons: [
        {
          id: "lesson-pf-3-1",
          slug: "pf-3-1-what-is-an-algorithm",
          title: "3.1: What is an Algorithm?",
          lesson_number: 1,
          duration: 15,
          xp_reward: 25,
          youtube_query: "what is an algorithm simple explanation",
          summary_image: "/assets/summaries/algorithm_definition.png",
          predict_question: {
            question: "What are the three essential requirements of any valid algorithm?",
            options: {
              A: "It must be in English, contain pictures, and run on a phone",
              B: "It must be Clear (unambiguous), Finite (has an end), and Effective (solves the problem)",
              C: "It must contain at least 1,000 steps",
              D: "It must use colors"
            },
            correct: "B",
            explanation: "A proper algorithm must have unambiguous steps, terminate after a finite number of steps, and correctly solve the intended problem."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Google searches through billions of web pages and finds what I want in a fraction of a second! How is that even possible?!",
                cody: "No accidents in computer science, Shady! It is powered by brilliant algorithms! Great programmers design the plan and solution first, then write the code!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Algorithm: The Blueprint Before the Code",
                body: "Named after the historic Persian mathematician <strong>Muhammad ibn Musa al-Khwarizmi</strong>, an algorithm is: <em>A finite, step-by-step procedure designed to solve a problem or accomplish a task</em>.<br><br><strong>3 Mandatory Conditions for a Valid Algorithm:</strong><br>1. <strong>Clear & Unambiguous:</strong> Every instruction leaves no room for confusion or multiple interpretations.<br>2. <strong>Finite (Has a definite end):</strong> It cannot run in an endless void forever; it must finish and produce a result.<br>3. <strong>Effective:</strong> Every step must be realistically executable and actually solve the problem.<br><br><strong>Example: Finding the Tallest Student in Class:</strong><br>1. Assume the first student is currently the 'Tallest'.<br>2. Stand in front of the next student and compare their height with 'Tallest'.<br>3. If this student is taller, update 'Tallest' to be this student.<br>4. Repeat step 2 and 3 for all remaining students.<br>5. The student left in the 'Tallest' spot is the tallest in class!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Algorithms",
                question: "Navigation apps like Google Maps finding the fastest route to avoid traffic rely on:",
                options: {
                  A: "A smart pathfinding algorithm (like Dijkstra's algorithm)",
                  B: "Random guessing",
                  C: "Turning off street lights",
                  D: "Coin flips"
                },
                correct: "A",
                explanation: "Navigation software utilizes pathfinding algorithms to compute the shortest and fastest route across complex road networks."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the key difference between an algorithm and code?",
            options: {
              A: "An algorithm is the logical plan to solve a problem; code is that plan written in a specific programming language",
              B: "An algorithm works only on laptops, while code works only on phones",
              C: "There is no difference; they are 100% identical",
              D: "Only robots can understand algorithms"
            },
            correct: "A",
            explanation: "An algorithm is the abstract problem-solving strategy, while code is its practical implementation in Python, JavaScript, C++, etc."
          },
          key_points: [
            "An algorithm is an unambiguous, step-by-step plan for solving a problem.",
            "Every algorithm must be clear, finite, and effective.",
            "All modern digital technology, search engines, and AI are built on clever algorithms."
          ]
        },

        {
          id: "lesson-pf-3-2",
          slug: "pf-3-2-flowcharts-visual-logic",
          title: "3.2: Visualizing Logic — Flowcharts",
          lesson_number: 2,
          duration: 15,
          xp_reward: 25,
          youtube_query: "flowchart programming beginners",
          summary_image: "/assets/summaries/flowchart_symbols.png",
          predict_question: {
            question: "In standard flowchart diagrams, what does the Diamond shape (🔷) represent?",
            options: {
              A: "Start or end of the program",
              B: "A standard calculation or process",
              C: "A decision point asking a question with Yes/No branches",
              D: "Printing on paper"
            },
            correct: "C",
            explanation: "The diamond symbol represents a decision or condition where logic splits into two paths (True/Yes or False/No)."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I wrote out an algorithm in a whole page of text, but my friend got lost trying to follow the decision paths!",
                cody: "A picture is worth a thousand words, Shady! In software engineering, we map algorithms visually using a diagram called a Flowchart!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Flowcharts: The Visual Map of Program Flow",
                body: "A <strong>Flowchart</strong> is a visual diagram that illustrates the sequence of steps and decision paths in a program from start to finish.<br><br><strong>Universal Flowchart Symbols:</strong><br>• ⭕ <strong>Oval (Terminal):</strong> Represents the START or END of the program.<br>• ⬜ <strong>Rectangle (Process):</strong> Represents an action or calculation (e.g., total = a + b).<br>• ▱ <strong>Parallelogram (Input / Output):</strong> Represents receiving user input or displaying output to the screen.<br>• 🔷 <strong>Diamond (Decision):</strong> Represents a condition or question with two arrows branching out: one for (YES) and one for (NO).<br>• ➡️ <strong>Flowline Arrows:</strong> Connect symbols and indicate the direction of execution."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Flowchart Shapes",
                question: "Which geometric shape should you use to represent: 'Enter Username and Password'?",
                options: {
                  A: "Diamond (Decision)",
                  B: "Parallelogram (Input / Output)",
                  C: "Oval (Terminal)",
                  D: "Hexagon"
                },
                correct: "B",
                explanation: "Parallelograms are reserved specifically for Input (entering credentials) and Output operations."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the biggest advantage of drawing a flowchart before coding?",
            options: {
              A: "It allows the code to run without a processor",
              B: "It helps programmers visualize flow, spot logical flaws early, and communicate ideas clearly",
              C: "It makes computers run colder",
              D: "It eliminates the need for software testing"
            },
            correct: "B",
            explanation: "Flowcharts help engineers identify missing branches and clarify logic before writing complex code."
          },
          key_points: [
            "A flowchart is a visual diagram mapping the steps and decisions of an algorithm.",
            "Standard symbols: Oval (Start/End), Rectangle (Process), Parallelogram (I/O), and Diamond (Decision).",
            "Flowcharts make complex logic intuitive and prevent costly programming mistakes."
          ]
        },

        {
          id: "lesson-pf-3-3",
          slug: "pf-3-3-pseudocode-planning-logic",
          title: "3.3: Pseudocode — Planning Before Code",
          lesson_number: 3,
          duration: 15,
          xp_reward: 25,
          youtube_query: "pseudocode programming beginners guide",
          summary_image: "/assets/summaries/pseudocode_example.png",
          predict_question: {
            question: "Why do software engineers write Pseudocode before writing real code in a programming language?",
            options: {
              A: "Computers execute pseudocode faster than real code",
              B: "It lets you focus on logical problem-solving without worrying about strict syntax rules",
              C: "Pseudocode is required for web servers",
              D: "It reduces file download sizes"
            },
            correct: "B",
            explanation: "Pseudocode allows developers to organize thoughts in plain human language before wrestling with language-specific syntax."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, I want to code my project, but I get overwhelmed worrying about brackets, colons, and semicolons!",
                cody: "Professional programmers use a secret weapon: Pseudocode! It's an informal way to write program logic using simple plain English before typing actual code."
              }
            },
            {
              block_type: "text",
              content: {
                title: "What is Pseudocode and Why Do Engineers Love It?",
                body: "<strong>Pseudocode</strong> ('pseudo' meaning imitation) is an informal, human-readable outline of a program that mimics code structure without strict syntax rules.<br><br><strong>Key Benefits of Pseudocode:</strong><br>• No compiler errors: no editor will yell at you for missing a colon.<br>• Uses intuitive keywords: START, INPUT, IF, ELSE, REPEAT, PRINT, END.<br>• Bridges the gap between an idea in your head and code in an editor.<br><br><strong>Example: Student Pass/Fail Checker:</strong><br><pre style=\"background:#0F172A; padding:12px; border-radius:8px; color:#38BDF8;\">START\n  INPUT student_score\n  IF student_score >= 50 THEN\n      PRINT \"Congratulations! You passed! 🎉\"\n  ELSE\n      PRINT \"Keep practicing and try again! 💪\"\n  END IF\nEND</pre>"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Pseudocode",
                question: "Can a computer execute pseudocode directly?",
                options: {
                  A: "Yes, because computers understand all human writing",
                  B: "No, pseudocode is written for humans to plan logic and must be converted to a real programming language to run",
                  C: "Yes, if written in capital letters",
                  D: "Yes, if it has no spelling errors"
                },
                correct: "B",
                explanation: "Pseudocode is an informal design tool for human readers; machines require actual programming languages."
              }
            }
          ],
          checkpoint_question: {
            question: "Which of the following keywords are commonly used when structuring pseudocode?",
            options: {
              A: "START, INPUT, IF, ELSE, PRINT, END",
              B: "PHOTO, DRAW, CLICK",
              C: "WINDOWS, APPLE, GOOGLE",
              D: "KEYBOARD, MOUSE, SCREEN"
            },
            correct: "A",
            explanation: "These standard action keywords outline sequential flow, user input, decision branching, and output."
          },
          key_points: [
            "Pseudocode is an informal, human-readable plan that mimics code structure.",
            "It has no strict syntax rules and focuses on pure problem-solving logic.",
            "Writing solid pseudocode makes writing the actual code fast and straightforward."
          ]
        },

        {
          id: "lesson-pf-3-4",
          slug: "pf-3-4-debugging-fixing-errors",
          title: "3.4: Debugging — When Things Go Wrong",
          lesson_number: 4,
          duration: 15,
          xp_reward: 25,
          youtube_query: "types of programming errors debugging explained",
          summary_image: "/assets/summaries/debugging_types.png",
          predict_question: {
            question: "If your code runs without crashing, but the math output is wrong (e.g., 5 + 3 outputs 2), what type of error is this?",
            options: {
              A: "Syntax Error",
              B: "Logic Error",
              C: "Runtime Error",
              D: "Keyboard error"
            },
            correct: "B",
            explanation: "A Logic Error occurs when syntax is valid, but the algorithm or formula is wrong (such as subtracting instead of adding)."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody! I ran my code and scary red error text popped up! Does this mean I'm terrible at programming? 😞",
                cody: "Not at all, Shady! Every programmer on Earth — even senior engineers at Google — gets errors every day! Bugs aren't failures; they are puzzles waiting to be solved through Debugging!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Story of the Very First Computer Bug!",
                body: "In 1947, computer pioneer <strong>Grace Hopper</strong> was working on the Harvard Mark II computer (a machine that filled an entire room). Suddenly, the system malfunctioned.<br>When technicians inspected the relays, they discovered an actual <strong>moth</strong> trapped inside! They taped the insect into their logbook with the caption: <em>'First actual case of bug being found'</em>. From then on, computer errors were called <strong>Bugs</strong>, and fixing them was called <strong>Debugging</strong>!<br><br><strong>The 3 Major Types of Programming Errors:</strong><br>1. <strong>Syntax Error (Grammar Mistake):</strong><br>Typing an invalid command like <code>prnt(\"Hello\")</code> instead of <code>print</code>, or forgetting quotes.<br>→ Result: The computer refuses to run the program at all.<br><br>2. <strong>Logic Error (Flawed Thinking):</strong><br>The program runs completely, but the outcome is wrong (e.g., calculating average by adding numbers without dividing).<br>→ Result: Misleading answers without any crash.<br><br>3. <strong>Runtime Error (Crash While Running):</strong><br>The code starts fine, then hits an impossible operation like dividing by zero or opening a deleted file.<br>→ Result: The program crashes mid-execution."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Bug Types",
                question: "Forgetting to close a parenthesis ) or quotation mark \" is what type of error?",
                options: {
                  A: "Syntax Error",
                  B: "Logic Error",
                  C: "Hardware failure",
                  D: "Network Error"
                },
                correct: "A",
                explanation: "Missing punctuation or misspelling commands violates the syntax rules of the programming language."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the very first thing a programmer should do when an error message appears?",
            options: {
              A: "Delete the entire project and start over",
              B: "Read the error message calmly to identify the error type and the exact line number",
              C: "Click the Run button 10 times quickly",
              D: "Close the computer and walk away"
            },
            correct: "B",
            explanation: "Error messages are helpful guides that tell you precisely which line caused the issue and why."
          },
          key_points: [
            "A flaw or mistake in code is called a Bug, and resolving it is called Debugging.",
            "Errors fall into three categories: Syntax (grammar), Logic (reasoning), and Runtime (crashes).",
            "Encountering bugs is a natural part of coding; troubleshooting builds problem-solving mastery."
          ]
        }
      ]
    },

    // =========================================================================
    // CHAPTER 4 — Programming Languages
    // =========================================================================
    {
      id: "chap-pf-04",
      slug: "chap-pf-04-programming-languages",
      title: "Chapter 4: Programming Languages",
      english_title: "Chapter 4: Programming Languages",
      description: "Why are there hundreds of programming languages? High-level vs. low-level, compilers vs. interpreters, and a first hands-on look at real code.",
      chapter_number: 4,
      lessons_count: 4,
      icon_symbol: "🗣️",
      lessons: [
        {
          id: "lesson-pf-4-1",
          slug: "pf-4-1-why-not-human-languages",
          title: "4.1: Why Can't We Just Talk to Computers in Plain English?",
          lesson_number: 1,
          duration: 15,
          xp_reward: 25,
          youtube_query: "programming languages explained for beginners",
          summary_image: "/assets/summaries/language_levels.png",
          predict_question: {
            question: "Why are languages like Python and JavaScript called 'High-Level Languages'?",
            options: {
              A: "Because they are the fastest languages in the world",
              B: "Because they use human-readable words and abstract away complex hardware details",
              C: "Because they only run on airplanes",
              D: "Because they cost money to use"
            },
            correct: "B",
            explanation: "High-level languages are closer to human reasoning, using English words and simple syntax instead of raw electrical memory addresses."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "If computers only understand 0 and 1, and humans think in spoken languages, how do we ever communicate?",
                cody: "Through programming languages! A programming language is an ingenious translator that takes readable human instructions and turns them into binary for the machine to execute!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Language Levels: From Human Thought to Silicon Gates",
                body: "<strong>1. High-Level Languages:</strong><br>• Examples: Python, JavaScript, Java, C#.<br>• Characteristics: Easy to read and write, using familiar words like <code>print, if, while</code>. You build apps quickly without worrying about computer transistors or RAM memory addresses.<br><br><strong>2. Low-Level Languages:</strong><br>• Examples: Assembly and Machine Code (Binary).<br>• Characteristics: Extremely close to the physical architecture of the CPU. Difficult for humans to read, but blazing fast because it communicates directly with hardware.<br><br><strong>The Full Translation Pipeline:</strong><br>Human Idea → High-Level Code → Compiler/Interpreter → Binary (0s & 1s) → CPU executes!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Language Levels",
                question: "Which of the following is easiest for a beginner human to read and understand?",
                options: {
                  A: "Machine Code (01001000 01100101)",
                  B: "Assembly Language",
                  C: "Python (print('Hello'))",
                  D: "Hexadecimal memory dumps"
                },
                correct: "C",
                explanation: "Python was intentionally designed with clean, English-like syntax to maximize human readability."
              }
            }
          ],
          checkpoint_question: {
            question: "What was the main motivation behind inventing high-level programming languages?",
            options: {
              A: "To enable humans to write software effectively without having to write millions of binary 0s and 1s",
              B: "To eliminate the need for microchips",
              C: "To prevent computers from connecting to the internet",
              D: "To lock files permanently"
            },
            correct: "A",
            explanation: "High-level languages empower humans to develop complex software efficiently without tedious binary encoding."
          },
          key_points: [
            "Programming languages act as the translator between human ideas and computer hardware.",
            "High-level languages (Python, JS) prioritize human readability and developer speed.",
            "Low-level languages (Assembly) prioritize raw hardware control and microsecond execution speed."
          ]
        },

        {
          id: "lesson-pf-4-2",
          slug: "pf-4-2-world-of-programming-languages",
          title: "4.2: The Universe of Programming Languages",
          lesson_number: 2,
          duration: 15,
          xp_reward: 25,
          youtube_query: "popular programming languages and their uses",
          summary_image: "/assets/summaries/languages_overview.png",
          predict_question: {
            question: "If your goal is to build interactive website features running directly in Google Chrome, which language is essential?",
            options: {
              A: "Swift",
              B: "C++",
              C: "JavaScript",
              D: "SQL"
            },
            correct: "C",
            explanation: "JavaScript is the native programming language built into all modern web browsers for client-side interactivity."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I see so many language names: Python, JavaScript, C++, Java, Swift... Why can't there just be one single language for everything?!",
                cody: "Imagine a carpentry toolbox with a hammer, saw, and screwdriver. Could you use a hammer to unscrew a tiny screw? Different programming languages are specialized tools tailored for different jobs!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Guide to Major Languages & Their Real-World Uses",
                body: "<strong>🐍 Python:</strong><br>The most popular language in the world! Renowned for readability. Dominates Artificial Intelligence (AI), Machine Learning, Data Science, and backend automation (Google, Netflix, NASA).<br><br><strong>🌐 JavaScript:</strong><br>The undisputed ruler of the Web! Runs natively inside every web browser, powering interactive websites, web games, and full-stack servers.<br><br><strong>☕ Java & Kotlin:</strong><br>Powerhouse languages behind Android mobile applications and enterprise banking infrastructure.<br><br><strong>🍎 Swift:</strong><br>Apple's official modern language designed for building iOS, iPadOS, and macOS apps.<br><br><strong>🎮 C++ & Rust:</strong><br>Ultra-high-performance languages delivering maximum speed. Power 3D game engines (Fortnite, Unreal Engine), aerospace guidance systems, and operating systems.<br><br><strong>🏗️ HTML & CSS:</strong><br>The foundational languages defining the structure and visual styling of web pages."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Language Matching",
                question: "Which programming language is the global #1 choice for Artificial Intelligence (AI) and Data Science?",
                options: {
                  A: "Python",
                  B: "HTML",
                  C: "CSS",
                  D: "Swift"
                },
                correct: "A",
                explanation: "Python's massive ecosystem of AI libraries (like TensorFlow and PyTorch) makes it the worldwide standard for AI."
              }
            }
          ],
          checkpoint_question: {
            question: "Why do software companies use different programming languages for different projects?",
            options: {
              A: "Each language is specialized to excel at specific requirements (browser interactivity, high-speed graphics, AI, mobile apps)",
              B: "Because computers can only understand one language per week",
              C: "Each country has a legal requirement for its own language",
              D: "All programming languages are identical"
            },
            correct: "A",
            explanation: "Different domains have different performance, platform, and ecosystem requirements."
          },
          key_points: [
            "There is no single 'best' language; each is an optimized tool for specific problems.",
            "Python is best for beginners, data science, and Artificial Intelligence.",
            "JavaScript is the universal standard for browser interactivity and modern web apps."
          ]
        },

        {
          id: "lesson-pf-4-3",
          slug: "pf-4-3-compiler-vs-interpreter",
          title: "4.3: How Does Code Actually Run? (Compiler vs. Interpreter)",
          lesson_number: 3,
          duration: 15,
          xp_reward: 25,
          youtube_query: "compiler vs interpreter programming explained",
          summary_image: "/assets/summaries/compiler_interpreter.png",
          predict_question: {
            question: "Python is an Interpreted language. What does this mean during code execution?",
            options: {
              A: "The code is translated and executed line-by-line in real time, stopping immediately if an error is encountered",
              B: "You have to wait an hour before any code can run",
              C: "Python does not translate code and talks directly to electricity",
              D: "The interpreter deletes the code after running"
            },
            correct: "A",
            explanation: "An interpreter translates and executes code instruction by instruction on the fly, making it interactive and easy to test."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, when I hit Run in Python, it runs instantly! What actually converts my text into machine execution?",
                cody: "There are two major kinds of translators in computer science: line-by-line live translators (Interpreters), and translators that compile the whole book before publishing (Compilers)!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Two Translation Approaches: Compilers vs. Interpreters",
                body: "<strong>1. The Interpreter (Live, Line-by-Line):</strong><br>• Examples: Python and JavaScript.<br>• How it works: Acts like a live speech interpreter! Reads line 1 → translates to machine code → executes it immediately → moves to line 2.<br>• Advantages: Instant testing, easy debugging, interactive experimentation.<br>• Trade-off: Slightly slower execution on massive mathematical computations compared to pre-compiled binaries.<br><br><strong>2. The Compiler (Ahead-of-Time Translation):</strong><br>• Examples: C++, Rust, Go.<br>• How it works: Acts like translating an entire book and printing a finished executable file (like a <code>.exe</code> file). Scans the entire project first. If a single syntax error exists, compilation fails.<br>• Advantages: Maximum raw execution speed and efficiency.<br>• Trade-off: You must re-compile after every change before running."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Interpreter Behavior",
                question: "If your Python code has a syntax mistake on Line 10, what will the Python interpreter do?",
                options: {
                  A: "Execute Lines 1 through 9 successfully, then stop at Line 10 and display an error",
                  B: "Refuse to run Line 1 at all",
                  C: "Skip Line 10 silently and run Line 11",
                  D: "Fix the mistake automatically"
                },
                correct: "A",
                explanation: "Because an interpreter executes line-by-line, it runs preceding lines until it encounters the invalid instruction."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the primary difference between a Compiler and an Interpreter?",
            options: {
              A: "A Compiler translates the entire program into machine code beforehand, while an Interpreter translates and executes line-by-line on the fly",
              B: "Compilers only work on phones; Interpreters only work on laptops",
              C: "Interpreters remove the need for electricity",
              D: "There is no difference"
            },
            correct: "A",
            explanation: "Compilers produce standalone machine executables in advance, while interpreters translate instructions dynamically during execution."
          },
          key_points: [
            "An Interpreter executes code line-by-line in real time (e.g., Python).",
            "A Compiler translates entire codebases into machine code files before execution (e.g., C++).",
            "Python's interpreted nature makes it friendly, flexible, and ideal for learning."
          ]
        },

        {
          id: "lesson-pf-4-4",
          slug: "pf-4-4-first-look-real-code",
          title: "4.4: First Look at Real Code",
          lesson_number: 4,
          duration: 15,
          xp_reward: 25,
          youtube_query: "read python code for beginners",
          summary_image: "/assets/summaries/read_code_overview.png",
          predict_question: {
            question: "In Python, what does a line starting with a hashtag (#) signify?",
            options: {
              A: "A secret command for the processor",
              B: "A comment for human readers that the computer completely ignores",
              C: "A symbol that disconnects Wi-Fi",
              D: "An order to delete all files"
            },
            correct: "B",
            explanation: "The # symbol marks a comment: notes written by developers to explain code to teammates and themselves."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, looking at a black screen filled with lines of code used to intimidate me. It looked like ancient hieroglyphics!",
                cody: "No mystery at all, Shady! Real code reads like simple English sentences. Today, we'll read a complete real script line by line and see how clean it is!"
              }
            },
            {
              block_type: "code_example",
              content: {
                title: "Student Welcome Card — First Real Python Script",
                language: "Python",
                code: "# Welcome program for a new student in SPS Code Orbit\nstudent_name = \"Shady\"\nstudent_age = 16\nschool_name = \"Salam Prep\"\n\nprint(\"=== WELCOME TO CODE ORBIT! ===\")\nprint(\"Student Name: \" + student_name)\nprint(\"Student Age: \" + str(student_age))\nprint(\"School: \" + school_name)",
                explanation: "Notice how readable this is: we store the name, age, and school in labeled variables, then display them to the screen using print()!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Anatomy of Real Code Lines",
                body: "• Lines starting with <code>#</code> are <strong>Comments</strong>: explanatory notes written for human developers. The computer ignores them.<br>• <code>student_name = \"Shady\"</code>: We create a labeled memory container named <code>student_name</code> and store the text \"Shady\" inside.<br>• <code>print(...)</code>: The built-in output function that displays messages on the user's screen.<br>• <code>str(student_age)</code>: Converts the number 16 into text format so it can be combined with words."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Code Reading",
                question: "If we edit Line 2 to be: student_name = \"Omar\", what will the program output for Student Name?",
                options: {
                  A: "Student Name: Shady",
                  B: "Student Name: Omar",
                  C: "Student Name: student_name",
                  D: "The program crashes"
                },
                correct: "B",
                explanation: "The variable now stores the new value \"Omar\", which will be output when print() references it."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the primary purpose of code comments in professional software?",
            options: {
              A: "To document and explain what the code does for other developers and your future self",
              B: "To double the processor speed",
              C: "To clean viruses automatically",
              D: "To force users to pay a subscription"
            },
            correct: "A",
            explanation: "Comments help development teams understand the intent, logic, and nuances behind written code."
          },
          key_points: [
            "Real Python code is designed to be readable, concise, and structured like simple English.",
            "Comments (starting with #) are human-only notes ignored by the computer.",
            "Variables store values, and print() outputs information to the screen."
          ]
        }
      ]
    },

    // =========================================================================
    // CHAPTER 5 — The World of the Web
    // =========================================================================
    {
      id: "chap-pf-05",
      slug: "chap-pf-05-the-world-of-web",
      title: "Chapter 5: The World of the Web",
      english_title: "Chapter 5: The World of the Web",
      description: "How does the global internet actually work? Understand the Client-Server model, packets, subsea cables, and the Holy Trinity: HTML, CSS & JavaScript.",
      chapter_number: 5,
      lessons_count: 4,
      icon_symbol: "🌐",
      lessons: [
        {
          id: "lesson-pf-5-1",
          slug: "pf-5-1-what-is-the-internet",
          title: "5.1: What is the Internet?",
          lesson_number: 1,
          duration: 15,
          xp_reward: 25,
          youtube_query: "how the internet works for beginners",
          summary_image: "/assets/summaries/internet_infrastructure.png",
          predict_question: {
            question: "What is the true distinction between the Internet and the World Wide Web?",
            options: {
              A: "There is no difference; they are exactly the same thing",
              B: "The Internet is the global physical network of connected computers and cables, while the Web is a service for browsing web pages running on top of it",
              C: "The Internet is for phones, while the Web is for laptops",
              D: "The Web is an obsolete protocol that was shut down"
            },
            correct: "B",
            explanation: "The Internet is the physical infrastructure (like a global highway network), while the Web (WWW) is the service and information traveling across that highway."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I click a link in Cairo and a website hosted in California appears in less than a second! Is it magic?",
                cody: "Not magic, Shady! It is the largest physical engineering achievement in human history: thousands of kilometers of fiber-optic cables running across ocean floors at the speed of light!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Internet: The Physical Global Network",
                body: "The internet is not an invisible cloud in the sky. It is a physical global infrastructure consisting of:<br>• Billions of interconnected computers, routers, and data center servers.<br>• Giant subsea fiber-optic cables traversing thousands of kilometers across ocean floors carrying light pulses.<br>• Every connected device has a unique numerical address called an <strong>IP Address</strong> (e.g., <code>192.168.1.1</code>).<br><br><strong>How Does Data Travel?</strong><br>Files and web pages are broken into tiny chunks called <strong>Packets</strong>. Each packet travels along the fastest available physical path across routers and reassembles in perfect order on your screen in milliseconds!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Internet Protocol",
                question: "The unique digital address assigned to every device connected to the internet is known as an:",
                options: {
                  A: "IP Address",
                  B: "RAM Number",
                  C: "CPU Clock",
                  D: "Binary Tag"
                },
                correct: "A",
                explanation: "An IP (Internet Protocol) address acts as a unique digital street address routing data packets directly to your device."
              }
            }
          ],
          checkpoint_question: {
            question: "How do web pages and streaming videos travel between continents across the globe?",
            options: {
              A: "Carrier pigeons and postal mail",
              B: "Through massive fiber-optic cables laid on ocean floors and high-speed terrestrial networks",
              C: "Exclusively via smartphone battery signals",
              D: "By pure coincidence without cables"
            },
            correct: "B",
            explanation: "Over 95% of all intercontinental internet traffic travels through fiber-optic cables laid along ocean floors."
          },
          key_points: [
            "The Internet is the physical global network of computers, routers, and subsea cables.",
            "The World Wide Web (WWW) is an information-sharing service built on top of the internet.",
            "Data travels as small packets addressed to unique IP addresses across the globe."
          ]
        },

        {
          id: "lesson-pf-5-2",
          slug: "pf-5-2-how-websites-reach-you",
          title: "5.2: How Do Websites Reach You? (Client-Server Model)",
          lesson_number: 2,
          duration: 15,
          xp_reward: 25,
          youtube_query: "how websites work client server model",
          summary_image: "/assets/summaries/client_server_restaurant.png",
          predict_question: {
            question: "When you open a website in your browser, who is the Client and who is the Server?",
            options: {
              A: "The remote server is the Client; your browser is the Server",
              B: "Your web browser is the Client requesting content; the remote host computer is the Server responding with files",
              C: "Both are Clients simultaneously",
              D: "Both are Servers"
            },
            correct: "B",
            explanation: "Your browser (Client) initiates an HTTP request, and the web host (Server) serves the response containing HTML, CSS, and JS files."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I type www.google.com in my browser... how does the webpage arrive so fast?",
                cody: "Think of dining at a restaurant! You are the customer (Client), and the kitchen is the Server. You order a dish (HTTP Request), and the kitchen prepares and serves it to your table (HTTP Response)!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Client-Server Architecture",
                body: "Everything on the modern web relies on this architecture:<br><br><strong>1. The Client:</strong><br>Your device and web browser (Chrome, Safari, Firefox). Its job: send requests (Requests), receive web files, and render them on your screen.<br><br><strong>2. The Server:</strong><br>A high-performance computer running 24/7 in a secure data center. Its job: listen for requests, locate the requested files or database data, and send back a response (Response).<br><br><strong>Step-by-Step in One Second:</strong><br>1. You type a website domain into your browser.<br>2. DNS (Domain Name System) translates the domain name into the server's IP address.<br>3. Your browser sends an <strong>HTTP Request</strong>.<br>4. The server responds with page files: HTML + CSS + JavaScript.<br>5. Your browser parses the files and renders the interactive page on your screen!<br><br><em>Security tip: Always look for the lock icon 🔒 in your address bar — it means the connection is encrypted via HTTPS!</em>"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Web Security",
                question: "What does the 'S' stand for in HTTPS (https://)?",
                options: {
                  A: "Speed",
                  B: "Secure (Encrypted connection)",
                  C: "Software",
                  D: "Server"
                },
                correct: "B",
                explanation: "HTTPS stands for HyperText Transfer Protocol Secure, meaning data transmitted between client and server is encrypted."
              }
            }
          ],
          checkpoint_question: {
            question: "What three core file types does a server send to your browser to render a complete webpage?",
            options: {
              A: "HTML, CSS, JavaScript",
              B: "Word, Excel, PowerPoint",
              C: "Python, C++, Java",
              D: "Windows, macOS, Linux"
            },
            correct: "A",
            explanation: "Webpages are built using HTML for content structure, CSS for visual styles, and JavaScript for interactivity."
          },
          key_points: [
            "In the Client-Server model, your browser (Client) requests files, and the host (Server) serves them.",
            "Web browsers act as the rendering engine that turns code files into visual pages.",
            "HTTPS ensures the communication channel between client and server is encrypted."
          ]
        },

        {
          id: "lesson-pf-5-3",
          slug: "pf-5-3-html-css-javascript-trinity",
          title: "5.3: HTML, CSS & JavaScript — The Holy Trinity of Web",
          lesson_number: 3,
          duration: 15,
          xp_reward: 25,
          youtube_query: "HTML CSS JavaScript explained simply",
          summary_image: "/assets/summaries/web_trio_house.png",
          predict_question: {
            question: "If you want to set a webpage background color to dark navy and style fonts beautifully, which language is responsible?",
            options: {
              A: "HTML",
              B: "CSS",
              C: "JavaScript",
              D: "PHP"
            },
            correct: "B",
            explanation: "CSS (Cascading Style Sheets) is dedicated purely to presentation, layout, typography, and styling."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, every website mentions HTML, CSS, and JavaScript... what does each of them actually do?",
                cody: "Imagine building a house, Shady: HTML is the bricks and foundation (Structure). CSS is the paint, wallpaper, and interior design (Styling). JavaScript is the electricity, elevators, and smart lights (Interactivity)!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "The Holy Trinity of Web Development",
                body: "<strong>1. HTML (Structure & Content):</strong><br>Defines <em>what</em> is on the page: headings, paragraphs, images, buttons, and links.<br><code>&lt;h1&gt;Welcome to SPS!&lt;/h1&gt;<br>&lt;p&gt;Start your journey into web development.&lt;/p&gt;<br>&lt;button&gt;Click Here&lt;/button&gt;</code><br><br><strong>2. CSS (Presentation & Style):</strong><br>Defines <em>how it looks</em>: colors, fonts, spacing, layout grids, and responsiveness across phones and desktops.<br><code>h1 { color: #38BDF8; font-size: 32px; }<br>button { background: #10B981; border-radius: 8px; }</code><br><br><strong>3. JavaScript (Behavior & Interactivity):</strong><br>Defines <em>what happens</em> when users interact: opening modals, playing sound effects, sending form data, and updating content without reloading the page!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Web Roles",
                question: "A button reads 'Buy Now', is styled in vibrant green, and displays a popup 'Item Added!' when clicked. What handles each piece in order?",
                options: {
                  A: "HTML creates the button → CSS styles it green → JavaScript handles the click popup",
                  B: "CSS creates the button → JavaScript styles it → HTML handles the click",
                  C: "JavaScript handles all three",
                  D: "HTML handles all three"
                },
                correct: "A",
                explanation: "HTML supplies the button element, CSS applies the green styling, and JavaScript responds to the click event."
              }
            }
          ],
          checkpoint_question: {
            question: "Which of the three web technologies is a full programming language with variables, conditions, and loops?",
            options: {
              A: "HTML",
              B: "CSS",
              C: "JavaScript",
              D: "All three are full programming languages"
            },
            correct: "C",
            explanation: "HTML is a markup language and CSS is a stylesheet language, while JavaScript is the full programming language of the web."
          },
          key_points: [
            "HTML = Structure and content (what exists on the page).",
            "CSS = Presentation and aesthetics (how elements look and scale).",
            "JavaScript = Logic and interactivity (what happens when users interact)."
          ]
        },

        {
          id: "lesson-pf-5-4",
          slug: "pf-5-4-what-can-you-build",
          title: "5.4: What Can You Build with Code?",
          lesson_number: 4,
          duration: 15,
          xp_reward: 25,
          youtube_query: "what can you build with programming",
          summary_image: "/assets/summaries/programming_possibilities.png",
          predict_question: {
            question: "If your dream is to create a high-performance native iOS mobile app specifically for iPhone, which language is standard?",
            options: {
              A: "Python",
              B: "Swift",
              C: "HTML",
              D: "C++"
            },
            correct: "B",
            explanation: "Swift is Apple's native language designed specifically for iOS, iPadOS, and macOS apps."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, once I learn programming, what kind of real-world projects can I actually build myself?",
                cody: "Almost anything that exists on a screen, Shady! Websites like YouTube, games like Minecraft, smart AI chatbots, mobile apps, and even autonomous robots and spacecraft controls!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Limitless Horizons: What Programming Empowers You to Build",
                body: "Programming is not just about writing syntax; it is a <strong>superpower for creative innovation</strong>:<br><br>🌐 <strong>Web Applications:</strong><br>Build educational platforms, social communities, and global e-commerce portals.<br><br>📱 <strong>Mobile Apps:</strong><br>Create smartphone apps for chat, fitness, study organizers, and games used by people worldwide.<br><br>🤖 <strong>Artificial Intelligence (AI & Data):</strong><br>Train machine learning models that analyze photos, understand speech, and assist doctors in diagnosing medical conditions.<br><br>🎮 <strong>Video Game Development:</strong><br>Design 3D physics engines, character mechanics, and interactive game worlds.<br><br>🚀 <strong>Robotics & Space Exploration:</strong><br>Program drones, self-driving cars, and robotic rovers exploring the surface of Mars!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Developer Mindset",
                question: "Every tech industry titan and master programmer started their journey at:",
                options: {
                  A: "Born with innate coding knowledge",
                  B: "The exact same starting line you are at right now: curiosity, hands-on practice, and learning from mistakes",
                  C: "Only by buying supercomputers",
                  D: "Memorizing textbooks without touching a keyboard"
                },
                correct: "B",
                explanation: "Every great engineer started with the simplest 'Hello World' program and built skills gradually through curiosity and practice."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the single most valuable trait for becoming a great software engineer?",
            options: {
              A: "Curiosity, persistent practice, and embracing mistakes as opportunities to learn",
              B: "Memorizing syntax without understanding",
              C: "Never running code",
              D: "Working only on a black computer"
            },
            correct: "A",
            explanation: "Perseverance and curiosity in solving problems are the real keys to programming mastery."
          },
          key_points: [
            "Programming powers websites, mobile apps, AI models, video games, and robotics.",
            "Every professional engineer started from the same fundamentals you are learning right now.",
            "Consistent hands-on practice turns creative ideas into functional digital reality."
          ]
        }
      ]
    },

    // =========================================================================
    // CHAPTER 6 — Choose Your Track
    // =========================================================================
    {
      id: "chap-pf-06",
      slug: "chap-pf-06-choose-your-track",
      title: "Chapter 6: Choose Your Track",
      english_title: "Chapter 6: Choose Your Track",
      description: "Congratulations! You have mastered all foundational concepts. Compare Python vs. JavaScript, understand Frontend vs. Backend, and confidently pick your Level 1 track!",
      chapter_number: 6,
      lessons_count: 4,
      icon_symbol: "🎯",
      lessons: [
        {
          id: "lesson-pf-6-1",
          slug: "pf-6-1-why-python-first",
          title: "6.1: Python — The Language Everyone Loves",
          lesson_number: 1,
          duration: 15,
          xp_reward: 25,
          youtube_query: "why python is great for beginners",
          summary_image: "/assets/summaries/python_track_card.png",
          predict_question: {
            question: "Why do university professors and software experts consistently recommend Python as the best first text-based language?",
            options: {
              A: "Because it has no modern features",
              B: "Because its syntax is clean, readable, and structured like simple English sentences",
              C: "Because it only runs on iPhones",
              D: "Because it requires no computer"
            },
            correct: "B",
            explanation: "Python's philosophy is 'readability counts', allowing beginners to focus on core logic rather than complex punctuation."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, everyone keeps telling me: if you want to start coding, start with Python Adventures! Why is Python so universally recommended?",
                cody: "Because Python was built on a brilliant philosophy: 'Readable code is better than complex code'. It reads like plain English without the confusing syntax traps of older languages!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Side-by-Side Comparison: The Magic of Python",
                body: "Let's compare the exact same task: printing 'Hello World' in two different languages:<br><br><strong>In Java (Intimidating for a beginner):</strong><br><pre style=\"background:#0F172A; padding:10px; border-radius:6px; color:#F87171;\">public class Main {\n    public static void main(String[] args) {\n        System.out.println(\"Hello World\");\n    }\n}</pre><br><strong>In Python (Clean and intuitive):</strong><br><pre style=\"background:#0F172A; padding:10px; border-radius:6px; color:#34D399;\">print(\"Hello World\")</pre><br>One single, elegant line in Python achieves what requires 5 complex lines in Java! Furthermore, Python is the global #1 language for Artificial Intelligence, Data Science, and automation."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Python Strengths",
                question: "In which of the following technological domains does Python lead the entire industry?",
                options: {
                  A: "Artificial Intelligence (AI) and Data Science",
                  B: "Creating phone wallpaper designs only",
                  C: "Video editing software",
                  D: "Old TV hardware"
                },
                correct: "A",
                explanation: "Python is the undisputed leader in AI and Data Science thanks to top libraries like PyTorch and TensorFlow."
              }
            }
          ],
          checkpoint_question: {
            question: "What is the recommended path for students starting with Python on SPS Code Orbit?",
            options: {
              A: "Python Adventures (Level 1) → Python Foundations (Level 2) → Python Developer (Level 3)",
              B: "Web Explorers only",
              C: "Stop after Foundations",
              D: "Always restart from zero"
            },
            correct: "A",
            explanation: "SPS Code Orbit provides a smooth, step-by-step pathway from beginner to professional Python mastery."
          },
          key_points: [
            "Python offers the cleanest, most readable syntax for beginners.",
            "Applications of Python include: script automation, web backends, and Artificial Intelligence.",
            "The Python Adventures track offers a fast, rewarding, and fun first coding adventure."
          ]
        },

        {
          id: "lesson-pf-6-2",
          slug: "pf-6-2-javascript-web-language",
          title: "6.2: JavaScript — The Language of the Internet",
          lesson_number: 2,
          duration: 15,
          xp_reward: 25,
          youtube_query: "why learn javascript for beginners",
          summary_image: "/assets/summaries/javascript_track_card.png",
          predict_question: {
            question: "What unique capability makes JavaScript completely different from every other programming language?",
            options: {
              A: "It only works on Mac computers",
              B: "It is the only programming language natively built into and supported by all web browsers worldwide",
              C: "It is free while all other languages cost money",
              D: "It contains zero bugs"
            },
            correct: "B",
            explanation: "JavaScript is the sole scripting language supported natively by every web browser on Earth without plugins."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody, if my true passion is building interactive websites like YouTube and Facebook that friends can open in their browsers, what should I choose?",
                cody: "Then JavaScript is your golden path! JavaScript runs through the veins of the web. You can write code, hit save, and see visual results live on your screen instantly!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "JavaScript: The Engine of the Modern Web",
                body: "Open any web browser, press F12 to open Developer Tools, and click Console: you can type JavaScript commands right there and watch the page react immediately!<br><br><strong>Where Does JavaScript Run Today?</strong><br>• <strong>In the Browser (Frontend):</strong> Building interactive UI, web animations, and browser games.<br>• <strong>On Servers (Backend):</strong> Powered by Node.js, JavaScript builds fast, scalable server APIs.<br>• <strong>Mobile Apps:</strong> With frameworks like React Native, you can build iOS and Android apps with a single codebase!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: JavaScript Execution",
                question: "To test a line of JavaScript right now, do you need to install heavy software?",
                options: {
                  A: "Yes, you must buy specialized hardware",
                  B: "No, your web browser already contains a high-speed JavaScript engine built right in",
                  C: "Yes, you need a paid subscription",
                  D: "It only runs inside Google servers"
                },
                correct: "B",
                explanation: "Modern browsers like Chrome, Edge, and Safari have built-in JS engines (like V8) ready to run code immediately."
              }
            }
          ],
          checkpoint_question: {
            question: "Who should prioritize choosing the Web / JavaScript track?",
            options: {
              A: "Students who want to build interactive web apps and see immediate visual results",
              B: "People who want to repair mechanical keyboards",
              C: "People who dislike screens",
              D: "Nobody"
            },
            correct: "A",
            explanation: "The JavaScript web track is ideal for creators who want immediate visual feedback and interactive applications."
          },
          key_points: [
            "JavaScript is the native programming language of all modern web browsers.",
            "It powers frontend interfaces, backend servers, and cross-platform mobile apps.",
            "Immediate visual feedback makes learning web development engaging and exciting."
          ]
        },

        {
          id: "lesson-pf-6-3",
          slug: "pf-6-3-frontend-vs-backend",
          title: "6.3: Frontend vs. Backend — Who Does What?",
          lesson_number: 3,
          duration: 15,
          xp_reward: 25,
          youtube_query: "frontend vs backend explained",
          summary_image: "/assets/summaries/frontend_backend.png",
          predict_question: {
            question: "Where should password verification and database checking occur for security?",
            options: {
              A: "Frontend (Inside the user's web browser)",
              B: "Backend (On secure remote servers and databases)",
              C: "On the TV screen",
              D: "Inside the charging cable"
            },
            correct: "B",
            explanation: "Sensitive operations like credential checks and payment processing must run securely on the backend server to prevent tampering."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "I keep hearing people say 'I'm a Frontend developer' or 'I do Backend'... Are they working at totally different companies?!",
                cody: "No, Shady! They are two sides of the exact same product! Think of a restaurant: Frontend is the dining room, menus, and decor. Backend is the kitchen, pantry, and secure safe behind the scenes!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Comprehensive Comparison: Frontend vs. Backend",
                body: "<strong>1. Frontend (The Client-Side User Experience):</strong><br>• Everything the user sees, touches, and clicks on their screen.<br>• Responsible for: Visual layout, responsive design, animations, and typography.<br>• Core technologies: HTML, CSS, JavaScript, React.<br><br><strong>2. Backend (Behind-the-Scenes Architecture):</strong><br>• The hidden, secure engine running on cloud servers.<br>• Responsible for: User authentication, saving student scores, database queries, and payment processing.<br>• Core technologies: Python, Node.js, PHP, PostgreSQL, Cloud databases.<br><br><strong>The Full-Stack Developer:</strong><br>An engineer who masters both frontend and backend development to build complete applications independently!"
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Specialization",
                question: "Designing how video thumbnails appear on Instagram and styling the heart like button is the job of:",
                options: {
                  A: "Frontend Developer",
                  B: "Backend Developer",
                  C: "Database Administrator only",
                  D: "Hardware engineer"
                },
                correct: "A",
                explanation: "Everything visual and interactive that users see and touch on screen is crafted by frontend developers."
              }
            }
          ],
          checkpoint_question: {
            question: "What title is given to a software engineer who can build both the Frontend and the Backend of an application?",
            options: {
              A: "Full-Stack Developer",
              B: "Hardware Engineer",
              C: "Cable Technician",
              D: "Data Cable Specialist"
            },
            correct: "A",
            explanation: "A Full-Stack Developer has the versatile skillset to build client-side interfaces and server-side logic."
          },
          key_points: [
            "Frontend encompasses everything the user sees and interacts with (HTML/CSS/JS).",
            "Backend handles security, databases, authentication, and server-side computing.",
            "Full-Stack developers bridge both worlds to build complete products from end to end."
          ]
        },

        {
          id: "lesson-pf-6-4",
          slug: "pf-6-4-your-journey-begins",
          title: "6.4: Your Journey Begins — Choose Your Track!",
          lesson_number: 4,
          duration: 15,
          xp_reward: 25,
          youtube_query: "how to start learning programming roadmap",
          summary_image: "/assets/summaries/choose_track_roadmap.png",
          predict_question: {
            question: "Now that you have completed Programming Foundations, what is your best next step?",
            options: {
              A: "Stop coding entirely",
              B: "Choose a Level 1 track in Python or Web and immediately start writing hands-on code",
              C: "Memorize books without opening a computer",
              D: "Wait several years"
            },
            correct: "B",
            explanation: "Solidifying your knowledge requires putting concepts into practice with real code in Level 1 courses."
          },
          blocks: [
            {
              block_type: "dialogue",
              content: {
                shady: "Cody! I can't believe I finished all 24 lessons in Programming Foundations and truly understand concepts that used to scare me! I'm ready to write real code!",
                cody: "Congratulations, champion! You now possess a rock-solid algorithmic and conceptual foundation. Pick your Level 1 track and launch into the orbit of coding creativity!"
              }
            },
            {
              block_type: "text",
              content: {
                title: "Golden Review: Everything You Mastered in Foundations",
                body: "Let's review the major pillars of computer science you now master:<br>• <strong>Technology & Hardware:</strong> Hardware vs. software, and the Input → Process → Output cycle.<br>• <strong>Machine Language:</strong> The binary system of 0s and 1s and how electrical switches represent data.<br>• <strong>Program Architecture:</strong> Sequence (order), Conditions (decision-making), and Loops (automation).<br>• <strong>Algorithmic Thinking:</strong> Designing algorithms, drawing Flowcharts, writing Pseudocode, and Debugging errors.<br>• <strong>The Internet & Web:</strong> Subsea cable infrastructure, the Client-Server model, and the HTML/CSS/JS trinity.<br><br><strong>Your Available Level 1 Tracks on SPS Code Orbit:</strong><br>1. 🐍 <strong>Python Adventures (Level 1):</strong> Cleanest syntax, interactive terminal games, and entry into Artificial Intelligence.<br>2. 🌐 <strong>Web Explorers (Level 1):</strong> Build real web pages with HTML5 & CSS3 and see visual designs live.<br>3. ⚡ <strong>JavaScript Adventures (Level 1):</strong> Dive into browser interactivity and web logic."
              }
            },
            {
              block_type: "quick_check",
              content: {
                title: "Quick Check: Ready to Launch",
                question: "What is the best mindset when writing your first lines of real code?",
                options: {
                  A: "Giving up whenever an error message appears",
                  B: "Reading error messages calmly, experimenting with hands-on practice, and knowing that every bug is a learning step",
                  C: "Copy-pasting without understanding",
                  D: "Avoiding running code"
                },
                correct: "B",
                explanation: "Great programmers embrace challenges, learn from debugging, and build expertise through active practice."
              }
            }
          ],
          checkpoint_question: {
            question: "Are you ready to begin your chosen Level 1 track in SPS Code Orbit?",
            options: {
              A: "YES! I understand foundational concepts and am excited to build real projects in SPS Code Orbit!",
              B: "I prefer reviewing Foundations once more to reinforce concepts",
              C: "Programming still feels too mysterious",
              D: "Maybe tomorrow"
            },
            correct: "A",
            explanation: "Welcome to Level 1! Head over to the course catalog and start your coding adventure."
          },
          key_points: [
            "You have completed Programming Foundations and established a solid computer science base.",
            "You are fully prepared to choose Python Adventures or Web Explorers in Level 1.",
            "Your coding journey has officially begun — believe in your ability to build the future!"
          ]
        }
      ]
    }
  ]
};

if (typeof window !== 'undefined') {
  window.PROGRAMMING_FOUNDATIONS_COURSE = PROGRAMMING_FOUNDATIONS_COURSE;
}

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    PROGRAMMING_FOUNDATIONS_COURSE
  };
}
