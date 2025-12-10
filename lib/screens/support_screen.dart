import 'package:flutter/material.dart';

import '../constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kScreenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi Smart Parking ini dibuat untuk membantu mahasiswa dan '
              'civitas akademika UPN "Veteran" Yogyakarta dalam mengelola slot parkir '
              'secara lebih efisien.\n\n'
              'Fitur utama:\n'
              '• Pemilihan area parkir (FTI, Lapangan Volly, Lapangan Basket)\n'
              '• Pemilihan slot mobil & motor\n'
              '• Konfirmasi waktu parkir dan checkout otomatis\n'
              '• Riwayat booking yang tersimpan di perangkat\n',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 16),
            Text(
              'Kontak & Bantuan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email: support@smartparking.upn.ac.id\n'
              'Telepon: (0274) 000000\n'
              'Jam layanan: Senin - Jumat, 08.00 - 16.00 WIB',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
