import 'dart:async';

import '../models/materi.dart';

enum ModeSimulasi { berhasilBerisi, berhasilKosong, gagal, lambat }

class LayananMateri {
  Future<List<Materi>> ambilMateri(ModeSimulasi mode) async {
    // Simulasi loading jaringan selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    switch (mode) {
      case ModeSimulasi.berhasilBerisi:
        return const [
          // ==========================================
          // SILAKAN GANTI TEKS DI BAWAH INI DENGAN DATA KAMU
          // ==========================================
          Materi(judul: 'Nama Lengkap', deskripsi: 'Feri Tri setiawan'),
          Materi(judul: 'NIM', deskripsi: '202463121007'),
          Materi(judul: 'Kelas', deskripsi: 'K2 Teknik Komputer'),
        ];
      case ModeSimulasi.berhasilKosong:
        return const []; // Mengembalikan list kosong
      case ModeSimulasi.gagal:
        throw Exception('Server menolak permintaan');
      case ModeSimulasi.lambat:
        // Simulasi jaringan lambat yang memicu timeout
        await Future.delayed(const Duration(seconds: 10));
        return const [];
    }
  }
}
