import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedLinkPreview {
  final String url;
  final String title;
  final String domain;

  const SharedLinkPreview({
    required this.url,
    required this.title,
    required this.domain,
  });
}

class QuickEmojiSticker {
  final String code;
  final String label;
  final IconData icon;
  final Color color;

  const QuickEmojiSticker({
    required this.code,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class GroupChatMessage {
  final String id;
  final String senderName;
  final String senderSubId;
  final String senderRole; // 'SUPER_BOSS', 'GROUP_ADMIN', 'MEMBER'
  final String text;
  final String timestamp;
  final bool isMe;
  final SharedLinkPreview? sharedLink;
  final Map<String, int> reactions;

  const GroupChatMessage({
    required this.id,
    required this.senderName,
    required this.senderSubId,
    required this.senderRole,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.sharedLink,
    this.reactions = const {},
  });

  GroupChatMessage copyWith({
    Map<String, int>? reactions,
  }) {
    return GroupChatMessage(
      id: id,
      senderName: senderName,
      senderSubId: senderSubId,
      senderRole: senderRole,
      text: text,
      timestamp: timestamp,
      isMe: isMe,
      sharedLink: sharedLink,
      reactions: reactions ?? this.reactions,
    );
  }
}

class AoeGroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupAdminName;
  final String groupAdminMemberId;
  final int memberCount;
  final Color accentColor;
  final IconData groupIcon;

  const AoeGroupChatScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupAdminName,
    required this.groupAdminMemberId,
    required this.memberCount,
    required this.accentColor,
    required this.groupIcon,
  });

  @override
  State<AoeGroupChatScreen> createState() => _AoeGroupChatScreenState();
}

class _AoeGroupChatScreenState extends State<AoeGroupChatScreen> {
  static const Color _navy = Color(0xFF18284A);
  static const Color _gold = Color(0xFFBA9A45);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  String _postingAsRole = 'MEMBER'; // 'MEMBER', 'GROUP_ADMIN', 'SUPER_BOSS'

  static const List<QuickEmojiSticker> _quickStickers = [
    QuickEmojiSticker(
      code: 'Amen',
      label: 'Amen',
      icon: Icons.volunteer_activism,
      color: Color(0xFFD97706),
    ),
    QuickEmojiSticker(
      code: 'Love',
      label: 'Love',
      icon: Icons.favorite,
      color: Color(0xFFE11D48),
    ),
    QuickEmojiSticker(
      code: 'Praise',
      label: 'Praise',
      icon: Icons.celebration,
      color: Color(0xFF059669),
    ),
    QuickEmojiSticker(
      code: 'Joy',
      label: 'Joy',
      icon: Icons.sentiment_very_satisfied,
      color: Color(0xFF0284C7),
    ),
    QuickEmojiSticker(
      code: 'Fire',
      label: 'Spirit',
      icon: Icons.local_fire_department,
      color: Color(0xFFEA580C),
    ),
    QuickEmojiSticker(
      code: 'Hymn',
      label: 'Hymn',
      icon: Icons.music_note,
      color: Color(0xFF7C3AED),
    ),
    QuickEmojiSticker(
      code: 'Word',
      label: 'Word',
      icon: Icons.auto_stories,
      color: Color(0xFF18284A),
    ),
    QuickEmojiSticker(
      code: 'Bless',
      label: 'Blessed',
      icon: Icons.auto_awesome,
      color: Color(0xFFB45309),
    ),
  ];

  static QuickEmojiSticker _stickerForCode(String code) {
    for (final s in _quickStickers) {
      if (s.code == code) return s;
    }
    return _quickStickers.first;
  }

