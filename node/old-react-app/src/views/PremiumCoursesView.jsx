import React, { useState } from 'react';
import { ArrowLeft, Clock, PlayCircle, Crown } from 'lucide-react';
import { premiumCourses } from '../data/premiumCourses';
import NotifyMeModal from '../components/NotifyMeModal';

const PremiumCoursesView = ({ onBack }) => {
  const [selectedCourse, setSelectedCourse] = useState(null);

  return (
    <div className="premium-view">
      <header className="game-header">
        <button className="icon-btn" onClick={onBack}>
          <ArrowLeft />
        </button>
        <h2 style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Crown color="var(--color-premium)" size={24} /> Video Kurslar (Premium)
        </h2>
        <div className="spacer"></div>
      </header>

      <div className="premium-content">
        <div className="premium-info-block">
          <h3>Nega ba'zi darslar pullik?</h3>
          <p>
            <strong>Bepul qismda</strong> siz dasturlashning asosiy mantiqi va ko'nikmalarini o'yin orqali o'rganasiz — bu <em>hech qachon pullik bo'lmaydi!</em> <br/><br/>
            <strong>Video kurslar</strong> esa haqiqiy ustozlar tomonidan yozilgan maxsus darslardir. Ular chuqurroq mavzularni (o'yin yaratish, veb-sayt tuzish) o'z ichiga oladi va ko'proq resurs talab qiladi.
          </p>
        </div>

        <div className="courses-grid">
          {premiumCourses.map(course => (
            <div 
              key={course.id} 
              className="course-card shine-effect"
              onClick={() => setSelectedCourse(course)}
            >
              <div className="course-badge">Tez orada</div>
              <div className="course-icon">{course.icon}</div>
              <h3>{course.title}</h3>
              <p className="course-desc">{course.description}</p>
              
              <div className="course-stats">
                <div className="stat">
                  <PlayCircle size={16} /> {course.stats.split(',')[0]}
                </div>
                <div className="stat">
                  <Clock size={16} /> {course.stats.split(',')[1]}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {selectedCourse && (
        <NotifyMeModal 
          courseTitle={selectedCourse.title} 
          onClose={() => setSelectedCourse(null)} 
        />
      )}
    </div>
  );
};

export default PremiumCoursesView;
