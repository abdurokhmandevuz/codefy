export const pythonLessons = [
  {
    id: 1,
    title: 'Salom, Dunyo!',
    theory: 'Dasturlashda eng birinchi qilinadigan ish bu ekranga matn chiqarishdir. Python tilida buning uchun print() funksiyasidan foydalanamiz.',
    exampleCode: 'print("Salom, Dunyo!")',
    task: 'Pastdagi kod maydonida ekranga "Salom" so\'zini chiqaring.',
    initialCode: '# Kodingizni shu yerga yozing\n',
    expectedOutput: 'Salom'
  },
  {
    id: 2,
    title: 'O\'zgaruvchilar',
    theory: 'O\'zgaruvchi — bu kompyuter xotirasidagi quti. Unga nom beramiz va ichiga biror narsa saqlaymiz. Pythonda shunchaki nom va = belgisi yetarli.',
    exampleCode: 'ism = "Ali"\nprint(ism)',
    task: 'O\'zingizning ismingizni "ism" nomli o\'zgaruvchiga saqlang va uni ekranga chiqaring.',
    initialCode: 'ism = ""\n',
    expectedOutput: 'ismingiz' 
  },
  {
    id: 3,
    title: 'Sonlar bilan ishlash',
    theory: 'Dasturlashda matematikalarni osongina bajarish mumkin: qo\'shish (+), ayirish (-), ko\'paytirish (*), bo\'lish (/).',
    exampleCode: 'print(5 + 3) # 8 chiqadi',
    task: '10 va 5 sonlarini ko\'paytirib, ekranga chiqaring.',
    initialCode: '',
    expectedOutput: '50'
  },
  {
    id: 4,
    title: 'Matn (string) bilan ishlash',
    theory: 'Matnlarni bir-biriga qo\'shish uchun + belgisidan foydalanamiz.',
    exampleCode: 'print("Salom, " + "Ali!") # Salom, Ali!',
    task: '"Code" va "fy" so\'zlarini qo\'shib ekranga chiqaring.',
    initialCode: '',
    expectedOutput: 'Codefy'
  },
  {
    id: 5,
    title: 'Shartlar (if/else)',
    theory: 'Ba\'zida shartga qarab har xil ishlarni qilish kerak. Agar (if) shart to\'g\'ri bo\'lsa bitta kod, yo\'qsa (else) boshqa kod ishlaydi. Pythonda bo\'sh joylar (indent) juda muhim!',
    exampleCode: 'yosh = 10\nif yosh > 7:\n    print("Katta")\nelse:\n    print("Kichik")',
    task: 'son = 10 deb berilgan. Agar u 5 dan katta bo\'lsa "Katta" deb ekranga chiqaring.',
    initialCode: 'son = 10\n',
    expectedOutput: 'Katta'
  },
  {
    id: 6,
    title: 'Ro\'yxatlar (List)',
    theory: 'Ro\'yxatlar [ ] qavslar ichida yoziladi va bir nechta qiymatni o\'zida saqlaydi.',
    exampleCode: 'mevalar = ["Olma", "Nok", "Banan"]\nprint(mevalar[0]) # Olma',
    task: 'Uchta raqamdan iborat ro\'yxat yarating va uning ikkinchi elementini (indeksi 1) ekranga chiqaring (masalan 20).',
    initialCode: 'sonlar = [10, 20, 30]\n',
    expectedOutput: '20'
  },
  {
    id: 7,
    title: 'Tsikllar (For)',
    theory: 'Biror narsani ko\'p marta takrorlash uchun For tsiklidan foydalanamiz.',
    exampleCode: 'for i in range(3):\n    print("Qadam")',
    task: '"Codefy" so\'zini 3 marta ekranga chiqaring.',
    initialCode: 'for i in range(3):\n    ',
    expectedOutput: 'Codefy\nCodefy\nCodefy'
  },
  {
    id: 8,
    title: 'Tsikllar (While)',
    theory: 'While tsikli ma\'lum bir shart rost (True) bo\'lguncha takrorlanaveradi.',
    exampleCode: 'x = 0\nwhile x < 2:\n    print(x)\n    x += 1',
    task: '0 dan 2 gacha bo\'lgan sonlarni ekranga chiqaring (0, 1, 2).',
    initialCode: 'i = 0\nwhile i < 3:\n    \n    i += 1',
    expectedOutput: '0\n1\n2'
  },
  {
    id: 9,
    title: 'Funksiyalar',
    theory: 'Funksiya bu qayta-qayta ishlatsa bo\'ladigan quti. Unga buyruqlar joylab, xohlagan payt chaqirish mumkin.',
    exampleCode: 'def salomlash():\n    print("Salom!")\n\nsalomlash()',
    task: '"qichqiriq" nomli funksiya yarating va u ekranga "URAA" deb chiqarsin. Keyin funksiyani chaqiring.',
    initialCode: 'def qichqiriq():\n    \n',
    expectedOutput: 'URAA'
  },
  {
    id: 10,
    title: 'Kichik Loyiha: Juft son',
    theory: 'Endi hamma o\'rganganlarimizni birlashtiramiz! Sonning juft yoki toqligini % (qoldiq) orqali bilish mumkin.',
    exampleCode: 'print(4 % 2) # 0 (juft)\nprint(5 % 2) # 1 (toq)',
    task: 'Agar "son" juft bo\'lsa "Juft", toq bo\'lsa "Toq" deb ekranga chiqaring.',
    initialCode: 'son = 8\n# shart tekshiring\n',
    expectedOutput: 'Juft'
  }
];
