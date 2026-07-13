import React, { useState } from 'react';
import { X, Bell, CheckCircle } from 'lucide-react';

const NotifyMeModal = ({ courseTitle, onClose }) => {
  const [contactInfo, setContactInfo] = useState('');
  const [isSubmitted, setIsSubmitted] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!contactInfo.trim()) return;

    // Simulate API call to backend
    console.log(`[Lead Generated] Course: "${courseTitle}", Contact: ${contactInfo}`);
    
    setIsSubmitted(true);
    
    // Auto close after 3 seconds
    setTimeout(() => {
      onClose();
    }, 3000);
  };

  return (
    <div className="modal-overlay">
      <div className="result-modal zoom-in premium-modal">
        <button className="close-btn" onClick={onClose}><X size={24} /></button>
        
        {isSubmitted ? (
          <div className="modal-success-content">
            <CheckCircle size={64} color="#FFD700" className="pulse" />
            <h2>Rahmat!</h2>
            <p>Kurs qo'shilishi bilan sizga albatta xabar beramiz.</p>
          </div>
        ) : (
          <div className="modal-form-content">
            <div className="modal-icon-wrapper">
              <Bell size={48} color="#9C27B0" />
            </div>
            <h2>Bu kurs tez orada qo'shiladi!</h2>
            <p><strong>"{courseTitle}"</strong> kursi ustida ishlayapmiz. Birinchilardan bo'lib xabardor bo'lishni xohlaysizmi?</p>
            
            <form onSubmit={handleSubmit} className="notify-form">
              <input 
                type="text" 
                placeholder="Email yoki telefon raqamingiz" 
                value={contactInfo}
                onChange={(e) => setContactInfo(e.target.value)}
                className="notify-input"
              />
              <button type="submit" className="primary-btn premium-btn pulse" disabled={!contactInfo.trim()}>
                Xabar berish
              </button>
            </form>
          </div>
        )}
      </div>
    </div>
  );
};

export default NotifyMeModal;
