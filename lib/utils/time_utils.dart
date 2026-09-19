/// Utility logic untuk konversi waktu, hitung usia/selisih waktu presisi,
/// serta konversi kalender Masehi ke kalender Hijriah.
class TimeUtils {
  /// Nama-nama bulan dalam kalender Hijriah
  static const List<String> hijriMonthNames = [
    'Muharram',
    'Safar',
    'Rabiul Awwal',
    'Rabiul Akhir',
    'Jumadil Ula',
    'Jumadil Akhir',
    'Rajab',
    'Sya\'ban',
    'Ramadhan',
    'Syawwal',
    'Dzulqa\'dah',
    'Dzulhijjah',
  ];

  /// Menghitung selisih waktu atau usia dari [from] hingga [to]
  /// secara presisi dalam Tahun, Bulan, Hari, Jam, Menit, dan Detik.
  /// Jika [to] lebih lampau dari [from], hasilnya dihitung dengan durasi absolut / status khusus.
  static AgeDifference calculateAgeDifference(DateTime from, DateTime to) {
    bool isFuture = to.isBefore(from);
    DateTime start = isFuture ? to : from;
    DateTime end = isFuture ? from : to;

    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;
    int hours = end.hour - start.hour;
    int minutes = end.minute - start.minute;
    int seconds = end.second - start.second;

    if (seconds < 0) {
      seconds += 60;
      minutes -= 1;
    }
    if (minutes < 0) {
      minutes += 60;
      hours -= 1;
    }
    if (hours < 0) {
      hours += 24;
      days -= 1;
    }
    if (days < 0) {
      // Dapatkan jumlah hari pada bulan sebelumnya
      final prevMonthDate = DateTime(end.year, end.month, 0);
      days += prevMonthDate.day;
      months -= 1;
    }
    if (months < 0) {
      months += 12;
      years -= 1;
    }

    final totalDuration = end.difference(start);

    return AgeDifference(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      totalDays: totalDuration.inDays,
      totalHours: totalDuration.inHours,
      totalMinutes: totalDuration.inMinutes,
      totalSeconds: totalDuration.inSeconds,
      isFuture: isFuture,
    );
  }

  /// Mengonversi DateTime Masehi ke Tanggal Hijriah
  /// Menggunakan algoritma Julian Day Number (JDN) ke Kalender Tabular Islam / Kuwaiti Algorithm.
  static HijriDate gregorianToHijri(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;

    // Jika bulan Januari atau Februari, sesuaikan tahun & bulan untuk perhitungan Julian Day
    if (month <= 2) {
      year -= 1;
      month += 12;
    }

    // Perhitungan Julian Day (JD)
    int a = (year / 100).floor();
    int b = 2 - a + (a / 4).floor();
    int jd = (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524;

    // Konversi Julian Day ke Kalender Hijriah (Tabular Islamic Calendar)
    // Epoch Hijriah JD = 1948439.5 (1 Muharram 1 H ~ 16 Juli 622 M)
    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;

    int j = ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;

    int hijriMonth = ((24 * l) / 709).floor();
    int hijriDay = l - ((709 * hijriMonth) / 24).floor();
    int hijriYear = 30 * n + j - 30;

    // Validasi batas rentang bulan (1-12)
    if (hijriMonth < 1) hijriMonth = 1;
    if (hijriMonth > 12) hijriMonth = 12;

    String monthName = (hijriMonth >= 1 && hijriMonth <= 12)
        ? hijriMonthNames[hijriMonth - 1]
        : '';

    return HijriDate(
      year: hijriYear,
      month: hijriMonth,
      day: hijriDay,
      monthName: monthName,
    );
  }
}

/// Model representasi data selisih usia
class AgeDifference {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final int totalDays;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;
  final bool isFuture;

  const AgeDifference({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
    this.isFuture = false,
  });

  String get formattedDetailed {
    return '$years Tahun, $months Bulan, $days Hari, $hours Jam, $minutes Menit, $seconds Detik';
  }
}

/// Model representasi tanggal Hijriah
class HijriDate {
  final int year;
  final int month;
  final int day;
  final String monthName;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
    required this.monthName,
  });

  String get formatted {
    return '$day $monthName $year H';
  }

  @override
  String toString() => formatted;
}
