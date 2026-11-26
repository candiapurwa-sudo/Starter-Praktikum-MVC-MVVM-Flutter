import '../data/repositori_tugas.dart';
import '../model/tugas.dart';

class PengendaliTugas {
  PengendaliTugas(this._repo);

  final RepositoriTugas _repo;
  String? _galat;
  bool _hanyaBelumSelesai = false;

  List<Tugas> get daftar {
    final semua = _repo.daftar;
    if (!_hanyaBelumSelesai) return semua;
    return semua.where((tugas) => !tugas.selesai).toList();
  }

  int get totalTugas => _repo.daftar.length;
  String? get galat => _galat;
  bool get hanyaBelumSelesai => _hanyaBelumSelesai;
  int get jumlahSelesai =>
      _repo.daftar.where((tugas) => tugas.selesai).length;

  bool tambah(String input) {
    _galat = validasiJudul(input);
    if (_galat != null) return false;
    _repo.tambah(input.trim());
    return true;
  }

  void ubahStatus(int id) => _repo.ubahStatus(id);

  void ubahFilter(bool aktif) {
    _hanyaBelumSelesai = aktif;
  }
}