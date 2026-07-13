import React, { useState } from 'react';
import HomeView from './views/HomeView';
import MapView from './views/MapView';
import GameView from './views/GameView';
import LessonsMapView from './views/LessonsMapView';
import LessonView from './views/LessonView';
import PremiumCoursesView from './views/PremiumCoursesView';
import './index.css';

function App() {
  const [currentView, setCurrentView] = useState('home');
  const [currentLevelId, setCurrentLevelId] = useState(null);
  
  // Game progress state
  const [unlockedLevels, setUnlockedLevels] = useState(1);
  const [levelStars, setLevelStars] = useState({}); // { 1: 3, 2: 2, ... }
  const [hasSeenOnboarding, setHasSeenOnboarding] = useState(false);

  // Lessons progress state
  const [unlockedLessons, setUnlockedLessons] = useState({ js: 1, python: 1 });
  const [currentLessonLang, setCurrentLessonLang] = useState(null);
  const [currentLessonId, setCurrentLessonId] = useState(null);

  const handleStartGame = () => {
    setCurrentView('map');
  };

  const handleStartLessons = () => {
    setCurrentView('lessonsMap');
  };

  const handleStartPremium = () => {
    setCurrentView('premiumCourses');
  };

  const handleSelectLevel = (levelId) => {
    if (levelId <= unlockedLevels) {
      setCurrentLevelId(levelId);
      setCurrentView('game');
    }
  };

  const handleLevelComplete = (levelId, stars) => {
    setLevelStars(prev => ({
      ...prev,
      [levelId]: Math.max(prev[levelId] || 0, stars)
    }));
    
    if (levelId === unlockedLevels && levelId < 15) {
      setUnlockedLevels(prev => prev + 1);
    }
  };

  const handleSelectLesson = (language, lessonId) => {
    if (lessonId <= (unlockedLessons[language] || 1)) {
      setCurrentLessonLang(language);
      setCurrentLessonId(lessonId);
      setCurrentView('lesson');
    }
  };

  const handleLessonComplete = (language, lessonId) => {
    setUnlockedLessons(prev => {
      const currentUnlocked = prev[language] || 1;
      if (lessonId === currentUnlocked && lessonId < 10) {
        return { ...prev, [language]: currentUnlocked + 1 };
      }
      return prev;
    });
  };

  const handleBackToMap = () => {
    setCurrentView('map');
    setCurrentLevelId(null);
  };

  const handleBackToLessonsMap = () => {
    setCurrentView('lessonsMap');
    setCurrentLessonId(null);
    setCurrentLessonLang(null);
  };

  return (
    <div className="app-container">
      {currentView === 'home' && (
        <HomeView 
          onStartGame={handleStartGame} 
          onStartLessons={handleStartLessons}
          onStartPremium={handleStartPremium}
          hasSeenOnboarding={hasSeenOnboarding}
          onOnboardingComplete={() => setHasSeenOnboarding(true)}
        />
      )}
      
      {currentView === 'map' && (
        <MapView 
          unlockedLevels={unlockedLevels} 
          levelStars={levelStars}
          onSelectLevel={handleSelectLevel} 
          onBack={() => setCurrentView('home')}
        />
      )}
      
      {currentView === 'game' && currentLevelId && (
        <GameView 
          levelId={currentLevelId}
          onComplete={handleLevelComplete}
          onBack={handleBackToMap}
        />
      )}

      {currentView === 'lessonsMap' && (
        <LessonsMapView 
          unlockedLessons={unlockedLessons}
          onSelectLesson={handleSelectLesson}
          onBack={() => setCurrentView('home')}
        />
      )}

      {currentView === 'lesson' && currentLessonId && currentLessonLang && (
        <LessonView 
          language={currentLessonLang}
          lessonId={currentLessonId}
          onComplete={handleLessonComplete}
          onBack={handleBackToLessonsMap}
        />
      )}

      {currentView === 'premiumCourses' && (
        <PremiumCoursesView 
          onBack={() => setCurrentView('home')}
        />
      )}
    </div>
  );
}

export default App;
