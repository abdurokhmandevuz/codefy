function parseCode(code) {
  const lines = code.split('\n');
  const commands = [];
  
  let inRepeat = false;
  let repeatCount = 0;
  let repeatCommands = [];
  let loopType = null; // 'py' or 'js'
  
  for (let i = 0; i < lines.length; i++) {
    const rawLine = lines[i];
    const line = rawLine.trim();
    if (!line) continue;

    // JavaScript style block closing
    if (line === '}' && inRepeat && loopType === 'js') {
      for (let r = 0; r < repeatCount; r++) {
        commands.push(...repeatCommands.map((c, idx) => ({ ...c, id: `rep-${i}-${r}-${idx}` })));
      }
      inRepeat = false;
      repeatCount = 0;
      repeatCommands = [];
      loopType = null;
      continue;
    } else if (line === '}') {
      return { error: `Xato (qator ${i + 1}): Kutilmagan '}' belgisi.` };
    }

    // Python style loop: for i in range(3):
    const pyLoopMatch = line.match(/^for\s+.*\s+in\s+range\s*\(\s*(\d+)\s*\)\s*:/);
    // JS style loop: for (let i = 0; i < 3; i++) {
    const jsLoopMatch = line.match(/^for\s*\(.*;.*<\s*(\d+);.*\)\s*\{?/);

    const loopMatch = pyLoopMatch || jsLoopMatch;

    if (loopMatch) {
      if (inRepeat) {
        return { error: `Xato (qator ${i + 1}): Ichma-ich tsikllar qo'llab-quvvatlanmaydi.` };
      }
      inRepeat = true;
      repeatCount = parseInt(loopMatch[1], 10);
      repeatCommands = [];
      loopType = pyLoopMatch ? 'py' : 'js';
      continue;
    }

    // Parse commands
    let type = null;
    if (line.includes('move_forward') || line.includes('moveForward')) type = 'FORWARD';
    else if (line.includes('turn_right') || line.includes('turnRight')) type = 'TURN_RIGHT';
    else if (line.includes('turn_left') || line.includes('turnLeft')) type = 'TURN_LEFT';
    else {
      return { error: `Xato (qator ${i + 1}): Noma'lum buyruq: "${line}"` };
    }

    // Add to appropriate list
    if (inRepeat) {
      const isIndented = rawLine.startsWith(' ') || rawLine.startsWith('\t');
      
      if (!isIndented && loopType === 'py') {
        // Python loop ended because indentation broke
        for (let r = 0; r < repeatCount; r++) {
          commands.push(...repeatCommands.map((c, idx) => ({ ...c, id: `rep-${i}-${r}-${idx}` })));
        }
        inRepeat = false;
        repeatCount = 0;
        repeatCommands = [];
        loopType = null;
        commands.push({ type, id: `cmd-${i}` });
      } else {
        repeatCommands.push({ type, id: `cmd-${i}` });
      }
    } else {
      commands.push({ type, id: `cmd-${i}` });
    }
  }

  // End of file, flush any remaining repeats (even if JS, maybe they forgot '}')
  if (inRepeat) {
    for (let r = 0; r < repeatCount; r++) {
      commands.push(...repeatCommands.map((c, idx) => ({ ...c, id: `rep-end-${r}-${idx}` })));
    }
  }

  return { commands };
}

window.parseCode = parseCode;
