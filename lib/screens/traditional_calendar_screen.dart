import 'package:flutter/material.dart';
import '../utils/calendar_utils.dart';
import 'package:intl/intl.dart';

class TraditionalCalendarScreen extends StatefulWidget {
  const TraditionalCalendarScreen({Key? key}) : super(key: key);

  @override
  _TraditionalCalendarScreenState createState() => _TraditionalCalendarScreenState();
}

class _TraditionalCalendarScreenState extends State<TraditionalCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  
  String _weton = '';
  Map<String, dynamic> _saka = {};
  String _advice = '';

  @override
  void initState() {
    super.initState();
    _calculateCalendar();
  }

  void _calculateCalendar() {
    setState(() {
      _weton = CalendarUtils.getWeton(_selectedDate);
      _saka = CalendarUtils.getSaka(_selectedDate);
      _advice = CalendarUtils.getAgriculturalAdvice(_weton, _saka['sasih'] as String);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calculateCalendar();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Tradisional'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Pilih Tanggal Masehi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dateFormat.format(_selectedDate),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Pilih'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hasil Konversi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Divider(thickness: 2),
                        const SizedBox(height: 10),
                        _buildResultRow('Kalender Jawa (Weton):', _weton, Icons.wb_sunny),
                        const SizedBox(height: 15),
                        _buildResultRow(
                          'Kalender Saka Bali:',
                          'Tahun ${_saka['tahun']}, Sasih ${_saka['sasih']}',
                          Icons.nights_stay,
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          'Saran Pertanian:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[300]!),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.eco, color: Colors.green[700]),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _advice,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green[900],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.orange, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}