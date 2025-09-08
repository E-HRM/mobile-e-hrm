// ignore_for_file: deprecated_member_use

import 'package:e_hrm/contraints/colors.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30.0, //horizontal
      runSpacing: 25.0, //vertikal
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // warna shadow
                    blurRadius: 8, // seberapa blur
                    offset: Offset(0, 4), // posisi shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Image.asset(
                'lib/assets/image/menu_home/kunjungan_icon.png',
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "Kunjungan",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Card(
              shape: CircleBorder(),
              color: AppColors.secondaryColor.withOpacity(0.2),
              elevation: 4, // tinggi shadow
              shadowColor: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'lib/assets/image/menu_home/agenda_kerja.png',
                  width: 38,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Agenda Kerja",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Card(
              shape: CircleBorder(),
              color: AppColors.secondaryColor.withOpacity(0.2),
              elevation: 4, // tinggi shadow
              shadowColor: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'lib/assets/image/menu_home/cuti_izin.png',
                  width: 39,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Cuti/izin",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Card(
              shape: CircleBorder(),
              color: AppColors.secondaryColor.withOpacity(0.2),
              elevation: 4, // tinggi shadow
              shadowColor: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'lib/assets/image/menu_home/jam_istirahat.png',
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Jam Istirahat",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Card(
              shape: CircleBorder(),
              color: AppColors.secondaryColor.withOpacity(0.2),
              elevation: 4, // tinggi shadow
              shadowColor: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'lib/assets/image/menu_home/lembur_icon.png',
                  width: 39,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Lembur",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Card(
              shape: CircleBorder(),
              color: AppColors.menuColor,
              elevation: 4, // tinggi shadow
              // shadowColor: Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'lib/assets/image/menu_home/money_icon.png',
                  width: 47,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "Request \nPocket Money",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDefaultColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