  late List<GroupChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      const GroupChatMessage(
        id: 'm1',
        senderName: 'Pastor Larry Joshua Augustus',
        senderSubId: 'AOE-FAM-2026-001-H1',
        senderRole: 'SUPER_BOSS',
        text:
            'Grace and peace to everyone in this fellowship! Let us keep our hearts prepared in prayer for Sunday morning service.',
        timestamp: '09:15 AM',
        isMe: false,
        sharedLink: SharedLinkPreview(
          url: 'https://youtube.com/@AlphaOmegaEkklesiaChennai',
          title: 'Alpha Omega Ekklesia — Sunday Worship Livestream & Word',
          domain: 'youtube.com',
        ),
        reactions: {'Amen': 14, 'Love': 9, 'Praise': 6},
      ),
      GroupChatMessage(
        id: 'm2',
        senderName: widget.groupAdminName,
        senderSubId: widget.groupAdminMemberId,
        senderRole: 'GROUP_ADMIN',
        text:
            'Thank you Pastor Larry! Everyone please review the schedule & worksheet link below before our fellowship gathering this week.',
        timestamp: '09:42 AM',
        isMe: false,
        sharedLink: SharedLinkPreview(
          url:
              'https://aoekklesia.org/groups/${widget.groupId.toLowerCase()}-notes',
          title:
              '${widget.groupName} — Weekly Fellowship Study Guide & Schedule',
          domain: 'aoekklesia.org',
        ),
        reactions: const {'Amen': 8, 'Word': 5},
      ),
      const GroupChatMessage(
        id: 'm3',
        senderName: 'Pastor Soma Augustus',
        senderSubId: 'AOE-FAM-2026-001-S1',
        senderRole: 'SUPER_BOSS',
        text:
            'So blessed to see this fellowship growing in unity! Do share your testimonies and prayer praises here.',
        timestamp: '10:05 AM',
        isMe: false,
        reactions: {'Love': 11, 'Praise': 7, 'Bless': 5},
      ),
      const GroupChatMessage(
        id: 'm4',
        senderName: 'Desmond Fernandez',
        senderSubId: 'AOE-FAM-2026-002-H1',
        senderRole: 'MEMBER',
        text:
            'Amen Pastors! Our family will be there 15 minutes early to help set up the hall.',
        timestamp: '10:18 AM',
        isMe: true,
        reactions: {'Amen': 6, 'Fire': 4},
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleReaction(int msgIndex, String code) {
    final msg = _messages[msgIndex];
    final updated = Map<String, int>.from(msg.reactions);
    updated[code] = (updated[code] ?? 0) + 1;
    setState(() {
      _messages[msgIndex] = msg.copyWith(reactions: updated);
    });
  }

  void _insertEmojiSticker(QuickEmojiSticker sticker) {
    final text = _messageController.text;
    final addition = text.isEmpty ? '[${sticker.label}] ' : ' [${sticker.label}]';
    _messageController.text = '$text$addition';
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  SharedLinkPreview? _extractLinkFromText(String text) {
    final urlRegex = RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false);
    final match = urlRegex.firstMatch(text);
    if (match == null) return null;
    final rawUrl = match.group(0)!;
    final uri = Uri.tryParse(rawUrl);
    final host = uri?.host.isNotEmpty == true ? uri!.host : 'shared-link.org';
    return SharedLinkPreview(
      url: rawUrl,
      title: 'Shared Fellowship Link · $host',
      domain: host,
    );
  }

  void _sendMessage({SharedLinkPreview? explicitLink}) {
    final rawText = _messageController.text.trim();
    if (rawText.isEmpty && explicitLink == null) return;

    final link = explicitLink ?? _extractLinkFromText(rawText);

    String senderName = 'Desmond Fernandez';
    String senderSubId = 'AOE-FAM-2026-002-H1';
    bool isMe = true;

    if (_postingAsRole == 'SUPER_BOSS') {
      senderName = 'Pastor Larry Joshua Augustus';
      senderSubId = 'AOE-FAM-2026-001-H1';
      isMe = false;
    } else if (_postingAsRole == 'GROUP_ADMIN') {
      senderName = widget.groupAdminName;
      senderSubId = widget.groupAdminMemberId;
      isMe = false;
    }

    final newMessage = GroupChatMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      senderName: senderName,
      senderSubId: senderSubId,
      senderRole: _postingAsRole,
      text: rawText.isEmpty && explicitLink != null
          ? 'Shared a link: ${explicitLink.title}'
          : rawText,
      timestamp: 'Just Now',
      isMe: isMe,
      sharedLink: link,
      reactions: const {'Amen': 1},
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
      _showEmojiPicker = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _openShareLinkDialog() {
    final urlCtrl = TextEditingController(
      text: 'https://maps.google.com/?q=Alpha+Omega+Ekklesia+Chennai',
    );
    final titleCtrl = TextEditingController(
      text: 'Alpha Omega Ekklesia — Fellowship Venue Location (Chennai)',
    );

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_link, color: _navy),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Share Link in Group Chat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Link Title / Description',
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: urlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL (https://...)',
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
            FilledButton.icon(
              onPressed: () {
                final url = urlCtrl.text.trim();
                if (url.isEmpty) return;
                final uri = Uri.tryParse(url);
                final domain =
                    uri?.host.isNotEmpty == true ? uri!.host : 'aoekklesia.org';
                final title = titleCtrl.text.trim().isEmpty
                    ? 'Shared Ministry Link'
                    : titleCtrl.text.trim();
                Navigator.of(ctx).pop();
                _sendMessage(
                  explicitLink: SharedLinkPreview(
                    url: url,
                    title: title,
                    domain: domain,
                  ),
                );
              },
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Share Link'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openSharedUrl(SharedLinkPreview link) async {
    final uri = Uri.tryParse(link.url);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: _navy,
            content: Text('Opening link: ${link.url}'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD), // Warm WhatsApp-inspired canvas
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              child: Icon(
                widget.groupIcon,
                color: const Color(0xFFFEF08A),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.groupName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.memberCount} Members · Admin: ${widget.groupAdminName}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Share Link',
            onPressed: _openShareLinkDialog,
            icon: const Icon(Icons.add_link, color: Color(0xFFFEF08A)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Pinned Super Boss / Group Admin Oversight Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF233761),
              border: Border(
                bottom: BorderSide(color: Color(0xFF334155)),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.push_pin,
                  color: Color(0xFFFEF08A),
                  size: 14,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Super Bosses: Pastors Larry & Soma Augustus · Emojis & Links Enabled',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                PopupMenuButton<String>(
                  initialValue: _postingAsRole,
                  onSelected: (val) => setState(() => _postingAsRole = val),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'MEMBER',
                      child: Text('Post as Member (Desmond)'),
                    ),
                    PopupMenuItem(
                      value: 'GROUP_ADMIN',
                      child: Text(
                        'Post as Group Admin (${widget.groupAdminName})',
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'SUPER_BOSS',
                      child: Text('Post as Super Boss (Pastor Larry)'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _gold.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      _postingAsRole == 'SUPER_BOSS'
                          ? 'Posting: Pastor'
                          : _postingAsRole == 'GROUP_ADMIN'
                          ? 'Posting: Admin'
                          : 'Posting: Member',
                      style: const TextStyle(
                        color: Color(0xFFFEF08A),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg, index);
              },
            ),
          ),

          // Quick Emoji & Reaction Bar (WhatsApp style)
          if (_showEmojiPicker)
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _quickStickers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, idx) {
                  final sticker = _quickStickers[idx];
                  return InkWell(
                    onTap: () => _insertEmojiSticker(sticker),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: sticker.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sticker.color.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(sticker.icon, size: 16, color: sticker.color),
                          const SizedBox(width: 5),
                          Text(
                            sticker.label,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: sticker.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // WhatsApp-style Message Composer Bar
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Toggle Emoji Tray',
                  onPressed: () =>
                      setState(() => _showEmojiPicker = !_showEmojiPicker),
                  icon: Icon(
                    _showEmojiPicker
                        ? Icons.keyboard_alt_outlined
                        : Icons.emoji_emotions_outlined,
                    color: _navy,
                  ),
                ),
                IconButton(
                  tooltip: 'Share Link Card',
                  onPressed: _openShareLinkDialog,
                  icon: const Icon(Icons.link, color: _navy),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message, emoji, or paste https:// link...',
                      hintStyle: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 21,
                  backgroundColor: const Color(0xFF059669),
                  child: IconButton(
                    tooltip: 'Send Message',
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(GroupChatMessage msg, int index) {
    final isSuperBoss = msg.senderRole == 'SUPER_BOSS';
    final isGroupAdmin = msg.senderRole == 'GROUP_ADMIN';

    final bubbleColor = msg.isMe
        ? const Color(0xFFDCF8C6) // Classic WhatsApp outgoing soft green
        : isSuperBoss
        ? const Color(0xFFFFFBEB) // Warm gold-tinted pastoral card
        : Colors.white;

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(msg.isMe ? 14 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 14),
          ),
          border: Border.all(
            color: isSuperBoss
                ? _gold.withValues(alpha: 0.6)
                : const Color(0xFFE2E8F0),
            width: isSuperBoss ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender Name + Role Badge
            Row(
              children: [
                Flexible(
                  child: Text(
                    msg.senderName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isSuperBoss
                          ? const Color(0xFF92400E)
                          : isGroupAdmin
                          ? const Color(0xFF0284C7)
                          : _navy,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                if (isSuperBoss)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _navy,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SUPER BOSS · PASTOR',
                      style: TextStyle(
                        color: Color(0xFFFEF08A),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (isGroupAdmin)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'GROUP ADMIN',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Text(
                    msg.senderSubId,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),

            // Shared Link Preview Box
            if (msg.sharedLink != null) ...[
              InkWell(
                onTap: () => _openSharedUrl(msg.sharedLink!),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: const Border(
                      left: BorderSide(color: _navy, width: 3.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.link, size: 14, color: _navy),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              msg.sharedLink!.domain,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: _navy,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new,
                            size: 12,
                            color: Color(0xFF64748B),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        msg.sharedLink!.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        msg.sharedLink!.url,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0284C7),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Message Body Text
            Text(
              msg.text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF0F172A),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 8),

            // Reactions & Timestamp Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 4,
                    children: [
                      ...msg.reactions.entries.map((entry) {
                        final sticker = _stickerForCode(entry.key);
                        return InkWell(
                          onTap: () => _toggleReaction(index, entry.key),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: sticker.color.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  sticker.icon,
                                  size: 12,
                                  color: sticker.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${sticker.label} ${entry.value}',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: sticker.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      InkWell(
                        onTap: () => _toggleReaction(index, 'Praise'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: const Icon(
                            Icons.add_reaction_outlined,
                            size: 13,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  msg.timestamp,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
