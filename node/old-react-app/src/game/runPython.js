let pyodideInstance = null;
let pyodideLoading = null;

export async function loadPythonEnv() {
  if (pyodideInstance) return pyodideInstance;
  if (pyodideLoading) return pyodideLoading;

  pyodideLoading = (async () => {
    if (!window.loadPyodide) {
      await new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/pyodide/v0.26.0/full/pyodide.js';
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
      });
    }
    pyodideInstance = await window.loadPyodide({
      indexURL: 'https://cdn.jsdelivr.net/pyodide/v0.26.0/full/'
    });
    return pyodideInstance;
  })();

  return pyodideLoading;
}

export async function runPython(code) {
  try {
    const pyodide = await loadPythonEnv();

    await pyodide.runPythonAsync(`
import sys
import io
sys.stdout = io.StringIO()
    `);

    await pyodide.runPythonAsync(code);

    const output = pyodide.runPython('sys.stdout.getvalue()');
    return { success: true, output: output.trim(), error: null };
  } catch (err) {
    const message = err.message.split('\n').pop() || err.message;
    return { success: false, output: '', error: message };
  }
}
