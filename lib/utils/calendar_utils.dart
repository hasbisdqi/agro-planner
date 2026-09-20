class CalendarUtils {
  static const List<String> _pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  static const List<String> _hari = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  // Referensi tanggal 1 Januari 1900 adalah Senin Pahing
  static final DateTime _baseDate = DateTime(1900, 1, 1);

  // Nilai Neptu Hari & Pasaran
  static const Map<String, int> neptuHari = {
    'Minggu': 5,
    'Senin': 4,
    'Selasa': 3,
    'Rabu': 7,
    'Kamis': 8,
    'Jumat': 6,
    'Sabtu': 9,
  };

  static const Map<String, int> neptuPasaran = {
    'Legi': 5,
    'Pahing': 9,
    'Pon': 7,
    'Wage': 4,
    'Kliwon': 8,
  };

  static Map<String, dynamic> getWetonDetail(DateTime date) {
    DateTime targetDate = DateTime(date.year, date.month, date.day);
    DateTime refDate = _baseDate;
    
    int diffDays = targetDate.difference(refDate).inDays;
    
    int dayIndex = (1 + diffDays) % 7;
    if (dayIndex < 0) dayIndex += 7;
    
    int pasaranIndex = (1 + diffDays) % 5;
    if (pasaranIndex < 0) pasaranIndex += 5;

    String namaHari = _hari[dayIndex];
    String namaPasaran = _pasaran[pasaranIndex];
    int nHari = neptuHari[namaHari] ?? 0;
    int nPasaran = neptuPasaran[namaPasaran] ?? 0;
    int totalNeptu = nHari + nPasaran;

    return {
      'hari': namaHari,
      'pasaran': namaPasaran,
      'weton': '$namaHari $namaPasaran',
      'neptuHari': nHari,
      'neptuPasaran': nPasaran,
      'totalNeptu': totalNeptu,
      'deskripsi': _getWetonDescription(namaHari, namaPasaran, totalNeptu),
    };
  }

  static String getWeton(DateTime date) {
    return getWetonDetail(date)['weton'] as String;
  }

  static String _getWetonDescription(String hari, String pasaran, int totalNeptu) {
    return 'Weton $hari $pasaran memiliki nilai Neptu $totalNeptu '
        '(Hari $hari = ${neptuHari[hari]}, Pasaran $pasaran = ${neptuPasaran[pasaran]}). '
        'Siklus weton berulang setiap 35 hari (selapan) hasil perpaduan 7 hari mingguan dan 5 hari pasaran Jawa.';
  }

  static const List<String> _sasih = [
    'Kasa (Satu)', 'Karo (Dua)', 'Katiga (Tiga)', 'Kapat (Empat)', 
    'Kalima (Lima)', 'Kanem (Enam)', 'Kapitu (Tujuh)', 'Kawalu (Delapan)', 
    'Kasanga (Sembilan)', 'Kadasa (Sepuluh)', 'Desta (Sebelas)', 'Sada (Dua Belas)'
  ];

  static Map<String, dynamic> getSaka(DateTime date) {
    int sakaYear = date.year - 78;
    int sasihIndex = (date.month + 5) % 12;
    if (sasihIndex < 0) sasihIndex += 12;

    return {
      'tahun': sakaYear,
      'sasih': _sasih[sasihIndex],
    };
  }
}