class CalendarUtils {
  static const List<String> _pasaran = ['Legi', 'Pahing', 'Pon', 'Wage', 'Kliwon'];
  static const List<String> _hari = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  // Referensi tanggal 1 Januari 1900 adalah Senin Pahing
  static final DateTime _baseDate = DateTime(1900, 1, 1);
  // Indeks hari 1 Jan 1900: Senin (1)
  // Indeks pasaran 1 Jan 1900: Pahing (1)

  static String getWeton(DateTime date) {
    // Normalisasi date ke midnight
    DateTime targetDate = DateTime(date.year, date.month, date.day);
    DateTime refDate = _baseDate;
    
    int diffDays = targetDate.difference(refDate).inDays;
    
    // Hari: (1 + diffDays) % 7
    int dayIndex = (1 + diffDays) % 7;
    if (dayIndex < 0) dayIndex += 7;
    
    // Pasaran: (1 + diffDays) % 5
    int pasaranIndex = (1 + diffDays) % 5;
    if (pasaranIndex < 0) pasaranIndex += 5;

    return '${_hari[dayIndex]} ${_pasaran[pasaranIndex]}';
  }

  static const List<String> _sasih = [
    'Kasa (Satu)', 'Karo (Dua)', 'Katiga (Tiga)', 'Kapat (Empat)', 
    'Kalima (Lima)', 'Kanem (Enam)', 'Kapitu (Tujuh)', 'Kawalu (Delapan)', 
    'Kasanga (Sembilan)', 'Kadasa (Sepuluh)', 'Desta (Sebelas)', 'Sada (Dua Belas)'
  ];

  static Map<String, dynamic> getSaka(DateTime date) {
    // Pendekatan dummy: 
    // Tahun Saka = Tahun Masehi - 78
    // Bulan/Sasih = (Bulan Masehi + 5) % 12 (karena Kasa biasa sekitar bulan Juli)
    int sakaYear = date.year - 78;
    int sasihIndex = (date.month + 5) % 12;
    if (sasihIndex < 0) sasihIndex += 12;

    return {
      'tahun': sakaYear,
      'sasih': _sasih[sasihIndex],
    };
  }

  static String getAgriculturalAdvice(String weton, String sasih) {
    // Dummy advice
    if (weton.contains('Kliwon')) {
      return 'Hari yang sangat baik untuk mulai menanam padi menurut Pranata Mangsa. Tanah sedang dalam kondisi prima.';
    } else if (sasih.contains('Kapat')) {
      return 'Sasih Kapat: Baik untuk menanam palawija atau umbi-umbian. Curah hujan mulai stabil.';
    } else {
      return 'Hari netral untuk kegiatan pertanian. Perhatikan cuaca setempat sebelum pemupukan.';
    }
  }
}