class RegistrationData {
  final String key;
  final String nama;
  final String tanggal;
  final String tempat;
  final String alamat;
  final String kelas;
  final String foto3;
  final bool register;
  final int biaya;
  final DateTime tanggalBergabung;

  RegistrationData({
    required this.key,
    required this.nama,
    required this.tanggal,
    required this.tempat,
    required this.alamat,
    required this.kelas,
    required this.foto3,
    required this.register,
    required this.biaya,
    required this.tanggalBergabung,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'nama': nama,
      'tanggal': tanggal,
      'tempat': tempat,
      'alamat': alamat,
      'kelas': kelas,
      'foto3': foto3,
      'register': register,
      'biaya': biaya,
      'now':tanggalBergabung
    };
  }
}
