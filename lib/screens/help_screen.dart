import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final sessionService = SessionService();
    await sessionService.logout();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Panduan Aplikasi',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildGuideItem(
                        context,
                        '1. Daftar Anggota Kelompok',
                        'Berisi informasi mengenai para pengembang aplikasi ini.',
                      ),
                      _buildGuideItem(
                        context,
                        '2. Komputasi Pertanian',
                        'Menghitung kebutuhan pupuk dan air untuk lahan Anda secara otomatis.',
                      ),
                      _buildGuideItem(
                        context,
                        '3. Manajemen Data Lahan & Tanaman',
                        'Kelola dan catat data lahan, jenis tanaman, serta jadwal pemeliharaan.',
                      ),
                      _buildGuideItem(
                        context,
                        '4. Konversi Waktu & Umur Tanaman',
                        'Melihat perbedaan zona waktu dan menghitung umur tanaman secara presisi.',
                      ),
                      _buildGuideItem(
                        context,
                        '5. Konversi Kalender Tradisional',
                        'Menghitung dan mengkonversi tanggal kalender Masehi ke sistem Weton dan Saka Bali.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
