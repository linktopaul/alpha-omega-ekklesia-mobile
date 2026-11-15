import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/church_config.dart';

/// Dedicated UPI giving screen for Alpha Omega Ekklesia.
class AoeGivingScreen extends StatefulWidget {
  const AoeGivingScreen({super.key});

  @override
  State<AoeGivingScreen> createState() => _AoeGivingScreenState();
}

class _AoeGivingScreenState extends State<AoeGivingScreen> {
  final _amountController = TextEditingController(text: '1000');
  final _noteController = TextEditingController();
  late String _selectedFund;

  final upiConfig = AlphaOmegaEkklesiaConfig.profile.upi;

  @override
  void initState() {
    super.initState();
    _selectedFund = upiConfig.availableFunds.first;
  }

  @override
  void dispose() {
    _amountController.disposeWidget();
    super.dispose();
  }

  Future<void> _launchUpiPayment() async {
    final amount = _amountController.text.trim();
    if (amount.isEmpty || (double.tryParse(amount) ?? 0) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid donation amount')),
      );
      return;
    }

    final note = _noteController.text.trim().isNotEmpty
        ? _noteController.text.trim()
        : _selectedFund;

    // Standard NPCI UPI URI scheme
    final uri = Uri.parse(
      'upi://pay?pa=${upiConfig.vpa}'
      '&pn=${Uri.encodeComponent(upiConfig.merchantName)}'
      '&am=$amount'
      '&cu=INR'
      '&tn=${Uri.encodeComponent(note)}',
    );

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showUpiFallbackDialog();
      }
    } catch (_) {
      if (mounted) {
        _showUpiFallbackDialog();
      }
    }
  }

  void _showUpiFallbackDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('UPI Payment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'No direct UPI application was detected. You can copy the church UPI ID below and pay via Google Pay, PhonePe, Paytm, or BHIM:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      upiConfig.vpa,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF18284A),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    tooltip: 'Copy UPI ID',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: upiConfig.vpa));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('UPI ID copied to clipboard!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF18284A);
    const gold = Color(0xFFBA9A45);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tithes & Digital Giving',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Giving Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF18284A), Color(0xFF233761)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: navy.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: gold.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volunteer_activism, color: gold, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alpha Omega Ekklesia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Ministry Giving & Stewardship',
                              style: TextStyle(
                                color: Color(0xFFFEF08A),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '"Each of you should give what you have decided in your heart to give, not reluctantly or under compulsion, for God loves a cheerful giver." — 2 Corinthians 9:7',
                    style: TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Official UPI ID: ',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Expanded(
                          child: Text(
                            upiConfig.vpa,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFFEF08A),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.white, size: 16),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: upiConfig.vpa));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('UPI ID copied!')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fund Designation Selector
            const Text(
              'Select Offering Purpose',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: upiConfig.availableFunds.map((fund) {
                final isSelected = _selectedFund == fund;
                return ChoiceChip(
                  label: Text(fund),
                  selected: isSelected,
                  selectedColor: const Color(0xFF233761),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? const Color(0xFFFEF08A) : const Color(0xFF0F172A),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedFund = fund);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Donation Amount Input & Presets
            const Text(
              'Enter Amount (INR ₹)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.currency_rupee, color: navy),
                hintText: 'Enter custom amount',
                suffixText: 'INR',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Preset Buttons
            Row(
              children: upiConfig.quickPresets.map((amount) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _amountController.text = amount.toString();
                        });
                      },
                      child: Text('₹$amount', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Action Pay Button
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _launchUpiPayment,
              icon: const Icon(Icons.account_balance_wallet, color: gold),
              label: const Text(
                'Proceed with UPI Payment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Supports GPay, PhonePe, Paytm, BHIM & Bank UPI Apps',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
extension on TextEditingController {
  void disposeWidget() => dispose();
}
