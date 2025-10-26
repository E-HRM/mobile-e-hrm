// ignore_for_file: deprecated_member_use

import 'package:e_hrm/contraints/colors.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 60, //horizontal
      runSpacing: 20, //vertikal
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/kunjungan-klien');
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 100, // <-- DIKEMBALIKAN KE 100 (agar seragam)
            width: 120,
            // 1. Padding vertikal disesuaikan
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // 2. Pusatkan
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3. Hapus Expanded, beri ukuran tetap
                Image.asset(
                  'lib/assets/image/menu_home/kunjungan.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                // 4. Sesuaikan jarak
                SizedBox(height: 8),
                Text(
                  "Kunjungan",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/agenda-kerja');
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 100,
            width: 120,
            // 1. Sesuaikan padding agar konten muat
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // 2. Pusatkan konten
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3. Hapus Expanded, beri ukuran tetap
                Image.asset(
                  'lib/assets/image/menu_home/agendakerja.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                // 4. Sesuaikan jarak
                SizedBox(height: 8),
                // 5. Perbaiki label teks
                Text(
                  "Agenda Kerja",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 100,
            width: 120,
            // 1. Sesuaikan padding agar konten muat
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // 2. Pusatkan konten
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3. Hapus Expanded, beri ukuran tetap
                Image.asset(
                  'lib/assets/image/menu_home/cuti.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                // 4. Sesuaikan jarak
                SizedBox(height: 8),
                Text(
                  "Cuti/Izin",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/jam-istirahat');
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 100,
            width: 120,
            // 1. Sesuaikan padding agar konten muat
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // 2. Pusatkan konten
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3. Hapus Expanded, beri ukuran tetap
                Image.asset(
                  'lib/assets/image/menu_home/istirahat.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                // 4. Sesuaikan jarak
                SizedBox(height: 8),
                Text(
                  "Jam Istirahat",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 100,
            width: 120,
            // 1. Kurangi padding vertikal
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // 2. Pusatkan semua konten
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3. Hapus Expanded dan beri ukuran gambar yang pas
                Image.asset(
                  'lib/assets/image/menu_home/lembur.png',
                  width: 50, // Beri ukuran tetap
                  height: 50, // Beri ukuran tetap
                  fit: BoxFit.cover,
                ),
                // 4. Kurangi jarak
                SizedBox(height: 8),
                Text(
                  "Lembur",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 100,
            width: 120,
            // SARAN 1: Kurangi padding agar ada ruang lebih untuk konten
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.hintColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // SARAN 2: Pusatkan konten di dalam Column
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SARAN 3: Hapus 'Expanded'
                Image.asset(
                  'lib/assets/image/menu_home/finance.png',
                  // SARAN 4: Sesuaikan ukuran gambar agar pas
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                // SARAN 5: Sesuaikan jarak
                SizedBox(height: 8),
                Text(
                  "Kunjungan",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
