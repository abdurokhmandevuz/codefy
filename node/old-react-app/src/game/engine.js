export const executeBlocks = (blocks, startPos, gridSize, walls, targetPos) => {
  // blocks is an array of objects: { type: 'FORWARD' | 'TURN_RIGHT' | 'TURN_LEFT' | 'REPEAT_2' | 'REPEAT_3' | 'REPEAT_4' }
  const path = [];
  let currentPos = { ...startPos };
  path.push({ ...currentPos, action: 'START' });

  let i = 0;
  let status = 'SUCCESS'; // 'SUCCESS', 'HIT_WALL', 'OUT_OF_BOUNDS'
  let isLevelComplete = false;

  const moveForward = () => {
    let newX = currentPos.x;
    let newY = currentPos.y;

    if (currentPos.dir === 'UP') newY -= 1;
    else if (currentPos.dir === 'RIGHT') newX += 1;
    else if (currentPos.dir === 'DOWN') newY += 1;
    else if (currentPos.dir === 'LEFT') newX -= 1;

    // Check bounds
    if (newX < 0 || newX >= gridSize.cols || newY < 0 || newY >= gridSize.rows) {
      status = 'OUT_OF_BOUNDS';
      return false;
    }

    // Check walls
    const hitWall = walls.some(w => w.x === newX && w.y === newY);
    if (hitWall) {
      status = 'HIT_WALL';
      return false;
    }

    currentPos = { ...currentPos, x: newX, y: newY };
    path.push({ ...currentPos, action: 'FORWARD' });

    if (newX === targetPos.x && newY === targetPos.y) {
      isLevelComplete = true;
    }
    return true;
  };

  const turn = (direction) => {
    const dirs = ['UP', 'RIGHT', 'DOWN', 'LEFT'];
    const currentIdx = dirs.indexOf(currentPos.dir);
    let newIdx = currentIdx;

    if (direction === 'RIGHT') newIdx = (currentIdx + 1) % 4;
    else if (direction === 'LEFT') newIdx = (currentIdx + 3) % 4;

    currentPos = { ...currentPos, dir: dirs[newIdx] };
    path.push({ ...currentPos, action: `TURN_${direction}` });
  };

  const executeAction = (blockType) => {
    if (isLevelComplete || status !== 'SUCCESS') return;

    if (blockType === 'FORWARD') {
      moveForward();
    } else if (blockType === 'TURN_RIGHT') {
      turn('RIGHT');
    } else if (blockType === 'TURN_LEFT') {
      turn('LEFT');
    }
  };

  while (i < blocks.length && status === 'SUCCESS' && !isLevelComplete) {
    const block = blocks[i];
    
    if (block.type.startsWith('REPEAT')) {
      const times = parseInt(block.type.split('_')[1] || 3, 10);
      const nextBlock = blocks[i + 1];
      if (nextBlock && !nextBlock.type.startsWith('REPEAT')) {
        for (let t = 0; t < times; t++) {
          executeAction(nextBlock.type);
          if (status !== 'SUCCESS' || isLevelComplete) break;
        }
        i += 2; // Skip the repeat block and the block it applied to
        continue;
      } else {
        // If no next block or next block is another repeat, just ignore
        i++;
      }
    } else {
      executeAction(block.type);
      i++;
    }
  }

  return {
    path,
    status,
    isComplete: isLevelComplete
  };
};
