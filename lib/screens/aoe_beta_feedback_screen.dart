import 'package:flutter/material.dart';

enum BetaFeedbackStatus {
  pendingReview('PENDING YOUR REVIEW', Color(0xFFB45309), Color(0xFFFEF3C7)),
  approvedGitHub('APPROVED · ON GITHUB', Color(0xFF15803D), Color(0xFFDCFCE7)),
  rejected('DECLINED', Color(0xFFB91C1C), Color(0xFFFEE2E2));

  final String label;
  final Color textColor;
  final Color bgColor;
  const BetaFeedbackStatus(this.label, this.textColor, this.bgColor);
}

class BetaFeedbackItem {
  final String id;
  final String submitterName;
  final String submitterRole;
  final String familyId;
  final String moduleName;
  final String targetFile;
  final String voiceFileName;
  final String voiceDuration;
  final String voiceTranscript;
  final String screenshotFileName;
  final String screenshotVisualAnalysis;
  final String issueTitle;
  final String issueCategory; // 'enhancement', 'bug', 'ui-ux'
  final String priority; // 'P0', 'P1', 'P2'
  final List<String> acceptanceCriteria;
  final String submittedAt;
  final BetaFeedbackStatus status;
  final int? githubIssueNumber;
  final String? githubIssueUrl;

  const BetaFeedbackItem({
    required this.id,
    required this.submitterName,
    required this.submitterRole,
    required this.familyId,
    required this.moduleName,
    required this.targetFile,
    required this.voiceFileName,
    required this.voiceDuration,
    required this.voiceTranscript,
    required this.screenshotFileName,
    required this.screenshotVisualAnalysis,
    required this.issueTitle,
    required this.issueCategory,
    required this.priority,
    required this.acceptanceCriteria,
    required this.submittedAt,
    required this.status,
    this.githubIssueNumber,
    this.githubIssueUrl,
  });

  BetaFeedbackItem copyWith({
    String? issueTitle,
    String? issueCategory,
    String? priority,
    List<String>? acceptanceCriteria,
    BetaFeedbackStatus? status,
    int? githubIssueNumber,
    String? githubIssueUrl,
  }) {
    return BetaFeedbackItem(
      id: id,
      submitterName: submitterName,
      submitterRole: submitterRole,
      familyId: familyId,
      moduleName: moduleName,
      targetFile: targetFile,
      voiceFileName: voiceFileName,
      voiceDuration: voiceDuration,
      voiceTranscript: voiceTranscript,
      screenshotFileName: screenshotFileName,
      screenshotVisualAnalysis: screenshotVisualAnalysis,
      issueTitle: issueTitle ?? this.issueTitle,
      issueCategory: issueCategory ?? this.issueCategory,
      priority: priority ?? this.priority,
      acceptanceCriteria: acceptanceCriteria ?? this.acceptanceCriteria,
      submittedAt: submittedAt,
      status: status ?? this.status,
      githubIssueNumber: githubIssueNumber ?? this.githubIssueNumber,
      githubIssueUrl: githubIssueUrl ?? this.githubIssueUrl,
    );
  }
}

class AoeBetaFeedbackScreen extends StatefulWidget {
  final int initialTabIndex;

  const AoeBetaFeedbackScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<AoeBetaFeedbackScreen> createState() => _AoeBetaFeedbackScreenState();
}

class _AoeBetaFeedbackScreenState extends State<AoeBetaFeedbackScreen> {
  static const Color _navy = Color(0xFF1B2A4A);
  static const Color _gold = Color(0xFFD4AF37);

  late int _activeTab; // 0 = Tester Capture (Voice+Screenshot+LLM), 1 = Owner Review Queue -> GitHub Issues
  BetaFeedbackStatus? _reviewFilter;

