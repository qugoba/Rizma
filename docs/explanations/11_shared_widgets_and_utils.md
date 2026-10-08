# 11 — المكوّنات المشتركة والثيم والأدوات والكتالوج

كل ما في `lib/core/` وما يشبهه مما تستعمله أكثر من شاشة. لكل عنصر: ما هو، معاملاته، لماذا كُتب هكذا، وأين يُستعمل.

## الثيم (`core/theme/`)

### `AppColors`
قيم Figma حرفيًا، مرتبة بالدور لا باللون: الأسطح (`ground`, `light`, `card`, `mute`, `line`, `disabled`, **`placeholder`** للنص الإرشادي)، النصوص (`ink`, `soft`)، عائلات اللون (`teal*`, `amber*`, `blue*`, `coral*`, `purple*`) بنمط `X / XDark / XTint`.

### `AppTextStyles`
أنماط Cairo. الاسم يحمل الحجم (`heading22`, `body15`…) لمطابقة أسماء Figma. تُبنى بدالة خاصة `_cairo(size, weight, height, color)`؛ `height` مضاعف لحجم الخط (يطابق `line-height` غير المقيّد بوحدة في Figma). لتغيير اللون فقط نستعمل `copyWith(color: …)` بدل نمط جديد.

### `AppTheme.light`
`ThemeData` بـ Material 3، لوحة ألوان من `teal` مع تثبيت `primary/surface/onSurface`، `scaffoldBackgroundColor = ground`، و`fontFamily: 'Cairo'` (خط محلي من `assets/fonts`).

### `ProfileColorPalette` (`profile_palette.dart`)
امتداد على `ProfileColor` يعطي ثلاثة ألوان: `body` (جسم الشخصية)، `fold` (الزاوية المطوية)، `avatarBackground` (خلفية الأفاتار الفاتحة). القيم من `design_spec/README.md`. يستعملها أيضًا الكتالوج لتلوين المواد.

## المكوّنات (`core/widgets/`)

| المكوّن | المعاملات | ما يفعله ولماذا |
|---|---|---|
| `PrimaryButton` | `label`, `onPressed?`, `iconAsset?`, `height=52`, `backgroundColor`, `foregroundColor` | الزر العريض. `onPressed == null` = معطّل (رمادي `disabled`) كالمعتاد في Flutter. `Material` + `InkWell` ليظهر التموّج فوق اللون. `Semantics` تعلن زرًّا بحالته. الأيقونة **أول** عنصر في الصف فتظهر يمين النص (RTL) كما في Figma. |
| `IconTile` | `asset?` أو `iconData?`, `iconColor?`, `color`, `size=48`, `iconSize=24`, `radius=14` | مربع ملوّن بأيقونة وسطه. يقبل SVG من Figma أو أيقونة Material للأيقونات التي لم تُصدَّر بعد (`assert` يتأكد من تمرير واحد فقط). |
| `ProgressBar` | `value (0..1)`, `trackColor`, `fillColor`, `height=6` | شريط تقدّم كبسولي. المحاذاة `AlignmentDirectional.centerStart` فتبدأ التعبئة من **اليمين** في RTL. `FractionallySizedBox` يحسب العرض نسبيًا بلا `LayoutBuilder`. |
| `BottomNav` + `RizmaTab` | `current`, `onSelected` | الشريط السفلي: الرئيسية · المواد · تقدّمي · حسابي (الأولى يمينًا). الأيقونات خطوط بلون واحد فتُصبغ بـ `ColorFilter.mode(srcIn)` بلون التبويب (teal للمحدَّد، `soft` لغيره) فنستعمل ملفًا واحدًا لكل أيقونة. |
| `Mascot` | `size`, `color` | شخصية رِزمة بلون الطالب. SVG واحد أخضر + `ColorMapper` يستبدل لونين فقط (الجسم `#177A63` والزاوية `#7ED3B2`). `==`/`hashCode` على المبدّل ليعمل تخزين flutter_svg المؤقت. |
| `BackTile` / `ScreenTopBar` | `onTap` / `title`, `subtitle?`, `onBack`, `end?` | زر رجوع مربّع 44 (أيقونته سهم لليمين = الرجوع في RTL) وشريط علوي: رجوع + عنوان + عنصر اختياري في الطرف الآخر. `?end` عنصر قائمة اختياري (Dart 3.8). |
| `RizmaSwitch` | `value`, `onChanged`, `semanticsLabel` | مفتاح 52×32. المقبض يبدأ من اليمين وهو مطفأ (RTL) عبر `AlignmentDirectional`. `Semantics(toggled:)`. |
| `RizmaCard` | `child`, `padding` | بطاقة بيضاء بحد `line` وزوايا 20. |
| `DashedBorderBox` | `color`, `radius`, `strokeWidth`, `dash`, `gap`, `padding` | حد منقّط للصناديق الفارغة. `CustomPainter` يمرّ على `PathMetric` لمستطيل مدوّر ويرسم مقاطع قصيرة. |
| `PinDots` / `PinPad` | انظر `08_pin_entry_and_forgot.md` | نقاط الرمز السري ولوحة الأرقام LTR. |

