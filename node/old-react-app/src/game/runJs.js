export async function runJs(code) {
  let output = [];
  const originalLog = console.log;

  try {
    // Override console.log
    console.log = (...args) => {
      output.push(args.map(a => typeof a === 'object' ? JSON.stringify(a) : String(a)).join(' '));
    };

    // Construct a safe function wrapper
    const fn = new Function(code);
    fn();
    
    return { success: true, output: output.join('\n'), error: null };
  } catch (error) {
    return { success: false, output: output.join('\n'), error: error.message || error.toString() };
  } finally {
    // Restore original console.log
    console.log = originalLog;
  }
}
