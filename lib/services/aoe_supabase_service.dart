import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Option 1 Cloud Storage & Sync Service:
/// - Database: Supabase PostgreSQL (`public.aoe_beta_feedback_queue`, `aoe_families`, `aoe_group_messages`, `aoe_celebrations`)
/// - Media Storage Buckets:
///   1. `aoe-beta-voice-notes` (Tester `.m4a` voice recordings)
///   2. `aoe-beta-screenshots` (Tester `.png` annotated screenshots)
/// - Development Issue Tracker: GitHub Issues (`linktopaul/alpha-omega-ekklesia-mobile/issues`)
class AoeSupabaseService {
  AoeSupabaseService._();
  static final AoeSupabaseService instance = AoeSupabaseService._();

  static const String voiceBucket = 'aoe-beta-voice-notes';
  static const String screenshotBucket = 'aoe-beta-screenshots';
  static const String feedbackTable = 'aoe_beta_feedback_queue';
  static const String githubRepo = 'linktopaul/alpha-omega-ekklesia-mobile';

  static const String _prefSupabaseUrl = 'aoe_supabase_url';
  static const String _prefSupabaseAnonKey = 'aoe_supabase_anon_key';
  static const String _prefGithubPat = 'aoe_github_pat';
  static const String _prefCachedFeedbackJson = 'aoe_cached_beta_feedback_v1';

