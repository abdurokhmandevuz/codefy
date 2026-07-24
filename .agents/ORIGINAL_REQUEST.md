# Original User Request

## Initial Request — 2026-07-24T06:02:43Z

# Teamwork Project Prompt — Draft

Codefy (Full-stack o'quv platformasi) darslar o'tish (learning) tizimini noldan oxirigacha, ya'ni orqa qism (Django) modellarini va APIni kengaytirishdan boshlab, old qismdagi (Flutter) darslarni to'liq ishlab chiqarishga (production-ready) tayyor holatga keltirish.

Working directory: C:\Users\abdur\OneDrive\Desktop
Integrity mode: benchmark

## Requirements

### R1. Backend API & Modellar
Django backendda dars turlari (nazariya, test, kod yozish) uchun qabul qilingan barcha modellar kengaytirilib, `getLessonDetail` API mukammal va real ma'lumotlar bilan ishlashiga moslashishi kerak.

### R2. Flutter Frontend (Dars Oqimi)
Flutter ilovasida foydalanuvchi xaritadagi (Home) qulfi ochilgan darsni bossa, unga dars turi (nazariya, test, kod yozish) to'g'ri render qilinishi, javoblar tekshirilishi, va "Tugatish" tugmasi orqali keyingi dars qulfi ochilishi ta'minlanishi kerak.

### R3. Geymifikatsiya Sinxronizatsiyasi
Foydalanuvchi darsni tugatganida backend orqali olingan Tangalar (Coins), Tajriba (XP) va Ketma-ketlik (Streak) asosiy ekranda (TopBar) darhol o'zgarishi kerak.

## Acceptance Criteria

### Backend & API
- [ ] API orqali chaqirilgan `/api/v1/lesson/{id}` manzilida test varianti (options) va to'g'ri javoblar (correct_option) qat'iy va xatosiz JSON qaytarishi tekshiriladi.
- [ ] Dars muvaffaqiyatli yechilgach, foydalanuvchi hisobiga XP va Tangalar qo'shilganini API javobida ko'rsatish testi (script yoki manual) tasdiqlanadi.

### Flutter UI / UX
- [ ] `flutter analyze` buyrug'i barcha yangi o'zgartirilgan dars (Lesson) ekranlari uchun xato (error) qaytarmasligi shart.
- [ ] Darsni tugatish tugmasi bosilgach UI ekrani avtomatik bosh menyuga (Home) o'tishi va undagi Tangalar / XP qiymati darhol yangi qiymatga o'zgarishi kerak.
