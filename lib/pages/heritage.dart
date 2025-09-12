import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/cards.dart';
import '../widgets/footer.dart';

class HeritagePage extends StatelessWidget {
  const HeritagePage({super.key});

  @override
  Widget build(BuildContext context) {
    // FIXED: Add responsive design and text scale clamping
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isVerySmall = width < 360;
    final isSmall = width < 600;
    final isMedium = width < 900;

    // FIXED: More aggressive text scale clamping
    final clampedScale = isVerySmall
        ? mq.textScaler.scale(1).clamp(0.8, 1.0)
        : isSmall
        ? mq.textScaler.scale(1).clamp(0.85, 1.1)
        : mq.textScaler.scale(1).clamp(0.9, 1.2);

    final clamped = mq.copyWith(textScaler: TextScaler.linear(clampedScale));

    final t = Theme.of(context).textTheme;

    // FIXED: Responsive padding
    final horizontalPadding = isVerySmall
        ? 12.0
        : isSmall
        ? 16.0
        : 24.0;
    final verticalPadding = isSmall ? 40.0 : 60.0;

    // ======= HERO / INTRO =======
    final intro = MaxWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Our Distinguished Heritage',
              subtitle:
                  'Since 2017 — a legacy of Pakistani elegance, tradition, and precise execution',
            ),
            SizedBox(height: isSmall ? 16 : 24),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final isTwoCol = w >= 900;
                final gap = isSmall ? 16.0 : 24.0;
                final colW = isTwoCol ? (w - gap) / 2 : w;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    SizedBox(
                      width: colW,
                      child: _StoryBlock(
                        title: 'From Islamabad, With Timeless Taste',
                        body:
                            'Founded in 1995, we began as a boutique planner for intimate Nikkah and Mehndi functions across Islamabad & Rawalpindi. Over three decades, our craft has grown to encompass large-format corporate events, destination weddings in the northern hills, and gala nights that blend classic Pakistani hospitality with modern production.',
                        points: const [
                          'Respect for customs: Mehman-Nawazi at the core',
                          'Mughal-inspired design with contemporary polish',
                          'Precision logistics, vendor stewardship, and AV excellence',
                        ],
                        isSmall: isSmall,
                        isVerySmall: isVerySmall,
                      ),
                    ),
                    SizedBox(
                      width: colW,
                      child: _StoryBlock(
                        title: 'What Heritage Means To Us',
                        body:
                            'Heritage is more than history; its the part of the past we keep alive. We preserve signature motifs, rituals, and service standards that define who we are — then re-interpret them for todays audiences.',
                        points: const [
                          'Signature floral and stage styling (Kashmiri & Mughal cues)',
                          'Curated qawwali / cultural performances',
                          'Family-first planning with discreet coordination',
                        ],
                        isSmall: isSmall,
                        isVerySmall: isVerySmall,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    // ======= TIMELINE =======
    final timeline = Container(
      decoration: BoxDecoration(gradient: royalGradient),
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 40 : 56,
        horizontal: horizontalPadding,
      ),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Milestones Through The Years',
              subtitle: 'A journey of trust, craft, and growth',
              titleColor: Colors.white,
            ),
            SizedBox(height: isSmall ? 12 : 16),
            Column(
              children: [
                _TimelineItem(
                  year: '2017',
                  title: 'Founded in Islamabad',
                  desc:
                      'First boutique weddings & family celebrations across the twin cities.',
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
                _TimelineItem(
                  year: '2018',
                  title: 'Corporate Debut',
                  desc:
                      'First AGM & awards night; introduced run-of-show discipline & AV partners.',
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
                _TimelineItem(
                  year: '2019',
                  title: 'Destination North',
                  desc:
                      'Bhurban / Nathia Gali weddings with full guest logistics & vendor network.',
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
                _TimelineItem(
                  year: '2020',
                  title: 'In-house Show Calling',
                  desc:
                      'Production, stage management & creative decks brought under one roof.',
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
                _TimelineItem(
                  year: '2021',
                  title: 'Hybrid & Digital',
                  desc:
                      'Live streaming and hybrid programs for summits and launches.',
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
                _TimelineItem(
                  year: '2024',
                  title: 'National Recognition',
                  desc:
                      'Multiple industry awards for service, design and execution excellence.',
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // ======= CRAFT & INSPIRATION =======
    final craft = MaxWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Craft & Inspiration',
              subtitle:
                  'Traditions we honor, details we obsess over, experiences we elevate',
            ),
            SizedBox(height: isSmall ? 20 : 28),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final cols = w < 700
                    ? 1
                    : w < 1100
                    ? 2
                    : 3;
                final gap = isSmall ? 16.0 : 24.0;
                final itemW = (w - gap * (cols - 1)) / cols;

                const items = [
                  AboutCard(
                    icon: '🌿',
                    title: 'Mughal Cues',
                    body:
                        'Arches, jaali patterns, jewel tones & metallic accents re-imagined with modern restraint.',
                  ),
                  AboutCard(
                    icon: '🎶',
                    title: 'Cultural Programs',
                    body:
                        'Qawwali nights, classical sets and regional folk curated for ambience & audience.',
                  ),
                  AboutCard(
                    icon: '🕯️',
                    title: 'Tablescapes & Florals',
                    body:
                        'Kashmiri florals, candlelight layers, and heirloom textures for intimate depth.',
                  ),
                  AboutCard(
                    icon: '🎤',
                    title: 'Production & AV',
                    body:
                        'Stage craft, show-calling, sound & light design tied to the story of your event.',
                  ),
                  AboutCard(
                    icon: '🤝',
                    title: 'Vendor Stewardship',
                    body:
                        'Trusted caterers, décor, entertainment & technical partners — curated and managed end-to-end.',
                  ),
                  AboutCard(
                    icon: '🗺️',
                    title: 'Guest Journey',
                    body:
                        'Signage, wayfinding, concierge desks and hospitality woven into every moment.',
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

    // ======= AWARDS & PRESS =======
    final awards = Container(
      color: AppColors.charcoal,
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 32 : 48,
        horizontal: horizontalPadding,
      ),
      child: MaxWidth(
        child: Column(
          children: [
            Text(
              'Awards & Press Mentions',
              textAlign: TextAlign.center,
              maxLines: 2, // FIXED: Prevent overflow
              overflow: TextOverflow.ellipsis,
              style: (isSmall ? t.titleMedium : t.titleLarge)!.copyWith(
                color: Colors.white,
                fontSize: isVerySmall
                    ? 18
                    : null, // FIXED: Smaller font for tiny screens
              ),
            ),
            SizedBox(height: isSmall ? 12 : 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: isSmall ? 12 : 16,
              runSpacing: isSmall ? 10 : 12,
              children: [
                _BadgeChip(
                  '🏆  Event Planner of the Year 2024',
                  isSmall: isSmall,
                ),
                _BadgeChip('💎  Platinum Service 2023', isSmall: isSmall),
                _BadgeChip(
                  '📰  Featured: Leading Lifestyle Mag',
                  isSmall: isSmall,
                ),
                _BadgeChip('🥇  Best Wedding Designer 2023', isSmall: isSmall),
              ],
            ),
          ],
        ),
      ),
    );

    // ======= VENUES & PARTNERSHIPS =======
    final venues = MaxWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 32 : 48,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Signature Venues & Partnerships',
              subtitle:
                  'Destinations and partners that shaped our journey in the twin cities & beyond',
            ),
            const SizedBox(height: 10),
            _PartnersRow(isSmall: isSmall),
          ],
        ),
      ),
    );

    // ======= COMMUNITY & SUSTAINABILITY =======
    final community = MaxWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 40 : 56,
          horizontal: horizontalPadding,
        ),
        child: Column(
          children: [
            const SectionHeader(
              title: 'Community & Sustainability',
              subtitle:
                  'The values we pass forward — training, inclusivity, and mindful operations',
            ),
            SizedBox(height: isSmall ? 10 : 14),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final isTwoCol = w >= 900;
                final gap = isSmall ? 16.0 : 24.0;
                final colW = isTwoCol ? (w - gap) / 2 : w;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    SizedBox(
                      width: colW,
                      child: _StoryBlock(
                        title: 'Training & Craft',
                        body:
                            'We mentor junior coordinators and vendors, share safety protocols, and codify SOPs so craft outlives individuals.',
                        points: const [
                          'Intern & vendor training sessions',
                          'Health & safety briefings on-site',
                          'Documentation & checklists handed down',
                        ],
                        isSmall: isSmall,
                        isVerySmall: isVerySmall,
                      ),
                    ),
                    SizedBox(
                      width: colW,
                      child: _StoryBlock(
                        title: 'Responsible Operations',
                        body:
                            'We minimize waste, repurpose florals, opt for efficient lighting, and work with suppliers who share our standards.',
                        points: const [
                          'Waste-aware décor & packaging',
                          'Energy-efficient AV where possible',
                          'Local sourcing to support community',
                        ],
                        isSmall: isSmall,
                        isVerySmall: isVerySmall,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    // ======= CTA =======
    final cta = Container(
      decoration: BoxDecoration(gradient: goldGradient),
      padding: EdgeInsets.symmetric(
        vertical: isSmall ? 32 : 44,
        horizontal: horizontalPadding,
      ),
      child: MaxWidth(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 12,
          children: [
            Text(
              'Explore Our Heritage In Action',
              textAlign: TextAlign.center,
              maxLines: 2, // FIXED: Prevent overflow
              overflow: TextOverflow.ellipsis,
              style: (isSmall ? t.titleMedium : t.titleLarge)!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isVerySmall ? 18 : null, // FIXED: Smaller font
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryGold,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 16 : 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/portfolio'),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(
                isVerySmall
                    ? 'Portfolio'
                    : 'View Portfolio', // FIXED: Shorter text for tiny screens
              ),
            ),
          ],
        ),
      ),
    );

    // ======= PAGE =======
    return MediaQuery(
      data: clamped, // FIXED: Apply clamped MediaQuery
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            intro,
            timeline,
            craft,
            awards,
            venues,
            community,
            cta,
            const Footer(), // same footer link/section as home
          ],
        ),
      ),
    );
  }
}

/// FIXED: Simple two–column friendly narrative block with overflow protection
class _StoryBlock extends StatelessWidget {
  final String title;
  final String body;
  final List<String> points;
  final bool isSmall;
  final bool isVerySmall;

