import 'package:doctory/core/common/models/shared_models.dart';

class ClinicDetailsMockData {
  static ClinicModel getClinicDetails(String id) {
    // In a real app, this would fetch from an API by ID.
    // We'll return a rich mockup.
    return ClinicModel(
      id: id,
      name: 'Al-Safa Medical Center',
      nameAr: 'مركز الصفا الطبي',
      description:
          'A comprehensive medical center offering state-of-the-art facilities and a wide range of specialties including Cardiology, Pediatrics, and Dentistry. Our expert team is dedicated to your health.',
      descriptionAr:
          'مركز طبي شامل يقدم مرافق حديثة ومجموعة واسعة من التخصصات بما في ذلك أمراض القلب وطب الأطفال وطب الأسنان. فريق الخبراء لدينا مكرس لصحتك.',
      imageUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=500&q=80',
      photos: [
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=500&q=80',
        'https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?w=500&q=80',
        'https://images.unsplash.com/photo-1516549655169-df83a0774514?w=500&q=80',
      ],
      rating: 4.8,
      address: 'Gehan St, Mansoura, Dakahlia',
      addressAr: 'شارع جيهان، المنصورة، الدقهلية',
      phone: '+20 101 234 5678',
      lat: 31.0425,
      lng: 31.3765,
      reviewsCount: 120,
      isOpen: true,
      operatingHours: {
        'Saturday': '09:00 AM - 10:00 PM',
        'Sunday': '09:00 AM - 10:00 PM',
        'Monday': '09:00 AM - 10:00 PM',
        'Tuesday': '09:00 AM - 10:00 PM',
        'Wednesday': '09:00 AM - 10:00 PM',
        'Thursday': '09:00 AM - 08:00 PM',
        'Friday': 'Closed',
      },
      specialties: ['Cardiology', 'Dental', 'Pediatrics'],
      doctors: [
        DoctorModel(
          id: 'd1',
          name: 'Dr. Ahmed Youssef',
          nameAr: 'د. أحمد يوسف',
          specialty: 'Cardiologist',
          specialtyAr: 'طبيب قلب',
          imageUrl:
              'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=250&q=80',
          rating: 4.9,
          reviewsCount: 85,
          experience: 15,
          patientsCount: 2000,
        ),
        DoctorModel(
          id: 'd2',
          name: 'Dr. Sara Ali',
          nameAr: 'د. سارة علي',
          specialty: 'Pediatrician',
          specialtyAr: 'طبيبة أطفال',
          imageUrl:
              'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=250&q=80',
          rating: 4.7,
          reviewsCount: 50,
          experience: 8,
          patientsCount: 1200,
        ),
      ],
    );
  }
}
