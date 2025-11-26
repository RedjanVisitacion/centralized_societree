import 'package:flutter/material.dart';

class VotingReceiptScreen extends StatelessWidget {
  final String receiptId;
  final Map<String, String> selections;

  const VotingReceiptScreen({super.key, required this.receiptId, required this.selections});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = selections.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting Receipt'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receipt ID', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  SelectableText(
                    receiptId,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Your selections', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: entries.isEmpty
                  ? Center(child: Text('No selections recorded', style: theme.textTheme.bodyMedium))
                  : ListView.separated(
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final e = entries[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(e.key),
                          subtitle: Text('Candidate ID: ${e.value}'),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for voting!')));
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
