import '../../data/model/specialization_model.dart';
import '../../data/model/clinic_model.dart';
import '../../data/model/doctor_model.dart';
import '../../data/model/user_model.dart';
import '../../data/model/payment_model.dart';
import '../../data/model/subscription_model.dart';
import '../../data/model/pending_clinic_model.dart';
import '../../data/model/verification_model.dart';
import '../../data/model/support_ticket_model.dart';
import '../../data/model/ad_model.dart';
import '../../data/model/dashboard_stats_model.dart';
import '../../data/model/admin_profile_model.dart';

class AdminMockDataSource {
  List<AdminSpecializationModel> getSpecializations() => [
    const AdminSpecializationModel(id: '1', name: 'Cardiology', nameAr: 'القلب والأوعية الدموية', description: 'تشخيص وعلاج أمراض القلب والشرايين', icon: '🫀', isActive: true),
    const AdminSpecializationModel(id: '2', name: 'Neurology', nameAr: 'الأمراض العصبية', description: 'تشخيص وعلاج اضطرابات الجهاز العصبي', icon: '🧠', isActive: true),
    const AdminSpecializationModel(id: '3', name: 'Orthopedics', nameAr: 'جراحة العظام', description: 'جراحة وإصلاح كسور وإصابات العظام والمفاصل', icon: '🦵', isActive: true),
    const AdminSpecializationModel(id: '4', name: 'Pediatrics', nameAr: 'طب الأطفال', description: 'رعاية صحة الأطفال من الولادة حتى المراهقة', icon: '👶', isActive: false),
    const AdminSpecializationModel(id: '5', name: 'OB/GYN', nameAr: 'النساء والولادة', description: 'رعاية صحة المرأة ومتابعة الحمل والولادة', icon: '🫃', isActive: true),
    const AdminSpecializationModel(id: '6', name: 'Ophthalmology', nameAr: 'طب العيون', description: 'تشخيص وعلاج أمراض وجراحة العيون', icon: '👁️', isActive: true),
  ];

  List<AdminClinicModel> getClinics() => [
    const AdminClinicModel(id: '1', name: 'مركز القلب التخصصي', specialty: 'القلب والأوعية الدموية', description: 'مركز متخصص في تشخيص وعلاج أمراض القلب والشرايين', location: 'الطابق الثاني - غرفة 201', phone: '+966 11 234 5678', managerName: 'أ. محمد عبد الرحمن', isActive: true, doctorCount: 4, staffCount: 8, avgRating: 4.5, specializations: ['القلب والأوعية الدموية', 'جراحة القلب']),
    const AdminClinicModel(id: '2', name: 'مركز الأعصاب والعمود الفقري', specialty: 'الأمراض العصبية', description: 'مركز رائد في تشخيص وعلاج اضطرابات الجهاز العصبي', location: 'الطابق الثالث - غرفة 305', phone: '+966 11 345 6789', managerName: 'د. هشام فؤاد', isActive: true, doctorCount: 3, staffCount: 6, avgRating: 4.2, specializations: ['الأمراض العصبية', 'جراحة المخ والأعصاب']),
    const AdminClinicModel(id: '3', name: 'عيادة العظام والعلاج الطبيعي', specialty: 'جراحة العظام', description: 'عيادة متكاملة لجراحة العظام والمفاصل وإصابات الرياضة', location: 'الطابق الأول - غرفة 104', phone: '+966 11 456 7890', managerName: 'د. خالد الزهراني', isActive: true, doctorCount: 5, staffCount: 10, avgRating: 4.8, specializations: ['جراحة العظام', 'العلاج الطبيعي', 'طب الرياضة']),
    const AdminClinicModel(id: '4', name: 'عيادة الجلدية والتجميل', specialty: 'الأمراض الجلدية', description: 'عيادة متخصصة في الأمراض الجلدية وعلاجات التجميل بالليزر', location: 'الطابق الثاني - غرفة 210', phone: '+966 11 567 8901', managerName: 'د. عمار السيد', isActive: true, doctorCount: 2, staffCount: 5, avgRating: 4.6, specializations: ['الأمراض الجلدية', 'جراحة التجميل']),
    const AdminClinicModel(id: '5', name: 'عيادة الأطفال', specialty: 'طب الأطفال', description: 'عيادة متخصصة في رعاية الأطفال من حديثي الولادة حتى سن المراهقة', location: 'الطابق الرابع - غرفة 402', phone: '+966 11 678 9012', managerName: '—', isActive: false, doctorCount: 1, staffCount: 0, avgRating: 3.8, specializations: ['طب الأطفال', 'حديثي الولادة']),
  ];

