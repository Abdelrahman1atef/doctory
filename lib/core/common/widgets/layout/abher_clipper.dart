import 'package:flutter/material.dart';

class AbherClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // 1. نبدأ من الحافة اليسرى، ولكن نترك مسافة من الأعلى (مثلاً 50)
    // هذه المسافة هي التي ستظهر فيها الخلفية الزرقاء وهي "نازلة"
    path.moveTo(0, 40);

    path.cubicTo(size.width * 0.4, 80, size.width * 0.7, 0, size.width, 50);

    // 3. النزول للركن السفلي الأيمن
    path.lineTo(size.width, size.height);

    // 4. الذهاب للركن السفلي الأيسر
    path.lineTo(0, size.height);

    // 5. إغلاق المسار
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
