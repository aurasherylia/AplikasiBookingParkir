import 'package:flutter/material.dart';

import '../constants.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'Bagaimana cara memesan slot parkir?',
        'a':
            'Login dengan NIM & password, pilih area parkir, pilih slot yang tersedia, lalu konfirmasi di halaman Book Space.'
      },
      {
        'q': 'Apakah saya bisa memesan lebih dari satu kali?',
        'a':
            'Bisa. Setiap booking akan disimpan di Parking History dan dapat dibuka kembali kapan saja.'
      },
      {
        'q': 'Apakah aplikasi ini hanya untuk Kampus 2 UPN?',
        'a':
            'Saat ini aplikasi difokuskan untuk pengelolaan parkir di Kampus 2 UPN "Veteran" Yogyakarta.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('How it works'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(kScreenPadding),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final item = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  childrenPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    item['q']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  children: [
                    Text(
                      item['a']!,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
