/**
 * SPS CODE ORBIT — Real Python Execution Engine
 * Uses Pyodide (Python/WebAssembly) for genuine CPython execution.
 * Replaces the previous fake Python parser/simulator.
 *
 * Architecture:
 *   - Pyodide loads once from CDN (WebAssembly, browser-side only)
 *   - All Python execution is client-side — no server, no Node, no PHP
 *   - PHP/MySQL handle auth, progress, enrollment (unchanged)
 *   - JavaScript handles non-Python exercises (JS, HTML, CSS) unchanged
 *
 * Pyodide CDN: https://cdn.jsdelivr.net/pyodide/v0.27.5/full/pyodide.js
 *   WASM loads from same CDN — no server-side Python needed.
 */

class SafeCodeRunner {
  constructor() {
    this._pyodide = null;
    this._pyodideLoading = false;
    this._pyodideReady = false;
    this._pyodideError = null;
    this._stdinQueue = [];
    this._pendingInputCallback = null;
    this._trapWindowPrint();
    // Start loading Pyodide immediately (background)
    this._initPyodide();
  }

  /** Pre-seed stdin values for automated test-solution runs. */
  setStdin(values) {
    if (Array.isArray(values)) this._stdinQueue = values.map(String);
    else if (values == null || values === '') this._stdinQueue = [];
    else this._stdinQueue = [String(values)];
  }

  _trapWindowPrint() {
    if (typeof window !== 'undefined' && window.print) {
      window._nativePrint = window.print;
      window.print = function(...args) {
        if (args.length > 0) console.log('[SPS Orbit]:', ...args);
      };
    }
  }

  async _initPyodide() {
    if (this._pyodideReady || this._pyodideLoading) return;
    this._pyodideLoading = true;
    try {
      // Load Pyodide from CDN if not already on page
      if (typeof loadPyodide === 'undefined') {
        await new Promise((resolve, reject) => {
          const script = document.createElement('script');
          script.src = 'https://cdn.jsdelivr.net/pyodide/v0.27.5/full/pyodide.js';
          script.onload = resolve;
          script.onerror = () => reject(new Error('Failed to load Pyodide script from CDN'));
          document.head.appendChild(script);
        });
      }
      this._pyodide = await loadPyodide({
        indexURL: 'https://cdn.jsdelivr.net/pyodide/v0.27.5/full/',
        stdout: () => {},  // we capture via runPythonAsync below
        stderr: () => {}
      });
      this._pyodideReady = true;
      this._pyodideLoading = false;
      // Signal any waiting callers
      if (this._readyResolvers) {
        this._readyResolvers.forEach(r => r());
        this._readyResolvers = [];
      }
    } catch (err) {
      this._pyodideError = err;
      this._pyodideLoading = false;
      if (this._readyResolvers) {
        this._readyResolvers.forEach(r => r());
        this._readyResolvers = [];
      }
    }
  }

  _waitForPyodide() {
    if (this._pyodideReady || this._pyodideError) {
      return Promise.resolve();
    }
    if (!this._readyResolvers) this._readyResolvers = [];
    return new Promise(resolve => this._readyResolvers.push(resolve));
  }

  /** Main entry point — dispatches by language */
  async runCodeAsync(code, language = 'Python') {
    const lang = (language || 'Python').toLowerCase();
    if (lang.includes('js') || lang.includes('javascript')) {
      return this.runJavaScriptSnippet(code);
    }
    if (lang.includes('html') || lang.includes('web')) {
      return this.runHtmlSnippet(code);
    }
    if (lang.includes('css')) {
      return this.runCssSnippet(code);
    }
    return await this._runRealPython(code);
  }

  /** Synchronous wrapper — returns a Promise but some callers expect sync.
   *  Use runCodeAsync() for proper async. This keeps backward compat. */
  runCode(code, language = 'Python') {
    // Return a promise — callers that await it work correctly.
    // Legacy sync callers get a Promise object; we handle that gracefully
    // in the UI by checking for .then on the result.
    return this.runCodeAsync(code, language);
  }

