import React from 'react';
import { Flame, Star, Coins } from 'lucide-react';

const TopBar = ({ streak = 2, stars = 14, coins = 150 }) => {
  return (
    <div className="top-bar">
      <div className="top-bar-stat streak">
        <Flame size={20} color="#FF9600" fill="#FF9600" />
        <span>{streak}</span>
      </div>
      <div className="top-bar-stat stars">
        <Star size={20} color="#FFC800" fill="#FFC800" />
        <span>{stars}</span>
      </div>
      <div className="top-bar-stat coins">
        <Coins size={20} color="#1CB0F6" fill="#1CB0F6" />
        <span>{coins}</span>
      </div>
    </div>
  );
};

export default TopBar;