## الأدوات الصرفة (`core/utils/`)

| الملف | الدوال | ملاحظات |
|---|---|---|
| `student_code.dart` | `generate`, `isValid`, `normalize`, `generateUnique` | `RZ-XXXX` بأحرف بلا 0/O/1/I/L. الطول ثابت `randomLength`. التفرّد المحلي عبر استعلام القاعدة. |
| `pin_hasher.dart` | `PinHasher.hash/verify/generateSalt/isValidFormat` و`PinLockout` | SHA-256 مع salt، مقارنة بزمن ثابت، قفل 5 محاولات/30 ثانية. انظر `02_profiles_and_pin.md`. |
| `class_code.dart` | `normalize`, `isValid` | أحرف كبيرة بلا مسافات؛ حروف/أرقام/شرطة، حتى 16. |
| `streak.dart` | `currentStreak(times, now)` | أيام متتالية حتى اليوم (أو أمس). |

## النصوص (`core/strings/ar.dart`)
كل النصوص الظاهرة مجمّعة حسب الشاشة، مع دوال للنصوص المركّبة (`homeGreeting(name)`, `continueWithGrade(g)`…).
- **صيغ الجمع العربية:** `stars(n)`: 0 → «0 نجوم»، 1 → «نجمة واحدة»، 2 → «نجمتان»، 3–10 → «N نجوم»، 11+ → «N نجمة». `streakDays(n)`: «يوم واحد متتالٍ»، «يومان متتاليان»، «N أيام متتالية»، «N يومًا متتاليًا».
- `gradeName(g)` يحوّل 1–12 إلى «الصف الخامس» إلخ (قائمة صريحة لأن «الحادي عشر» و«الثاني عشر» لها قواعدها).
- `colorName(color)` أسماء الألوان لقارئ الشاشة.

## الكتالوج (`features/catalog/`)
| الملف | الدور |
|---|---|
| `assets/content/catalog_grade5.json` | مواد ← وحدات ← دروس ← مفاهيم (3 مواد، 6 وحدات، 12 درسًا). **العناوين مؤقتة وتنتظر مراجعة معلم** (حقل `_note`). |
| `catalog_models.dart` | `Catalog`, `CatalogSubject`, `CatalogUnit`, `CatalogLesson`, `CatalogConcept` مع `fromJson`. `Catalog` يبني فهارس سريعة: `lessonById`, `subjectById`, `unitOfLesson`, `nextLessonInSubject`, `conceptById`, `firstLesson`, `allLessons`. |
| `catalog_repository.dart` | يقرأ JSON من الأصول مرة واحدة ويحفظه (`loadString` قابلة للحقن للاختبار). إن كبر الملف لاحقًا يُنقل التحليل إلى `compute`. |
| `catalog_providers.dart` | `catalogRepositoryProvider` و`catalogProvider` (`FutureProvider`). |
| `subject_visuals.dart` | `subjectIconAsset(key)`: مفتاح الأيقونة ← ملف SVG. |

الواجهة **لا تكتب أسماء المواد والدروس في الكود**؛ تقرأها من الكتالوج.