  async _runRealPython(code) {
    // Ensure Pyodide is loaded
    await this._waitForPyodide();

    if (this._pyodideError) {
      return {
        success: false,
        output: `Python engine failed to load: ${this._pyodideError.message}\n\nPlease check your internet connection and reload the page.`,
        error: this._pyodideError.message
      };
    }

    if (!this._pyodideReady) {
      // Still loading — retry signal
      return {
        success: false,
        output: 'Python engine is still loading. Please wait a moment and click Run Code again.',
        loading: true
      };
    }

    const py = this._pyodide;
    const stdinQueue = [...this._stdinQueue]; // snapshot
    this._stdinQueue = []; // consume

    // Build captured-output + stdin shim
    const runnerSetup = `
import sys
import io

class _SPS_Stdout:
    def __init__(self):
        self._buf = []
    def write(self, s):
        self._buf.append(s)
    def flush(self):
        pass
    def getvalue(self):
        return ''.join(self._buf)

class _SPS_Stdin:
    def __init__(self, queue):
        self._queue = list(queue)
        self._buf = ''
        self._pos = 0
    def readline(self):
        if self._queue:
            val = self._queue.pop(0)
            return val + '\\n'
        # Fall back to JS prompt for interactive playground
        import js
        val = js.window.prompt('Input:') or ''
        return val + '\\n'
    def read(self, n=-1):
        return self.readline()

_sps_out = _SPS_Stdout()
_sps_err = _SPS_Stdout()
sys.stdout = _sps_out
sys.stderr = _sps_err
`;

    try {
      // Set up capture
      await py.runPythonAsync(runnerSetup);

      // Inject stdin queue into Python
      py.globals.set('_sps_stdin_queue', stdinQueue);
      await py.runPythonAsync(`
import sys
_sps_stdin = _SPS_Stdin(_sps_stdin_queue)
sys.stdin = _sps_stdin
`);

      // Run user code
      await py.runPythonAsync(code);

      // Collect output
      const stdout = py.globals.get('_sps_out').getvalue();
      const stderr = py.globals.get('_sps_err').getvalue();

      // Restore stdout/stderr
      await py.runPythonAsync('import sys; sys.stdout = sys.__stdout__; sys.stderr = sys.__stderr__');

      const output = stdout + (stderr ? '\n[stderr]\n' + stderr : '');

      return {
        success: true,
        output: output || '(Code executed with no output)'
      };

    } catch (err) {
      // Restore stdout/stderr even on error
      try {
        await py.runPythonAsync('import sys; sys.stdout = sys.__stdout__; sys.stderr = sys.__stderr__');
      } catch (_) {}

      // Collect any partial output
      let partialOut = '';
      try {
        partialOut = py.globals.get('_sps_out').getvalue();
      } catch (_) {}

      // Format the Python error nicely
      const errMsg = this._formatPythonError(err.message || String(err));

      return {
        success: false,
        output: (partialOut ? partialOut + '\n' : '') + errMsg,
        error: errMsg
      };
    }
  }

  _formatPythonError(msg) {
    // Pyodide wraps errors — extract the Python traceback part
    // Typical: "PythonError: Traceback...\nNameError: name 'x' is not defined"
    if (msg.includes('PythonError:')) {
      msg = msg.replace(/^PythonError:\s*/, '');
    }
    // Remove internal Pyodide file paths like File "<exec>", line N
    msg = msg.replace(/File "<exec>",/g, 'File "<your code>",');
    return msg.trim();
  }

  // ─── JavaScript runner (unchanged) ─────────────────────────────────────────
  runJavaScriptSnippet(code) {
    const logs = [];
    const customConsole = {
      log: (...args) => logs.push(args.map(a => typeof a === 'object' ? JSON.stringify(a) : String(a)).join(' ')),
      error: (...args) => logs.push('Error: ' + args.map(a => typeof a === 'object' ? JSON.stringify(a) : String(a)).join(' ')),
      warn: (...args) => logs.push('Warn: ' + args.map(a => typeof a === 'object' ? JSON.stringify(a) : String(a)).join(' ')),
      info: (...args) => logs.push(args.map(a => typeof a === 'object' ? JSON.stringify(a) : String(a)).join(' '))
    };
    const shadowPrint = (...args) => customConsole.log(...args);
    try {
      const mockDocument = {
        querySelector: () => ({ textContent: '', style: {}, innerHTML: '' }),
        getElementById: () => ({ textContent: '', style: {}, innerHTML: '' }),
        createElement: () => ({ textContent: '', style: {}, appendChild: () => {} })
      };
      const mockWindow = { print: shadowPrint, alert: (m) => logs.push('[ALERT]: ' + m), confirm: () => true, prompt: () => '' };
      const fn = new Function('console', 'print', 'document', 'window', `"use strict";\n${code}`);
      fn(customConsole, shadowPrint, mockDocument, mockWindow);
      return { success: true, output: logs.join('\n') || '(No console output)' };
    } catch (err) {
      return { success: false, error: err.name + ': ' + err.message, output: `${err.name}: ${err.message}` };
    }
  }

  runHtmlSnippet(code) {
    try {
      const parser = new DOMParser();
      const doc = parser.parseFromString(code, 'text/html');
      const bodyChildren = Array.from(doc.body.children);
      const textParts = bodyChildren.length > 0
        ? bodyChildren.map(el => el.textContent.trim()).filter(Boolean)
        : [doc.body.textContent.trim()];
      return { success: true, output: textParts.join('\n') || doc.body.innerHTML || '(HTML parsed)' };
    } catch (err) {
      return { success: false, error: err.message, output: 'Error parsing HTML: ' + err.message };
    }
  }

