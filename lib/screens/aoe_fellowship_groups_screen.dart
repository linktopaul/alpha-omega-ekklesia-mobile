import 'package:flutter/material.dart';
import 'aoe_group_chat_screen.dart';

class GroupJoinRequest {
  final String memberName;
  final String memberFamilyId;
  final String requestedAt;

  const GroupJoinRequest({
    required this.memberName,
    required this.memberFamilyId,
    required this.requestedAt,
  });
}

class FellowshipGroupRecord {
  final String groupId;
  final String name;
  final String schedule;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String groupAdminName;
  final String groupAdminMemberId;
  final int activeMemberCount;
  final String currentUserStatus; // 'JOINED', 'PENDING', 'NOT_JOINED'
  final String? approvedByNote;
  final List<GroupJoinRequest> pendingRequests;

  const FellowshipGroupRecord({
    required this.groupId,
    required this.name,
    required this.schedule,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.groupAdminName,
    required this.groupAdminMemberId,
    required this.activeMemberCount,
    required this.currentUserStatus,
    this.approvedByNote,
    this.pendingRequests = const [],
  });

  FellowshipGroupRecord copyWith({
    String? groupAdminName,
    String? groupAdminMemberId,
    int? activeMemberCount,
    String? currentUserStatus,
    String? approvedByNote,
    List<GroupJoinRequest>? pendingRequests,
  }) {
    return FellowshipGroupRecord(
      groupId: groupId,
      name: name,
      schedule: schedule,
      description: description,
      icon: icon,
      accentColor: accentColor,
      groupAdminName: groupAdminName ?? this.groupAdminName,
      groupAdminMemberId: groupAdminMemberId ?? this.groupAdminMemberId,
      activeMemberCount: activeMemberCount ?? this.activeMemberCount,
      currentUserStatus: currentUserStatus ?? this.currentUserStatus,
      approvedByNote: approvedByNote ?? this.approvedByNote,
      pendingRequests: pendingRequests ?? this.pendingRequests,
    );
  }
}

class AoeFellowshipGroupsScreen extends StatefulWidget {
  const AoeFellowshipGroupsScreen({super.key});

  @override
  State<AoeFellowshipGroupsScreen> createState() =>
      _AoeFellowshipGroupsScreenState();
}

class _AoeFellowshipGroupsScreenState extends State<AoeFellowshipGroupsScreen> {
  static const Color _navy = Color(0xFF18284A);
  static const Color _gold = Color(0xFFBA9A45);

  bool _isApprovalDeskView = false;
  String _selectedAuthority =
      'Super Boss: Pastor Larry Joshua Augustus';

  late List<FellowshipGroupRecord> _groups;

