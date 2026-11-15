import 'package:flutter/material.dart';

class AoeWorshipScreen extends StatelessWidget {
  const AoeWorshipScreen({super.key});

  final List<Map<String, String>> songs = const [
    {
      'title': 'Great Is Thy Faithfulness',
      'author': 'Thomas Chisholm & William Runyan',
      'key': 'D Major',
      'tempo': 'Slow Reverence',
      'category': 'Classic Anglo-Indian Hymn',
    },
    {
      'title': 'Alpha and Omega',
      'author': 'Israel Houghton',
      'key': 'C Major',
      'tempo': 'Worship Praise',
      'category': 'Contemporary Adoration',
    },
    {
      'title': 'How Great Thou Art',
      'author': 'Stuart K. Hine',
      'key': 'G Major',
      'tempo': 'Majestic',
      'category': 'Celebration & Communion',
    },
    {
      'title': 'In Christ Alone',
      'author': 'Keith Getty & Stuart Townend',
      'key': 'D Major',
      'tempo': 'Anthem',
      'category': 'Sunday Anthem',
    },
    {
      'title': 'Blessed Assurance',
      'author': 'Fanny Crosby & Phoebe Knapp',
      'key': 'D Major',
      'tempo': 'Upbeat Praise',
      'category': 'Hymn of Assurance',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF18284A);
    const gold = Color(0xFFBA9A45);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hymns & Worship Setlists', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF18284A), Color(0xFF233761)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.library_music, color: gold, size: 32),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Sunday Setlist',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Selected for Sunday Morning Celebration & Holy Communion',
                        style: TextStyle(color: Color(0xFFFEF08A), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hymnal & Song Library',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          ...songs.map((song) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.music_note, color: navy, size: 22),
                ),
                title: Text(
                  song['title']!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                subtitle: Text(
                  '${song['author']} • ${song['category']}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF08A).withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    song['key']!,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
