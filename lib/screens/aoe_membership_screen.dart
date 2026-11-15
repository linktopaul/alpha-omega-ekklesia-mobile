import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HouseholdMemberItem {
  final String fullName;
  final String roleLabel; // Head of Household, Spouse, Child
  final String roleSuffix; // H1, S1, C1, C2

  const HouseholdMemberItem({
    required this.fullName,
    required this.roleLabel,
    required this.roleSuffix,
  });
}

class ChurchFamilyRecord {
  final String? familyId; // Null while pending approval; e.g. AOE-FAM-2026-001 when approved
  final String familyName;
  final String headOfHousehold;
  final String phone;
  final String locality;
  final List<HouseholdMemberItem> members;
  final bool isApproved;
  final String? approvedBy;
  final String submittedAt;

  const ChurchFamilyRecord({
    this.familyId,
    required this.familyName,
    required this.headOfHousehold,
    required this.phone,
    required this.locality,
    required this.members,
    required this.isApproved,
    this.approvedBy,
    required this.submittedAt,
  });

  ChurchFamilyRecord approve({
    required String generatedFamilyId,
    required String pastorName,
  }) {
    return ChurchFamilyRecord(
      familyId: generatedFamilyId,
      familyName: familyName,
      headOfHousehold: headOfHousehold,
      phone: phone,
      locality: locality,
      members: members,
      isApproved: true,
      approvedBy: pastorName,
      submittedAt: submittedAt,
    );
  }
}

class AoeMembershipScreen extends StatefulWidget {
  const AoeMembershipScreen({super.key});

  @override
  State<AoeMembershipScreen> createState() => _AoeMembershipScreenState();
}

class _AoeMembershipScreenState extends State<AoeMembershipScreen> {
  static const Color _navy = Color(0xFF18284A);
  static const Color _gold = Color(0xFFBA9A45);

  bool _isPastorAdminView = false;
  String _selectedApprovingPastor = 'Pastor Larry Joshua Augustus';
  int _nextSequenceNumber = 3;

  final List<ChurchFamilyRecord> _families = [
    const ChurchFamilyRecord(
      familyId: 'AOE-FAM-2026-001',
      familyName: 'The Augustus Family',
      headOfHousehold: 'Pastor Larry Joshua Augustus',
      phone: '+91 98400 11223',
      locality: 'Kilpauk, Chennai',
      isApproved: true,
      approvedBy: 'Founding Clergy',
      submittedAt: 'Founding Household',
      members: [
        HouseholdMemberItem(
          fullName: 'Pastor Larry Joshua Augustus',
          roleLabel: 'Head of Household · Senior Pastor',
          roleSuffix: 'H1',
        ),
        HouseholdMemberItem(
          fullName: 'Pastor Soma Augustus',
          roleLabel: 'Spouse · Co-Pastor',
          roleSuffix: 'S1',
        ),
      ],
    ),
    const ChurchFamilyRecord(
      familyId: 'AOE-FAM-2026-002',
      familyName: 'The Fernandez Family',
      headOfHousehold: 'Desmond Fernandez',
      phone: '+91 98412 44510',
      locality: 'Perambur, Chennai',
      isApproved: true,
      approvedBy: 'Pastor Larry Joshua Augustus',
      submittedAt: 'Approved Nov 2026',
      members: [
        HouseholdMemberItem(
          fullName: 'Desmond Fernandez',
          roleLabel: 'Head of Household',
          roleSuffix: 'H1',
        ),
        HouseholdMemberItem(
          fullName: 'Lorraine Fernandez',
          roleLabel: 'Spouse',
          roleSuffix: 'S1',
        ),
        HouseholdMemberItem(
          fullName: 'Aaron Fernandez',
          roleLabel: 'Child (Youth Choir)',
          roleSuffix: 'C1',
        ),
      ],
    ),
    const ChurchFamilyRecord(
      familyId: null,
      familyName: "The D'Cruz Family",
      headOfHousehold: "Winfred D'Cruz",
      phone: '+91 94441 78230',
      locality: 'Vepery, Chennai',
      isApproved: false,
      approvedBy: null,
      submittedAt: 'Requested Today · 10:15 AM',
      members: [
        HouseholdMemberItem(
          fullName: "Winfred D'Cruz",
          roleLabel: 'Head of Household',
          roleSuffix: 'H1',
        ),
        HouseholdMemberItem(
          fullName: "Patricia D'Cruz",
          roleLabel: 'Spouse',
          roleSuffix: 'S1',
        ),
        HouseholdMemberItem(
          fullName: "Melissa D'Cruz",
          roleLabel: 'Child',
          roleSuffix: 'C1',
        ),
      ],
    ),
    const ChurchFamilyRecord(
      familyId: null,
      familyName: 'The Rozario Family',
      headOfHousehold: 'Collin Rozario',
      phone: '+91 98840 61904',
      locality: 'St. Thomas Mount, Chennai',
      isApproved: false,
      approvedBy: null,
      submittedAt: 'Requested Yesterday',
      members: [
        HouseholdMemberItem(
          fullName: 'Collin Rozario',
          roleLabel: 'Head of Household',
          roleSuffix: 'H1',
        ),
        HouseholdMemberItem(
          fullName: 'Bernadette Rozario',
          roleLabel: 'Spouse',
          roleSuffix: 'S1',
        ),
      ],
    ),
  ];