  runCssSnippet(code) {
    return { success: true, output: code.replace(/\s+/g, ' ').trim() || '(CSS rules validated)' };
  }

  // ─── evaluatePractice — used by Test Solution ───────────────────────────────
  async evaluatePracticeAsync(code, expectedOutput, language = 'Python') {
    const result = await this.runCodeAsync(code, language);

    if (!result.success) {
      const errMsg = result.error || result.output || 'Execution error';
      const isRuntime = errMsg.includes('Error') || errMsg.includes('Traceback');
      return {
        passed: false,
        output: result.output,
        message: isRuntime
          ? 'Your code produced an error. Check the error message and fix your code.'
          : 'Syntax error. Check your Python syntax.'
      };
    }

    const trimmedOut = (result.output || '').trim();
    const expected = String(expectedOutput || '').trim();

    let passed = false;
    if (language.toLowerCase().includes('css')) {
      passed = code.replace(/\s+/g, '').includes(expected.replace(/\s+/g, ''));
    } else if (!expected) {
      passed = result.success;
    } else {
      passed = (trimmedOut === expected) || trimmedOut.includes(expected);
    }

    return {
      passed,
      output: trimmedOut || '(No output produced)',
      message: passed
        ? 'Correct! Mission complete.'
        : `Not quite — your output does not match the expected result.\n\nExpected:\n${expected}\n\nGot:\n${trimmedOut}`
    };
  }

  /** Synchronous-compatible wrapper (returns Promise) */
  evaluatePractice(code, expectedOutput, language = 'Python') {
    return this.evaluatePracticeAsync(code, expectedOutput, language);
  }
}

// ─── UI helpers — async-aware wrappers ──────────────────────────────────────
async function runIdeCodeAsync(id, lang) {
  const textarea = document.getElementById(`code-textarea-${id}`);
  const consoleBox = document.getElementById(`console-out-${id}`);
  if (!textarea || !consoleBox) return;

  const code = textarea.value;

  // HTML/CSS live preview
  if ((lang || '').toLowerCase() === 'html' || (lang || '').toLowerCase() === 'css') {
    consoleBox.innerHTML = `<iframe class="live-html-preview" id="iframe-${id}"></iframe>`;
    const iframe = document.getElementById(`iframe-${id}`);
    if (typeof renderLiveHtmlIframe === 'function') renderLiveHtmlIframe(iframe, code);
    return;
  }

  consoleBox.textContent = '⏳ Running…';

  if (!window.codeRunner) window.codeRunner = new SafeCodeRunner();

  const result = await window.codeRunner.runCodeAsync(code, lang || 'Python');

  if (result.loading) {
    consoleBox.textContent = result.output;
    return;
  }

  consoleBox.textContent = result.output || (result.success
    ? '(Code executed with no output)'
    : result.error || 'Execution error');
}

async function testExerciseSolutionAsync(idx, lang, expectedOutput, successMsg, solutionCode) {
  const textarea = document.getElementById(`code-textarea-exercise-${idx}`);
  const consoleBox = document.getElementById(`console-out-exercise-${idx}`);
  const statusBadge = document.getElementById(`challenge-status-badge-${idx}`);
  if (!textarea || !consoleBox) return;

  const userCode = textarea.value;
  // solutionCode is NEVER executed; it is passed only for reference, not evaluated here.

  consoleBox.textContent = '⏳ Testing…';
  if (statusBadge) statusBadge.textContent = 'Testing…';

  if (!window.codeRunner) window.codeRunner = new SafeCodeRunner();

  // Pre-seed deterministic test input
  try { window.codeRunner.setStdin(['ShadyCoder']); } catch (_) {}

  const result = await window.codeRunner.evaluatePracticeAsync(userCode, expectedOutput, lang || 'Python');

  consoleBox.textContent = result.output + '\n\n' + result.message;

  if (statusBadge) {
    statusBadge.textContent = result.passed ? '✅ Passed' : '❌ Needs work';
    statusBadge.style.color = result.passed ? '#4ADE80' : '#F87171';
  }
}


// ─── Exports ─────────────────────────────────────────────────────────────────
if (typeof window !== 'undefined') {
  window.SafeCodeRunner = SafeCodeRunner;
  window.codeRunner = window.codeRunner || new SafeCodeRunner();
  // Expose async UI helpers globally so lesson.html onclick handlers work
  window.runIdeCodeAsync = runIdeCodeAsync;
  window.testExerciseSolutionAsync = testExerciseSolutionAsync;
}
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { SafeCodeRunner };
}
