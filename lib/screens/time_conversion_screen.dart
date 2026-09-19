import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/time_utils.dart';

class TimeConversionScreen extends StatefulWidget {
  const TimeConversionScreen({super.key});

  @override
  State<TimeConversionScreen> createState() => _TimeConversionScreenState();
}

class _TimeConversionScreenState extends State<TimeConversionScreen> {
  DateTime _selectedDateTime = DateTime.now().subtract(const Duration(days: 30));
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update live clock every second for live age counter
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Lahir / Tanam',
      confirmText: 'PILIH',
      cancelText: 'BATAL',
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
        helpText: 'Pilih Jam/Waktu',
        confirmText: 'PILIH',
        cancelText: 'BATAL',
      );

      final TimeOfDay finalTime = pickedTime ?? TimeOfDay.fromDateTime(_selectedDateTime);

      setState(() {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          finalTime.hour,
          finalTime.minute,
        );
      });
    }
  }

  void _setQuickPreset(Duration offset) {
    setState(() {
      _selectedDateTime = DateTime.now().subtract(offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ageDiff = TimeUtils.calculateAgeDifference(_selectedDateTime, _currentTime);
    final hijriDate = TimeUtils.gregorianToHijri(_selectedDateTime);
    final currentHijriDate = TimeUtils.gregorianToHijri(_currentTime);

    final dateFormatter = DateFormat('EEEE, dd MMMM yyyy, HH:mm:ss', 'id_ID');
    // Fallback format if locale id_ID is not initialized in basic runner
    String formattedSelectedDate;
    String formattedCurrentDate;
    try {
      formattedSelectedDate = DateFormat('EEEE, dd MMMM yyyy - HH:mm WIB').format(_selectedDateTime);
      formattedCurrentDate = DateFormat('EEEE, dd MMMM yyyy - HH:mm:ss WIB').format(_currentTime);
    } catch (_) {
      formattedSelectedDate = '${_selectedDateTime.day}/${_selectedDateTime.month}/${_selectedDateTime.year} ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}';
      formattedCurrentDate = '${_currentTime.day}/${_currentTime.month}/${_currentTime.year} ${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Waktu & Umur'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Banner
              _buildHeaderBanner(colorScheme, theme),
              const SizedBox(height: 16),

              // Date Picker Card
              _buildDatePickerCard(colorScheme, theme, formattedSelectedDate),
              const SizedBox(height: 16),

              // Live Real-Time Age Card
              _buildLiveAgeCard(colorScheme, theme, ageDiff),
              const SizedBox(height: 16),

              // Hijri Calendar Card
              _buildHijriCard(colorScheme, theme, hijriDate, currentHijriDate),
              const SizedBox(height: 16),

              // Time Zone Converter Card
              _buildTimeZoneCard(colorScheme, theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.surfaceVariant,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kalkulator Usia & Kalender Hijriah',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Hitung usia tanaman atau kelahiran secara live per detik dengan konversi penanggalan Islam.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerCard(
    ColorScheme colorScheme,
    ThemeData theme,
    String formattedSelectedDate,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tanggal Patokan (Lahir / Tanam)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.event, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Terpilih:',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          formattedSelectedDate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.edit_calendar_rounded),
                label: const Text('Pilih Tanggal & Waktu'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Preset Cepat (Usia Tanaman):',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('Hari Ini', Duration.zero),
                  const SizedBox(width: 6),
                  _buildPresetChip('1 Minggu Lalu', const Duration(days: 7)),
                  const SizedBox(width: 6),
                  _buildPresetChip('1 Bulan Lalu', const Duration(days: 30)),
                  const SizedBox(width: 6),
                  _buildPresetChip('100 Hari Lalu', const Duration(days: 100)),
                  const SizedBox(width: 6),
                  _buildPresetChip('1 Tahun Lalu', const Duration(days: 365)),
                  const SizedBox(width: 6),
                  _buildPresetChip('20 Tahun Lalu', const Duration(days: 365 * 20 + 5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, Duration offset) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      onPressed: () => _setQuickPreset(offset),
    );
  }

  Widget _buildLiveAgeCard(
    ColorScheme colorScheme,
    ThemeData theme,
    AgeDifference ageDiff,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.primaryContainer.withOpacity(0.2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.av_timer_rounded, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      ageDiff.isFuture ? 'Waktu Menuju Target' : 'Detail Usia Saat Ini',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade400),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 6 Grid Units (Tahun, Bulan, Hari, Jam, Menit, Detik)
            Row(
              children: [
                _buildTimeUnitBox(theme, colorScheme, '${ageDiff.years}', 'Tahun'),
                const SizedBox(width: 6),
                _buildTimeUnitBox(theme, colorScheme, '${ageDiff.months}', 'Bulan'),
                const SizedBox(width: 6),
                _buildTimeUnitBox(theme, colorScheme, '${ageDiff.days}', 'Hari'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTimeUnitBox(theme, colorScheme, '${ageDiff.hours.toString().padLeft(2, '0')}', 'Jam'),
                const SizedBox(width: 6),
                _buildTimeUnitBox(theme, colorScheme, '${ageDiff.minutes.toString().padLeft(2, '0')}', 'Menit'),
                const SizedBox(width: 6),
                _buildTimeUnitBox(
                  theme,
                  colorScheme,
                  '${ageDiff.seconds.toString().padLeft(2, '0')}',
                  'Detik',
                  highlight: true,
                ),
              ],
            ),
            const Divider(height: 24),

            // Summary text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Format Rinci:',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        ageDiff.formattedDetailed,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Total: ${NumberFormat('#,###').format(ageDiff.totalDays)} Hari (~${NumberFormat('#,###').format(ageDiff.totalHours)} Jam / ${NumberFormat('#,###').format(ageDiff.totalSeconds)} Detik)',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnitBox(
    ThemeData theme,
    ColorScheme colorScheme,
    String value,
    String label, {
    bool highlight = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: highlight
              ? colorScheme.primaryContainer
              : colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlight
                ? colorScheme.primary
                : colorScheme.outlineVariant.withOpacity(0.5),
            width: highlight ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: highlight
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: highlight
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHijriCard(
    ColorScheme colorScheme,
    ThemeData theme,
    HijriDate selectedHijri,
    HijriDate currentHijri,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.nightlight_round, color: Colors.amber.shade800, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Konversi Kalender Hijriah',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tanggal Terpilih dalam Hijriah
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hijriah Tanggal Terpilih:',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Target',
                          style: TextStyle(fontSize: 10, color: Colors.brown.shade900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    selectedHijri.formatted,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bulan ke-${selectedHijri.month} (${selectedHijri.monthName}) Tahun ${selectedHijri.year} Hijriah',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.brown.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Tanggal Hari ini dalam Hijriah
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.today_rounded, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hari Ini (Kalender Hijriah):',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          currentHijri.formatted,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeZoneCard(ColorScheme colorScheme, ThemeData theme) {
    final utc = _currentTime.toUtc();
    final wib = utc.add(const Duration(hours: 7));
    final wita = utc.add(const Duration(hours: 8));
    final wit = utc.add(const Duration(hours: 9));
    final london = utc.add(const Duration(hours: 1)); // BST / GMT+1 approximate summer/winter

    final timeFormatter = DateFormat('HH:mm:ss');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.public_rounded, color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Zona Waktu Dunia (Live Clock)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildZoneItem(theme, 'WIB (UTC+7)', timeFormatter.format(wib), 'Jakarta/Sumatera/Jawa', true),
                const SizedBox(width: 8),
                _buildZoneItem(theme, 'WITA (UTC+8)', timeFormatter.format(wita), 'Bali/Makassar', false),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildZoneItem(theme, 'WIT (UTC+9)', timeFormatter.format(wit), 'Maluku/Papua', false),
                const SizedBox(width: 8),
                _buildZoneItem(theme, 'London (UTC+1/0)', timeFormatter.format(london), 'United Kingdom', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneItem(
    ThemeData theme,
    String label,
    String time,
    String location,
    bool isPrimary,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primaryContainer.withOpacity(0.4)
              : theme.colorScheme.surfaceVariant.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary
                ? theme.colorScheme.primary.withOpacity(0.4)
                : theme.colorScheme.outlineVariant.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isPrimary ? theme.colorScheme.primary : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              location,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
