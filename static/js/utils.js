// Sayt bo'ylab ishlatiladigan yordamchi funksiyalar (Animatsiyalar, Toast xabarlar)

document.addEventListener('DOMContentLoaded', () => {
    // 1. Sahifalarda silliq paydo bo'lish (Fade-in transition)
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.4s ease-out';
    setTimeout(() => {
        document.body.style.opacity = '1';
    }, 50);

    // 2. Havolalarni bosganda silliq yo'qolish (Fade-out transition)
    document.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', (e) => {
            // Agar boshqa sahifaga o'tayotgan bo'lsa va hash anchor bo'lmasa
            if (link.hostname === window.location.hostname && !link.hash && link.target !== '_blank' && link.href && !link.href.includes('javascript:void')) {
                e.preventDefault();
                document.body.style.opacity = '0';
                setTimeout(() => {
                    window.location.href = link.href;
                }, 300);
            }
        });
    });
});

// 3. Professional Toast (xabarnoma) tizimi
window.showToast = function(message, type = 'success') {
    const toast = document.createElement('div');
    const colors = {
        success: 'bg-accentGreen text-bgPrimary',
        error: 'bg-red-500 text-white',
        info: 'bg-accentYellow text-black'
    };
    
    toast.className = `fixed bottom-4 right-4 ${colors[type] || colors.info} px-6 py-3 rounded-lg shadow-2xl font-bold transform translate-y-full opacity-0 transition-all duration-300 z-50 flex items-center gap-2`;
    
    let icon = '';
    if (type === 'success') icon = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>';
    if (type === 'error') icon = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>';
    if (type === 'info') icon = '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>';

    toast.innerHTML = `${icon} ${message}`;
    document.body.appendChild(toast);
    
    // Animate in
    setTimeout(() => {
        toast.classList.remove('translate-y-full', 'opacity-0');
    }, 10);
    
    // Remove after 3s
    setTimeout(() => {
        toast.classList.add('translate-y-full', 'opacity-0');
        setTimeout(() => toast.remove(), 300);
    }, 3000);
};
