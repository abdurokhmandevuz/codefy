const levels = [
  {
    id: 1,
    title: '1-Bosqich: Oldinga intil',
    gridSize: { cols: 5, rows: 5 },
    startPos: { x: 1, y: 3, dir: 'RIGHT' },
    targetPos: { x: 3, y: 3 },
    walls: [],
    hintLevel: 'buttons', // 1-5 buttons
    starThresholds: [2, 3, 5],
  },
  {
    id: 2,
    title: '2-Bosqich: Burilish vaqti',
    gridSize: { cols: 5, rows: 5 },
    startPos: { x: 1, y: 1, dir: 'RIGHT' },
    targetPos: { x: 3, y: 3 },
    walls: [
      { x: 2, y: 1 },
      { x: 2, y: 2 }
    ],
    hintLevel: 'buttons',
    starThresholds: [4, 6, 8],
  },
  {
    id: 3,
    title: '3-Bosqich: Zig-Zag',
    gridSize: { cols: 6, rows: 6 },
    startPos: { x: 1, y: 1, dir: 'DOWN' },
    targetPos: { x: 4, y: 4 },
    walls: [
      { x: 1, y: 3 },
      { x: 2, y: 3 },
      { x: 3, y: 1 },
      { x: 3, y: 2 }
    ],
    hintLevel: 'buttons',
    starThresholds: [6, 8, 12],
  },
  {
    id: 4,
    title: '4-Bosqich: Takrorlash kuchi',
    gridSize: { cols: 6, rows: 6 },
    startPos: { x: 0, y: 2, dir: 'RIGHT' },
    targetPos: { x: 5, y: 2 },
    walls: [],
    hintLevel: 'buttons',
    starThresholds: [2, 4, 6],
  },
  {
    id: 5,
    title: '5-Bosqich: Labirint',
    gridSize: { cols: 6, rows: 6 },
    startPos: { x: 0, y: 0, dir: 'RIGHT' },
    targetPos: { x: 5, y: 5 },
    walls: [
      { x: 1, y: 0 }, { x: 1, y: 1 }, { x: 1, y: 2 }, { x: 1, y: 3 },
      { x: 3, y: 5 }, { x: 3, y: 4 }, { x: 3, y: 3 }, { x: 3, y: 2 }
    ],
    hintLevel: 'buttons',
    starThresholds: [8, 12, 16],
  }
];

// Generate placeholder levels 6-15
for (let i = 6; i <= 15; i++) {
  let hint = 'buttons';
  if (i >= 6 && i <= 10) hint = 'assisted';
  if (i >= 11) hint = 'free';

  levels.push({
    id: i,
    title: `${i}-Bosqich: Tez orada...`,
    gridSize: { cols: 5, rows: 5 },
    startPos: { x: 0, y: 0, dir: 'RIGHT' },
    targetPos: { x: 4, y: 4 },
    walls: [],
    hintLevel: hint,
    starThresholds: [5, 10, 15],
  });
}

window.gameLevels = levels;
