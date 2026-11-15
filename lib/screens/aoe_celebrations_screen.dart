import 'package:flutter/material.dart';

enum CelebrationCategory {
  birthday('Birthday', 'Birthdays', Icons.cake_outlined, Color(0xFFE11D48)),
  anniversary('Anniversary', 'Anniversaries', Icons.favorite_border, Color(0xFFD97706)),
  baptism('Baptism', 'Baptisms', Icons.water_drop_outlined, Color(0xFF0284C7));

  final String label;
  final String pluralLabel;
  final IconData icon;
  final Color color;
  const CelebrationCategory(this.label, this.pluralLabel, this.icon, this.color);
}

class CelebrationWishItem {
  final String senderName;
  final String senderRole; // 'SUPER_BOSS', 'MEMBER'
  final String message;
  final String timeAgo;

  const CelebrationWishItem({
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.timeAgo,
  });
}

class CelebrationEventRecord {
  final String id;
  final CelebrationCategory category;
  final String celebrantName;
  final String familyId;
  final String dateBadge;
  final String milestoneTitle;
  final String scriptureNote;
  final int wishCount;
  final bool hasWishedByMe;
  final List<CelebrationWishItem> wishes;

  const CelebrationEventRecord({
    required this.id,
    required this.category,
    required this.celebrantName,
    required this.familyId,
    required this.dateBadge,
    required this.milestoneTitle,
    required this.scriptureNote,
    required this.wishCount,
    this.hasWishedByMe = false,
    this.wishes = const [],
  });

  CelebrationEventRecord addWish(CelebrationWishItem wish) {
    return CelebrationEventRecord(
      id: id,
      category: category,
      celebrantName: celebrantName,
      familyId: familyId,
      dateBadge: dateBadge,
      milestoneTitle: milestoneTitle,
      scriptureNote: scriptureNote,
      wishCount: wishCount + 1,
      hasWishedByMe: true,
      wishes: [...wishes, wish],
    );
  }
}

class AoeCelebrationsScreen extends StatefulWidget {
  const AoeCelebrationsScreen({super.key});

  @override
  State<AoeCelebrationsScreen> createState() => _AoeCelebrationsScreenState();
}

class _AoeCelebrationsScreenState extends State<AoeCelebrationsScreen> {
  static const Color _navy = Color(0xFF18284A);
  static const Color _gold = Color(0xFFBA9A45);

  CelebrationCategory? _selectedCategory; // null = All

  final List<CelebrationEventRecord> _events = [
    const CelebrationEventRecord(
      id: 'c1',
      category: CelebrationCategory.birthday,
      celebrantName: 'Aaron Fernandez',
      familyId: 'AOE-FAM-2026-002-C1',
      dateBadge: 'TODAY · 15 NOV',
      milestoneTitle: '19th Birthday · Choir Group Admin',
      scriptureNote:
          '"The Lord bless you and keep you; the Lord make His face shine upon you." — Numbers 6:24-25',
      wishCount: 18,
      wishes: [
        CelebrationWishItem(
          senderName: 'Pastor Larry Joshua Augustus',
          senderRole: 'SUPER_BOSS',
          message:
              'Happy 19th Birthday Aaron! May the Lord continue to anoint your voice and music ministry at Alpha Omega Ekklesia.',
          timeAgo: '08:30 AM',
        ),
        CelebrationWishItem(
          senderName: "Winfred D'Cruz",
          senderRole: 'MEMBER',
          message:
              'Wishing you a blessed birthday Aaron! Have a wonderful year ahead in Christ.',
          timeAgo: '09:15 AM',
        ),
      ],
    ),
    const CelebrationEventRecord(
      id: 'c2',
      category: CelebrationCategory.anniversary,
      celebrantName: 'Desmond & Lorraine Fernandez',
      familyId: 'AOE-FAM-2026-002',
      dateBadge: 'TODAY · 15 NOV',
      milestoneTitle: '22nd Wedding Anniversary · Perambur, Chennai',
      scriptureNote:
          '"Unless the Lord builds the house, the builders labor in vain." — Psalm 127:1',
      wishCount: 24,
      wishes: [
        CelebrationWishItem(
          senderName: 'Pastor Soma Augustus',
          senderRole: 'SUPER_BOSS',
          message:
              'Happy 22nd Anniversary Desmond & Lorraine! Thank you for being pillars of faith in our church family.',
          timeAgo: '08:45 AM',
        ),
      ],
    ),
    const CelebrationEventRecord(
      id: 'c3',
      category: CelebrationCategory.baptism,
      celebrantName: "Winfred D'Cruz",
      familyId: 'AOE-FAM-2026-003-H1',
      dateBadge: 'TODAY · 15 NOV',
      milestoneTitle:
          'Water Baptism Anniversary · 5 Years in Christ (Baptized at AOE)',
      scriptureNote:
          '"Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!" — 2 Corinthians 5:17',
      wishCount: 15,
      wishes: [
        CelebrationWishItem(
          senderName: 'Pastor Larry Joshua Augustus',
          senderRole: 'SUPER_BOSS',
          message:
              'Rejoicing with you on 5 glorious years since your water baptism, Brother Winfred!',
          timeAgo: '09:00 AM',
        ),
      ],
    ),
    const CelebrationEventRecord(
      id: 'c4',
      category: CelebrationCategory.baptism,
      celebrantName: "Trevor D'Monte",
      familyId: 'AOE-FAM-2026-005-H1',
      dateBadge: 'THIS SUNDAY · 09:30 AM',
      milestoneTitle:
          'Upcoming Water Baptism Service Reminder · Officiated by Pastors Larry & Soma',
      scriptureNote:
          '"Repent and be baptized, every one of you, in the name of Jesus Christ." — Acts 2:38',
      wishCount: 12,
      wishes: [
        CelebrationWishItem(
          senderName: 'Collin Rozario',
          senderRole: 'MEMBER',
          message:
              'Praying for you Trevor as you take your covenant step of water baptism this Sunday!',
          timeAgo: 'Yesterday',
        ),
      ],
    ),
    const CelebrationEventRecord(
      id: 'c5',
      category: CelebrationCategory.birthday,
      celebrantName: "Melissa D'Cruz",
      familyId: 'AOE-FAM-2026-003-C1',
      dateBadge: 'TOMORROW · 16 NOV',
      milestoneTitle: 'Birthday Reminder · Youth Fellowship Admin',
      scriptureNote:
          '"For I know the plans I have for you, declares the Lord." — Jeremiah 29:11',
      wishCount: 9,
      wishes: [],
    ),
  ];

