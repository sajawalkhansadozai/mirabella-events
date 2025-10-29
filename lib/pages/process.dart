// lib/pages/process.dart
import 'package:flutter/material.dart';
import '../widgets/common.dart';
import '../theme.dart';

class ProcessPage extends StatelessWidget {
  const ProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: More aggressive text scale clamping to prevent overflow
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isVerySmall = width < 360;
    final isSmall = width < 600;

    final clampedScale = isVerySmall
        ? mq.textScaler
              .scale(1)
              .clamp(0.8, 1.0) // More restrictive for very small screens
        : isSmall
        ? mq.textScaler
              .scale(1)
              .clamp(0.85, 1.1) // More restrictive for small screens
        : mq.textScaler.scale(1).clamp(0.9, 1.2); // Reduced max scale

    final clamped = mq.copyWith(textScaler: TextScaler.linear(clampedScale));

    final steps = const [
      (
        '1',
        'Initial Consultation',
        'Understand your vision, guest profile, dates and budget bands.',
      ),
      (
        '2',
        'Proposal & Design',
        'Venues shortlist, mood boards, staging concepts & high-level timelines.',
      ),
      (
        '3',
        'Vendor Coordination',
        'Curated premium vendors: décor, AV, catering, artists, logistics.',
      ),
      (
        '4',
        'Final Preparation',
        'Site visits, run-of-show, rehearsals, contingency and protocol.',
      ),
      (
        '5',
        'Event Execution',
        'White-glove delivery, show-calling and live adjustments.',
      ),
    ];

    // ==== HERO (width-aware title size) ====
    final hero = LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final titleSize = w < 360
            ? 26.0 // Slightly smaller for very small screens
            : w < 520
            ? 32.0 // Reduced from 34.0
            : w < 900
            ? 42.0 // Reduced from 46.0
            : 52.0; // Reduced from 56.0