  List<AdminDoctorModel> getDoctors() => [
    const AdminDoctorModel(id: '1', name: 'د. سارة أحمد', phone: '+966 55 123 4567', email: 'sara@clinic.com', specialty: 'القلب والأوعية الدموية', degree: 'استشاري', employmentType: DoctorEmploymentType.inCenter, clinicId: '1', clinicName: 'مركز القلب التخصصي', isActive: true),
    const AdminDoctorModel(id: '2', name: 'د. عبد الله ناصر', phone: '+966 55 234 5678', email: 'abdullah@clinic.com', specialty: 'الأمراض العصبية', degree: 'أستاذ', employmentType: DoctorEmploymentType.inCenter, clinicId: '2', clinicName: 'مركز الأعصاب والعمود الفقري', isActive: true),
    const AdminDoctorModel(id: '3', name: 'د. خالد الزهراني', phone: '+966 55 345 6789', email: 'khaled@clinic.com', specialty: 'جراحة العظام', degree: 'استشاري', employmentType: DoctorEmploymentType.ownClinic, clinicId: '3', clinicName: 'عيادة العظام والعلاج الطبيعي', isActive: true),
    const AdminDoctorModel(id: '4', name: 'د. نورة العنزي', phone: '+966 55 456 7890', email: 'noura@clinic.com', specialty: 'الأمراض الجلدية', degree: 'أخصائي', employmentType: DoctorEmploymentType.inCenter, clinicId: '4', clinicName: 'عيادة الجلدية والتجميل', isActive: true),
    const AdminDoctorModel(id: '5', name: 'د. أحمد السيد', phone: '+966 55 567 8901', email: 'ahmed@freelance.com', specialty: 'طب العيون', degree: 'أخصائي', employmentType: DoctorEmploymentType.freelance, isActive: true),
    const AdminDoctorModel(id: '6', name: 'د. منى عبد الرحمن', phone: '+966 55 678 9012', email: 'mona@clinic.com', specialty: 'طب الأطفال', degree: 'أخصائي', employmentType: DoctorEmploymentType.inCenter, clinicId: '5', clinicName: 'عيادة الأطفال', isActive: false),
  ];

  List<AdminUserModel> getUsers() => [
    const AdminUserModel(id: '1', name: 'أحمد محمد', email: 'ahmed@email.com', phone: '+966 50 111 2233', role: 'patient', registeredAt: '2024-01-15', isActive: true, totalVisits: 12, avgRating: 4.5),
    const AdminUserModel(id: '2', name: 'فاطمة علي', email: 'fatima@email.com', phone: '+966 50 222 3344', role: 'patient', registeredAt: '2024-02-20', isActive: true, totalVisits: 8, avgRating: 4.2),
    const AdminUserModel(id: '3', name: 'عمر حسن', email: 'omar@email.com', phone: '+966 50 333 4455', role: 'patient', registeredAt: '2024-03-10', isActive: true, totalVisits: 5, avgRating: 3.8),
    const AdminUserModel(id: '4', name: 'سارة خالد', email: 'sara@email.com', phone: '+966 50 444 5566', role: 'patient', registeredAt: '2024-01-05', isActive: true, totalVisits: 20, avgRating: 4.8),
    const AdminUserModel(id: '5', name: 'محمد عبد الله', email: 'mohamed@email.com', phone: '+966 50 555 6677', role: 'patient', registeredAt: '2024-04-01', isActive: false, totalVisits: 2, avgRating: 4.0),
    const AdminUserModel(id: '6', name: 'م. عبد الرحمن', email: 'abdelrahman@clinic.com', phone: '+966 50 666 7788', role: 'clinic_owner', registeredAt: '2023-11-01', isActive: true, totalVisits: 0, avgRating: 0),
    const AdminUserModel(id: '7', name: 'د. هشام فؤاد', email: 'hesham@clinic.com', phone: '+966 50 777 8899', role: 'clinic_owner', registeredAt: '2023-12-15', isActive: true, totalVisits: 0, avgRating: 0),
    const AdminUserModel(id: '8', name: 'د. خالد الزهراني', email: 'khaled2@clinic.com', phone: '+966 50 888 9900', role: 'clinic_owner', registeredAt: '2024-01-20', isActive: true, totalVisits: 0, avgRating: 0),
    const AdminUserModel(id: '9', name: 'د. عمار السيد', email: 'ammar@clinic.com', phone: '+966 50 999 0011', role: 'clinic_owner', registeredAt: '2024-02-01', isActive: true, totalVisits: 0, avgRating: 0),
    const AdminUserModel(id: '10', name: 'عبد العزيز عمر', email: 'aziz@clinic.com', phone: '+966 50 111 0022', role: 'clinic_owner', registeredAt: '2024-02-15', isActive: true, totalVisits: 0, avgRating: 0),
  ];