  List<CelebrationEventRecord> get _filteredEvents {
    if (_selectedCategory == null) return _events;
    return _events.where((e) => e.category == _selectedCategory).toList();
  }

  List<String> _quickWishesForCategory(CelebrationCategory cat) {
    switch (cat) {
      case CelebrationCategory.birthday:
        return [
          'Happy Birthday! God Bless You!',
          'Blessed Birthday! Numbers 6:24-26',
        ];
      case CelebrationCategory.anniversary:
        return [
          'Happy Wedding Anniversary!',
          'God Bless Your Marriage & Home!',
        ];
      case CelebrationCategory.baptism:
        return [
          'Blessed Baptism Milestone in Christ!',
          'Rejoicing With You in the Lord!',
        ];
    }
  }

  void _sendQuickWish(CelebrationEventRecord record, String wishText) {
    final idx = _events.indexOf(record);
    if (idx == -1) return;

    setState(() {
      _events[idx] = record.addWish(
        CelebrationWishItem(
          senderName: 'Collin Rozario (AOE-FAM-2026-004-H1)',
          senderRole: 'MEMBER',
          message: wishText,
          timeAgo: 'Just Now',
        ),
      );
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: _navy,
          content: Text(
            'Sent blessing to ${record.celebrantName}: "$wishText"',
          ),
        ),
      );
  }

