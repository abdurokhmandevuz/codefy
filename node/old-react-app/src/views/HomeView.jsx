import React, { useState, useEffect } from 'react';
import { Gamepad2, BookOpen, Crown } from 'lucide-react';
import Onboarding from '../components/Onboarding';
import TopBar from '../components/TopBar';

const HomeView = ({ onStartGame, onStartLessons, onStartPremium, hasSeenOnboarding, onOnboardingComplete }) => {
  const [showOnboarding, setShowOnboarding] = useState(false);

  useEffect(() => {
    if (!hasSeenOnboarding) {
      setShowOnboarding(true);
    }
  }, [hasSeenOnboarding]);

  const handleOnboardingFinish = () => {
    setShowOnboarding(false);
    onOnboardingComplete();
  };

  return (
    <div className="home-view">
      {showOnboarding && <Onboarding onComplete={handleOnboardingFinish} />}
      
      <div className="hero-panel" style={{ paddingTop: '1rem' }}>
        <TopBar />

        <h1 className="logo">
          <span className="logo-code">Code</span>
          <span className="logo-fy">fy</span>
        </h1>
        <p className="subtitle">Dasturlashni o'yin orqali o'rganamiz!</p>
        
        <div className="character-preview">
          🤖
        </div>
      </div>

      <div className="home-content">
        <div className="home-actions">
          <div className="home-cards-grid">
            <button className="home-card" onClick={onStartGame}>
              <div className="home-card-icon" style={{color: 'var(--color-primary)'}}>
                <Gamepad2 size={32} />
              </div>
              <span className="home-card-title">O'yin (Bloklar)</span>
            </button>

            <button className="home-card" onClick={onStartLessons}>
              <div className="home-card-icon" style={{color: 'var(--color-accent)'}}>
                <BookOpen size={32} />
              </div>
              <span className="home-card-title">Darslar (Kod yozish)</span>
            </button>

            <button className="home-card shine-effect" onClick={onStartPremium}>
              <div className="home-card-icon" style={{color: 'var(--color-premium)'}}>
                <Crown size={32} />
              </div>
              <span className="home-card-title">Video Kurslar</span>
            </button>
          </div>
          
          {hasSeenOnboarding && (
            <button className="secondary-btn" onClick={() => setShowOnboarding(true)}>
              <BookOpen size={20} />
              Qanday o'ynaladi?
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default HomeView;
