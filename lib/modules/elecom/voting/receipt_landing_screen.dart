import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:centralized_societree/services/user_session.dart';
import 'package:centralized_societree/modules/elecom/voting/voting_receipt_screen.dart';
import 'package:centralized_societree/modules/elecom/services/elecom_voting_service.dart';
import 'package:centralized_societree/modules/elecom/voting/voting_screen.dart';
import 'package:centralized_societree/modules/elecom/widgets/voting_action_button.dart';
import 'package:centralized_societree/modules/elecom/student_dashboard/widgets/student_bottom_nav_bar.dart';

class ReceiptLandingScreen extends StatefulWidget {
  const ReceiptLandingScreen({super.key});

  @override
  State<ReceiptLandingScreen> createState() => _ReceiptLandingScreenState();
}

class _ReceiptLandingScreenState extends State<ReceiptLandingScreen> {
  bool _truthy(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.toLowerCase();
      return s == '1' || s == 'true' || s == 'open' || s == 'yes' || s == 'allowed';
    }
    return false;
  }

  Future<void> _showNotStartedDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (ctx, a1, a2) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Material(
                  color: Colors.transparent,
                  child: AlertDialog(
                    title: Row(
                      children: [
                        const Expanded(child: Text('Voting not started')),
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    content: const Text('The voting has not started yet. Please check back later.'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _within(String? start, String? end) {
    if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) return true;
    DateTime? s, e;
    try { if (start != null && start.isNotEmpty) s = DateTime.parse(start); } catch (_) {}
    try { if (end != null && end.isNotEmpty) e = DateTime.parse(end); } catch (_) {}
    final now = DateTime.now();
    if (s != null && now.isBefore(s)) return false;
    if (e != null && now.isAfter(e)) return false;
    return true;
  }

  Future<bool> _checkVotingOpen(String sid) async {
    try {
      final list = await ElecomVotingService.getVotingStatus(sid);
      if (list.isEmpty) return false;
      for (final m in list) {
        final open = _truthy(m['open'] ?? m['is_open'] ?? m['voting_open'] ?? m['window_open'] ?? m['allowed'] ?? m['status']);
        final start = (m['start'] ?? m['window_start'] ?? m['opens_at'] ?? '').toString();
        final end = (m['end'] ?? m['window_end'] ?? m['closes_at'] ?? '').toString();
        if (open && _within(start, end)) return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _showEndedDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (ctx, a1, a2) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Material(
                  color: Colors.transparent,
                  child: AlertDialog(
                    title: Row(
                      children: [
                        const Expanded(child: Text('Voting has ended')),
                        IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    content: const Text('The voting window is closed. You can no longer submit a vote.'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sid = UserSession.studentId ?? '';
      final id = (UserSession.lastReceiptStudentId == sid) ? UserSession.lastReceiptId : null;
      final selections = (UserSession.lastReceiptStudentId == sid) ? UserSession.lastReceiptSelections : null;
      bool already = false;
      if (sid.isNotEmpty) {
        try { already = await ElecomVotingService.checkAlreadyVotedDirect(sid); } catch (_) {}
      }
      if (!mounted) return;
      if (already && sid.isNotEmpty && id != null && id.isNotEmpty && selections != null && selections.isNotEmpty) {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => VotingReceiptScreen(
              receiptId: id,
              selections: selections,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 12),
              Text(
                'No receipt available',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We could not find a local voting receipt for your account. Submit your vote to generate one.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: TextButton.styleFrom(
                      foregroundColor: (theme.brightness == Brightness.dark) ? Colors.white : Colors.black,
                    ),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 12),
                  VotingActionButton(
                    onPressed: () async {
                      if (StudentBottomNavBar.windowNotStarted) {
                        await _showNotStartedDialog();
                        return;
                      }
                      if (StudentBottomNavBar.windowEnded) {
                        await _showEndedDialog();
                        return;
                      }
                      // Window considered open locally; navigate without delay
                      if (!mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VotingScreen()),
                      );
                    },
                    icon: const Icon(Icons.how_to_vote_outlined),
                    label: 'Vote Now',
                    compact: true,
                    fullWidth: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
