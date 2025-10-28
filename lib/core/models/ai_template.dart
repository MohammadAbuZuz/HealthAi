class AITemplate {
  final String id;
  final String title;
  final List<String> inputFields;
  final String reasoningSteps;
  final String outputFormat;

  AITemplate({
    required this.id,
    required this.title,
    required this.inputFields,
    required this.reasoningSteps,
    required this.outputFormat,
  });
}

// 🥗 1. تغذية للجيم
final gymNutritionTemplate = AITemplate(
  id: 'gym_nutrition',
  title: 'تغذية للجيم',
  inputFields: [
    'العمر',
    'الوزن (كغم)',
    'الطول (سم)',
    'الجنس',
    'مستوى النشاط',
    'الهدف (زيادة عضل / خسارة دهون / ثبات)',
  ],
  reasoningSteps: '''
1. احسب معدل الأيض الأساسي.
2. احسب السعرات المطلوبة حسب النشاط.
3. وزع المغذيات حسب الهدف.
4. قدم خطة تغذية مفصلة.
''',
  outputFormat: '''
خطة تغذية للجيم:
- السعرات اليومية: ...
- البروتين: ...
- الكربوهيدرات: ...
- الدهون: ...
نصائح إضافية: ...
''',
);

// 💇‍♂️ 2. تشخيص مشاكل تساقط الشعر
final hairLossTemplate = AITemplate(
  id: 'hair_loss',
  title: 'تشخيص مشاكل تساقط الشعر',
  inputFields: [
    'العمر',
    'الجنس',
    'مدة تساقط الشعر',
    'أماكن التساقط',
    'نوع الشعر',
    'الأدوية أو المكملات المستخدمة',
  ],
  reasoningSteps: '''
1. حدد نوع التساقط (وراثي، هرموني، نقص غذاء، توتر).
2. اربط الأعراض بعوامل الخطر.
3. اقترح فحوصات أو علاجات أولية.
''',
  outputFormat: '''
تشخيص مبدئي:
- نوع التساقط المحتمل: ...
- الأسباب المحتملة: ...
- نصائح العناية: ...
- استشارة مختص في الحالات التالية: ...
''',
);

// ⚖️ 3. تشخيص سبب السمنة
final obesityTemplate = AITemplate(
  id: 'obesity',
  title: 'تشخيص سبب السمنة',
  inputFields: [
    'العمر',
    'الوزن',
    'الطول',
    'النشاط اليومي',
    'النظام الغذائي الحالي',
    'وجود أمراض (مثل الغدة أو السكري)',
  ],
  reasoningSteps: '''
1. احسب مؤشر كتلة الجسم (BMI).
2. حدد ما إذا كانت السمنة غذائية أو مرضية.
3. اربط البيانات بالعادات الغذائية والنوم والنشاط.
''',
  outputFormat: '''
تحليل الحالة:
- مؤشر كتلة الجسم: ...
- نوع السمنة: ...
- الأسباب المحتملة: ...
- خطة مبدئية للتحكم في الوزن: ...
''',
);

// 🧪 4. توصية بالتحاليل اللازمة
final testsRecommendationTemplate = AITemplate(
  id: 'tests_recommendation',
  title: 'توصية بالتحاليل اللازمة',
  inputFields: [
    'الأعراض الرئيسية',
    'المدة الزمنية للأعراض',
    'الأدوية الحالية إن وجدت',
    'التاريخ المرضي للعائلة',
  ],
  reasoningSteps: '''
1. حدد الجهاز المتأثر (هضمي، دموي، هرموني...).
2. استنتج التحاليل المناسبة بناءً على الأعراض.
''',
  outputFormat: '''
التحاليل المقترحة:
- ...
- ...
💡 ملاحظة: في حال استمرار الأعراض يجب مراجعة الطبيب المختص.
''',
);

// 🧴 5. تشخيص مشاكل الجلد
final skinTemplate = AITemplate(
  id: 'skin_issues',
  title: 'تشخيص مشاكل الجلد',
  inputFields: [
    'العمر',
    'نوع البشرة',
    'مكان المشكلة الجلدية',
    'مدة ظهور الأعراض',
    'الأدوية أو الكريمات المستخدمة',
  ],
  reasoningSteps: '''
1. صنف نوع المشكلة (حب شباب، حساسية، جفاف، فطريات...).
2. اربطها بعوامل محتملة (تغذية، أدوية، مناخ...).
3. قدم تشخيصًا أوليًا وتوصيات عناية.
''',
  outputFormat: '''
تحليل الحالة الجلدية:
- نوع المشكلة المحتملة: ...
- الأسباب المحتملة: ...
- العناية الموصى بها: ...
- حالات تتطلب مراجعة طبيب الجلدية: ...
''',
);

// القائمة العامة
final List<AITemplate> allTemplates = [
  gymNutritionTemplate,
  hairLossTemplate,
  obesityTemplate,
  testsRecommendationTemplate,
  skinTemplate,
];
