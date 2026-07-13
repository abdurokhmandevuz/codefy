import React from 'react';
import { ArrowLeft, Star, Lock } from 'lucide-react';
import { levels } from '../game/levels';
import TopBar from '../components/TopBar';

const MapView = ({ unlockedLevels, levelStars, onSelectLevel, onBack }) => {
  const totalStars = Object.values(levelStars).reduce((a, b) => a + b, 0);
  
  return (
    <div className="map-view">
      <header className="map-header">
        <button className="icon-btn" onClick={onBack}>
          <ArrowLeft />
        </button>
        <h2>Xarita</h2>
        <TopBar stars={totalStars} />
      </header>

      <div className="map-container">
        <div className="map-path">
          <svg className="path-svg">
            <polyline 
              points={levels.map((l, i) => {
                const x = 50 + Math.sin(i * 1.5) * 30;
                const y = (i * 120) + 60;
                return `${x}%,${y}`;
              }).join(' ')} 
              fill="none" 
              stroke="var(--color-primary)" 
              strokeWidth="4" 
              strokeDasharray="12 12"
              opacity="0.5"
            />
          </svg>
          
          {levels.map((level, index) => {
            const isUnlocked = level.id <= unlockedLevels;
            const isCurrent = level.id === unlockedLevels;
            const isCompleted = level.id < unlockedLevels;
            const stars = levelStars[level.id] || 0;
            
            // Generate a zigzag path position
            const leftPosition = 50 + Math.sin(index * 1.5) * 30;

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
                key={level.id}
                className={`level-node-wrapper ${wrapperClass}`}
                style={{ 
                  position: 'absolute',
                  left: `${leftPosition}%`, 
                  top: `${(index * 120) + 30}px`,
                  transform: 'translateX(-50%)'
                }}
              >
                <button 
                  className="level-node"
                  onClick={() => onSelectLevel(level.id)}
                  disabled={!isUnlocked}
                  style={inlineStyle}
                >
                  {isCompleted ? '✓' : (isUnlocked ? level.id : <Lock size={20} />)}
                </button>
                
                {isUnlocked && (
                  <div className="level-stars">
                    {[1, 2, 3].map(starNum => (
                      <Star 
                        key={starNum} 
                        size={12} 
                        fill={starNum <= stars ? "#FFD700" : "transparent"} 
                        color={starNum <= stars ? "#FFD700" : "#ccc"} 
                      />
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default MapView;
