import 'package:doctory/core/common/models/shared_models.dart';

class DoctorDetailsMockData {
  static DoctorModel getDoctorDetails(String id) {
    // Return rich mock data based on id
    return DoctorModel(
      id: id,
      name: 'Dr. Ahmed Youssef',
      nameAr: 'د. أحمد يوسف',
      specialty: 'Cardiologist',
      specialtyAr: 'استشاري أمراض القلب',
      imageUrl:
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&q=80',
      rating: 4.9,
      reviewsCount: 128,
      experience: 15,
      patientsCount: 2500,
      bio:
          'Dr. Ahmed Youssef is a highly experienced Cardiologist with over 15 years of clinical practice. He specializes in advanced cardiovascular diseases, heart failure management, and preventive cardiology. He is dedicated to providing compassionate and comprehensive care to his patients.',
      bioAr:
          'د. أحمد يوسف هو طبيب قلب ذو خبرة عالية تزيد عن 15 عاماً في الممارسة السريرية. يتخصص في أمراض القلب والأوعية الدموية المتقدمة، وإدارة قصور القلب، وطب القلب الوقائي. يكرس جهده لتقديم رعاية شاملة ورحيمة لمرضاه.',
      qualifications: [
        'MD in Cardiology, Cairo University',
        'Fellow of the American College of Cardiology',
        'Board Certified in Cardiovascular Disease',
      ],
      availableSlots: {
        DateTime.now().toIso8601String().split('T')[0]: [
          TimeSlotModel(
            id: 's1',
            startTime: DateTime.now().copyWith(hour: 9, minute: 0),
            endTime: DateTime.now().copyWith(hour: 9, minute: 30),
          ),
          TimeSlotModel(
            id: 's2',
            startTime: DateTime.now().copyWith(hour: 10, minute: 0),
            endTime: DateTime.now().copyWith(hour: 10, minute: 30),
            isAvailable: false,
          ),
          TimeSlotModel(
            id: 's3',
            startTime: DateTime.now().copyWith(hour: 11, minute: 0),
            endTime: DateTime.now().copyWith(hour: 11, minute: 30),
          ),
        ],
      },
    );
  }
}
