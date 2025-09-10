// lib/pages/services.dart
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';
import '../widgets/footer.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Clamp extreme accessibility text scales so layouts don’t overflow
    final mq = MediaQuery.of(context);
    final clampedMQ = mq.copyWith(
      textScaler: TextScaler.linear(mq.textScaler.scale(1).clamp(0.9, 1.25)),
    );

    // ====== HERO ======
    final hero = LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final titleSize = w < 360
            ? 28.0
            : w < 520
            ? 34.0
            : w < 900
            ? 46.0
            : 56.0;

        return Container(
          decoration: BoxDecoration(gradient: royalGradient),
          padding: const EdgeInsets.symmetric(vertical: 56),
          width: double.infinity,
          child: MaxWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Bespoke Luxury Services',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: titleSize,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Full-service planning across Islamabad & Rawalpindi — from South Asian weddings to executive corporate events.',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        );
      },
    );

    // ====== SERVICES (with price ranges + CTA to form) ======
    final services = [
      ServiceCard(
        imageAsset: 'assets/images/services/wedding.jpg',
        title: 'Luxury Wedding Planning',
        desc:
            'Timeless ceremonies and grand celebrations with classic elegance.',
        bullets: [
          'Complete coordination',
          'Venue & design',
          'Vendor management',
          'Run-of-show & timelines',
        ],
        priceFrom: 'PKR 800k',
        priceTo: 'PKR 3.5M',
        ctaText: 'Book this service',
        onPressed: () => Navigator.pushNamed(
          context,
          '/contact',
          arguments: {'service': 'Luxury Wedding Planning'},
        ),
      ),
      ServiceCard(
        imageAsset: 'assets/images/services/corporate.jpg',
        title: 'Executive Corporate Events',
        desc: 'Professional gatherings, conferences & business celebrations.',
        bullets: ['Conferences', 'Launches', 'Board meetings', 'Award nights'],
        priceFrom: 'PKR 500k',
        priceTo: 'PKR 2.0M',
        ctaText: 'Book this service',
        onPressed: () => Navigator.pushNamed(
          context,
          '/contact',
          arguments: {'service': 'Executive Corporate Events'},
        ),
      ),
      ServiceCard(
        imageAsset: 'assets/images/services/social.jpg',
        title: 'Social Celebrations',
        desc: 'Milestones crafted with grace & sophisticated touches.',
        bullets: ['Anniversaries', 'Birthdays', 'Reunions', 'Holidays'],
        priceFrom: 'PKR 300k',
        priceTo: 'PKR 1.2M',
        ctaText: 'Book this service',
        onPressed: () => Navigator.pushNamed(
          context,
          '/contact',
          arguments: {'service': 'Social Celebrations'},
        ),
      ),
      ServiceCard(
        imageAsset: 'assets/images/services/awards.jpg',
        title: 'Award Ceremonies',
        desc: 'Prestigious ceremonies honoring achievements with grandeur.',
        bullets: [
          'Show flow & scripting',
          'Stage & AV',
          'VIP hospitality',
          'Press handling',
        ],
        priceFrom: 'PKR 700k',
        priceTo: 'PKR 2.5M',
        ctaText: 'Book this service',
        onPressed: () => Navigator.pushNamed(
          context,
          '/contact',
          arguments: {'service': 'Award Ceremonies'},
        ),
      ),
      ServiceCard(
        imageAsset: 'assets/images/services/gala.jpg',
        title: 'Exclusive Gala Dinners',
        desc: 'World-class cuisine & refined luxury evenings.',
        bullets: [
          'Menu curation',
          'Entertainment',
          'Staging & lights',
          'Guest journey',
        ],
        priceFrom: 'PKR 600k',
        priceTo: 'PKR 2.2M',
        ctaText: 'Book this service',
        onPressed: () => Navigator.pushNamed(
          context,
          '/contact',
          arguments: {'service': 'Exclusive Gala Dinners'},
        ),
      ),
      ServiceCard(
        imageAsset: 'assets/images/services/milestone.jpg',
        title: 'Milestone Celebrations',
        desc: 'Meaningful events marking life’s achievements.',
        bullets: ['Graduations', 'Retirements', 'Achievements', 'Memorials'],
        priceFrom: 'PKR 200k',
        priceTo: 'PKR 900k',
        ctaText: 'Book this service',
        onPressed: () => Navigator.pushNamed(
          context,
          '/contact',
          arguments: {'service': 'Milestone Celebrations'},
        ),
      ),
    ];

    // ✅ Responsive, overflow-proof services grid
    final servicesGrid = Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'What We Deliver',
              subtitle:
                  'Comprehensive management with traditional elegance & modern production',
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                const gap = 24.0;

                // Use fluid breakpoints to avoid cramped cards
                int cols;
                if (w >= 1280) {
                  cols = 3;
                } else if (w >= 820) {
                  cols = 2;
                } else {
                  cols = 1;
                }

                final itemW = (w - gap * (cols - 1)) / cols;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: services
                      .map((card) => SizedBox(width: itemW, child: card))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

    // ====== PRICING PLANS (responsive, no fixed widths) ======
    final pricing = Container(
      color: AppColors.pearl,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Planning Packages',
              subtitle:
                  'Choose a starting framework — we tailor every detail to your brief',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                const gap = 18.0;

                int cols;
                if (w >= 1100) {
                  cols = 3;
                } else if (w >= 740) {
                  cols = 2;
                } else {
                  cols = 1;
                }

                final itemW = (w - gap * (cols - 1)) / cols;

                final plans = const [
                  (
                    'Essential',
                    'PKR 150k – 400k+',
                    false,
                    [
                      'Event day management',
                      'Basic run-of-show',
                      'Vendor coordination (on-day)',
                      'Standard décor guidance',
                    ],
                  ),
                  (
                    'Signature',
                    'PKR 400k – 1.2M+',
                    true,
                    [
                      'Full planning & design',
                      'Vendor curation & contracts',
                      'Detailed timelines & rehearsals',
                      'Production & AV coordination',
                    ],
                  ),
                  (
                    'Royal',
                    'PKR 1.2M – 3.0M+',
                    false,
                    [
                      'Destination & guest logistics',
                      'Custom stage/production',
                      'VIP & protocol handling',
                      'Post-event wrap & media',
                    ],
                  ),
                ];

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  alignment: WrapAlignment.center,
                  children: plans
                      .map(
                        (p) => SizedBox(
                          width: itemW,
                          child: _PricingPlanCard(
                            label: p.$1,
                            priceText: p.$2,
                            highlight: p.$3,
                            points: p.$4,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

    // ====== ADD-ONS ======
    final addons = MaxWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Popular Add-ons',
              subtitle:
                  'Enhance any package with specialized services & experiences',
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children:
                    const [
                          _AddOnChip('Qawwali / Sufi Night'),
                          _AddOnChip('Live Streaming'),
                          _AddOnChip('Custom Invites & Stationery'),
                          _AddOnChip('Guest Concierge Desk'),
                          _AddOnChip('Photo Booth & Backdrops'),
                          _AddOnChip('Security & Protocol'),
                          _AddOnChip('Fireworks (venue-permitting)'),
                        ]
                        .map(
                          (w) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: w,
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );

    // ====== PROCESS ======
    final process = Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Our Process',
              subtitle:
                  'A structured journey from brief to applause — transparent, calm, and precise',
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                const gap = 18.0;

                int cols;
                if (w >= 1100) {
                  cols = 4;
                } else if (w >= 740) {
                  cols = 3;
                } else if (w >= 520) {
                  cols = 2;
                } else {
                  cols = 1;
                }

                final itemW = (w - gap * (cols - 1)) / cols;

                const steps = [
                  _ProcessStep(
                    '📝',
                    'Discovery',
                    'Brief, budget bands, dates, vision & guest profile.',
                  ),
                  _ProcessStep(
                    '🎨',
                    'Concept',
                    'Mood boards, stage sketches, tablescapes & brand cues.',
                  ),
                  _ProcessStep(
                    '🤝',
                    'Vendors',
                    'Curated partners, quotes, contracts & approvals.',
                  ),
                  _ProcessStep(
                    '📋',
                    'Run-of-Show',
                    'Detailed timelines, rehearsals & contingency mapping.',
                  ),
                  _ProcessStep(
                    '🎤',
                    'Production',
                    'Staging, sound, lighting & show-calling.',
                  ),
                  _ProcessStep(
                    '🧭',
                    'Guest Journey',
                    'Wayfinding, hospitality desks & VIP protocol.',
                  ),
                  _ProcessStep(
                    '🎉',
                    'Event Day',
                    'White-glove execution & live adjustments.',
                  ),
                  _ProcessStep(
                    '📦',
                    'Wrap',
                    'Vendor settlements, media handover & debrief.',
                  ),
                ];

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: steps
                      .map((s) => SizedBox(width: itemW, child: s))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

    // ====== FAQ ======
    final faq = Container(
      color: AppColors.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: MaxWidth(
        child: Column(
          children: const [
            SectionHeader(
              title: 'Service FAQs',
              subtitle:
                  'Timelines, vendor flexibility and what’s included in planning',
              titleColor: Colors.white,
            ),
            SizedBox(height: 8),
            _ServiceFaq(),
          ],
        ),
      ),
    );

    // ====== CTA ======
    final cta = Container(
      decoration: BoxDecoration(gradient: goldGradient),
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: MaxWidth(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 12,
          children: [
            Text(
              'Ready to start planning?',
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              icon: const Icon(Icons.mail),
              label: const Text('Request a Proposal'),
            ),
          ],
        ),
      ),
    );

    // ====== PAGE ======
    return MediaQuery(
      data: clampedMQ,
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              hero,
              servicesGrid,
              pricing,
              addons,
              process,
              faq,
              cta,
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== LOCAL WIDGETS ==================
class _PricingPlanCard extends StatelessWidget {
  final String label;
  final String priceText;
  final List<String> points;
  final bool highlight;
  const _PricingPlanCard({
    required this.label,
    required this.priceText,
    required this.points,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? AppColors.primaryGold : const Color(0xFFEAEAEA),
          width: 2,
        ),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x11000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (highlight)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: goldGradient,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.titleLarge!.copyWith(
              color: AppColors.deepBurgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(priceText, softWrap: true, style: t.bodyLarge),
          const SizedBox(height: 12),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•  ',
                    style: TextStyle(fontWeight: FontWeight.w700, height: 1.4),
                  ),
                  Expanded(
                    child: Text(
                      p,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: t.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGold, width: 2),
                foregroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              child: const Text('Request Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddOnChip extends StatelessWidget {
  final String label;
  const _AddOnChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
      ),
      child: Text(
        label,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.titleSmall!.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String emoji, title, body;
  const _ProcessStep(this.emoji, this.title, this.body);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x11000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.titleMedium!.copyWith(
              color: AppColors.deepBurgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(body, softWrap: true, style: t.bodyMedium),
        ],
      ),
    );
  }
}

class _ServiceFaq extends StatelessWidget {
  const _ServiceFaq();

  @override
  Widget build(BuildContext context) {
    final items = const [
      (
        'How far in advance should we book?',
        'For peak season (Nov–Mar), we recommend booking 6–12 months ahead for prime weekend dates.',
      ),
      (
        'Can we use our preferred vendors?',
        'Absolutely. We integrate your partners and manage them to our quality standards and SOPs.',
      ),
      (
        'Do you cover destination events in the North?',
        'Yes — Bhurban, Murree, Nathia Gali and beyond. We handle travel logistics, permits and local vendor management.',
      ),
      (
        'What’s typically included in planning?',
        'Vendor curation & contracts, timelines, rehearsals, design oversight, show-calling and on-day management.',
      ),
    ];

    return Column(
      children: items
          .map(
            (e) => Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(
                  context,
                ).textTheme.apply(bodyColor: Colors.white),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                title: Text(
                  e.$1,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                collapsedIconColor: Colors.white,
                iconColor: Colors.white,
                backgroundColor: Colors.white10,
                collapsedBackgroundColor: Colors.white10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e.$2,
                      softWrap: true,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
