import React, { useRef, useEffect } from 'react';
import { Terminal, Plus, HelpCircle } from 'lucide-react';

const CodeEditor = ({ code, setCode, hintLevel, onRun }) => {
  const textareaRef = useRef(null);

  const insertCode = (text) => {
    setCode((prev) => prev + (prev && !prev.endsWith('\n') ? '\n' : '') + text + '\n');
    if (textareaRef.current) {
      textareaRef.current.focus();
    }
  };

  // Keep textarea scrolled to bottom if typing fast
  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.scrollTop = textareaRef.current.scrollHeight;
    }
  }, [code]);

  const commands = [
    { label: "Oldinga yur", code: "move_forward()" },
    { label: "O'ngga burul", code: "turn_right()" },
    { label: "Chapga burul", code: "turn_left()" },
    { label: "3 marta takrorla", code: "for i in range(3):\n  " }
  ];

  return (
    <div className="code-editor-container">
      <div className="code-editor-header">
        <Terminal size={18} />
        <span>Matnli Dasturlash</span>
      </div>

      {hintLevel === 'buttons' && (
        <div className="editor-helpers buttons-mode">
          <p className="helper-title">Buyruqni tanlang:</p>
          <div className="helper-buttons">
            {commands.map((cmd, idx) => (
              <button 
                key={idx} 
                className="cmd-btn"
                onClick={() => insertCode(cmd.code)}
              >
                <Plus size={14} /> {cmd.label}
              </button>
            ))}
          </div>
        </div>
      )}

      {hintLevel === 'assisted' && (
        <div className="editor-helpers assisted-mode">
          <p className="helper-title"><HelpCircle size={14} /> Mavjud buyruqlar:</p>
          <div className="helper-text-list">
            <code>move_forward()</code>
            <code>turn_right()</code>
            <code>turn_left()</code>
            <code>for i in range(N):</code>
          </div>
        </div>
      )}

      <div className="textarea-wrapper">
        <div className="line-numbers">
          {code.split('\n').map((_, i) => (
            <div key={i}>{i + 1}</div>
          ))}
        </div>
        <textarea
          ref={textareaRef}
          className="real-textarea"
          value={code}
          onChange={(e) => setCode(e.target.value)}
          placeholder="Bu yerga kod yozing..."
          spellCheck="false"
        />
      </div>
    </div>
  );
};

export default CodeEditor;
