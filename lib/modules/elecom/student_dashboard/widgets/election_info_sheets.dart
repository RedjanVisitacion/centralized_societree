import 'package:flutter/material.dart';

void openManifestoHighlights(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voting Guidelines',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: const [
                    ListTile(
                      leading: Icon(Icons.verified_user_outlined),
                      title: Text('Bring your valid student ID'),
                    ),
                    ListTile(
                      leading: Icon(Icons.schedule_outlined),
                      title: Text('Follow the official election schedule'),
                    ),
                    ListTile(
                      leading: Icon(Icons.public_outlined),
                      title: Text('Use the official voting portal only'),
                    ),
                    ListTile(
                      leading: Icon(Icons.how_to_vote_outlined),
                      title: Text('Cast one vote per position'),
                    ),
                    ListTile(
                      leading: Icon(Icons.fact_check_outlined),
                      title: Text('Review your ballot before submitting'),
                    ),
                    ListTile(
                      leading: Icon(Icons.check_circle_outline),
                      title: Text('Wait for the confirmation message'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void openFaqsEducation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Election FAQs',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: const [
                    ListTile(
                      title: Text('Who can vote?'),
                      subtitle: Text(
                        'All currently enrolled students in USTP Oroquieta Campus',
                      ),
                    ),
                    ListTile(
                      title: Text('Where do I vote?'),
                      subtitle: Text(
                        'Inside campus via the official Societree app.',
                      ),
                    ),
                    ListTile(
                      title: Text('Forgot password?'),
                      subtitle: Text(
                        'Contact ELECOM at the help desk to reset your access.',
                      ),
                    ),
                    ListTile(
                      title: Text('Is my vote confidential?'),
                      subtitle: Text(
                        'Yes. Votes are anonymized and secured by ELECOM.',
                      ),
                    ),
                    ListTile(
                      title: Text('Internet needed?'),
                      subtitle: Text(
                        'Yes, connect to campus Wi‑Fi or mobile data inside campus.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void openFindPollingStation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'USTP Oroquieta polling stations (TBA)',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: const [
                    ListTile(
                      leading: Icon(Icons.campaign_outlined),
                      title: Text('Exact schedule to be announced'),
                      subtitle: Text('ELECOM will publish official polling locations and hours soon.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Stay tuned in-app'),
                      subtitle: Text('Watch for a notification from ELECOM with final details.'),
                    ),
                    ListTile(
                      leading: Icon(Icons.support_agent_outlined),
                      title: Text('ELECOM Help Desk (Oroquieta Campus)'),
                      subtitle: Text('For assistance and verification concerns'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
