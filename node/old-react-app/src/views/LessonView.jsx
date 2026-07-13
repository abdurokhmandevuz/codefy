import React, { useState, useEffect } from 'react';
import { ArrowLeft, Play, Terminal, CheckCircle, XCircle } from 'lucide-react';
import { jsLessons } from '../data/jsLessons';
import { pythonLessons } from '../data/pythonLessons';
import { runJs } from '../game/runJs';
import { runPython, loadPythonEnv } from '../game/runPython';
import CodeEditor from '../components/CodeEditor';
import TopBar from '../components/TopBar';

const LessonView = ({ language, lessonId, onComplete, onBack }) => {
  const isPython = language === 'python';
  const lessonsData = isPython ? pythonLessons : jsLessons;
  const lesson = lessonsData.find(l => l.id === lessonId);

  const [code, setCode] = useState(lesson.initialCode);
  const [output, setOutput] = useState('');
  const [isExecuting, setIsExecuting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [showError, setShowError] = useState(false);
  const [isLoadingEnv, setIsLoadingEnv] = useState(isPython);

  useEffect(() => {
    setCode(lesson.initialCode);
    setOutput('');
    setIsSuccess(false);
    setShowError(false);
    
    if (isPython) {
      setIsLoadingEnv(true);
      loadPythonEnv()
        .then(() => setIsLoadingEnv(false))
        .catch(err => {
          console.error("Pyodide yuklashda xatolik:", err);
          setIsLoadingEnv(false);
          setOutput(`Xatolik: Python muhitini yuklab bo'lmadi.\n${err.message}`);
        });
    } else {
      setIsLoadingEnv(false);
    }
  }, [lessonId, language, lesson.initialCode, isPython]);

  const handleRun = async () => {
    if (!code.trim() || isLoadingEnv) return;
    
    setIsExecuting(true);
    setShowError(false);
    setIsSuccess(false);
    setOutput('Ishga tushirilmoqda...');

    let result;
    if (isPython) {
      result = await runPython(code);
    } else {
      result = await runJs(code);
    }

    setIsExecuting(false);

    if (result.error) {
      setOutput(`XATO:\n${result.error}`);
      setShowError(true);
    } else {
      const out = result.output;
      setOutput(out);
      
      const cleanOut = out.trim();
      const expected = lesson.expectedOutput.trim();
      
      if (cleanOut === expected || cleanOut.includes(expected)) {
        setIsSuccess(true);
      } else {
        setShowError(true);
      }
    }
  };

  const handleNext = () => {
    onComplete(language, lessonId);
    onBack();
  };

  return (
    <div className="lesson-view">
      {/* 1. YUQORI QATOR (Header) */}
      <header className="game-header">
        <button className="icon-btn" onClick={onBack}>
          <ArrowLeft />
        </button>
        <h2 style={{ color: 'var(--color-ink)' }}>{lesson.id}-Dars: {lesson.title}</h2>
        <div className="lang-badge" style={{ backgroundColor: isPython ? 'var(--color-primary)' : 'var(--color-accent)', color: isPython ? 'var(--color-surface)' : 'var(--color-ink)' }}>
          {isPython ? 'Python' : 'JavaScript'}
        </div>
        <TopBar />
      </header>

      {/* 2. O'RTA QATOR (Nazariya + Kod muharriri) */}
      <div className="lesson-middle-row">
        <div className="lesson-theory-panel">
          <h3>📘 Nazariya</h3>
          <p>{lesson.theory}</p>
          
          <div className="lesson-example">
            <h4>Kodni ko'rib chiqing:</h4>
            <pre><code>{lesson.exampleCode}</code></pre>
          </div>

          <div className="lesson-task">
            <h4>🎯 Vazifa:</h4>
            <p>{lesson.task}</p>
          </div>
        </div>

        <div className="lesson-editor-panel">
          <CodeEditor 
            code={code} 
            setCode={setCode} 
            hintLevel="free" 
            onRun={handleRun} 
          />
        </div>
      </div>

      {/* 3. PASTKI QATOR (Konsol + Tugmalar) */}
      <div className="lesson-bottom-row">
        <div className="output-panel">
          <div className="output-header">
            <div style={{display: 'flex', alignItems: 'center', gap: '0.5rem'}}>
              <Terminal size={16} /> Konsol chiqishi
            </div>
            {/* Kichik banner natija uchun */}
            {isSuccess && (
              <div className="mini-success-badge">
                <CheckCircle size={14} /> To'g'ri!
              </div>
            )}
            {showError && !isSuccess && output && !output.includes('XATO:') && (
              <div className="mini-error-badge">
                <XCircle size={14} /> Noto'g'ri natija
              </div>
            )}
          </div>
          <pre className={`output-content ${showError ? 'error-text' : ''} ${isSuccess ? 'success-text' : ''}`}>
            {output}
          </pre>
        </div>

        <div className="lesson-actions-panel">
          {isLoadingEnv ? (
            <div className="loading-badge">Python yuklanmoqda...</div>
          ) : (
            <>
              {isSuccess && (
                <div className="mascot-reaction">
                  <span style={{fontSize: '2rem'}}>🤖</span> Barakalla!
                </div>
              )}
              {isSuccess ? (
                <button 
                  className="primary-btn pulse" 
                  onClick={handleNext}
                >
                  Keyingi dars
                </button>
              ) : (
                <button 
                  className="primary-btn run-btn" 
                  onClick={handleRun}
                  disabled={isExecuting}
                >
                  <Play size={20} /> Ishga tushirish
                </button>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default LessonView;
