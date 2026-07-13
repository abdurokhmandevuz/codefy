import React from 'react';
import { Star } from 'lucide-react';

const GameGrid = ({ gridSize, playerPos, targetPos, walls, pathState }) => {
  const { cols, rows } = gridSize;

  // Render grid cells
  const cells = [];
  for (let y = 0; y < rows; y++) {
    for (let x = 0; x < cols; x++) {
      const isWall = walls.some(w => w.x === x && w.y === y);
      const isTarget = targetPos.x === x && targetPos.y === y;
      const isPlayer = playerPos.x === x && playerPos.y === y;

      cells.push(
        <div key={`${x}-${y}`} className={`grid-cell ${isWall ? 'wall' : ''}`}>
          {isTarget && !isPlayer && (
            <div className="target">
              <Star fill="#FFD700" color="#FFD700" size={32} />
            </div>
          )}
          {isPlayer && (
            <div 
              className={`player player-${playerPos.dir.toLowerCase()} ${pathState === 'HIT_WALL' ? 'shake' : ''}`}
            >
              🤖
            </div>
          )}
        </div>
      );
    }
  }

  return (
    <div 
      className="game-grid" 
      style={{ 
        gridTemplateColumns: `repeat(${cols}, 1fr)`,
        gridTemplateRows: `repeat(${rows}, 1fr)`
      }}
    >
      {cells}
    </div>
  );
};

export default GameGrid;
