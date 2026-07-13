import React, { useState } from 'react';
import { ChevronRight, Play } from 'lucide-react';

const slides = [
  {
    title: 'Funksiya nima?',
    content: 'Funksiya — bu kompyuterga beriladigan maxsus buyruq. Masalan, "oldinga yur" degan blok aslida bitta kichkina funksiya!',
    visual: '🤖 ➡️ ⭐️',
    color: '#4CAF50'
  },
  {
    title: 'Ketma-ketlik',
    content: 'Kompyuterlar buyruqlarni siz qo\'ygan tartibda tepadan pastga qarab bajaradi. Agar tartibni adashtirsangiz, robot noto\'g\'ri yo\'lga ketib qoladi.',
    visual: '1️⃣ ⬇️ 2️⃣ ⬇️ 3️⃣',
    color: '#2196F3'
  },
  {
    title: 'Tsikl (Takrorlash)',
    content: 'Nega bir xil buyruqni 5 marta yozish kerak? O\'rniga "5 marta takrorla" blokini ishlatsak, ishimiz ancha osonlashadi!',
    visual: '🔁 x 3',
    color: '#9C27B0'
  },
  {
    title: 'Shart (Agar)',
    content: 'Ba\'zida qaror qabul qilish kerak. "Agar oldinda devor bo\'lsa, buril" — bu shartli buyruq deyiladi. Siz haqiqiy dasturchisiz!',
    visual: '🧱 ➡️ ↪️',
    color: '#FF9800'
  }
];

const Onboarding = ({ onComplete }) => {
  const [currentSlide, setCurrentSlide] = useState(0);

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(prev => prev + 1);
    } else {
      onComplete();
    }
  };

  const slide = slides[currentSlide];

  return (
    <div className="onboarding-modal-overlay">
      <div className="onboarding-modal zoom-in" style={{ borderTop: `8px solid ${slide.color}` }}>
        <div className="onboarding-progress">
          {slides.map((_, idx) => (
            <div 
              key={idx} 
              className={`progress-dot ${idx === currentSlide ? 'active' : ''} ${idx < currentSlide ? 'done' : ''}`}
              style={{ backgroundColor: idx === currentSlide ? slide.color : '' }}
            />
          ))}
        </div>
        
        <div className="onboarding-visual">
          {slide.visual}
        </div>
        
        <h2 style={{ color: slide.color }}>{slide.title}</h2>
        <p>{slide.content}</p>
        
        <div className="onboarding-actions" style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
          {currentSlide < slides.length - 1 ? (
            <button 
              className="primary-btn" 
              style={{ backgroundColor: slide.color, boxShadow: `0 4px 0px ${slide.color}80` }}
              onClick={handleNext}
            >
              Keyingisi <ChevronRight size={20} />
            </button>
          ) : (
            <button 
              className="primary-btn pulse" 
              style={{ backgroundColor: slide.color, boxShadow: `0 4px 0px ${slide.color}80` }}
              onClick={handleNext}
            >
              <Play size={20} /> Boshladik!
            </button>
          )}
          <button 
            className="btn-secondary" 
            style={{ border: 'none', background: 'transparent', color: '#888' }}
            onClick={onComplete}
          >
            O'tkazib yuborish
          </button>
        </div>
      </div>
    </div>
  );
};

export default Onboarding;
