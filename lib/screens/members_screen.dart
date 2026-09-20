import 'package:flutter/material.dart';

class Member {
  final String name;
  final String nim;

  Member({
    required this.name,
    required this.nim,
  });
}

class MembersScreen extends StatelessWidget {
  MembersScreen({super.key});

  final List<Member> members = [
    Member(
      name: 'Muhammad Hasbi Assidiqi',
      nim: '124240135',
    ),
    Member(
      name: 'Muhammad Ridho Nadika',
      nim: '124240137',
    ),
    Member(
      name: 'Muhammad Ghaffari',
      nim: '124240090',
    ),
    Member(
      name: 'Laksana Bagus S. A. J.',
      nim: '124240188',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota Kelompok'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIM: ${member.nim}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
