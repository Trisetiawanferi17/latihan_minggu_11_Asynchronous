import 'dart:async';

import 'package:flutter/material.dart';

import '../models/materi.dart';
import '../services/layanan_materi.dart';

class TugasKondisiPage extends StatefulWidget {
  const TugasKondisiPage({super.key});

  @override
  State<TugasKondisiPage> createState() => _TugasKondisiPageState();
}

class _TugasKondisiPageState extends State<TugasKondisiPage> {
  final _layanan = LayananMateri();

  late Future<List<Materi>> _futureMateri;
  ModeSimulasi _mode = ModeSimulasi.berhasilBerisi;

  @override
  void initState() {
    super.initState();
    _futureMateri = _ambilDenganTimeout();
  }

  // Fungsi mengambil data + timeout 3 detik
  Future<List<Materi>> _ambilDenganTimeout() {
    return _layanan.ambilMateri(_mode).timeout(const Duration(seconds: 3));
  }

  // Fungsi untuk memuat ulang
  void _muatUlang() {
    setState(() {
      _futureMateri = _ambilDenganTimeout();
    });
  }

  // Fungsi untuk ganti mode (untuk ngetes)
  void _gantiMode(ModeSimulasi modeBaru) {
    _mode = modeBaru;
    _muatUlang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas: 4 Kondisi'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _muatUlang),
        ],
      ),
      body: Column(
        children: [
          // Tombol untuk ganti-ganti simulasi (Biarkan saja untuk testing)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: ModeSimulasi.values.map((mode) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(mode.name),
                    selected: _mode == mode,
                    onSelected: (_) => _gantiMode(mode),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),

          // Ini inti dari FutureBuilder-nya
          Expanded(
            child: FutureBuilder<List<Materi>>(
              future: _futureMateri,
              builder: (context, snapshot) {
                // KONDISI 1: SEDANG MEMUAT
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat materi...'),
                      ],
                    ),
                  );
                }

                // KONDISI 4: GAGAL / ERROR
                if (snapshot.hasError) {
                  final isTimeout = snapshot.error.toString().contains(
                    'TimeoutException',
                  );
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 64,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isTimeout
                                ? 'Koneksi terlalu lama. Silakan coba lagi.'
                                : 'Gagal memuat materi.',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _muatUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Ambil data (berisi atau kosong)
                final data = snapshot.data ?? [];

                // KONDISI 3: BERHASIL TETAPI KOSONG
                if (data.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada materi tersedia',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _muatUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Muat Ulang'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // KONDISI 2: BERHASIL DENGAN DATA
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final materi = data[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(materi.judul),
                      subtitle: Text(materi.deskripsi),
                      trailing: const Icon(Icons.chevron_right),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
