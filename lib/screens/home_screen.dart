import 'package:flutter/material.dart';
import 'members_screen.dart';
import 'computation_screen.dart';
import 'crud_screen.dart';
import 'time_conversion_screen.dart';
import 'traditional_calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agro Planner - Home'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'PILIH MENU UTAMA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context: context,
                    number: '1',
                    icon: Icons.people_alt,
                    title: 'Daftar Anggota Kelompok',
                    subtitle: 'Informasi mahasiswa & tim pengembang',
                    destination: MembersScreen(),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    context: context,
                    number: '2',
                    icon: Icons.calculate,
                    title: 'Komputasi Pertanian',
                    subtitle: 'Kalkulator kebutuhan pupuk & air',
                    destination: const ComputationScreen(),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    context: context,
                    number: '3',
                    icon: Icons.eco,
                    title: 'Manajemen Data Lahan (CRUD)',
                    subtitle: 'Pencatatan komoditas & luas lahan',
                    destination: const CrudScreen(),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    context: context,
                    number: '4',
                    icon: Icons.access_time,
                    title: 'Konversi Waktu & Usia',
                    subtitle: 'Hitung detail umur & kalender Hijriah',
                    destination: const TimeConversionScreen(),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    context: context,
                    number: '5',
                    icon: Icons.calendar_month,
                    title: 'Kalender Tradisional',
                    subtitle: 'Konversi Weton Jawa & Saka Bali',
                    destination: const TraditionalCalendarScreen(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String number,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget destination,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Text(
                  number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
