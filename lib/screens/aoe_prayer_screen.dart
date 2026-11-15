import 'package:flutter/material.dart';

class AoePrayerScreen extends StatefulWidget {
  const AoePrayerScreen({super.key});

  @override
  State<AoePrayerScreen> createState() => _AoePrayerScreenState();
}

class _AoePrayerScreenState extends State<AoePrayerScreen> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isConfidential = true;

  final List<Map<String, dynamic>> _communityPrayers = [
    {
      'title': 'Healing and recovery for Sister Mary',
      'category': 'Healing & Health',
      'pastoralNote': 'Prayed by Pastor Larry & Prayer Ministry',
      'date': 'Yesterday',
      'answered': false,
    },
    {
      'title': 'Grace for Youth Ministry Camp in Chennai',
      'category': 'Missions & Youth',
      'pastoralNote': 'Interceded by Pastor Soma Augustus',
      'date': '2 days ago',
      'answered': true,
    },
    {
      'title': 'Job placement & direction for Brother Samuel',
      'category': 'Family & Work',
      'pastoralNote': 'Uplifted in Wednesday Intercessory Prayer',
      'date': '3 days ago',
      'answered': false,
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _showSubmitPrayerDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Submit Prayer Petition',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18284A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pastors Larry Joshua & Soma Augustus will stand in faith with you.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Prayer Subject',
                  hintText: 'e.g. Healing, Family, Guidance',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _detailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Details / Petition',
                  hintText: 'Share your prayer request...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Confidential Pastoral Request', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Share only with Pastors Larry & Soma', style: TextStyle(fontSize: 12)),
                value: _isConfidential,
                activeThumbColor: const Color(0xFF18284A),
                onChanged: (v) => setModalState(() => _isConfidential = v),
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF18284A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final title = _titleController.text.trim();
                  if (title.isNotEmpty) {
                    setState(() {
                      _communityPrayers.insert(0, {
                        'title': title,
                        'category': 'Personal Request',
                        'pastoralNote': _isConfidential
                            ? 'Confidential (Delivered to Pastors Larry & Soma)'
                            : 'Shared with Prayer Team',
                        'date': 'Just now',
                        'answered': false,
                      });
                    });
                    _titleController.clear();
                    _detailsController.clear();
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prayer request submitted in faith!')),
                    );
                  }
                },
                child: const Text('Submit Request', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF18284A);
    const gold = Color(0xFFBA9A45);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intercessory Prayer Wall', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        onPressed: _showSubmitPrayerDialog,
        icon: const Icon(Icons.add, color: gold),
        label: const Text('Request Prayer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: navy, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '"Therefore confess your sins to each other and pray for each other so that you may be healed. The prayer of a righteous person is powerful and effective." — James 5:16',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Active Prayer Petitions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          ..._communityPrayers.map((prayer) {
            final answered = prayer['answered'] as bool;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: answered ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            answered ? 'Praise Report / Answered' : prayer['category'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: answered ? const Color(0xFF166534) : const Color(0xFF92400E),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          prayer['date'] as String,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prayer['title'] as String,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_pin, size: 14, color: gold),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            prayer['pastoralNote'] as String,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
