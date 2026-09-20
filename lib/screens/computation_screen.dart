import 'package:flutter/material.dart';

class ComputationScreen extends StatefulWidget {
  const ComputationScreen({Key? key}) : super(key: key);

  @override
  _ComputationScreenState createState() => _ComputationScreenState();
}

class _ComputationScreenState extends State<ComputationScreen> {
  final TextEditingController _areaController = TextEditingController();
  String _selectedCrop = 'Padi';
  final List<String> _crops = ['Padi', 'Jagung', 'Cabai'];
  double? _estimatedNPK;

  void _calculate() {
    final areaText = _areaController.text.replaceAll(',', '.'); // Handle comma vs dot
    if (areaText.isEmpty) {
      setState(() {
        _estimatedNPK = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Luas lahan tidak boleh kosong')),
      );
      return;
    }

    final area = double.tryParse(areaText);
    if (area == null || area < 0 || area.isInfinite || area.isNaN) {
      setState(() {
        _estimatedNPK = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan angka luas lahan yang valid!')),
      );
      return;
    }

    // Edge case if result is too huge (e.g., NIM x NIM -> 15 quadrillion)
    // 100 juta m2 = 10.000 Hektar (sudah sangat luas untuk 1 petak)
    if (area > 100000000) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peringatan: Luas melebihi batas rasional (>10.000 Hektar). Pastikan input benar!')),
      );
    }

    double multiplier = 0;
    switch (_selectedCrop) {
      case 'Padi':
        multiplier = 200;
        break;
      case 'Jagung':
        multiplier = 350;
        break;
      case 'Cabai':
        multiplier = 500;
        break;
    }

    // Perhitungan
    double result = (area / 10000) * multiplier;
    
    // Filter NaN / Infinite yang mungkin lolos
    if (result.isNaN || result.isInfinite) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan perhitungan (Overflow/Invalid).')),
      );
      return;
    }

    setState(() {
      _estimatedNPK = result;
    });
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Kebutuhan Pupuk NPK'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hitung Estimasi Pupuk Anda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Luas Lahan (m²)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.landscape),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: const InputDecoration(
                labelText: 'Jenis Tanaman',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.grass),
              ),
              items: _crops.map((crop) {
                return DropdownMenuItem(
                  value: crop,
                  child: Text(crop),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCrop = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Hitung Estimasi'),
            ),
            const SizedBox(height: 24),
            if (_estimatedNPK != null)
              Card(
                elevation: 4,
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.green.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Estimasi Kebutuhan NPK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_estimatedNPK!.toStringAsFixed(2)} kg',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
