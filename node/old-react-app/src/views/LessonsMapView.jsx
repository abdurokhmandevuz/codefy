import React from 'react';
import { ArrowLeft, Lock, Terminal, Zap } from 'lucide-react';
import { jsLessons } from '../data/jsLessons';
import { pythonLessons } from '../data/pythonLessons';
import TopBar from '../components/TopBar';

const LessonsMapView = ({ unlockedLessons, levelStars, onSelectLesson, onBack }) => {
  const renderPath = (language, lessonsData, title, accentColor) => {
    const unlocked = unlockedLessons[language] || 1;
    
    return (
      <div className="lesson-path">
        <h3 className="path-title" style={{ color: accentColor }}>
          {title}
        </h3>
        
        <div className="path-nodes">
          <svg className="path-svg">
            <polyline 
              points={lessonsData.map((_, i) => `50%,${(i * 100) + 50}`).join(' ')} 
              fill="none" 
              stroke="var(--color-bg-soft)" 
              strokeWidth="10" 
              strokeLinejoin="round"
              strokeLinecap="round"
            />
          </svg>

          {lessonsData.map((lesson, index) => {
            const isUnlocked = lesson.id <= unlocked;
            const isCurrent = lesson.id === unlocked;
            const isCompleted = lesson.id < unlocked;
            
            let wrapperClass = 'locked';
            let inlineStyle = {};
            if (isCompleted) {
              wrapperClass = 'unlocked completed';
              inlineStyle = { borderColor: 'var(--color-primary)', color: 'var(--color-primary)' };
            } else if (isCurrent) {
              wrapperClass = 'unlocked current';
              inlineStyle = { borderColor: 'var(--color-secondary)', color: 'var(--color-secondary)' };
            }

            return (
              <div 
                key={lesson.id}
                className={`lesson-node-wrapper ${wrapperClass}`}
                style={{ top: `${(index * 100) + 20}px` }}
              >
                <div className="lesson-node-content">
                  <button 
                    className="lesson-node"
                    onClick={() => onSelectLesson(language, lesson.id)}
                    disabled={!isUnlocked}
                    style={inlineStyle}
                  >
                    {isCompleted ? '✓' : (isUnlocked ? lesson.id : <Lock size={20} />)}
                  </button>
                  <span className="lesson-node-label">{lesson.title}</span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    );
  };

  return (
    <div className="lessons-map-view">
      <header className="map-header">
        <button className="icon-btn" onClick={onBack}>
          <ArrowLeft />
        </button>
        <h2>Darslar Xaritasi</h2>
        <TopBar />
      </header>

      <div className="lessons-container">
        {renderPath('python', pythonLessons, <span style={{display: 'flex', alignItems: 'center', gap: '8px'}}><Terminal size={24} /> Python</span>, 'var(--color-primary)')}
        {renderPath('js', jsLessons, <span style={{display: 'flex', alignItems: 'center', gap: '8px'}}><Zap size={24} /> JavaScript</span>, 'var(--color-accent)')}
      </div>
    </div>
  );
};

export default LessonsMapView;
