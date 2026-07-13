from main.models import Course, Module, Lesson

course, _ = Course.objects.get_or_create(
    title="Python 3 ni o'rganish",
    defaults={'description': "Noldan Python dasturlash tilini o'rganib, haqiqiy loyihalar yarating.", 'track_type': 'python'}
)

# ==============================
# MODUL 1: ASOSLAR
# ==============================
mod1, _ = Module.objects.get_or_create(course=course, order=1,
    defaults={'title': "Python Asoslari", 'description': "print, o'zgaruvchilar va ma'lumot turlari."})

lessons_mod1 = [
    {
        'order': 1,
        'title': "Salom Dunyo!",
        'content': """<h3 class="text-lg font-bold mb-2">print() funksiyasi</h3>
<p class="mb-4">Python da ekranga matn chiqarish uchun <code class="bg-bgCard px-1 rounded">print()</code> funksiyasidan foydalanamiz. Bu har qanday dasturning birinchi qadami!</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Salom Dunyo!"</span>)
</div>
<p class="mb-4">Qo'shtirnoq ichidagi matn <strong>string</strong> deyiladi.</p>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> Ekranga <code>Salom Dunyo!</code> deb chiqaring.
</div>""",
        'initial_code': '# Bu yerga kod yozing\n',
        'expected_output': 'Salom Dunyo!'
    },
    {
        'order': 2,
        'title': "O'zgaruvchilar",
        'content': """<h3 class="text-lg font-bold mb-2">O'zgaruvchi nima?</h3>
<p class="mb-4">O'zgaruvchi — ma'lumotni saqlash uchun ishlatiluvchi "quticha". Python da <code>=</code> belgisi orqali qiymat beriladi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">ism</span> = <span class="text-accentGreen">"Ali"</span><br>
<span class="text-blue-400">yosh</span> = <span class="text-accentYellow">20</span><br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">ism</span>)
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>nom</code> degan o'zgaruvchi yarating va unga ismingizni bering. Keyin uni chiqaring. Natija: <code>Codefy</code>
</div>""",
        'initial_code': '# nom degan ozgaruvchi yarating\n',
        'expected_output': 'Codefy'
    },
    {
        'order': 3,
        'title': "Sonlar bilan ishlash",
        'content': """<h3 class="text-lg font-bold mb-2">Integer va Float</h3>
<p class="mb-4">Python da ikki xil son turi bor: <strong>int</strong> (butun son) va <strong>float</strong> (kasr son).</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">a</span> = <span class="text-accentYellow">10</span><br>
<span class="text-blue-400">b</span> = <span class="text-accentYellow">3</span><br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">a</span> + <span class="text-blue-400">b</span>)  <span class="text-gray-500"># 13</span><br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">a</span> * <span class="text-blue-400">b</span>)  <span class="text-gray-500"># 30</span>
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> 5 va 7 sonlarini qo'shib natijani chiqaring. Natija: <code>12</code>
</div>""",
        'initial_code': '# 5 va 7 ni qoshing\n',
        'expected_output': '12'
    },
]

for l in lessons_mod1:
    Lesson.objects.get_or_create(module=mod1, order=l['order'],
        defaults={'title': l['title'], 'content': l['content'], 'initial_code': l['initial_code'], 'expected_output': l['expected_output']})

# ==============================
# MODUL 2: SHARTLAR
# ==============================
mod2, _ = Module.objects.get_or_create(course=course, order=2,
    defaults={'title': "Shartlar va Qarorlar", 'description': "if, elif, else operatorlari."})

lessons_mod2 = [
    {
        'order': 1,
        'title': "if - Shart operatori",
        'content': """<h3 class="text-lg font-bold mb-2">if nima?</h3>
<p class="mb-4">Dastur ba'zan qaror qabul qilishi kerak. <code>if</code> operatori shart tekshiradi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">yosh</span> = <span class="text-accentYellow">18</span><br>
<span class="text-purple-400">if</span> <span class="text-blue-400">yosh</span> >= <span class="text-accentYellow">18</span>:<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Voyaga yetgan"</span>)<br>
<span class="text-purple-400">else</span>:<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Voyaga yetmagan"</span>)
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>ball = 85</code> bo'lsa, 70 dan katta bo'lsa <code>O'tdi</code> deb chiqaring.
</div>""",
        'initial_code': 'ball = 85\n# shart yozing\n',
        'expected_output': "O'tdi"
    },
    {
        'order': 2,
        'title': "elif - Ko'p shartlar",
        'content': """<h3 class="text-lg font-bold mb-2">elif bilan bir necha shart</h3>
<p class="mb-4">Bir nechta shart tekshirish uchun <code>elif</code> dan foydalanamiz.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">ball</span> = <span class="text-accentYellow">75</span><br>
<span class="text-purple-400">if</span> ball >= <span class="text-accentYellow">90</span>:<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"A'lo"</span>)<br>
<span class="text-purple-400">elif</span> ball >= <span class="text-accentYellow">70</span>:<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Yaxshi"</span>)<br>
<span class="text-purple-400">else</span>:<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Qoniqarli"</span>)
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> Yuqoridagi kodni yozing. ball=75 uchun natija: <code>Yaxshi</code>
</div>""",
        'initial_code': 'ball = 75\n# elif bilan tekshiring\n',
        'expected_output': 'Yaxshi'
    },
]