  @override
  void initState() {
    super.initState();
    _groups = [
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-01',
        name: '1. Sunday School',
        schedule: 'Sundays · 09:45 AM IST',
        description:
            'Biblical foundation, scripture memory, and Anglo-Indian Sunday School classes for children & teens.',
        icon: Icons.auto_stories_outlined,
        accentColor: Color(0xFF0284C7),
        groupAdminName: 'Lorraine Fernandez',
        groupAdminMemberId: 'AOE-FAM-2026-002-S1',
        activeMemberCount: 24,
        currentUserStatus: 'JOINED',
        approvedByNote: 'Approved by Super Boss: Pastor Soma Augustus',
        pendingRequests: [
          GroupJoinRequest(
            memberName: "Melissa D'Cruz",
            memberFamilyId: 'AOE-FAM-2026-003-C1',
            requestedAt: 'Today · 11:20 AM',
          ),
        ],
      ),
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-02',
        name: "2. Men's Fellowship",
        schedule: '1st & 3rd Saturdays · 06:30 PM IST',
        description:
            'Brotherhood in Christ, men\'s prayer breakfast, outreach, and church stewardship.',
        icon: Icons.groups_outlined,
        accentColor: Color(0xFF1E40AF),
        groupAdminName: 'Desmond Fernandez',
        groupAdminMemberId: 'AOE-FAM-2026-002-H1',
        activeMemberCount: 19,
        currentUserStatus: 'JOINED',
        approvedByNote: 'Approved by Super Boss: Pastor Larry Joshua Augustus',
        pendingRequests: [
          GroupJoinRequest(
            memberName: "Winfred D'Cruz",
            memberFamilyId: 'AOE-FAM-2026-003-H1',
            requestedAt: 'Today · 10:45 AM',
          ),
        ],
      ),
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-03',
        name: "3. Women's Fellowship",
        schedule: '2nd & 4th Saturdays · 04:30 PM IST',
        description:
            'Intercessory prayer circle, hospitality ministry, and community care led by women of the church.',
        icon: Icons.volunteer_activism_outlined,
        accentColor: Color(0xFFBE185D),
        groupAdminName: "Patricia D'Cruz",
        groupAdminMemberId: 'AOE-FAM-2026-003-S1',
        activeMemberCount: 26,
        currentUserStatus: 'NOT_JOINED',
        pendingRequests: [
          GroupJoinRequest(
            memberName: 'Bernadette Rozario',
            memberFamilyId: 'AOE-FAM-2026-004-S1',
            requestedAt: 'Yesterday',
          ),
        ],
      ),
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-04',
        name: "4. Couple's Fellowship",
        schedule: 'Last Friday Monthly · 07:00 PM IST',
        description:
            'Christ-centered marriage enrichment, family altar devotionals, and fellowship dinners.',
        icon: Icons.favorite_border,
        accentColor: Color(0xFFB45309),
        groupAdminName: 'Collin Rozario',
        groupAdminMemberId: 'AOE-FAM-2026-004-H1',
        activeMemberCount: 16,
        currentUserStatus: 'PENDING',
        approvedByNote: 'Awaiting Group Admin or Pastor Approval',
        pendingRequests: [],
      ),
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-05',
        name: '5. Choir Group',
        schedule: 'Saturdays · 05:00 PM IST',
        description:
            'Four-part Anglo-Indian traditional hymns, Sunday worship leading, and special seasonal cantatas.',
        icon: Icons.music_note_outlined,
        accentColor: Color(0xFF059669),
        groupAdminName: 'Aaron Fernandez',
        groupAdminMemberId: 'AOE-FAM-2026-002-C1',
        activeMemberCount: 14,
        currentUserStatus: 'NOT_JOINED',
        pendingRequests: [
          GroupJoinRequest(
            memberName: 'Collin Rozario',
            memberFamilyId: 'AOE-FAM-2026-004-H1',
            requestedAt: 'Yesterday',
          ),
        ],
      ),
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-06',
        name: '6. Media Team',
        schedule: 'Sundays · 08:45 AM IST',
        description:
            'Sanctuary sound engineering, lyric projection, photography, and YouTube/Facebook livestreaming.',
        icon: Icons.videocam_outlined,
        accentColor: Color(0xFF7C3AED),
        groupAdminName: "Trevor D'Monte",
        groupAdminMemberId: 'AOE-FAM-2026-005-H1',
        activeMemberCount: 8,
        currentUserStatus: 'NOT_JOINED',
        pendingRequests: [],
      ),
      const FellowshipGroupRecord(
        groupId: 'AOE-GRP-07',
        name: '7. Youth Fellowship',
        schedule: 'Saturdays · 05:00 PM IST',
        description:
            'Next-generation discipleship, Bible quiz, acoustic worship, and youth mission outreach.',
        icon: Icons.local_fire_department_outlined,
        accentColor: Color(0xFFEA580C),
        groupAdminName: "Melissa D'Cruz",
        groupAdminMemberId: 'AOE-FAM-2026-003-C1',
        activeMemberCount: 21,
        currentUserStatus: 'NOT_JOINED',
        pendingRequests: [],
      ),
    ];
  }

  int get _totalPendingRequests =>
      _groups.fold(0, (sum, g) => sum + g.pendingRequests.length);

  void _openGroupChat(FellowshipGroupRecord group) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AoeGroupChatScreen(
          groupId: group.groupId,
          groupName: group.name,
          groupAdminName: group.groupAdminName,
          groupAdminMemberId: group.groupAdminMemberId,
          memberCount: group.activeMemberCount,
          accentColor: group.accentColor,
          groupIcon: group.icon,
        ),
      ),
    );
  }

  void _requestToJoinGroup(int index) {
    final group = _groups[index];
    final updatedRequests = List<GroupJoinRequest>.from(group.pendingRequests)
      ..add(
        const GroupJoinRequest(
          memberName: 'Desmond Fernandez',
          memberFamilyId: 'AOE-FAM-2026-002-H1',
          requestedAt: 'Just Now',
        ),
      );

    setState(() {
      _groups[index] = group.copyWith(
        currentUserStatus: 'PENDING',
        approvedByNote: 'Awaiting Group Admin or Pastor (Super Boss) Approval',
        pendingRequests: updatedRequests,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _navy,
        content: Text(
          'Join request sent for ${group.name}! Awaiting Group Admin (${group.groupAdminName}) or Pastor Approval.',
        ),
      ),
    );
  }

  void _approveJoinRequest(int groupIndex, GroupJoinRequest req) {
    final group = _groups[groupIndex];
    final updatedRequests = List<GroupJoinRequest>.from(group.pendingRequests)
      ..remove(req);

    final isCurrentUser = req.memberFamilyId == 'AOE-FAM-2026-002-H1';

    setState(() {
      _groups[groupIndex] = group.copyWith(
        activeMemberCount: group.activeMemberCount + 1,
        currentUserStatus: isCurrentUser ? 'JOINED' : group.currentUserStatus,
        approvedByNote: isCurrentUser
            ? 'Approved by $_selectedAuthority'
            : group.approvedByNote,
        pendingRequests: updatedRequests,
      );
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF059669),
          content: Text(
            'Approved ${req.memberName} (${req.memberFamilyId}) into ${group.name} by $_selectedAuthority',
          ),
        ),
      );
  }

  void _showChangeGroupAdminDialog(int groupIndex) {
    final group = _groups[groupIndex];
    final nameCtrl = TextEditingController(text: group.groupAdminName);
    final idCtrl = TextEditingController(text: group.groupAdminMemberId);

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Assign Group Admin — ${group.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _navy,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'As Super Boss (Pastor Larry / Pastor Soma Augustus), you can appoint or change the Group Admin for this fellowship:',
                style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'New Group Admin Name',
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(
                  labelText: 'Member Sub-ID (e.g. AOE-FAM-2026-002-H1)',
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _groups[groupIndex] = group.copyWith(
                    groupAdminName: nameCtrl.text.trim(),
                    groupAdminMemberId: idCtrl.text.trim().isEmpty
                        ? group.groupAdminMemberId
                        : idCtrl.text.trim(),
                  );
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: _navy,
                    content: Text(
                      'Updated Group Admin for ${group.name} to ${nameCtrl.text.trim()}',
                    ),
                  ),
                );
              },
              child: const Text('Save Admin'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTotal = _totalPendingRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fellowship Groups (7)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: _navy,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Switcher: All 7 Groups vs Admin / Super Boss Approval Desk
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
                      onTap: () => setState(() => _isApprovalDeskView = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isApprovalDeskView
                              ? _navy
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.diversity_3_outlined,
                              size: 16,
                              color: !_isApprovalDeskView
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'All 7 Groups',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: !_isApprovalDeskView
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
                      onTap: () => setState(() => _isApprovalDeskView = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isApprovalDeskView
                              ? _navy
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 16,
                              color: _isApprovalDeskView
                                  ? const Color(0xFFFEF08A)
                                  : const Color(0xFF475569),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Group Approvals ($pendingTotal)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _isApprovalDeskView
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

            if (!_isApprovalDeskView)
              _buildGroupsDirectoryView()
            else
              _buildApprovalDeskView(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsDirectoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Super Boss & Group Admin Hierarchy Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF18284A), Color(0xFF233761)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _gold.withValues(alpha: 0.5)),
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
                      border: Border.all(
                        color: _gold.withValues(alpha: 0.6),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          color: Color(0xFFFEF08A),
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'SUPER BOSS OVERSIGHT',
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
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      '7 OFFICIAL MINISTRIES',
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Pastors Larry & Soma Augustus (Super Bosses)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Each Fellowship Group has a dedicated Group Admin under the direct oversight of Pastors Larry & Soma Augustus. Members can join a group only after Group Admin or Pastoral Approval.',
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
        ...List.generate(_groups.length, (index) {
        final group = _groups[index];
        final isJoined = group.currentUserStatus == 'JOINED';
        final isPending = group.currentUserStatus == 'PENDING';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isJoined
                  ? const Color(0xFF10B981).withValues(alpha: 0.45)
                  : const Color(0xFFE2E8F0),
              width: isJoined ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: group.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      group.icon,
                      color: group.accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                group.name,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: _navy,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${group.activeMemberCount} Members',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          group.schedule,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                group.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF334155),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              // Leadership Box: Group Admin + Super Boss
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.manage_accounts_outlined,
                          size: 15,
                          color: _navy,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Group Admin: ${group.groupAdminName} (${group.groupAdminMemberId})',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: _navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 14,
                          color: Color(0xFF92400E),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Super Bosses: Pastor Larry & Pastor Soma Augustus',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (isJoined) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF166534),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'MEMBER · ${group.approvedByNote ?? "Approved"}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: _navy,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _openGroupChat(group),
                    icon: const Icon(Icons.chat_bubble_outline, size: 17),
                    label: const Text(
                      'Open Group Chat (Emojis & Links)',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ] else if (isPending)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.hourglass_top,
                        color: Color(0xFF92400E),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'PENDING · Awaiting Group Admin or Pastor Approval',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _navy,
                      side: const BorderSide(color: _navy),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _requestToJoinGroup(index),
                    icon: const Icon(Icons.group_add_outlined, size: 17),
                    label: const Text(
                      'Request to Join (Requires Admin / Pastor Approval)',
                      style: TextStyle(
                        fontSize: 12,
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

  Widget _buildApprovalDeskView() {
    final groupsWithPending = _groups
        .asMap()
        .entries
        .where((e) => e.value.pendingRequests.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Approving Authority Selector: Super Bosses (Pastors) or Group Admin
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
                  Icon(Icons.admin_panel_settings, color: _navy, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fellowship Group Approval Authority',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: _navy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Pastors Larry & Soma are Super Bosses across all 7 groups. Select active approver:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text(
                      'Super Boss: Pastor Larry Joshua Augustus',
                    ),
                    selected:
                        _selectedAuthority ==
                        'Super Boss: Pastor Larry Joshua Augustus',
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color:
                          _selectedAuthority ==
                              'Super Boss: Pastor Larry Joshua Augustus'
                          ? Colors.white
                          : _navy,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedAuthority =
                            'Super Boss: Pastor Larry Joshua Augustus';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Super Boss: Pastor Soma Augustus'),
                    selected:
                        _selectedAuthority ==
                        'Super Boss: Pastor Soma Augustus',
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color:
                          _selectedAuthority ==
                              'Super Boss: Pastor Soma Augustus'
                          ? Colors.white
                          : _navy,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedAuthority =
                            'Super Boss: Pastor Soma Augustus';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Assigned Group Admin'),
                    selected: _selectedAuthority == 'Assigned Group Admin',
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: _selectedAuthority == 'Assigned Group Admin'
                          ? Colors.white
                          : _navy,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedAuthority = 'Assigned Group Admin';
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
            const Icon(
              Icons.pending_actions,
              color: Color(0xFFD97706),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Pending Group Join Requests ($_totalPendingRequests)',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (groupsWithPending.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF10B981),
                  size: 36,
                ),
                SizedBox(height: 6),
                Text(
                  'All Group Join Requests Approved!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _navy,
                  ),
                ),
              ],
            ),
          )
        else
          ...groupsWithPending.expand((entry) {
            final groupIdx = entry.key;
            final group = entry.value;
            return group.pendingRequests.map((req) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFDE68A),
                    width: 1.5,
                  ),
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
                            color: group.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            group.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: group.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            req.requestedAt,
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
                      req.memberName,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Member ID: ${req.memberFamilyId} · Group Admin: ${group.groupAdminName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _approveJoinRequest(groupIdx, req),
                        icon: const Icon(Icons.verified, size: 17),
                        label: Text(
                          'Approve into ${group.name}',
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
            });
          }),

        const SizedBox(height: 16),
        // Super Boss Exclusive: Manage All 7 Group Admins
        const Row(
          children: [
            Icon(Icons.supervisor_account, color: _navy, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Super Boss Roster: Group Admins (7 Groups)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(_groups.length, (idx) {
          final g = _groups[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: ListTile(
              dense: true,
              leading: Icon(g.icon, color: g.accentColor, size: 20),
              title: Text(
                g.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: _navy,
                ),
              ),
              subtitle: Text(
                'Admin: ${g.groupAdminName} (${g.groupAdminMemberId})',
                style: const TextStyle(fontSize: 11.5),
              ),
              trailing: TextButton(
                onPressed: () => _showChangeGroupAdminDialog(idx),
                child: const Text(
                  'Change Admin',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