  List<AdminPaymentModel> getPayments() => [
    const AdminPaymentModel(id: '1', code: 'PAY-001', payerName: 'مركز القلب التخصصي', type: 'اشتراك سنوي', amount: 12000, method: 'تحويل بنكي', status: 'مكتملة', date: '2024-12-01'),
    const AdminPaymentModel(id: '2', code: 'PAY-002', payerName: 'مركز الأعصاب والعمود الفقري', type: 'اشتراك شهري', amount: 1500, method: 'بطاقة ائتمان', status: 'مكتملة', date: '2024-12-05'),
    const AdminPaymentModel(id: '3', code: 'PAY-003', payerName: 'عيادة العظام', type: 'عمولة', amount: 3200, method: 'محفظة إلكترونية', status: 'معلقة', date: '2024-12-10'),
    const AdminPaymentModel(id: '4', code: 'PAY-004', payerName: 'د. أحمد السيد', type: 'اشتراك طبيب', amount: 800, method: 'تحويل بنكي', status: 'مكتملة', date: '2024-12-12'),
    const AdminPaymentModel(id: '5', code: 'PAY-005', payerName: 'عيادة الجلدية والتجميل', type: 'إعلان مميز', amount: 2500, method: 'بطاقة ائتمان', status: 'ملغية', date: '2024-12-15'),
  ];

  List<AdminSubscriptionModel> getPlans() => [
    const AdminSubscriptionModel(id: '1', name: 'الباقة الأساسية', duration: 'شهري', price: 500, badge: 'أساسي', cssClass: 'plan-free', features: ['دكتور واحد', 'مواعيد غير محدودة', 'دعم فني عبر البريد'], isActive: true),
    const AdminSubscriptionModel(id: '2', name: 'الباقة المتقدمة', duration: 'شهري', price: 1200, badge: 'متقدم', cssClass: 'plan-standard', features: ['3 أطباء', 'مواعيد غير محدودة', 'دعم فني عبر الهاتف', 'إحصائيات متقدمة', 'تقارير دورية'], isActive: true),
    const AdminSubscriptionModel(id: '3', name: 'الباقة الاحترافية', duration: 'سنوي', price: 12000, badge: 'احترافية', cssClass: 'plan-premium', features: ['أطباء غير محدودين', 'مواعيد غير محدودة', 'دعم فني على مدار الساعة', 'إحصائيات متقدمة', 'تقارير دورية', 'إعلانات مجانية', 'مدير حساب مخصص'], isActive: true),
    const AdminSubscriptionModel(id: '4', name: 'باقة التجربة', duration: '14 يوم', price: 0, badge: 'تجربة', cssClass: 'plan-free', features: ['دكتور واحد', '10 مواعيد', 'دعم فني'], isActive: true),
    const AdminSubscriptionModel(id: '5', name: 'باقة قديمة', duration: 'شهري', price: 800, badge: 'قديمة', cssClass: 'plan-standard', features: ['دكتور واحد', 'مواعيد غير محدودة', 'دعم فني'], isActive: false),
  ];

