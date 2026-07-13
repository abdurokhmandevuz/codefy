import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, Play, RotateCcw, Star } from 'lucide-react';
import { levels } from '../game/levels';
import { executeBlocks } from '../game/engine';
import { parseCode } from '../game/codeParser';
import GameGrid from '../components/GameGrid';
import CodeEditor from '../components/CodeEditor';

import TopBar from '../components/TopBar';

const GameView = ({ levelId, onComplete, onBack }) => {
  const level = levels.find(l => l.id === levelId);
  const [code, setCode] = useState('');
  const [parseError, setParseError] = useState(null);
  
  // Game execution state
  const [isPlaying, setIsPlaying] = useState(false);
  const [playerPos, setPlayerPos] = useState(level.startPos);
  const [pathState, setPathState] = useState(null); // null, 'SUCCESS', 'HIT_WALL', 'OUT_OF_BOUNDS', 'FAILED'
  const [showResultModal, setShowResultModal] = useState(false);
  const [starsEarned, setStarsEarned] = useState(0);

  const executionTimerRef = useRef(null);

  // Reset level state when level changes
  useEffect(() => {
    resetLevel();
    setCode(''); // Clear code on new level
  }, [levelId]);

  const resetLevel = () => {
    setIsPlaying(false);
    setPlayerPos(level.startPos);
    setPathState(null);
    setShowResultModal(false);
    setParseError(null);
    if (executionTimerRef.current) clearTimeout(executionTimerRef.current);
  };

  const calculateStars = (linesCount) => {
    // We can use line count instead of blocks count
    if (linesCount <= level.starThresholds[0]) return 3;
    if (linesCount <= level.starThresholds[1]) return 2;
    if (linesCount <= level.starThresholds[2]) return 1;
    return 1;
  };

  const handlePlay = () => {
    if (!code.trim()) return;
    resetLevel();
    
    const parsed = parseCode(code);
    if (parsed.error) {
      setParseError(parsed.error);
      return;
    }

    const workspaceBlocks = parsed.commands;
    if (workspaceBlocks.length === 0) return;

    setIsPlaying(true);

    const { path, status, isComplete } = executeBlocks(
      workspaceBlocks, 
      level.startPos, 
      level.gridSize, 
      level.walls, 
      level.targetPos
    );

    // Animate execution
    let step = 0;
    const animate = () => {
      if (step < path.length) {
        setPlayerPos(path[step]);
        
        if (step === path.length - 1 && status !== 'SUCCESS' && !isComplete) {
          setPathState(status);
        }

        step++;
        executionTimerRef.current = setTimeout(animate, 500);
      } else {
        setIsPlaying(false);
        if (isComplete) {
          const linesCount = code.trim().split('\n').filter(l => l.trim()).length;
          const stars = calculateStars(linesCount);
          setStarsEarned(stars);
          setShowResultModal(true);
        } else {
          setPathState('FAILED');
          setTimeout(() => {
            resetLevel();
          }, 1500);
        }
      }
    };
    
    executionTimerRef.current = setTimeout(animate, 200);
  };

  const handleNextLevel = () => {
    onComplete(levelId, starsEarned);
    onBack();
  };

  return (
    <div className="game-view">
      <header className="game-header">
        <button className="icon-btn" onClick={onBack}>
          <ArrowLeft />
        </button>
        <h2>{level.title}</h2>
        <div className="blocks-counter">
          Maqsad: {level.starThresholds[0]} qator (⭐⭐⭐)
        </div>
        <TopBar />
      </header>

      <div className="game-content">
        <div className="left-panel editor-panel">
          <CodeEditor 
            code={code} 
            setCode={setCode} 
            hintLevel={level.hintLevel} 
            onRun={handlePlay} 
          />
          {parseError && (
            <div className="parse-error">
              {parseError}
            </div>
          )}
        </div>

        <div className="right-panel">
          <div className="grid-container">
            <GameGrid 
              gridSize={level.gridSize}
              playerPos={playerPos}
              targetPos={level.targetPos}
              walls={level.walls}
              pathState={pathState}
            />
            
            {pathState === 'FAILED' && (
              <div className="feedback-overlay error">
                <span style={{fontSize: '2rem'}}>😲</span> Qayta urinib ko'ring!
              </div>
            )}
          </div>

          <div className="controls" style={{ display: 'flex', flexDirection: 'column', gap: 'var(--space-3)', width: '100%' }}>
            <button 
              className="primary-btn" 
              onClick={handlePlay}
              disabled={isPlaying || !code.trim()}
            >
              <Play size={20} />
              Ishga Tushirish
            </button>
            <button 
              className="secondary-btn" 
              onClick={resetLevel}
              disabled={isPlaying}
            >
              <RotateCcw size={20} />
              Boshiga Qaytarish
            </button>
          </div>
        </div>
      </div>

      {showResultModal && (
        <div className="modal-overlay">
          <div className="result-modal zoom-in">
            <div style={{fontSize: '4rem', marginBottom: '-20px', zIndex: 10, position: 'relative'}}>🎉</div>
            <h2>Tabriklaymiz!</h2>
            <div className="stars-earned">
              {[1, 2, 3].map(starNum => (
                <Star 
                  key={starNum} 
                  size={48} 
                  fill={starNum <= starsEarned ? "#FFD700" : "transparent"} 
                  color={starNum <= starsEarned ? "#FFD700" : "#ccc"} 
                  className={starNum <= starsEarned ? 'star-pop' : ''}
                  style={{ animationDelay: `${starNum * 0.2}s` }}
                />
              ))}
            </div>
            <p>Siz {code.trim().split('\n').filter(l => l.trim()).length} qator kod bilan bosqichni yakunladingiz!</p>
            <div className="modal-actions">
              <button className="primary-btn" onClick={handleNextLevel}>
                Keyingi Bosqich
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default GameView;