        return Container(
          decoration: BoxDecoration(gradient: royalGradient),
          padding: EdgeInsets.symmetric(
            vertical: isSmall ? 40 : 56, // Responsive padding
            horizontal: isVerySmall ? 16 : 24, // Added horizontal padding
          ),
          width: double.infinity,
          child: MaxWidth(
            child: Column(
              children: [
                Text(
                  'Our Refined Process',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2, // Prevent overflow
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: titleSize,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'A meticulous approach to creating extraordinary celebrations',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2, // Prevent overflow
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white70,
                    fontSize: isVerySmall
                        ? 14
                        : null, // Smaller font for tiny screens
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // ==== TIMELINE ====
    final timeline = Padding(
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 32 : 48, // Responsive padding
        horizontal: isVerySmall ? 12 : 16, // Added horizontal padding
      ),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'How We Work—Step by Step',
              subtitle: 'Clear milestones keep everyone calm and aligned',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 980; // wide only when there is space
                return Column(
                  children: List.generate(
                    steps.length,
                    (i) => _ProcessRow(
                      index: i,
                      number: steps[i].$1,
                      title: steps[i].$2,
                      desc: steps[i].$3,
                      left: wide ? i.isOdd : false,
                      isSmall: isSmall, // Pass responsive info
                      isVerySmall: isVerySmall,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    // ==== WHAT WE HANDLE (18 chips, responsive) ====
    final handleLabels = const [
      'Venue scouting',
      'Design & décor',
      'Stage & AV',
      'Hospitality desks',
      'Guest logistics',
      'Artists & entertainment',
      'Security & protocol',
      'Run-of-show',
      'Live streaming',
      'Media handover',
      'Catering liaison',
      'Floral design',
      'Seating & layout',
      'Invites & stationery',
      'Transportation',
      'Accommodation',
      'Photography',
      'Videography',
    ];

    final chipsGrid = MaxWidth(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isSmall ? 32 : 40,
          left: isVerySmall ? 12 : 16,
          right: isVerySmall ? 12 : 16,
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'What We Handle for You',
              subtitle:
                  'From first call to curtain close, every moving part is covered',
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final cols = w >= 1200
                    ? 6
                    : w >= 900
                    ? 4
                    : w >= 600
                    ? 3
                    : w >=
                          360 // Added breakpoint for very small screens
                    ? 2
                    : 1; // Single column for extremely small screens
                const gap = 12.0;
                final itemW = (w - gap * (cols - 1)) / cols;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: handleLabels
                      .map(
                        (txt) => SizedBox(
                          width: itemW,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _PillChip(txt, isSmall: isSmall),
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

    // ==== CAPABILITIES ====
    final capabilities = Container(
      color: AppColors.pearl,
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 32 : 48,
        horizontal: isVerySmall ? 12 : 16,
      ),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Production Capabilities',
              subtitle: 'Experienced teams, tested SOPs and reliable partners',
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final cols = w < 700
                    ? 1
                    : w < 1100
                    ? 2
                    : 4;
                const gap = 18.0;
                final itemW = (w - gap * (cols - 1)) / cols;
                final items = [
                  _CapabilityCard(
                    emoji: '🎤',
                    title: 'Show-Calling',
                    body:
                        'Precise cues for hosts, artists, lighting and screens—down to seconds.',
                    isSmall: isSmall,
                    isVerySmall: isVerySmall,
                  ),
                  _CapabilityCard(
                    emoji: '🎛️',
                    title: 'Audio-Visual',
                    body:
                        'Line-array sound, LED walls, projection mapping and redundancies.',
                    isSmall: isSmall,
                    isVerySmall: isVerySmall,
                  ),
                  _CapabilityCard(
                    emoji: '🧭',
                    title: 'Guest Journey',
                    body:
                        'Wayfinding, check-in, VIP routing, parking and hospitality desks.',
                    isSmall: isSmall,
                    isVerySmall: isVerySmall,
                  ),
                  _CapabilityCard(
                    emoji: '🛡️',
                    title: 'Risk & Protocol',
                    body:
                        'Permits, security liaison, contingency plans and compliance.',
                    isSmall: isSmall,
                    isVerySmall: isVerySmall,
                  ),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: items
                      .map((e) => SizedBox(width: itemW, child: e))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

    // ==== TIMELINE AT A GLANCE ====
    final phases = const [
      (
        'T-12 to T-8 weeks',
        [
          'Shortlist venues and freeze dates',
          'Mood boards and high-level budgets',
          'Primary vendor holds (décor/AV/catering)',
        ],
      ),
      (
        'T-8 to T-4 weeks',
        [
          'Detailed stage and floor plans',
          'Menu curation and tasting (if applicable)',
          'Artist curation and contracts',
        ],
      ),
      (
        'T-4 to T-2 weeks',
        [
          'Run-of-show and responsibility matrix',
          'Guest logistics & protocol mapping',
          'Site recce with key vendors',
        ],
      ),
      (
        'Show Week',
        [
          'On-site builds and technical checks',
          'Full rehearsal and content review',
          'Final sign-offs and contingency brief',
        ],
      ),
      (
        'Event Day',
        [
          'White-glove execution and show-calling',
          'Live adjustments and stakeholder updates',
          'Vendor coordination and change control',
        ],
      ),
      (
        'T+3 Days',
        [
          'Vendor settlements and teardown checks',
          'Media handover and highlights',
          'Post-event debrief and learnings',
        ],
      ),
    ];

    final glance = MaxWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 32 : 44,
          horizontal: isVerySmall ? 12 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              title: 'Timeline at a Glance',
              subtitle: 'What typically happens and when',
            ),
            const SizedBox(height: 8),
            _TimelineAccordion(phases: phases, isSmall: isSmall),
          ],
        ),
      ),
    );

    // ==== FAQS ====
    final faqs = Container(
      color: AppColors.charcoal,
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 32 : 48,
        horizontal: isVerySmall ? 12 : 16,
      ),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Process FAQs',
              subtitle: 'Common questions about planning and delivery',
              titleColor: Colors.white,
            ),
            const SizedBox(height: 12),
            _ProcessFaq(isSmall: isSmall),
          ],
        ),
      ),
    );

    // ==== CTA ====
    final cta = Container(
      decoration: BoxDecoration(gradient: goldGradient),
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 32 : 44,
        horizontal: isVerySmall ? 12 : 16,
      ),
      child: MaxWidth(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Text(
              'Ready to map your event timeline?',
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2, // Prevent overflow
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isSmall ? 18 : null, // Smaller font for mobile
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(
                context,
                '/contact',
                arguments: {'intent': 'Process Planning'},
              ),
              icon: const Icon(Icons.event_available),
              label: Text(
                isVerySmall
                    ? 'Request Plan'
                    : 'Request a Detailed Plan', // Shorter text for tiny screens
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryGold,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 14 : 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // ==== PAGE ====
    return MediaQuery(
      data: clamped,
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              hero,
              timeline,
              chipsGrid,
              capabilities,
              glance,
              faqs,
              cta,
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------ Local widgets (FIXED for overflow prevention) ------------------ */

class _ProcessRow extends StatelessWidget {
  final int index;
  final String number, title, desc;
  final bool left;
  final bool isSmall;
  final bool isVerySmall;

  const _ProcessRow({
    required this.index,
    required this.number,
    required this.title,
    required this.desc,
    required this.left,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget buildCard(double width) {
      return SizedBox(
        width: width,
        child: Container(
          padding: EdgeInsets.all(
            isVerySmall
                ? 16
                : isSmall
                ? 20
                : 24, // FIXED: Responsive padding
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              isSmall ? 16 : 20,
            ), // Slightly smaller radius for mobile
            border: Border.all(color: AppColors.lightGold, width: 3),
            boxShadow: const [
              BoxShadow(blurRadius: 18, color: Color(0x14000000)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
            children: [
              Text(
                title,
                softWrap: true,
                maxLines: isVerySmall
                    ? 2
                    : 3, // FIXED: Fewer lines on very small screens
                overflow: TextOverflow.ellipsis,
                style: (isVerySmall ? t.titleMedium : t.titleLarge)!.copyWith(
                  color: AppColors.deepBurgundy,
                  height: 1.2, // FIXED: Tighter line height
                ),
              ),
              SizedBox(
                height: isSmall ? 6 : 8,
              ), // FIXED: Less spacing on mobile
              Text(
                desc,
                softWrap: true,
                maxLines: isVerySmall
                    ? 3
                    : 4, // FIXED: Limit lines to prevent overflow
                overflow: TextOverflow.ellipsis,
                style: (isVerySmall ? t.bodyMedium : t.bodyLarge)!.copyWith(
                  height: 1.3, // FIXED: Tighter line height
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 12 : 18,
      ), // FIXED: Less spacing on mobile
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 980;
          // Center stack (marker + line) width and gaps
          const centerW = 84.0;
          const hGap = 16.0;

          if (!isWide) {
            // Single column (mobile/tablet)
            return buildCard(double.infinity);
          }

          // Compute safe card width so nothing overflows on medium desktops
          final raw = (c.maxWidth - centerW - hGap * 2) / 2;
          final cardW = raw.clamp(280.0, 520.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (left) buildCard(cardW) else SizedBox(width: cardW),
              SizedBox(
                width: centerW,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 2, height: 120, color: Colors.black12),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: goldGradient,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(blurRadius: 16, color: Color(0x33000000)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!left) buildCard(cardW) else SizedBox(width: cardW),
            ],
          );
        },
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String text;
  final bool isSmall;

  const _PillChip(this.text, {required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 14, // FIXED: Less padding on mobile
        vertical: isSmall ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
      ),
      child: Text(
        text,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: AppColors.textSecondary,
          fontSize: isSmall ? 12 : null, // FIXED: Smaller font on mobile
        ),
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  final String emoji, title, body;
  final bool isSmall;
  final bool isVerySmall;

  const _CapabilityCard({
    required this.emoji,
    required this.title,
    required this.body,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(
        isVerySmall
            ? 12
            : isSmall
            ? 14
            : 16, // FIXED: Responsive padding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmall ? 12 : 14),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x11000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: isVerySmall ? 20 : 24,
            ), // FIXED: Smaller emoji on tiny screens
          ),
          SizedBox(height: isSmall ? 6 : 8), // FIXED: Less spacing
          Flexible(
            // FIXED: Use Flexible instead of direct Text
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: (isVerySmall ? t.titleSmall : t.titleMedium)!.copyWith(
                color: AppColors.deepBurgundy,
                fontWeight: FontWeight.w700,
                height: 1.2, // FIXED: Tighter line height
              ),
            ),
          ),
          SizedBox(height: isSmall ? 3 : 4), // FIXED: Less spacing
          Flexible(
            // FIXED: Use Flexible for body text
            child: Text(
              body,
              softWrap: true,
              maxLines: isVerySmall ? 3 : 4, // FIXED: Limit lines
              overflow: TextOverflow.ellipsis,
              style: (isVerySmall ? t.bodySmall : t.bodyMedium)!.copyWith(
                height: 1.3, // FIXED: Tighter line height
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineAccordion extends StatelessWidget {
  final List<(String, List<String>)> phases;
  final bool isSmall;

  const _TimelineAccordion({required this.phases, required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      children: phases
          .map(
            (p) => Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.black12,
                listTileTheme: const ListTileThemeData(
                  textColor: AppColors.textSecondary,
                ),
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 4 : 8,
                ), // FIXED: Less padding on mobile
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 8 : 12,
                  vertical: isSmall ? 6 : 8,
                ),
                title: Text(
                  p.$1,
                  softWrap: true,
                  maxLines: 2, // FIXED: Prevent overflow in title
                  overflow: TextOverflow.ellipsis,
                  style: (isSmall ? t.titleSmall : t.titleMedium)!.copyWith(
                    color: AppColors.deepBurgundy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                children: p.$2
                    .map(
                      (s) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isSmall ? 2 : 4,
                        ), // FIXED: Less spacing
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: isSmall
                                  ? 16
                                  : 18, // FIXED: Smaller icon on mobile
                              color: AppColors.primaryGold,
                            ),
                            SizedBox(
                              width: isSmall ? 6 : 8,
                            ), // FIXED: Less spacing
                            Expanded(
                              child: Text(
                                s,
                                softWrap: true,
                                maxLines: 3, // FIXED: Limit lines
                                overflow: TextOverflow.ellipsis,
                                style: (isSmall ? t.bodySmall : t.bodyMedium)!
                                    .copyWith(
                                      height: 1.3, // FIXED: Tighter line height
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ProcessFaq extends StatelessWidget {
  final bool isSmall;

  const _ProcessFaq({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final items = const [
      (
        'How early should we start?',
        'For peak season (Nov–Mar), start 6–12 months ahead for prime weekend dates.',
      ),
      (
        'Can you work with our preferred vendors?',
        'Yes. We integrate your partners into our SOPs and manage them to our quality standards.',
      ),
      (
        'Do you cover permits and security?',
        'We handle permits where required, liaise with security teams and define protocol routes.',
      ),
      (
        'Will you be on-site the whole time?',
        'Absolutely. A senior producer/show-caller is present from build to teardown.',
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
                tilePadding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 4 : 8,
                ), // FIXED: Less padding
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 8 : 12,
                  vertical: isSmall ? 6 : 8,
                ),
                title: Text(
                  e.$1,
                  softWrap: true,
                  maxLines: 2, // FIXED: Prevent title overflow
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmall
                        ? 14
                        : 16, // FIXED: Smaller font on mobile
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
                      maxLines: 5, // FIXED: Limit answer lines
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmall ? 13 : 14, // FIXED: Smaller font
                        height: 1.4, // FIXED: Better line height
                      ),
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
