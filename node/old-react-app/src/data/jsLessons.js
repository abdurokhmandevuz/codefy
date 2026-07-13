export const jsLessons = [
  {
    id: 1,
    title: 'Salom, Dunyo!',
    theory: 'Dasturlashda eng birinchi qilinadigan ish bu ekranga matn chiqarishdir. JavaScript tilida buning uchun console.log() funksiyasidan foydalanamiz.',
    exampleCode: 'console.log("Salom, Dunyo!");',
    task: 'Pastdagi kod maydonida ekranga "Salom" so\'zini chiqaring.',
    initialCode: '// Kodingizni shu yerga yozing\n',
    expectedOutput: 'Salom'
  },
  {
    id: 2,
    title: 'O\'zgaruvchilar',
    theory: 'O\'zgaruvchi — bu kompyuter xotirasidagi quti. Unga nom beramiz va ichiga biror narsa saqlaymiz. JavaScript-da let so\'zidan foydalanamiz.',
    exampleCode: 'let ism = "Ali";\nconsole.log(ism);',
    task: 'O\'zingizning ismingizni "ism" nomli o\'zgaruvchiga saqlang va uni ekranga chiqaring.',
    initialCode: 'let ism = "";\n',
    expectedOutput: 'ismingiz' // Special logic: we can just check if anything is logged that is not empty. Or we just ask for a specific string.
  },
  {
    id: 3,
    title: 'Sonlar bilan ishlash',
    theory: 'Dasturlashda matematikalarni osongina bajarish mumkin: qo\'shish (+), ayirish (-), ko\'paytirish (*), bo\'lish (/).',
    exampleCode: 'console.log(5 + 3); // 8 chiqadi',
    task: '10 va 5 sonlarini ko\'paytirib, ekranga chiqaring.',
    initialCode: '',
    expectedOutput: '50'
  },
  {
    id: 4,
    title: 'Matn (string) bilan ishlash',
    theory: 'Matnlarni bir-biriga qo\'shish uchun + belgisidan foydalanamiz.',
    exampleCode: 'console.log("Salom, " + "Ali!"); // Salom, Ali!',
    task: '"Code" va "fy" so\'zlarini qo\'shib ekranga chiqaring.',
    initialCode: '',
    expectedOutput: 'Codefy'
  },
  {
    id: 5,
    title: 'Shartlar (if/else)',
    theory: 'Ba\'zida shartga qarab har xil ishlarni qilish kerak. Agar (if) shart to\'g\'ri bo\'lsa bitta kod, yo\'qsa (else) boshqa kod ishlaydi.',
    exampleCode: 'let yosh = 10;\nif (yosh > 7) {\n  console.log("Katta");\n} else {\n  console.log("Kichik");\n}',
    task: 'Son nomli o\'zgaruvchi yarating va unga 10 qiymatini bering. Agar u 5 dan katta bo\'lsa "Katta" deb ekranga chiqaring.',
    initialCode: 'let son = 10;\n',
    expectedOutput: 'Katta'
  },
  {
    id: 6,
    title: 'Ro\'yxatlar (Array)',
    theory: 'Ro\'yxatlar [ ] qavslar ichida yoziladi va bir nechta qiymatni o\'zida saqlaydi.',
    exampleCode: 'let mevalar = ["Olma", "Nok", "Banan"];\nconsole.log(mevalar[0]); // Olma',
    task: 'Uchta raqamdan iborat ro\'yxat yarating va uning ikkinchi elementini (indeksi 1) ekranga chiqaring (masalan 20).',
    initialCode: 'let sonlar = [10, 20, 30];\n',
    expectedOutput: '20'
  },
  {
    id: 7,
    title: 'Tsikllar (For)',
    theory: 'Biror narsani ko\'p marta takrorlash uchun For tsiklidan foydalanamiz.',
    exampleCode: 'for (let i = 0; i < 3; i++) {\n  console.log("Qadam");\n}',
    task: '"Codefy" so\'zini 3 marta ekranga chiqaring.',
    initialCode: 'for (let i = 0; i < 3; i++) {\n  \n}',
    expectedOutput: 'Codefy\nCodefy\nCodefy'
  },
  {
    id: 8,
    title: 'Tsikllar (While)',
    theory: 'While tsikli ma\'lum bir shart rost (true) bo\'lguncha takrorlanaveradi.',
    exampleCode: 'let x = 0;\nwhile (x < 2) {\n  console.log(x);\n  x++;\n}',
    task: '0 dan 2 gacha bo\'lgan sonlarni ekranga chiqaring (0, 1, 2).',
    initialCode: 'let i = 0;\nwhile (i < 3) {\n  \n  i++;\n}',
    expectedOutput: '0\n1\n2'
  },
  {
    id: 9,
    title: 'Funksiyalar',
    theory: 'Funksiya bu qayta-qayta ishlatsa bo\'ladigan quti. Unga buyruqlar joylab, xohlagan payt chaqirish mumkin.',
    exampleCode: 'function salomlash() {\n  console.log("Salom!");\n}\nsalomlash();',
    task: '"qichqiriq" nomli funksiya yarating va u ekranga "URAA" deb chiqarsin. Keyin funksiyani chaqiring.',
    initialCode: 'function qichqiriq() {\n  \n}\n',
    expectedOutput: 'URAA'
  },
  {
    id: 10,
    title: 'Kichik Loyiha: Juft son',
    theory: 'Endi hamma o\'rganganlarimizni birlashtiramiz! Sonning juft yoki toqligini % (qoldiq) orqali bilish mumkin.',
    exampleCode: 'console.log(4 % 2); // 0 (juft)\nconsole.log(5 % 2); // 1 (toq)',
    task: 'Agar "son" juft bo\'lsa "Juft", toq bo\'lsa "Toq" deb ekranga chiqaring.',
    initialCode: 'let son = 8;\n// shart tekshiring\n',
    expectedOutput: 'Juft'
  }
];