  // Tester Capture state
  String _selectedTester = 'Aaron Fernandez (Choir Group Admin · AOE-FAM-2026-002-C1)';
  String _selectedModule = '7 Fellowship Groups & Group Chat';
  bool _isRecordingVoice = false;
  bool _hasRecordedVoice = true;
  String _voiceDurationLabel = '00:22';
  String _voiceFileLabel = 'voice_note_choir_chat_pin.m4a';
  final String _capturedTranscript =
      'In the Choir Group chat, when I share Sunday hymn YouTube links and chord sheets, they scroll away once members reply Amen. Can we allow Group Admins and Pastors to pin an announcement banner at the top of the group chat?';
  bool _hasAttachedScreenshot = true;
  String _screenshotLabel = 'screenshot_09_fellowship_group_chat.png';
  final String _screenshotAnalysis =
      'Gemini Vision detected AoeGroupChatScreen (AOE-GRP-05 Choir Group). Top header bar has 36px vertical slot below group metadata suitable for a sticky pinned announcement banner.';
  final TextEditingController _extraNotesCtrl = TextEditingController(
    text: 'Tested on Android 14 (Samsung Galaxy A54). Pinning should be restricted to Super Bosses and Group Admin.',
  );

  bool _hasSynthesizedWithLlm = true;
  String _synthesizedTitle =
      'feat(group-chat): Allow Super Bosses & Group Admins to pin announcements in Fellowship Group Chat';
  String _synthesizedCategory = 'enhancement';
  String _synthesizedPriority = 'P1';
  List<String> _synthesizedCriteria = const [
    'Allow SUPER_BOSS (Pastors Larry & Soma) and GROUP_ADMIN to pin/unpin a message or link in AoeGroupChatScreen.',
    'Render a gold-accented sticky banner at the top of the group chat showing the pinned text/URL.',
    'Ensure regular members have read-only access to the pinned banner.',
  ];

  String? _playingReviewItemId;
  int _nextGithubIssueNumber = 2;