  List<AdminPendingClinicModel> getPendingClinics() => [
    const AdminPendingClinicModel(id: '1', clinicName: 'مركز العيون التخصصي', doctorName: 'د. أحمد السيد', email: 'ahmed@eyeclinic.com', package: 'الباقة المتقدمة', submittedAt: '2024-12-20', documentsCount: 3, status: PendingClinicStatus.pending),
    const AdminPendingClinicModel(id: '2', clinicName: 'عيادة الأسنان الحديثة', doctorName: 'د. محمد عبد الله', email: 'mohamed@dental.com', package: 'الباقة الاحترافية', submittedAt: '2024-12-18', documentsCount: 2, status: PendingClinicStatus.pending),
    const AdminPendingClinicModel(id: '3', clinicName: 'مركز العلاج الطبيعي', doctorName: 'د. فهد العنزي', email: 'fahad@pt.com', package: 'الباقة الأساسية', submittedAt: '2024-12-15', documentsCount: 4, status: PendingClinicStatus.approved),
    const AdminPendingClinicModel(id: '4', clinicName: 'عيادة نفسية', doctorName: 'د. منى شوقي', email: 'mona@psych.com', package: 'الباقة المتقدمة', submittedAt: '2024-12-10', documentsCount: 1, status: PendingClinicStatus.rejected, notes: 'مستندات غير مكتملة'),
    const AdminPendingClinicModel(id: '5', clinicName: 'مركز الأشعة التشخيصية', doctorName: 'د. ناصر القحطاني', email: 'naser@rad.com', package: 'الباقة الاحترافية', submittedAt: '2024-11-01', documentsCount: 5, status: PendingClinicStatus.paid),
  ];

  List<AdminVerificationModel> getVerifications() => [
    const AdminVerificationModel(id: '1', doctorName: 'د. محمد العمري', specialty: 'القلب والأوعية الدموية', degree: 'استشاري', syndicateId: 'SYN-12345', taxRegistry: 'TX-987654', phone: '+966 55 111 2233', email: 'mohamed.omari@clinic.com', requestDate: '2024-12-22', status: 'pending', documents: ['بطاقة النقابة', 'شهادة التخرج', 'شهادة البورد', 'الترخيص الطبي']),
    const AdminVerificationModel(id: '2', doctorName: 'د. سعاد الحربي', specialty: 'الأمراض الجلدية', degree: 'أخصائي', syndicateId: 'SYN-67890', taxRegistry: 'TX-543210', phone: '+966 55 222 3344', email: 'suaad.harbi@clinic.com', requestDate: '2024-12-20', status: 'pending', documents: ['بطاقة النقابة', 'شهادة التخرج', 'شهادة البورد']),
  ];

  List<AdminSupportTicketModel> getTickets() => [
    const AdminSupportTicketModel(id: '1', code: 'TCK-001', subject: 'مشكلة في تسجيل الدخول', reporter: 'د. سارة أحمد', priority: 'عالية', status: 'مفتوح', date: '2024-12-23'),
    const AdminSupportTicketModel(id: '2', code: 'TCK-002', subject: 'استفسار عن الفواتير', reporter: 'مركز القلب التخصصي', priority: 'متوسطة', status: 'قيد المعالجة', date: '2024-12-22'),
    const AdminSupportTicketModel(id: '3', code: 'TCK-003', subject: 'طلب إضافة تخصص جديد', reporter: 'د. خالد الزهراني', priority: 'منخفضة', status: 'تم الحل', date: '2024-12-20'),
    const AdminSupportTicketModel(id: '4', code: 'TCK-004', subject: 'خطأ في عرض المواعيد', reporter: 'عيادة الجلدية', priority: 'عالية', status: 'مفتوح', date: '2024-12-24'),
    const AdminSupportTicketModel(id: '5', code: 'TCK-005', subject: 'طلب ترقية الباقة', reporter: 'د. عبد الله ناصر', priority: 'متوسطة', status: 'قيد المعالجة', date: '2024-12-21'),
  ];