for l in lessons_mod2:
    Lesson.objects.get_or_create(module=mod2, order=l['order'],
        defaults={'title': l['title'], 'content': l['content'], 'initial_code': l['initial_code'], 'expected_output': l['expected_output']})

# ==============================
# MODUL 3: SIKLLAR
# ==============================
mod3, _ = Module.objects.get_or_create(course=course, order=3,
    defaults={'title': "Sikllar (Loops)", 'description': "for va while sikllari bilan takroriy amallar."})

lessons_mod3 = [
    {
        'order': 1,
        'title': "for - Sikl",
        'content': """<h3 class="text-lg font-bold mb-2">for sikli</h3>
<p class="mb-4"><code>for</code> sikli ma'lum marta yoki ro'yxat bo'yicha takrorlanadi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-purple-400">for</span> i <span class="text-purple-400">in</span> <span class="text-blue-400">range</span>(<span class="text-accentYellow">3</span>):<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Salom"</span>)
</div>
<p class="mb-4">Bu kod <code>Salom</code> ni 3 marta chiqaradi.</p>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> 1 dan 5 gacha sonlarni alohida qatorlarda chiqaring. (1, 2, 3, 4, 5)
</div>""",
        'initial_code': '# for siklidan foydalanib 1 dan 5 gacha chiqaring\n',
        'expected_output': '1\n2\n3\n4\n5'
    },
    {
        'order': 2,
        'title': "while - Sikl",
        'content': """<h3 class="text-lg font-bold mb-2">while sikli</h3>
<p class="mb-4"><code>while</code> sikli shart to'g'ri bo'lguncha ishlaydi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">n</span> = <span class="text-accentYellow">1</span><br>
<span class="text-purple-400">while</span> <span class="text-blue-400">n</span> <= <span class="text-accentYellow">3</span>:<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-blue-400">n</span>)<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-blue-400">n</span> += <span class="text-accentYellow">1</span>
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> while yordamida 10 dan 1 gacha teskari sanang. Natijaning boshi: <code>10</code>
</div>""",
        'initial_code': 'n = 10\n# while bilan teskari sanang\n',
        'expected_output': '10\n9\n8\n7\n6\n5\n4\n3\n2\n1'
    },
]

for l in lessons_mod3:
    Lesson.objects.get_or_create(module=mod3, order=l['order'],
        defaults={'title': l['title'], 'content': l['content'], 'initial_code': l['initial_code'], 'expected_output': l['expected_output']})

# ==============================
# MODUL 4: FUNKSIYALAR
# ==============================
mod4, _ = Module.objects.get_or_create(course=course, order=4,
    defaults={'title': "Funksiyalar", 'description': "Qayta foydalanish mumkin bo'lgan kod bloklari."})