  late List<BetaFeedbackItem> _reviewQueue;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex;
    _reviewQueue = [
      const BetaFeedbackItem(
        id: 'AOE-BETA-001',
        submitterName: 'Aaron Fernandez',
        submitterRole: 'GROUP ADMIN · Choir Group (AOE-GRP-05)',
        familyId: 'AOE-FAM-2026-002-C1',
        moduleName: '7 Fellowship Groups & Group Chat',
        targetFile: 'lib/screens/aoe_group_chat_screen.dart',
        voiceFileName: 'voice_note_choir_pin_00_22.m4a',
        voiceDuration: '00:22',
        voiceTranscript:
            '"Brother Paul, in the Choir Group chat, when I share the Sunday worship YouTube playlist and chord PDF links, they scroll up when members reply Amen. Can we let Group Admins and Pastors pin 1 announcement at the top of the group chat?"',
        screenshotFileName: 'screenshot_09_choir_chat_scroll.png',
        screenshotVisualAnalysis:
            'Vision LLM: Identified AoeGroupChatScreen (AOE-GRP-05). Top sub-banner can host a collapsible 1-line pinned message bar with link jump support.',
        issueTitle:
            'feat(group-chat): Allow Super Bosses & Group Admins to pin top announcement in Fellowship Group Chat',
        issueCategory: 'enhancement',
        priority: 'P1',
        acceptanceCriteria: [
          'Allow SUPER_BOSS and GROUP_ADMIN roles to pin any chat message or shared link.',
          'Display a sticky gold-bordered pinned announcement bar at the top of AoeGroupChatScreen.',
          'Tapping the pinned bar scrolls to or opens the shared ministry link.',
        ],
        submittedAt: '10 mins ago',
        status: BetaFeedbackStatus.pendingReview,
      ),
      const BetaFeedbackItem(
        id: 'AOE-BETA-002',
        submitterName: 'Pastor Larry Joshua Augustus',
        submitterRole: 'SUPER BOSS · Senior Pastor',
        familyId: 'AOE-FAM-2026-001-H1',
        moduleName: 'Direct UPI Giving (larryjoshuaa@oksbi)',
        targetFile: 'lib/screens/giving_screen.dart',
        voiceFileName: 'voice_note_pastor_larry_upi_00_19.m4a',
        voiceDuration: '00:19',
        voiceTranscript:
            '"Praise the Lord! Tested the UPI giving screen on GPay with larryjoshuaa@oksbi. After a family completes their tithe or building fund offering, let us give them a downloadable Church Offering Receipt with their Family ID AOE-FAM-2026-XXX."',
        screenshotFileName: 'screenshot_02_upi_giving_receipt.png',
        screenshotVisualAnalysis:
            'Vision LLM: Identified GivingScreen below UPI intent button. Adding a "Generate Family Offering Receipt" card after UPI launch improves donor record-keeping.',
        issueTitle:
            'feat(giving): Generate downloadable Family ID Tithe & Offering Receipt after UPI payment',
        issueCategory: 'enhancement',
        priority: 'P1',
        acceptanceCriteria: [
          'Include member Family ID (e.g., AOE-FAM-2026-002) and selected fund (Tithes, Offering, Building Fund) on a digital receipt card.',
          'Provide 1-tap Share / Save Receipt option for the donor family.',
        ],
        submittedAt: '28 mins ago',
        status: BetaFeedbackStatus.pendingReview,
      ),
      const BetaFeedbackItem(
        id: 'AOE-BETA-003',
        submitterName: "Trevor D'Monte",
        submitterRole: 'GROUP ADMIN · Media Team (AOE-GRP-06)',
        familyId: 'AOE-FAM-2026-005-H1',
        moduleName: 'Birthdays, Anniversaries & Baptisms',
        targetFile: 'lib/screens/aoe_celebrations_screen.dart',
        voiceFileName: 'voice_note_trevor_celebrations_00_15.m4a',
        voiceDuration: '00:15',
        voiceTranscript:
            '"On the Birthdays, Anniversaries & Baptisms screen, it would be great if we can export a greeting card image to share on WhatsApp for older relatives."',
        screenshotFileName: 'screenshot_10_celebrations_card.png',
        screenshotVisualAnalysis:
            'Vision LLM: Identified AoeCelebrationsScreen milestone card. Action row has space for a "Share Blessing Card" button.',
        issueTitle:
            'feat(celebrations): Add 1-tap shareable Birthday/Anniversary/Baptism blessing card for WhatsApp',
        issueCategory: 'enhancement',
        priority: 'P2',
        acceptanceCriteria: [
          'Format celebrant name, milestone badge, scripture verse, and pastoral blessing into a shareable summary.',
          'Allow 1-tap sharing from each celebration card.',
        ],
        submittedAt: '1 hour ago',
        status: BetaFeedbackStatus.approvedGitHub,
        githubIssueNumber: 1,
        githubIssueUrl:
            'https://github.com/linktopaul/alpha-omega-ekklesia-mobile/issues/1',
      ),
    ];
  }

  @override
  void dispose() {
    _extraNotesCtrl.dispose();
    super.dispose();
  }

  int get _pendingCount => _reviewQueue
      .where((item) => item.status == BetaFeedbackStatus.pendingReview)
      .length;

  int get _approvedCount => _reviewQueue
      .where((item) => item.status == BetaFeedbackStatus.approvedGitHub)
      .length;

  void _toggleVoiceRecording() {
    setState(() {
      if (_isRecordingVoice) {
        _isRecordingVoice = false;
        _hasRecordedVoice = true;
        _voiceDurationLabel = '00:24';
        _voiceFileLabel = 'voice_note_beta_tester_00_24.m4a';
      } else {
        _isRecordingVoice = true;
      }
    });
  }

  void _runMultimodalLlmSynthesis() {
    final customNote = _extraNotesCtrl.text.trim();
    setState(() {
      _hasSynthesizedWithLlm = true;
      if (_selectedModule.contains('Giving')) {
        _synthesizedTitle =
            'feat(giving): Add Family ID Tithe Receipt & UPI Transaction Reference Note';
        _synthesizedCategory = 'enhancement';
        _synthesizedPriority = 'P1';
        _synthesizedCriteria = [
          'Bind Family Membership ID (AOE-FAM-2026-XXX) to UPI transaction memo.',
          'Provide printable/shareable confirmation card after UPI intent.',
          if (customNote.isNotEmpty) 'Tester Note: $customNote',
        ];
      } else if (_selectedModule.contains('Celebrations')) {
        _synthesizedTitle =
            'feat(celebrations): Add push notification schedule for 08:00 AM IST Birthday & Baptism alerts';
        _synthesizedCategory = 'enhancement';
        _synthesizedPriority = 'P1';
        _synthesizedCriteria = [
          'Trigger morning reminder notification at 08:00 AM IST for church family milestones.',
          'Deep-link notification tap directly to AoeCelebrationsScreen.',
          if (customNote.isNotEmpty) 'Tester Note: $customNote',
        ];
      } else {
        _synthesizedTitle =
            'feat(group-chat): Allow Super Bosses & Group Admins to pin announcements in Fellowship Group Chat';
        _synthesizedCategory = 'enhancement';
        _synthesizedPriority = 'P1';
        _synthesizedCriteria = [
          'Allow SUPER_BOSS (Pastors Larry & Soma) and GROUP_ADMIN to pin/unpin a message or link in AoeGroupChatScreen.',
          'Render a gold-accented sticky banner at the top of the group chat showing the pinned text/URL.',
          if (customNote.isNotEmpty) 'Tester Note: $customNote',
        ];
      }
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          backgroundColor: _navy,
          content: Text(
            'Gemini Multimodal LLM analyzed Voice Note + Screenshot and generated the GitHub Issue Spec!',
          ),
        ),
      );
  }

  void _submitToOwnerReviewQueue() {
    final newId =
        'AOE-BETA-00${_reviewQueue.length + 1}';
    final parts = _selectedTester.split(' (');
    final name = parts.first;
    final role = parts.length > 1 ? parts[1].replaceAll(')', '') : 'Beta Tester';

    final newItem = BetaFeedbackItem(
      id: newId,
      submitterName: name,
      submitterRole: role,
      familyId: 'AOE-FAM-2026-002-C1',
      moduleName: _selectedModule,
      targetFile: _selectedModule.contains('Giving')
          ? 'lib/screens/giving_screen.dart'
          : _selectedModule.contains('Celebrations')
              ? 'lib/screens/aoe_celebrations_screen.dart'
              : 'lib/screens/aoe_group_chat_screen.dart',
      voiceFileName: _voiceFileLabel,
      voiceDuration: _voiceDurationLabel,
      voiceTranscript: '"$_capturedTranscript"',
      screenshotFileName: _screenshotLabel,
      screenshotVisualAnalysis: _screenshotAnalysis,
      issueTitle: _synthesizedTitle,
      issueCategory: _synthesizedCategory,
      priority: _synthesizedPriority,
      acceptanceCriteria: _synthesizedCriteria,
      submittedAt: 'Just now',
      status: BetaFeedbackStatus.pendingReview,
    );

    setState(() {
      _reviewQueue = [newItem, ..._reviewQueue];
      _activeTab = 1; // Switch to Owner Review Queue so user sees it immediately
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF15803D),
          content: Text(
            'Submitted $newId to Owner Review Queue (Awaiting your approval before GitHub Issue creation).',
          ),
        ),
      );
  }

  void _approveAndCreateGitHubIssue(BetaFeedbackItem item) {
    final issueNum = _nextGithubIssueNumber++;
    final issueUrl =
        'https://github.com/linktopaul/alpha-omega-ekklesia-mobile/issues/$issueNum';

    setState(() {
      _reviewQueue = _reviewQueue.map((entry) {
        if (entry.id == item.id) {
          return entry.copyWith(
            status: BetaFeedbackStatus.approvedGitHub,
            githubIssueNumber: issueNum,
            githubIssueUrl: issueUrl,
          );
        }
        return entry;
      }).toList();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF15803D),
          content: Text(
            'Approved ${item.id} -> Created GitHub Issue #$issueNum in linktopaul/alpha-omega-ekklesia-mobile!',
          ),
        ),
      );
  }

  void _rejectFeedbackItem(BetaFeedbackItem item) {
    setState(() {
      _reviewQueue = _reviewQueue.map((entry) {
        if (entry.id == item.id) {
          return entry.copyWith(status: BetaFeedbackStatus.rejected);
        }
        return entry;
      }).toList();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFB91C1C),
          content: Text('Declined feedback item ${item.id}.'),
        ),
      );
  }

  void _openEditSpecDialog(BetaFeedbackItem item) {
    final titleCtrl = TextEditingController(text: item.issueTitle);
    String selectedPriority = item.priority;
    String selectedCategory = item.issueCategory;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(
                'Edit LLM GitHub Issue Spec (${item.id})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'GitHub Issue Title',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Label / Type',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'enhancement',
                                child: Text('enhancement'),
                              ),
                              DropdownMenuItem(
                                value: 'bug',
                                child: Text('bug'),
                              ),
                              DropdownMenuItem(
                                value: 'ui-ux',
                                child: Text('ui-ux'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() => selectedCategory = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedPriority,
                            decoration: const InputDecoration(
                              labelText: 'Priority',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'P0',
                                child: Text('P0 (Blocker)'),
                              ),
                              DropdownMenuItem(
                                value: 'P1',
                                child: Text('P1 (High)'),
                              ),
                              DropdownMenuItem(
                                value: 'P2',
                                child: Text('P2 (Normal)'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() => selectedPriority = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _navy),
                  onPressed: () {
                    final updatedTitle = titleCtrl.text.trim();
                    if (updatedTitle.isEmpty) return;
                    setState(() {
                      _reviewQueue = _reviewQueue.map((entry) {
                        if (entry.id == item.id) {
                          return entry.copyWith(
                            issueTitle: updatedTitle,
                            issueCategory: selectedCategory,
                            priority: selectedPriority,
                          );
                        }
                        return entry;
                      }).toList();
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Save Spec'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Beta Feedback & GitHub Issues',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: _navy,
              ),
            ),
            Text(
              'Voice Note + Screenshot -> Gemini LLM -> Owner Review Gate',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top Mode Switcher: Tester Capture vs Owner Review Queue
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _activeTab = 0),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _activeTab == 0
                            ? _navy
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_none_outlined,
                            size: 16,
                            color: _activeTab == 0
                                ? const Color(0xFFFEF08A)
                                : const Color(0xFF475569),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '1. Tester: Voice & Screenshot',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: _activeTab == 0
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
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _activeTab = 1),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _activeTab == 1
                            ? _navy
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fact_check_outlined,
                            size: 16,
                            color: _activeTab == 1
                                ? const Color(0xFFFEF08A)
                                : const Color(0xFF475569),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '2. Review Queue ($_pendingCount)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: _activeTab == 1
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
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _activeTab == 0
                ? _buildTesterCaptureView()
                : _buildOwnerReviewQueueView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTesterCaptureView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pipeline Explainer Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B2A4A), Color(0xFF283E6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
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
                        color: _gold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _gold.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Text(
                        'MULTIMODAL LLM BETA TRIAGE',
                        style: TextStyle(
                          color: Color(0xFFFEF08A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Gemini 2.5 Flash',
                      style: TextStyle(
                        color: Color(0xFF93C5FD),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Record a Voice Note & Attach a Screenshot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Speak naturally about any bug or idea and attach a screenshot. Our AI assistant converts it into a structured engineering spec and sends it to the Owner Review Queue before creating a GitHub Issue.',
                  style: TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Tester & Screen Context Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tester Identity & Screen Module',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedTester,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Reporting Beta Tester',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value:
                          'Aaron Fernandez (Choir Group Admin · AOE-FAM-2026-002-C1)',
                      child: Text(
                        'Aaron Fernandez (Choir Group Admin · AOE-FAM-2026-002-C1)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          'Pastor Larry Joshua Augustus (Super Boss · Senior Pastor)',
                      child: Text(
                        'Pastor Larry Joshua Augustus (Super Boss · Senior Pastor)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          'Pastor Soma Augustus (Super Boss · Co-Pastor)',
                      child: Text(
                        'Pastor Soma Augustus (Super Boss · Co-Pastor)',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value:
                          "Trevor D'Monte (Media Team Admin · AOE-FAM-2026-005-H1)",
                      child: Text(
                        "Trevor D'Monte (Media Team Admin · AOE-FAM-2026-005-H1)",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedTester = val);
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedModule,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'App Screen / Module',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '7 Fellowship Groups & Group Chat',
                      child: Text(
                        '7 Fellowship Groups & Group Chat',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Direct UPI Giving (larryjoshuaa@oksbi)',
                      child: Text(
                        'Direct UPI Giving (larryjoshuaa@oksbi)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Birthdays, Anniversaries & Baptisms',
                      child: Text(
                        'Birthdays, Anniversaries & Baptisms',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Members & Family ID (AOE-FAM-2026-XXX)',
                      child: Text(
                        'Members & Family ID (AOE-FAM-2026-XXX)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedModule = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Step 1: Voice Note Recorder + Step 2: Screenshot Attachment side-by-side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voice Note Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isRecordingVoice
                          ? const Color(0xFFE11D48)
                          : const Color(0xFFE2E8F0),
                      width: _isRecordingVoice ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isRecordingVoice
                                ? Icons.radio_button_checked
                                : Icons.mic,
                            size: 16,
                            color: const Color(0xFFE11D48),
                          ),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              '1. Voice Note',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _navy,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE4E6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _isRecordingVoice ? 'REC...' : _voiceDurationLabel,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBE123C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.graphic_eq,
                                  size: 16,
                                  color: _navy,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    _voiceFileLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _hasRecordedVoice
                                  ? 'Audio captured · Whisper/Gemini ASR ready'
                                  : 'Tap below to record voice feedback',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _isRecordingVoice
                                ? const Color(0xFFBE123C)
                                : _navy,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: _toggleVoiceRecording,
                          icon: Icon(
                            _isRecordingVoice ? Icons.stop : Icons.mic_none,
                            size: 15,
                          ),
                          label: Text(
                            _isRecordingVoice
                                ? 'Stop Recording'
                                : 'Re-Record Voice',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Screenshot Attachment Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.screenshot_monitor,
                            size: 16,
                            color: Color(0xFF0284C7),
                          ),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              '2. Screenshot',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _navy,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _hasAttachedScreenshot ? 'ATTACHED' : 'NONE',
                              style: const TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0369A1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 16,
                                  color: Color(0xFF0284C7),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    _screenshotLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '1080×2160 PNG · UI Region Highlighted',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF0369A1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _navy,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            visualDensity: VisualDensity.compact,
                          ),
                          onPressed: () {
                            setState(() {
                              _hasAttachedScreenshot = true;
                              _screenshotLabel =
                                  'screenshot_annotated_${DateTime.now().second}.png';
                            });
                          },
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 15,
                          ),
                          label: const Text(
                            'Capture / Attach',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Step 3: Optional Notes + Run Multimodal LLM Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _extraNotesCtrl,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    labelText: '3. Additional Context (Optional)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBF4DC),
                      foregroundColor: const Color(0xFF92400E),
                      side: BorderSide(color: _gold.withValues(alpha: 0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: _runMultimodalLlmSynthesis,
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text(
                      'Synthesize Voice + Screenshot with LLM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Step 4: LLM Synthesized GitHub Issue Draft Preview Card
          if (_hasSynthesizedWithLlm)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _gold.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology_outlined,
                        size: 18,
                        color: Color(0xFF92400E),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'AI-Synthesized GitHub Issue Draft',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _navy,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$_synthesizedCategory · $_synthesizedPriority',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFEF08A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _synthesizedTitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VOICE TRANSCRIPT (GEMINI AUDIO):',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '"$_capturedTranscript"',
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'SCREENSHOT INSPECTION (GEMINI VISION):',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _screenshotAnalysis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Proposed Acceptance Criteria:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ..._synthesizedCriteria.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _navy,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              c,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      onPressed: _submitToOwnerReviewQueue,
                      icon: const Icon(Icons.send_outlined, size: 16),
                      label: const Text(
                        'Submit to Owner Review Queue',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOwnerReviewQueueView() {
    final visibleItems = _reviewFilter == null
        ? _reviewQueue
        : _reviewQueue.where((i) => i.status == _reviewFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner Approval Gate Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B2A4A), Color(0xFF283E6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _gold.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _gold.withValues(alpha: 0.5)),
                        ),
                        child: const Text(
                          'OWNER APPROVAL GATE · GITHUB',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFFEF08A),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_pendingCount Pending · $_approvedCount Live',
                      style: const TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Review Voice + Screenshot Feedback Before GitHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Repo: github.com/linktopaul/alpha-omega-ekklesia-mobile/issues — Listen to the tester voice note, inspect the screenshot, and click "Approve & Create GitHub Issue" to push to development.',
                  style: TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('All (${_reviewQueue.length})'),
                  selected: _reviewFilter == null,
                  selectedColor: _navy,
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: _reviewFilter == null ? Colors.white : _navy,
                  ),
                  onSelected: (_) => setState(() => _reviewFilter = null),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Pending Review ($_pendingCount)'),
                  selected: _reviewFilter == BetaFeedbackStatus.pendingReview,
                  selectedColor: _navy,
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: _reviewFilter == BetaFeedbackStatus.pendingReview
                        ? Colors.white
                        : _navy,
                  ),
                  onSelected: (_) => setState(
                    () => _reviewFilter = BetaFeedbackStatus.pendingReview,
                  ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Approved on GitHub ($_approvedCount)'),
                  selected: _reviewFilter == BetaFeedbackStatus.approvedGitHub,
                  selectedColor: _navy,
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: _reviewFilter == BetaFeedbackStatus.approvedGitHub
                        ? Colors.white
                        : _navy,
                  ),
                  onSelected: (_) => setState(
                    () => _reviewFilter = BetaFeedbackStatus.approvedGitHub,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Feedback Review Cards
          ...visibleItems.map(_buildReviewCard),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BetaFeedbackItem item) {
    final isPlaying = _playingReviewItemId == item.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.status == BetaFeedbackStatus.pendingReview
              ? _gold.withValues(alpha: 0.55)
              : const Color(0xFFE2E8F0),
          width: item.status == BetaFeedbackStatus.pendingReview ? 1.3 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Status Row
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item.status.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status == BetaFeedbackStatus.approvedGitHub &&
                          item.githubIssueNumber != null
                      ? 'APPROVED · GITHUB ISSUE #${item.githubIssueNumber}'
                      : item.status.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: item.status.textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${item.id} · ${item.priority} · ${item.issueCategory}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
              ),
              Text(
                item.submittedAt,
                style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // LLM Issue Title
          Text(
            item.issueTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tester: ${item.submitterName} (${item.submitterRole}) · Target: ${item.targetFile}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),

          // Multimodal Evidence Row: Voice Note Player + Screenshot Chip
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _playingReviewItemId = isPlaying ? null : item.id;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 18,
                          color: const Color(0xFFE11D48),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voice Note (${item.voiceDuration})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9F1239),
                                ),
                              ),
                              Text(
                                item.voiceFileName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  color: Color(0xFFBE123C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        size: 18,
                        color: Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Screenshot Attached',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF075985),
                              ),
                            ),
                            Text(
                              item.screenshotFileName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF0369A1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Transcript + Vision LLM Summary Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Transcript: ${item.voiceTranscript}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.screenshotVisualAnalysis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'LLM Acceptance Criteria:',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
                ...item.acceptanceCriteria.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '• $c',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Action Row for Pending vs Approved
          if (item.status == BetaFeedbackStatus.pendingReview)
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF15803D),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    onPressed: () => _approveAndCreateGitHubIssue(item),
                    icon: const Icon(Icons.check_circle_outline, size: 15),
                    label: const Text(
                      'Approve & Create GitHub Issue',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                  ),
                  onPressed: () => _openEditSpecDialog(item),
                  child: const Text(
                    'Edit Spec',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Reject Feedback',
                  onPressed: () => _rejectFeedbackItem(item),
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFFB91C1C),
                  ),
                ),
              ],
            )
          else if (item.status == BetaFeedbackStatus.approvedGitHub)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.task_alt,
                    size: 16,
                    color: Color(0xFF15803D),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Published to GitHub Issues: ${item.githubIssueUrl ?? ""}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