  List<ChurchFamilyRecord> get _pendingFamilies =>
      _families.where((f) => !f.isApproved).toList();

  List<ChurchFamilyRecord> get _approvedFamilies =>
      _families.where((f) => f.isApproved).toList();

  void _approveFamily(ChurchFamilyRecord pending) {
    final index = _families.indexOf(pending);
    if (index == -1) return;

    final newId =
        'AOE-FAM-2026-${_nextSequenceNumber.toString().padLeft(3, '0')}';
    setState(() {
      _nextSequenceNumber++;
      _families[index] = pending.approve(
        generatedFamilyId: newId,
        pastorName: _selectedApprovingPastor,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _navy,
        content: Text(
          'Approved by $_selectedApprovingPastor · Issued ID: $newId',
        ),
      ),
    );
  }

  void _openNewMemberSignUpModal() {
    final familyNameCtrl = TextEditingController();
    final headNameCtrl = TextEditingController();
    final spouseNameCtrl = TextEditingController();
    final childNameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final localityCtrl = TextEditingController(text: 'Perambur, Chennai');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _navy.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.group_add, color: _navy, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'New Member & Family Registration',
                        style: TextStyle(
                          fontSize: 17,
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
                const SizedBox(height: 6),
                const Text(
                  'Registrations are reviewed and approved by Pastor Larry Joshua Augustus or Pastor Soma Augustus before a permanent Family Membership ID (AOE-FAM-2026-XXX) is issued.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: familyNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Family / Household Name * (e.g. The D\'Monte Family)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: headNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Head of Household Full Name *',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: spouseNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Spouse Full Name (Optional)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: childNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Child / Dependent Name',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile / WhatsApp *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: localityCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Chennai Locality *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final famName = familyNameCtrl.text.trim();
                    final headName = headNameCtrl.text.trim();
                    if (famName.isEmpty || headName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter both Family Name and Head of Household Name.',
                          ),
                        ),
                      );
                      return;
                    }

                    final members = <HouseholdMemberItem>[
                      HouseholdMemberItem(
                        fullName: headName,
                        roleLabel: 'Head of Household',
                        roleSuffix: 'H1',
                      ),
                    ];
                    if (spouseNameCtrl.text.trim().isNotEmpty) {
                      members.add(
                        HouseholdMemberItem(
                          fullName: spouseNameCtrl.text.trim(),
                          roleLabel: 'Spouse',
                          roleSuffix: 'S1',
                        ),
                      );
                    }
                    if (childNameCtrl.text.trim().isNotEmpty) {
                      members.add(
                        HouseholdMemberItem(
                          fullName: childNameCtrl.text.trim(),
                          roleLabel: 'Child',
                          roleSuffix: 'C1',
                        ),
                      );
                    }

                    setState(() {
                      _families.add(
                        ChurchFamilyRecord(
                          familyId: null,
                          familyName: famName,
                          headOfHousehold: headName,
                          phone: phoneCtrl.text.trim().isEmpty
                              ? '+91 98400 00000'
                              : phoneCtrl.text.trim(),
                          locality: localityCtrl.text.trim().isEmpty
                              ? 'Chennai'
                              : localityCtrl.text.trim(),
                          members: members,
                          isApproved: false,
                          approvedBy: null,
                          submittedAt: 'Just Now · Awaiting Pastoral Approval',
                        ),
                      );
                    });

                    Navigator.of(sheetCtx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: _navy,
                        content: Text(
                          'Registration submitted! Sent to Pastor Larry & Pastor Soma for approval.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.verified_user_outlined),
                  label: const Text(
                    'Submit for Pastoral Approval',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _pendingFamilies.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Membership & Family ID',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: _navy,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: _navy.withValues(alpha: 0.08),
                foregroundColor: _navy,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _openNewMemberSignUpModal,
              icon: const Icon(Icons.person_add_alt_1, size: 16),
              label: const Text(
                'Join / Sign Up',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Switcher: Member View vs Pastor Admin View (Larry & Soma)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPastorAdminView = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isPastorAdminView ? _navy : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 16,
                              color: !_isPastorAdminView
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Member View (ID Card)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: !_isPastorAdminView
                                      ? Colors.white
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPastorAdminView = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isPastorAdminView ? _navy : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.admin_panel_settings_outlined,
                              size: 16,
                              color: _isPastorAdminView
                                  ? const Color(0xFFFEF08A)
                                  : const Color(0xFF475569),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Pastoral Admin ($pendingCount)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: _isPastorAdminView
                                      ? Colors.white
                                      : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (!_isPastorAdminView)
              _buildMemberView()
            else
              _buildPastorAdminView(),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberView() {
    // Show the latest approved family card as the active member's Digital Family ID Card
    final myFamily = _approvedFamilies.length > 1
        ? _approvedFamilies.last
        : _approvedFamilies.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Digital Family Membership ID Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF18284A), Color(0xFF233761)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _gold.withValues(alpha: 0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _navy.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Color(0xFF6EE7B7),
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'PASTORAL APPROVED MEMBER',
                          style: TextStyle(
                            color: Color(0xFF6EE7B7),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'ALPHA OMEGA EKKLESIA',
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFFEF08A),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                myFamily.familyName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${myFamily.locality} · ${myFamily.phone}',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  final id = myFamily.familyId ?? '';
                  Clipboard.setData(ClipboardData(text: id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Copied Family ID: $id'),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _gold.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'UNIQUE FAMILY ID',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFFEF08A),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            myFamily.familyId ?? 'PENDING',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.copy,
                            color: Color(0xFFFEF08A),
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 10),
              const Text(
                'HOUSEHOLD MEMBERS & SUB-IDS',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 8),
              ...myFamily.members.map((m) {
                final subId = '${myFamily.familyId}-${m.roleSuffix}';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: Color(0xFFFEF08A),
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${m.fullName} (${m.roleLabel})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          subId,
                          style: const TextStyle(
                            color: Color(0xFFFEF08A),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              Text(
                'Approved by: ${myFamily.approvedBy ?? "Pastoral Office"}',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Onboarding Workflow Explanation Banner for New Members
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF4DC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _gold.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user, color: Color(0xFF92400E), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How Member Sign-Up & Pastoral Approval Works',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF78350F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1. New families tap "Join / Sign Up" to submit household details.\n'
                      '2. Request enters Pending Queue for Pastor Larry or Pastor Soma Augustus.\n'
                      '3. Upon Pastoral Approval, a permanent Family ID (AOE-FAM-2026-XXX) is generated.',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF92400E),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Approved Church Family Directory
        Row(
          children: [
            const Icon(Icons.menu_book_outlined, color: _navy, size: 18),
            const SizedBox(width: 8),
            Text(
              'Verified Church Families (${_approvedFamilies.length})',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._approvedFamilies.map((f) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _navy,
                    child: Text(
                      f.headOfHousehold.isNotEmpty
                          ? f.headOfHousehold[0].toUpperCase()
                          : 'A',
                      style: const TextStyle(
                        color: Color(0xFFFEF08A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.familyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${f.members.length} Members · ${f.locality}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Verified by ${f.approvedBy}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Text(
                      f.familyId ?? '',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: _navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPastorAdminView() {
    final pendingList = _pendingFamilies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pastor Admin Header & Approver Selector
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _navy.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.security, color: _navy, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pastoral Approval Desk — Alpha Omega Ekklesia',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: _navy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Select which Pastor is reviewing and approving new member families:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Pastor Larry Joshua Augustus'),
                    selected:
                        _selectedApprovingPastor ==
                        'Pastor Larry Joshua Augustus',
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          _selectedApprovingPastor ==
                              'Pastor Larry Joshua Augustus'
                          ? Colors.white
                          : _navy,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedApprovingPastor =
                            'Pastor Larry Joshua Augustus';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Pastor Soma Augustus'),
                    selected:
                        _selectedApprovingPastor == 'Pastor Soma Augustus',
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _selectedApprovingPastor == 'Pastor Soma Augustus'
                          ? Colors.white
                          : _navy,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedApprovingPastor = 'Pastor Soma Augustus';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(Icons.pending_actions, color: Color(0xFFD97706), size: 20),
            const SizedBox(width: 8),
            Text(
              'Pending Family Approvals (${pendingList.length})',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (pendingList.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 40),
                SizedBox(height: 8),
                Text(
                  'All Member Families Approved!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: _navy,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'There are no pending membership requests waiting for Pastor Larry or Pastor Soma.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          )
        else
          ...pendingList.map((pending) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'AWAITING PASTORAL APPROVAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pending.submittedAt,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pending.familyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Head: ${pending.headOfHousehold} · ${pending.locality} · ${pending.phone}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Household Members (${pending.members.length}):',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...pending.members.map(
                          (m) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              '• ${m.fullName} — ${m.roleLabel} (Sub-ID suffix: -${m.roleSuffix})',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _approveFamily(pending),
                      icon: const Icon(Icons.verified, size: 18),
                      label: Text(
                        'Approve & Issue Family ID (AOE-FAM-2026-${_nextSequenceNumber.toString().padLeft(3, '0')})',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
