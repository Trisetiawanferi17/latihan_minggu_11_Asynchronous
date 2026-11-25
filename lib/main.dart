import 'package:flutter/material.dart';

import 'pages/praktikum1_page.dart';
import 'pages/praktikum2_page.dart';
import 'pages/praktikum3_page.dart';
import 'pages/tugas_kondisi_page.dart'; // Import untuk halaman Tugas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Async',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HalamanMenu(),
    );
  }
}

class HalamanMenu extends StatelessWidget {
  const HalamanMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum Async')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Praktikum 1 — Simulasi Pemuatan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Praktikum1Page()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.error_outline),
            title: const Text('Praktikum 2 — Menangani Kegagalan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Praktikum2Page()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: const Text('Praktikum 3 — Operasi Paralel'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Praktikum3Page()),
              );
            },
          ),
          const Divider(), // Garis pemisah antara praktikum dan tugas
          ListTile(
            leading: const Icon(Icons.task_alt, color: Colors.indigo),
            title: const Text(
              'Tugas — Halaman Empat Kondisi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TugasKondisiPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
