---
description: Copy feature from User project to Provider
---

# Workflow: Copy Feature from Rider to Driver

هذا الـ workflow مخصص لنسخ ميزة (Feature) تم تنفيذها مسبقاً في تطبيق الراكب (Rider) ونقلها لتطبيق السائق (Driver/Provider)، مع تعديل الـ APIs والمنطق البرمجي بما يتناسب مع السائق بناءً على الـ Postman Collection.

## Steps

### 1. Identify & Analyze (تحديد وتحليل الميزة)
- حدد الـ Feature المطلوب نقلها من مشروع الراكب.
- راجع الـ Folder Structure الخاص بالميزة في مشروع الراكب للتأكد من اتباعها نمط (View-Section-Widget).
- افتح ملف `Two Driver.postman_collection.json` وابحث عن الـ endpoints المقابلة للميزة في تطبيق السائق (عادةً ما تبدأ بـ `/api/driver/`).

### 2. Copy Files (نسخ الملفات)
قم بنسخ مجلد الميزة بالكامل إلى `lib/features/` في مشروع السائق مع الحفاظ على الهيكل:
- `cubit/`
- `data/` (repo, model, data_source)
- `presentation/` (views, sections, widgets)
- `di/`
- `router/`

### 3. Refactor Naming (تغيير المسميات)
استخدم الـ Search & Replace لتغيير المسميات داخل الملفات المنسوخة:
- تغيير `Rider` أو `User` إلى `Driver`.
- تغيير `RiderRequest` مثلاً إلى `DriverRequest`.
- تأكد من تحديث الـ imports لتشير إلى المسارات الصحيحة في المشروع الجديد.

### 4. UI Audit & Branding (مراجعة الواجهة والهوية)
بما أن دور السائق يختلف عن الراكب، يجب مراجعة الـ UI:
- **الألوان والسمات:** تأكد من استخدام `AppColors` الخاصة بتطبيق السائق (قد تختلف الهوية البصرية).
- **العناصر البصرية:** تأكد من أن الأيقونات والرسومات (Assets) مناسبة للسائق (مثلاً أيقونة سيارة أجرة بدلاً من أيقونة شخص يطلب).
- **النصوص (Localization):** راجع ملفات الـ ARB للتأكد من أن المصطلحات موجهة للسائق (مثلاً "رحلاتك القادمة" بدلاً من "طلباتك").
- **تجربة المستخدم:** هل يحتاج السائق لمعلومات إضافية في الواجهة؟ (مثل: تفاصيل السيارة، الربح المتوقع، مسافة الوصول).

### 5. API & Data Mapping (ربط البيانات والـ API)
هذه الخطوة تضمن توافق التطبيق مع الـ Backend الخاص بالسائق:

#### Postman Verification:
- افتح الـ Postman وراجع الـ Request Body والـ Response لـ كل endpoint.
- تأكد من الـ Query Parameters والـ Headers المطلوبة (مثل `Authorization: Bearer {{driver_token}}`).

#### Data Source & Models:
- قم بتحديث الـ endpoints في الـ `DataSource`.
- قارن الـ JSON Fields بدقة. **تحذير:** أحياناً نفس الحقل يكون له اسم مختلف (مثلاً `rider_id` في الراكب يقابله `driver_id` في السائق).
- حدث الـ Model والـ `fromJson`/`toJson` لتعكس البيانات الحقيقية من الـ Postman.

### 6. Dependency Injection & Router (التسجيل في النظام)
- قم بتسجيل الـ Cubit والـ Repository والـ DataSource في ملف الـ DI الخاص بالميزة (`di/`).
- أضف الـ Routes الجديدة في `router/` وحدث الـ `AppRouter` الرئيسي.

### 7. Adjust Logic (تعديل المنطق البرمجي)
- في الـ Cubit، عدل المنطق ليتناسب مع حالة السائق (مثل: قبول الرحلة، بدء الرحلة، إنهاء الرحلة).
- تأكد من معالجة الأخطاء (Error Handling) بشكل صحيح بناءً على ردود فعل الـ API الخاص بالسائق.

### 8. Verification (التحقق)
- اختبر الميزة باستخدام بيانات سائق حقيقية.
- تأكد من أن الـ UI يعرض البيانات الجديدة بشكل صحيح وبدون مشاكل في التصميم.

## IMPORTANT NOTES
> [!IMPORTANT]
> دائماً تأكد من الـ Postman Collection لأن الـ API Parameters قد تختلف بين الراكب والسائق حتى لو كانت نفس الميزة.

> [!TIP]
> عند مراجعة الـ UI، ركز على الـ User Context؛ السائق يحتاج لمعلومات سريعة وواضحة أثناء القيادة.

> [!WARNING]
> لا تنسَ تحديث الـ `ApiResult` handling واستخدام الـ `.fold()` pattern كما هو محدد في قواعد المشروع.