  String _supabaseUrl = const String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://aoe-chennai-church.supabase.co',
  );
  String _supabaseAnonKey = const String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );
  String _githubPat = const String.fromEnvironment(
    'GITHUB_PAT',
    defaultValue: '',
  );

  String get supabaseUrl => _supabaseUrl;
  String get supabaseAnonKey => _supabaseAnonKey;
  String get githubPat => _githubPat;

  bool get isCloudConfigured =>
      _supabaseUrl.isNotEmpty &&
      _supabaseUrl.startsWith('https://') &&
      _supabaseAnonKey.isNotEmpty;

  String get storageVoiceEndpoint =>
      '$_supabaseUrl/storage/v1/object/public/$voiceBucket';

  String get storageScreenshotEndpoint =>
      '$_supabaseUrl/storage/v1/object/public/$screenshotBucket';

  String get postgrestTableEndpoint =>
      '$_supabaseUrl/rest/v1/$feedbackTable';

  Future<void> loadConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString(_prefSupabaseUrl);
      final savedKey = prefs.getString(_prefSupabaseAnonKey);
      final savedPat = prefs.getString(_prefGithubPat);
      if (savedUrl != null && savedUrl.trim().isNotEmpty) {
        _supabaseUrl = savedUrl.trim();
      }
      if (savedKey != null && savedKey.trim().isNotEmpty) {
        _supabaseAnonKey = savedKey.trim();
      }
      if (savedPat != null && savedPat.trim().isNotEmpty) {
        _githubPat = savedPat.trim();
      }
    } catch (_) {
      // Fallback to in-memory defaults during widget tests if SharedPreferences is uninitialized
    }
  }

  Future<void> saveConfiguration({
    required String supabaseUrl,
    required String supabaseAnonKey,
    required String githubPat,
  }) async {
    _supabaseUrl = supabaseUrl.trim().replaceAll(RegExp(r'/$'), '');
    _supabaseAnonKey = supabaseAnonKey.trim();
    _githubPat = githubPat.trim();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefSupabaseUrl, _supabaseUrl);
      await prefs.setString(_prefSupabaseAnonKey, _supabaseAnonKey);
      await prefs.setString(_prefGithubPat, _githubPat);
    } catch (_) {}
  }

  /// Uploads a tester's `.m4a` voice note to Supabase Storage bucket `aoe-beta-voice-notes`.
  Future<String> uploadVoiceNote({
    required String fileName,
    Uint8List? audioBytes,
  }) async {
    final publicUrl = '$storageVoiceEndpoint/$fileName';
    if (!isCloudConfigured || audioBytes == null) {
      return publicUrl;
    }
    try {
      final uri = Uri.parse(
        '$_supabaseUrl/storage/v1/object/$voiceBucket/$fileName',
      );
      await http.post(
        uri,
        headers: {
          'apikey': _supabaseAnonKey,
          'Authorization': 'Bearer $_supabaseAnonKey',
          'Content-Type': 'audio/mp4',
          'x-upsert': 'true',
        },
        body: audioBytes,
      );
    } catch (_) {}
    return publicUrl;
  }

  /// Uploads a tester's `.png` screenshot to Supabase Storage bucket `aoe-beta-screenshots`.
  Future<String> uploadScreenshot({
    required String fileName,
    Uint8List? imageBytes,
  }) async {
    final publicUrl = '$storageScreenshotEndpoint/$fileName';
    if (!isCloudConfigured || imageBytes == null) {
      return publicUrl;
    }
    try {
      final uri = Uri.parse(
        '$_supabaseUrl/storage/v1/object/$screenshotBucket/$fileName',
      );
      await http.post(
        uri,
        headers: {
          'apikey': _supabaseAnonKey,
          'Authorization': 'Bearer $_supabaseAnonKey',
          'Content-Type': 'image/png',
          'x-upsert': 'true',
        },
        body: imageBytes,
      );
    } catch (_) {}
    return publicUrl;
  }

  /// Inserts a new multimodal feedback row into Supabase PostgreSQL `public.aoe_beta_feedback_queue`
  /// and caches it locally in `SharedPreferences`.
  Future<bool> insertFeedbackRow(Map<String, dynamic> rowPayload) async {
    await _appendLocalCachedFeedback(rowPayload);
    if (!isCloudConfigured) {
      return false;
    }
    try {
      final response = await http.post(
        Uri.parse(postgrestTableEndpoint),
        headers: {
          'apikey': _supabaseAnonKey,
          'Authorization': 'Bearer $_supabaseAnonKey',
          'Content-Type': 'application/json',
          'Prefer': 'return=minimal',
        },
        body: jsonEncode(rowPayload),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Updates an existing row's status in `public.aoe_beta_feedback_queue` when the Owner approves or declines it.
  Future<bool> updateFeedbackStatus({
    required String id,
    required String status,
    int? githubIssueNumber,
    String? githubIssueUrl,
  }) async {
    if (!isCloudConfigured) {
      return false;
    }
    try {
      final response = await http.patch(
        Uri.parse('$postgrestTableEndpoint?id=eq.$id'),
        headers: {
          'apikey': _supabaseAnonKey,
          'Authorization': 'Bearer $_supabaseAnonKey',
          'Content-Type': 'application/json',
          'Prefer': 'return=minimal',
        },
        body: jsonEncode({
          'status': status,
          if (githubIssueNumber != null)
            'github_issue_number': githubIssueNumber,
          if (githubIssueUrl != null) 'github_issue_url': githubIssueUrl,
          'reviewed_at': DateTime.now().toUtc().toIso8601String(),
        }),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Creates a real GitHub Issue on `linktopaul/alpha-omega-ekklesia-mobile/issues`
  /// when the Owner clicks "Approve & Create GitHub Issue" and a GitHub PAT is configured.
  Future<(int?, String?)> createGitHubIssueOnApproval({
    required String feedbackId,
    required String title,
    required String submitterName,
    required String submitterRole,
    required String targetFile,
    required String voiceStorageUrl,
    required String voiceDuration,
    required String voiceTranscript,
    required String screenshotStorageUrl,
    required String screenshotVisualAnalysis,
    required List<String> acceptanceCriteria,
    required String categoryLabel,
  }) async {
    if (_githubPat.isEmpty) {
      return (null, null);
    }
    try {
      final criteriaMd =
          acceptanceCriteria.map((c) => '- [ ] $c').join('\n');
      final bodyMd = '''
### AI Multimodal Beta Feedback (`$feedbackId` · Approved by Owner)

- **Reported By**: $submitterName (`$submitterRole`)
- **Target Module**: `$targetFile`
- **Supabase Voice Note (`$voiceDuration`)**: [$voiceStorageUrl]($voiceStorageUrl)
  > $voiceTranscript
- **Supabase Screenshot (`Gemini Vision`)**: [$screenshotStorageUrl]($screenshotStorageUrl)
  > $screenshotVisualAnalysis

#### Acceptance Criteria
$criteriaMd
''';
      final response = await http.post(
        Uri.parse('https://api.github.com/repos/$githubRepo/issues'),
        headers: {
          'Authorization': 'Bearer $_githubPat',
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'body': bodyMd,
          'labels': [categoryLabel],
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['number'] as int?, data['html_url'] as String?);
      }
    } catch (_) {}
    return (null, null);
  }

  Future<void> _appendLocalCachedFeedback(Map<String, dynamic> row) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingRaw = prefs.getString(_prefCachedFeedbackJson);
      final List<dynamic> list = existingRaw != null
          ? (jsonDecode(existingRaw) as List<dynamic>)
          : <dynamic>[];
      list.insert(0, row);
      await prefs.setString(_prefCachedFeedbackJson, jsonEncode(list));
    } catch (_) {}
  }
}