  void _openCustomWishDialog(CelebrationEventRecord record) {
    final wishCtrl = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Wish ${record.celebrantName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _navy,
            ),
          ),
          content: TextField(
            controller: wishCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Write your blessing, scripture, or wish...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                final text = wishCtrl.text.trim();
                if (text.isEmpty) return;
                Navigator.of(ctx).pop();
                _sendQuickWish(record, text);
              },
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Post Wish'),
            ),
          ],
        );
      },
    );
  }

  void _openAddReminderModal() {
    final nameCtrl = TextEditingController();
    final familyIdCtrl = TextEditingController(text: 'AOE-FAM-2026-004');
    final dateCtrl = TextEditingController(text: '20 NOV');
    final detailCtrl = TextEditingController();
    CelebrationCategory chosenCat = CelebrationCategory.birthday;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (_, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.celebration, color: _navy),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Add Birthday, Anniversary or Baptism Reminder',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: _navy,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(sheetCtx).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: CelebrationCategory.values.map((cat) {
                        final selected = chosenCat == cat;
                        return ChoiceChip(
                          label: Text(cat.label),
                          selected: selected,
                          selectedColor: _navy,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : _navy,
                          ),
                          onSelected: (_) =>
                              setModalState(() => chosenCat = cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Member / Couple Name *',
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: familyIdCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Family / Member ID',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: dateCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Date (e.g. 20 NOV)',
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: detailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Milestone Note (e.g. 10th Anniversary / Baptism)',
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        if (name.isEmpty) return;
                        setState(() {
                          _events.insert(
                            0,
                            CelebrationEventRecord(
                              id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                              category: chosenCat,
                              celebrantName: name,
                              familyId: familyIdCtrl.text.trim(),
                              dateBadge: dateCtrl.text.trim().toUpperCase(),
                              milestoneTitle: detailCtrl.text.trim().isEmpty
                                  ? '${chosenCat.label} Celebration'
                                  : detailCtrl.text.trim(),
                              scriptureNote:
                                  '"The Lord bless you and keep you." — Numbers 6:24',
                              wishCount: 1,
                              wishes: const [],
                            ),
                          );
                        });
                        Navigator.of(sheetCtx).pop();
                      },
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Save Reminder'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleEvents = _filteredEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Birthdays, Anniversaries & Baptisms',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
            color: _navy,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Add Reminder',
            onPressed: _openAddReminderModal,
            icon: const Icon(Icons.add_alert_outlined, color: _navy),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF18284A), Color(0xFF233761)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _gold.withValues(alpha: 0.55)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _gold.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Color(0xFFFEF08A),
                              size: 13,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'CHURCH FAMILY MILESTONES',
                              style: TextStyle(
                                color: Color(0xFFFEF08A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '3 TODAY',
                        style: TextStyle(
                          color: Color(0xFF6EE7B7),
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rejoice & Bless One Another',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Daily reminders for Birthdays, Wedding Anniversaries, and Water Baptisms across Alpha Omega Ekklesia. Tap a quick blessing below to wish your church family!',
                    style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('All Reminders (${_events.length})'),
                    selected: _selectedCategory == null,
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _selectedCategory == null ? Colors.white : _navy,
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedCategory = null),
                  ),
                  const SizedBox(width: 8),
                  ...CelebrationCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(
                          cat.icon,
                          size: 15,
                          color: isSelected ? const Color(0xFFFEF08A) : cat.color,
                        ),
                        label: Text(cat.pluralLabel),
                        selected: isSelected,
                        selectedColor: _navy,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : _navy,
                        ),
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Celebration Cards
            ...visibleEvents.map((record) {
              final cat = record.category;
              final quickWishes = _quickWishesForCategory(cat);

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cat.color.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Badge Row: Category + Date Reminder
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cat.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(cat.icon, size: 14, color: cat.color),
                              const SizedBox(width: 5),
                              Text(
                                '${cat.label.toUpperCase()} REMINDER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: cat.color,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            record.dateBadge,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Celebrant Name & Family ID
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: cat.color.withValues(alpha: 0.15),
                          child: Icon(cat.icon, color: cat.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.celebrantName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _navy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${record.milestoneTitle} · ${record.familyId}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF4DC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.volunteer_activism,
                                size: 13,
                                color: Color(0xFF92400E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${record.wishCount} Wishes',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Scripture Blessing Quote
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: const Border(
                          left: BorderSide(color: _gold, width: 3),
                        ),
                      ),
                      child: Text(
                        record.scriptureNote,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ),

                    // Existing Wishes Thread
                    if (record.wishes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      ...record.wishes.map((w) {
                        final isPastor = w.senderRole == 'SUPER_BOSS';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isPastor
                                ? const Color(0xFFFFFBEB)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: isPastor
                                ? Border.all(
                                    color: _gold.withValues(alpha: 0.45),
                                  )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      w.senderName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: isPastor
                                            ? const Color(0xFF92400E)
                                            : _navy,
                                      ),
                                    ),
                                  ),
                                  if (isPastor) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _navy,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'PASTOR',
                                        style: TextStyle(
                                          color: Color(0xFFFEF08A),
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 6),
                                  Text(
                                    w.timeAgo,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                w.message,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 10),
                    // One-Tap Quick Wishes + Write Custom Wish
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...quickWishes.map((wishText) {
                          return ActionChip(
                            avatar: Icon(
                              Icons.celebration,
                              size: 14,
                              color: cat.color,
                            ),
                            label: Text(
                              wishText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: cat.color,
                              ),
                            ),
                            backgroundColor: cat.color.withValues(alpha: 0.08),
                            side: BorderSide(
                              color: cat.color.withValues(alpha: 0.3),
                            ),
                            onPressed: () => _sendQuickWish(record, wishText),
                          );
                        }),
                        ActionChip(
                          avatar: const Icon(
                            Icons.edit_note,
                            size: 15,
                            color: _navy,
                          ),
                          label: const Text(
                            'Write Custom Wish',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _navy,
                            ),
                          ),
                          backgroundColor: const Color(0xFFF1F5F9),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          onPressed: () => _openCustomWishDialog(record),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
