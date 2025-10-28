class PromptEngineer {
  // إنشاء برومبت مخصص للصحة بناءً على بيانات المستخدم
  static String createHealthPrompt({
    required String userMessage,
    required Map<String, dynamic>? userData,
  }) {
    String baseContext = """
أنت مساعد صحي خبير في تطبيق HealthAI. 
أنت متخصص في التغذية، اللياقة البدنية، والصحة العامة.
قدم إجابات دقيقة، مفيدة، ومدعومة علمياً.
كن مشجعاً وداعماً للمستخدم.

""";

    // إضافة معلومات المستخدم إذا موجودة
    if (userData != null) {
      baseContext +=
          """
معلومات المستخدم الشخصية:
- الاسم: ${userData['name'] ?? 'غير معروف'}
- العمر: ${userData['age'] ?? 'غير معروف'} سنة
- الوزن: ${userData['weight'] ?? 'غير معروف'} كجم
- الطول: ${userData['height'] ?? 'غير معروف'} سم
- الهدف الصحي: ${userData['goal'] ?? 'غير محدد'}
- مستوى النشاط: ${userData['activityLevel'] ?? 'غير محدد'}

""";
    }

    baseContext +=
        """
تعليمات الرد:
1. قدم معلومات دقيقة ومدعومة علمياً
2. كن واضحاً وسهل الفهم
3. راعي المعلومات الشخصية للمستخدم
4. قدم نصائح عملية وقابلة للتطبيق
5. كن مشجعاً وإيجابياً
6. إذا كان السؤال غير واضح، اطلب توضيحاً

سؤال المستخدم: $userMessage

الرد المناسب:
""";

    return baseContext;
  }
}
