# 07 — شاشة 25: من يتعلّم الآن؟ (اختيار الملف)

**الملف:** `lib/features/profiles/profile_picker_screen.dart` · **Figma:** `25 من يتعلّم الآن؟` (21:445) والمرجع `design_spec/screens_25-29_and_19.js`

## الغرض
تظهر عند فتح التطبيق إذا وُجد **أكثر من ملف** أو ملف **عليه رمز سري**. الطالب يضغط على بطاقة اسمه ليكمل من حيث توقف، أو يضيف طالبًا جديدًا. الهاتف غالبًا مشترك بين الإخوة، وهذه الشاشة هي «الباب».

## من أين تأتي البيانات
| ما يظهر | المصدر |
|---|---|
| بطاقات الطلاب (الاسم، الصف، اللون) | `profilesProvider` (`StreamProvider` من `ProfileRepository.watchAll`) مرتبة بالأحدث نشاطًا |
| النجوم لكل طالب | `starsByProfileProvider` ← `ActivityDao.watchStarsByProfile` (مجموع `starsEarned` لكل ملف بـ `GROUP BY`) |
| أيقونة القفل | `profile.pinHash != null` |

لا أسماء ولا أرقام ثابتة: «أنس» و«24 نجمة» في Figma أمثلة. ملف جديد يظهر «0 نجوم».

## الهيكل
`Scaffold ← SafeArea ← CustomScrollView ← SliverFillRemaining(hasScrollBody: false)` ثم عمود بمسافة 16:
1. `_Brand`: شعار 34 + «رِزمة».
2. `_Heading`: «من يتعلّم الآن؟» (`title26`) و«اختر ملفك لتكمل من حيث توقفت.».
3. `_ProfilesGrid`: شبكة من عمودين.
4. `Spacer`: يدفع الباقي لأسفل الشاشة.
5. `_RestoreLink`: «لديك رمز طالب؟».
6. `_PrivacyNote`: «الملفات محفوظة على هذا الجهاز · لا نطلب بريدًا ولا رقم هاتف».

## `_ProfilesGrid` — لماذا صفوف مزدوجة وليس `Wrap`؟
نبني قائمة البطاقات (الطلاب ثم «طالب جديد») ونقسمها إلى **صفوف من بطاقتين**: `IntrinsicHeight ← Row(crossAxisAlignment: stretch, [Expanded, Expanded])`. السبب:
- `SliverFillRemaining(hasScrollBody: false)` يقيس الارتفاع الداخلي لأبنائه (intrinsic). نسخة أولى كانت `LayoutBuilder` + `Wrap` فانهار التخطيط لأن `LayoutBuilder` لا يدعم القياس الداخلي. وجدنا الخطأ باختبار الشاشة.
- `IntrinsicHeight` + `stretch` يجعل بطاقتي الصف بنفس الارتفاع.
- في RTL أول بطاقة على اليمين، فيظهر أول طالب يمينًا كما في التصميم.

## `_ProfileCard`
- `Material` أبيض بحد `line` وزوايا 22 و`InkWell` للضغط.
- حد أدنى للارتفاع 206 (من التصميم).
- أفاتار 80 دائري بخلفية لون الطالب الفاتحة وفيه `Mascot(size: 60, color: ...)`.
- الاسم (`section18`، سطر واحد مع `ellipsis`) والصف (`caption13`).
- صف السفلي: `_StarsChip` (نجمة + `ArStrings.stars(n)`) ومربع القفل 28 إن كان الملف محميًا.
- `Semantics(button: true, label: "الاسم، الصف، محمي برمز سري")` لقارئ الشاشة.

## `_NewProfileCard`
بطاقة بحد **منقّط** (`DashedBorderBox`، لون `disabled`، زوايا 22): دائرة بعلامة + «طالب جديد» (teal) + «أضف ملفًا لأخ أو أخت». تفتح `AppRoutes.createStep1` بـ `push` فيعود الطالب لهذه الشاشة بزر الرجوع.

## ماذا يحدث عند الضغط على بطاقة (`_open`)
```dart
if (p.pinHash != null) { context.push(AppRoutes.pin(p.id)); return; }
await activeProfileIdProvider.notifier.select(p.id);
if (context.mounted) context.go(AppRoutes.home);
```
- ملف محمي ← شاشة 27 (لا يُجعل نشطًا قبل إدخال الرمز الصحيح).
- ملف غير محمي ← يصير نشطًا ثم الرئيسية.

## `_RestoreLink`
بطاقة «لديك رمز طالب؟ استعد تقدّمك على هذا الجهاز». الاستعادة تحتاج خادمًا غير موجود بعد، فنعرض `SnackBar` صادقًا: «الاستعادة تحتاج اتصالًا بالإنترنت وستتوفّر قريبًا.» ولا نزيّف نجاحًا.

## الاختبارات
`test/flows_test.dart` (مجموعة «الإقلاع»): تظهر الأسماء وبطاقة «طالب جديد» و«0 نجوم»؛ اختيار ملف غير محمي يفتح رئيسيته؛ «طالب جديد» يفتح الخطوة 1؛ رسالة الاستعادة؛ ونجوم كل ملف منفصلة.
