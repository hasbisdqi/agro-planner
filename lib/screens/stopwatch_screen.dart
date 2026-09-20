import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
    _stopwatch.start();
    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {});
  }

  void _resetTimer() {
    _stopTimer();
    _stopwatch.reset();
    setState(() {
      _laps.clear();
    });
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      final lapTime = _formatTime(_stopwatch.elapsedMilliseconds);
      setState(() {
        _laps.insert(0, lapTime);
      });
    }
  }

  String _formatTime(int milliseconds) {
    final hundreds = (milliseconds / 10).truncate() % 100;
    final seconds = (milliseconds / 1000).truncate() % 60;
    final minutes = (milliseconds / (1000 * 60)).truncate() % 60;
    final hours = (milliseconds / (1000 * 60 * 60)).truncate();

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    final hundredsStr = hundreds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr.$hundredsStr';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRunning = _stopwatch.isRunning;
    final isStarted = _stopwatch.elapsedMilliseconds > 0;
    final timeStr = _formatTime(_stopwatch.elapsedMilliseconds);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch Timer Pertanian'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                elevation: 0,
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.water_drop_rounded,
                          size: 28,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Gunakan fitur ini untuk mengatur durasi pengairan pompa irigasi atau durasi perendaman benih.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Timer Display
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    timeStr,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 54,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: isRunning
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Laps Section (if any)
              if (_laps.isNotEmpty) ...[
                Text(
                  'Catatan Putaran (Lap)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    itemCount: _laps.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final lapNumber = _laps.length - index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lap $lapNumber',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.outline,
                              ),
                            ),
                            Text(
                              _laps[index],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Lap / Reset button
                  IconButton.filledTonal(
                    onPressed: isStarted
                        ? (isRunning ? _addLap : _resetTimer)
                        : null,
                    iconSize: 28,
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                    ),
                    icon: Icon(isRunning ? Icons.flag_rounded : Icons.replay_rounded),
                    tooltip: isRunning ? 'Catat Putaran' : 'Reset Timer',
                  ),

                  // Start / Pause button
                  FilledButton.icon(
                    onPressed: isRunning ? _stopTimer : _startTimer,
                    icon: Icon(
                      isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 28,
                    ),
                    label: Text(
                      isRunning ? 'Jeda' : (isStarted ? 'Lanjut' : 'Mulai'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