  const _StoryBlock({
    required this.title,
    required this.body,
    required this.points,
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
            ? 16
            : 18, // FIXED: Responsive padding
      ),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(isSmall ? 12 : 14),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x11000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
        children: [
          Text(
            title,
            maxLines: isVerySmall ? 2 : 3, // FIXED: Limit lines
            overflow: TextOverflow.ellipsis,
            style: (isVerySmall ? t.titleMedium : t.titleLarge)!.copyWith(
              color: AppColors.deepBurgundy,
              fontWeight: FontWeight.w700,
              height: 1.2, // FIXED: Tighter line height
            ),
          ),
          SizedBox(height: isSmall ? 6 : 8), // FIXED: Less spacing on mobile
          Text(
            body,
            maxLines: isVerySmall
                ? 4
                : 6, // FIXED: Limit lines to prevent overflow
            overflow: TextOverflow.ellipsis,
            style: (isVerySmall ? t.bodySmall : t.bodyMedium)!.copyWith(
              height: 1.3, // FIXED: Tighter line height
            ),
          ),
          SizedBox(height: isSmall ? 8 : 12), // FIXED: Less spacing
          ...points.map(
            (p) => Padding(
              padding: EdgeInsets.only(
                top: isSmall ? 4 : 6,
              ), // FIXED: Less spacing
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•  ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      fontSize: isVerySmall ? 12 : null, // FIXED: Smaller font
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p,
                      maxLines: isVerySmall ? 2 : 3, // FIXED: Limit lines
                      overflow: TextOverflow.ellipsis,
                      style: (isVerySmall ? t.bodySmall : t.bodyMedium)!
                          .copyWith(
                            height: 1.3, // FIXED: Tighter line height
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// FIXED: Vertical timeline item with overflow protection
class _TimelineItem extends StatelessWidget {
  final String year, title, desc;
  final bool isSmall;
  final bool isVerySmall;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.desc,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isSmall ? 6 : 8,
      ), // FIXED: Less spacing
      padding: EdgeInsets.all(
        isVerySmall
            ? 12
            : isSmall
            ? 14
            : 16, // FIXED: Responsive padding
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.35),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isVerySmall
                ? 52
                : 64, // FIXED: Smaller width on tiny screens
            padding: EdgeInsets.symmetric(
              vertical: isSmall ? 6 : 8,
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              gradient: goldGradient,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              year,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: isVerySmall
                    ? 11
                    : 14, // FIXED: Smaller font for tiny screens
              ),
            ),
          ),
          SizedBox(width: isSmall ? 10 : 14), // FIXED: Less spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
              children: [
                Text(
                  title,
                  maxLines: isVerySmall ? 1 : 2, // FIXED: Limit lines
                  overflow: TextOverflow.ellipsis,
                  style: (isVerySmall ? t.titleSmall : t.titleMedium)!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.2, // FIXED: Tighter line height
                  ),
                ),
                SizedBox(height: isSmall ? 4 : 6), // FIXED: Less spacing
                Text(
                  desc,
                  maxLines: isVerySmall ? 2 : 3, // FIXED: Limit lines
                  overflow: TextOverflow.ellipsis,
                  style: (isVerySmall ? t.bodySmall : t.bodyMedium)!.copyWith(
                    color: Colors.white70,
                    height: 1.3, // FIXED: Tighter line height
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

/// FIXED: Awards/press chip with overflow protection
class _BadgeChip extends StatelessWidget {
  final String text;
  final bool isSmall;

  const _BadgeChip(this.text, {required this.isSmall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 14, // FIXED: Less padding on mobile
        vertical: isSmall ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: Text(
        text,
        maxLines: 1, // FIXED: Prevent overflow
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: isSmall ? 12 : 14, // FIXED: Smaller font on mobile
        ),
      ),
    );
  }
}

/// FIXED: Partners row with responsive sizing
class _PartnersRow extends StatelessWidget {
  final bool isSmall;

  const _PartnersRow({required this.isSmall});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleSmall!.copyWith(
      color: AppColors.textSecondary,
      fontSize: isSmall ? 12 : null, // FIXED: Smaller font on mobile
    );

    final items = const [
      'Serena Islamabad',
      'Marriott Islamabad',
      'Islamabad Club',
      'Jinnah Convention Ctr.',
      'PC Bhurban',
      'PC Rawalpindi',
      'Bahria Auditorium',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 8,
      ), // FIXED: Less padding
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items
            .map(
              (e) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isSmall ? 6 : 8,
                ), // FIXED: Less margin
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 12 : 16, // FIXED: Less padding
                  vertical: isSmall ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warmWhite,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
                ),
                child: Text(
                  e,
                  style: style,
                  maxLines: 1, // FIXED: Prevent overflow
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
