import 'package:flutter/material.dart';

class Member {
  final String name;
  final String nim;
  final String role;
  final String avatarUrl;

  Member({
    required this.name,
    required this.nim,
    required this.role,
    this.avatarUrl = 'https://ui-avatars.com/api/?name=',
  });
}

class MembersScreen extends StatelessWidget {
  MembersScreen({super.key});

  final List<Member> members = [
    Member(
      name: 'Muhammad Hasbi Assidiqi',
      nim: '124240135',
      imagePath: 'assets/member1.png',
    ),
    Member(
      name: 'Muhammad Ridho Nadika',
      nim: '124240137',
      imagePath: 'assets/member2.png',
    ),
    Member(
      name: 'Muhammad Ghaffari',
      nim: '124240090',
      imagePath: 'assets/member3.png',
    ),
    Member(
      name: 'Laksana Bagus S. A. J.',
      nim: '124240188',
      imagePath: 'assets/member4.png',
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
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(
                        '${member.avatarUrl}${member.name.replaceAll(' ', '+')}',
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'NIM: ${member.nim}',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            member.role,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
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