lessons_mod4 = [
    {
        'order': 1,
        'title': "def - Funksiya yaratish",
        'content': """<h3 class="text-lg font-bold mb-2">Funksiya nima?</h3>
<p class="mb-4">Funksiya — bu bir necha marta chaqirib ishlatsa bo'ladigan kod bloki.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-purple-400">def</span> <span class="text-accentYellow">salom</span>():<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Assalomu alaykum!"</span>)<br><br>
<span class="text-accentYellow">salom</span>()
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>kutish</code> nomli funksiya yozing, u <code>Iltimos kuting...</code> deb chiqarsin.
</div>""",
        'initial_code': '# kutish funksiyasini yarating va chaqiring\n',
        'expected_output': 'Iltimos kuting...'
    },
    {
        'order': 2,
        'title': "Parametrli funksiyalar",
        'content': """<h3 class="text-lg font-bold mb-2">Parametrlar</h3>
<p class="mb-4">Funksiyaga ma'lumot uzatish uchun <strong>parametrlar</strong> ishlatiladi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-purple-400">def</span> <span class="text-accentYellow">salom</span>(ism):<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-accentYellow">print</span>(<span class="text-accentGreen">"Salom, "</span> + ism)<br><br>
<span class="text-accentYellow">salom</span>(<span class="text-accentGreen">"Jasur"</span>)
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>kopaytir(a, b)</code> funksiyasi yozing — u a va b ni ko'paytirib chiqarsin. <code>kopaytir(4, 5)</code> uchun natija: <code>20</code>
</div>""",
        'initial_code': '# kopaytir funksiyasini yarating\ndef kopaytir(a, b):\n    pass\n\nkopaytir(4, 5)\n',
        'expected_output': '20'
    },
    {
        'order': 3,
        'title': "return - Qiymat qaytarish",
        'content': """<h3 class="text-lg font-bold mb-2">return</h3>
<p class="mb-4"><code>return</code> funksiyadan natija qaytaradi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-purple-400">def</span> <span class="text-accentYellow">yigindi</span>(a, b):<br>
&nbsp;&nbsp;&nbsp;&nbsp;<span class="text-purple-400">return</span> a + b<br><br>
<span class="text-blue-400">natija</span> = <span class="text-accentYellow">yigindi</span>(<span class="text-accentYellow">3</span>, <span class="text-accentYellow">7</span>)<br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">natija</span>)
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>kvadrat(n)</code> funksiyasi yozing, n ning kvadratini return qilsin. <code>print(kvadrat(6))</code> natijasi: <code>36</code>
</div>""",
        'initial_code': 'def kvadrat(n):\n    pass  # bu yerni togrilan\n\nprint(kvadrat(6))\n',
        'expected_output': '36'
    },
]

for l in lessons_mod4:
    Lesson.objects.get_or_create(module=mod4, order=l['order'],
        defaults={'title': l['title'], 'content': l['content'], 'initial_code': l['initial_code'], 'expected_output': l['expected_output']})

# ==============================
# MODUL 5: RO'YXATLAR
# ==============================
mod5, _ = Module.objects.get_or_create(course=course, order=5,
    defaults={'title': "Ro'yxatlar (Lists)", 'description': "Ma'lumotlar to'plamini saqlash va boshqarish."})

lessons_mod5 = [
    {
        'order': 1,
        'title': "List yaratish",
        'content': """<h3 class="text-lg font-bold mb-2">List (ro'yxat)</h3>
<p class="mb-4">List ko'p qiymatni bitta o'zgaruvchida saqlaydi.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">mevalar</span> = [<span class="text-accentGreen">"olma"</span>, <span class="text-accentGreen">"banan"</span>, <span class="text-accentGreen">"uzum"</span>]<br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">mevalar</span>[<span class="text-accentYellow">0</span>])  <span class="text-gray-500"># olma</span><br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">len</span>(<span class="text-blue-400">mevalar</span>))  <span class="text-gray-500"># 3</span>
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>sonlar = [10, 20, 30]</code> ro'yxat yarating va birinchi elementni chiqaring. Natija: <code>10</code>
</div>""",
        'initial_code': '# sonlar listini yarating\n',
        'expected_output': '10'
    },
    {
        'order': 2,
        'title': "List ustida amallar",
        'content': """<h3 class="text-lg font-bold mb-2">append, remove, sort</h3>
<p class="mb-4">List ga element qo'shish va o'chirish.</p>
<div class="bg-bgCard rounded-lg p-4 mb-4 font-mono text-sm border border-borderSubtle">
<span class="text-blue-400">raqamlar</span> = [<span class="text-accentYellow">3</span>, <span class="text-accentYellow">1</span>, <span class="text-accentYellow">2</span>]<br>
<span class="text-blue-400">raqamlar</span>.<span class="text-accentYellow">append</span>(<span class="text-accentYellow">4</span>)<br>
<span class="text-blue-400">raqamlar</span>.<span class="text-accentYellow">sort</span>()<br>
<span class="text-accentYellow">print</span>(<span class="text-blue-400">raqamlar</span>)
</div>
<div class="bg-accentYellow/10 border border-accentYellow/30 rounded-lg p-4">
<strong class="text-accentYellow">Vazifa:</strong> <code>[3,1,4,1,5]</code> listini saralab chiqaring. Natija: <code>[1, 1, 3, 4, 5]</code>
</div>""",
        'initial_code': 'raqamlar = [3, 1, 4, 1, 5]\n# saralab chiqaring\n',
        'expected_output': '[1, 1, 3, 4, 5]'
    },
]

for l in lessons_mod5:
    Lesson.objects.get_or_create(module=mod5, order=l['order'],
        defaults={'title': l['title'], 'content': l['content'], 'initial_code': l['initial_code'], 'expected_output': l['expected_output']})

print(f"Kurs to'ldirildi! Jami modullar: 5, Darslar: {Lesson.objects.filter(module__course=course).count()} ta")