  List<AdminAdModel> getAds() => [
    const AdminAdModel(id: '1', title: 'خصم 20% على الكشف', type: AdType.banner, startDate: '2024-12-01', endDate: '2024-12-31', sortOrder: 1, clicks: 450, impressions: 15000, status: 'active', dailyCost: 100, totalBudget: 3000),
    const AdminAdModel(id: '2', title: 'د. سارة أحمد - استشارات قلب', type: AdType.featuredDoctor, startDate: '2024-12-15', endDate: '2025-01-15', sortOrder: 2, clicks: 230, impressions: 8000, status: 'active', dailyCost: 80, totalBudget: 2400, linkedEntityId: '1', linkedEntityName: 'د. سارة أحمد'),
    const AdminAdModel(id: '3', title: 'مركز القلب التخصصي', type: AdType.featuredClinic, startDate: '2024-11-01', endDate: '2024-11-30', sortOrder: 3, clicks: 180, impressions: 6000, status: 'inactive', dailyCost: 60, totalBudget: 1800, linkedEntityId: '1', linkedEntityName: 'مركز القلب التخصصي'),
    const AdminAdModel(id: '4', title: 'إعلان العودة للمدارس', type: AdType.banner, startDate: '2025-01-01', endDate: '2025-01-15', sortOrder: 4, clicks: 0, impressions: 0, status: 'scheduled', dailyCost: 120, totalBudget: 1800),
    const AdminAdModel(id: '5', title: 'عرض الاشتراك السنوي', type: AdType.banner, startDate: '2024-10-01', endDate: '2024-10-31', sortOrder: 5, clicks: 780, impressions: 20000, status: 'expired', dailyCost: 90, totalBudget: 2700),
    const AdminAdModel(id: '6', title: 'عيادة العظام والعلاج الطبيعي', type: AdType.featuredClinic, startDate: '2025-01-01', endDate: '2025-02-01', sortOrder: 6, clicks: 55, impressions: 3500, status: 'active', dailyCost: 70, totalBudget: 2100, linkedEntityId: '3', linkedEntityName: 'عيادة العظام والعلاج الطبيعي'),
  ];

  AdminDashboardStats getDashboardStats() => const AdminDashboardStats(
    totalVerifications: 128,
    activeClinics: 45,
    specializationsCount: 12,
    totalUsers: 2840,
    openTickets: 8,
    scheduledAds: 3,
    expiredSubscriptions: 5,
  );

  List<AdminTicketModel> getUrgentTickets() => [
    const AdminTicketModel(code: 'TCK-004', subject: 'خطأ في عرض المواعيد', reporter: 'عيادة الجلدية', priority: 'عالية', date: '2024-12-24'),
    const AdminTicketModel(code: 'TCK-001', subject: 'مشكلة في تسجيل الدخول', reporter: 'د. سارة أحمد', priority: 'عالية', date: '2024-12-23'),
    const AdminTicketModel(code: 'TCK-005', subject: 'طلب ترقية الباقة', reporter: 'د. عبد الله ناصر', priority: 'متوسطة', date: '2024-12-21'),
  ];

  List<AdminSubscriberModel> getSubscribers() => [
    const AdminSubscriberModel(clinicName: 'مركز القلب التخصصي', startDate: '2024-01-01', endDate: '2024-12-31', package: 'الباقة الاحترافية', doctorCount: 4, status: 'نشط'),
    const AdminSubscriberModel(clinicName: 'مركز الأعصاب', startDate: '2024-03-01', endDate: '2025-02-28', package: 'الباقة المتقدمة', doctorCount: 3, status: 'نشط'),
    const AdminSubscriberModel(clinicName: 'عيادة الأطفال', startDate: '2024-06-01', endDate: '2024-11-30', package: 'الباقة الأساسية', doctorCount: 1, status: 'منتهي'),
    const AdminSubscriberModel(clinicName: 'عيادة العظام', startDate: '2024-09-01', endDate: '2025-08-31', package: 'الباقة الاحترافية', doctorCount: 5, status: 'نشط'),
  ];

  List<AdminActivityModel> getActivityLog() => [
    const AdminActivityModel(date: '2024-12-24 10:30', action: 'إضافة دكتور جديد', user: 'أحمد (مدير النظام)', detail: 'تم إضافة د. محمد العمري'),
    const AdminActivityModel(date: '2024-12-24 09:15', action: 'تفعيل عيادة', user: 'أحمد (مدير النظام)', detail: 'تم تفعيل عيادة مركز العيون'),
    const AdminActivityModel(date: '2024-12-23 14:20', action: 'التحقق من طبيب', user: 'أحمد (مدير النظام)', detail: 'تم التحقق من د. سعاد الحربي'),
    const AdminActivityModel(date: '2024-12-23 11:00', action: 'تعديل خطة اشتراك', user: 'أحمد (مدير النظام)', detail: 'تم تعديل الباقة الاحترافية'),
  ];

  AdminProfileModel getProfile() => const AdminProfileModel(
    name: 'أحمد',
    role: 'المشرف العام',
    email: 'ahmed@doctory.com',
    phone: '+966 55 000 0000',
    permissionLevel: 'صلاحية كاملة',
    registeredAt: '2023-01-01',
    lastLogin: '2024-12-24 10:00',
    initials: 'أ',
  );
}
