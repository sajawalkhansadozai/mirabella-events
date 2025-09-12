// lib/pages/home.dart
import 'dart:async'; // for autoplay timer
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:eventmanagement/widgets/cards.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Clamp text scale to avoid overflow chaos on accessibility sizes
    final mq = MediaQuery.of(context);
    final textScale = MediaQuery.textScaleFactorOf(context);
    final clampedMQ = mq.copyWith(
      textScaler: TextScaler.linear(textScale.clamp(1.0, 1.25).toDouble()),
    );

    // ================= HERO (slider) =================
    final hero = _HeroSlider(
      images: const [
        // Use assets or network URLs — both work
        'assets/hero/slide1.jpg',
        'assets/hero/slide2.jpg',
        'assets/hero/slide3.jpg',
        'assets/hero/slide4.jpg',
      ],
      title: 'Mirabella Events',
      subtitle: 'Islamabad Premier Event Planners',
      body:
          'From Mehndi to Walima, corporate summits to cultural nights — we craft seamless experiences across Islamabad & Rawalpindi.',
      onPrimary: () => Navigator.pushNamed(context, '/services'),
      onSecondary: () => Navigator.pushNamed(context, '/contact'),
    );

    // ================ SERVICES PREVIEW (localized) ================
    final servicesPreview = Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: MaxWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              title: 'Bespoke Services for Pakistan',
              subtitle:
                  'South Asian weddings, corporate events, cultural nights and destination celebrations',
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final cols = w < 700
                    ? 1
                    : w < 1100
                    ? 2
                    : 3;
                const gap = 18.0;
                final itemWidth = (w - gap * (cols - 1)) / cols;
                final items = const [
                  _ServiceMiniCard(
                    emoji: '💐',
                    title: 'South Asian Weddings',
                    desc:
                        'Mehndi, Mayun, Baraat & Walima — full planning, guest hospitality and execution.',
                  ),
                  _ServiceMiniCard(
                    emoji: '📜',
                    title: 'Nikah Ceremonies',
                    desc:
                        'Intimate décor, seating, imam coordination and elegant photo-friendly setups.',
                  ),
                  _ServiceMiniCard(
                    emoji: '🏢',
                    title: 'Corporate Events',
                    desc:
                        'Conferences, launches & town halls with precise run-of-show and AV.',
                  ),
                  _ServiceMiniCard(
                    emoji: '🎶',
                    title: 'Qawwali & Cultural Nights',
                    desc:
                        'Artist curation, staging, ambient lighting, sound and guest flow.',
                  ),
                  _ServiceMiniCard(
                    emoji: '🏔️',
                    title: 'Destination (North)',
                    desc:
                        'Bhurban, Murree, Nathia Gali — logistics, vendor management & travel.',
                  ),
                  _ServiceMiniCard(
                    emoji: '🎨',
                    title: 'Design & Décor',
                    desc:
                        'Mood boards, stages, florals, tablescapes, branding & wayfinding.',
                  ),
                ];

                return Column(
                  children: [
                    Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: items
                          .map((e) => SizedBox(width: itemWidth, child: e))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          side: const BorderSide(
                            color: AppColors.primaryGold,
                            width: 2,
                          ),
                          foregroundColor: AppColors.primaryGold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/services'),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('View All Services'),
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

    // ================ STATS (FIXED OVERFLOW) ================
    final stats = Container(
      color: AppColors.navyBlue,
      padding: const EdgeInsets.symmetric(vertical: 60),
      width: double.infinity,
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Excellence Measured',
              subtitle:
                  'Three decades of creating unforgettable celebrations and exceeding expectations',
              titleColor: Colors.white,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final cols = w < 380
                    ? 1
                    : w < 900
                    ? 2
                    : 4;

                // 🔧 FIXED: More generous aspect ratios to prevent overflow
                final ratio = w < 360
                    ? 0.65 // Shorter/wider for very small screens
                    : w < 480
                    ? 0.70 // Increased from 0.88
                    : w < 700
                    ? 0.75 // Increased from 1.0
                    : 0.85; // Decreased from 1.15 for better proportion

                final spacing = w < 420 ? 16.0 : 24.0;

                return GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: w < 600 ? 8 : 0),
                  shrinkWrap: true,
                  crossAxisCount: cols,
                  childAspectRatio: ratio, // <-- Fixed responsive height ratios
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StatCounter(target: 250, label: 'Events Orchestrated'),
                    StatCounter(target: 8, label: 'Years of Excellence'),
                    StatCounter(target: 120, label: 'Venue Partners'),
                    StatCounter(target: 99, label: 'Client Satisfaction'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

    // ================ ABOUT (6 cards) ================
    final about = Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(vertical: 80),
      width: double.infinity,
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Our Distinguished Heritage',
              subtitle:
                  'Three decades of creating exceptional moments with unwavering dedication to traditional sophistication',
            ),
            const SizedBox(height: 36),
            LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final cols = w < 700
                    ? 1
                    : w < 1100
                    ? 2
                    : 3;
                const gap = 24.0;
                final itemWidth = (w - gap * (cols - 1)) / cols;

                const cards = [
                  AboutCard(
                    icon: '👑',
                    title: 'Royal Legacy',
                    body:
                        'Since 2017, serving distinguished clientele with traditional values and sophisticated celebrations.',
                  ),
                  AboutCard(
                    icon: '🏛️',
                    title: 'Prestigious Venues',
                    body:
                        'Partnerships with leading hotels, clubs and convention centers across the twin cities.',
                  ),
                  AboutCard(
                    icon: '✨',
                    title: 'White-Glove Service',
                    body:
                        'Personalized attention, meticulous planning and flawless execution for every detail.',
                  ),
                  AboutCard(
                    icon: '🤝',
                    title: 'Vendor Network',
                    body:
                        'Top-tier caterers, décor, AV & performers — curated, vetted, and managed end-to-end.',
                  ),
                  AboutCard(
                    icon: '📊',
                    title: 'Budget & Timeline',
                    body:
                        'Transparent budgets, approvals & milestone tracking to keep events on time and on budget.',
                  ),
                  AboutCard(
                    icon: '📞',
                    title: '24/7 Coordination',
                    body:
                        'Dedicated event manager with round-the-clock support from planning to pack-down.',
                  ),
                ];

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: cards
                      .map((card) => SizedBox(width: itemWidth, child: card))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );

    // ================ FEATURED PORTFOLIO (horizontal) ================
    final portfolioStrip = Container(
      color: AppColors.warmWhite,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: MaxWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              title: 'Portfolio of Excellence',
              subtitle: 'A glimpse of our most memorable celebrations',
            ),
            const SizedBox(height: 10),
            _HorizontalCards(
              cards: const [
                _EventCard(
                  tag: 'Luxury',
                  emoji: '💍',
                  date: '15 Sep 2024',
                  title: 'Serena Hotel — Shaadi Reception',
                  location: 'Islamabad',
                ),
                _EventCard(
                  tag: 'Executive',
                  emoji: '🏢',
                  date: '08 Oct 2024',
                  title: 'Corporate Summit — Jinnah Convention Centre',
                  location: 'Islamabad',
                ),
                _EventCard(
                  tag: 'Cultural',
                  emoji: '🎶',
                  date: '31 Dec 2024',
                  title: 'Qawwali Night — Shakarparian Open-Air',
                  location: 'Islamabad',
                ),
                _EventCard(
                  tag: 'Destination',
                  emoji: '🏔️',
                  date: '20 Jan 2025',
                  title: 'Destination Wedding — PC Bhurban',
                  location: 'Murree Hills',
                ),
                _EventCard(
                  tag: 'Corporate',
                  emoji: '🎤',
                  date: '12 Feb 2025',
                  title: 'Town Hall — Bahria Auditorium',
                  location: 'Rawalpindi',
                ),
                _EventCard(
                  tag: 'Intimate',
                  emoji: '💫',
                  date: '05 Mar 2025',
                  title: 'Nikkah — Private Lawn Setup',
                  location: 'Islamabad',
                ),
              ],
              onMore: () => Navigator.pushNamed(context, '/portfolio'),
            ),
          ],
        ),
      ),
    );

    // ================ TESTIMONIALS (auto-slide) ================
    final testimonials = Container(
      decoration: BoxDecoration(gradient: royalGradient),
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: MaxWidth(
        child: Column(
          children: const [
            SectionHeader(
              title: 'Client Love',
              subtitle: 'What our clients across Pakistan say',
              titleColor: Colors.white,
            ),
            SizedBox(height: 16),
            _TestimonialsCarousel(),
          ],
        ),
      ),
    );

    // ================ PARTNERS / VENUES STRIP ================
    final partners = Container(
      color: AppColors.pearl,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: MaxWidth(
        child: Column(
          children: [
            Text(
              'Trusted by leading venues & partners in Islamabad–Rawalpindi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const _PartnersRow(),
          ],
        ),
      ),
    );

    // ================ AWARDS RIBBON ================
    final awards = Container(
      color: AppColors.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: MaxWidth(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: const [
            _AwardChip('🏆  Event Planner of the Year 2024'),
            _AwardChip('💎  Platinum Service Award 2023'),
            _AwardChip('🥇  Best Wedding Planner 2023'),
            _AwardChip('🎖️  Corporate Excellence 2022'),
          ],
        ),
      ),
    );

    // ================ CTA BANNER ================
    final ctaBanner = Container(
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
              'Ready to plan your Islamabad event?',
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
              label: const Text('Start Your Inquiry'),
            ),
          ],
        ),
      ),
    );

    // ================ NEWSLETTER ================
    final newsletter = Container(
      color: AppColors.lightGold,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: const MaxWidth(child: _NewsletterBar()),
    );

    // ================ FAQ (Pakistan-aware) ================
    final faq = Container(
      color: AppColors.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: MaxWidth(
        child: Column(
          children: [
            const SectionHeader(
              title: 'Frequently Asked Questions',
              subtitle:
                  'Timelines, budgets and logistics for Pakistan-based events',
              titleColor: Colors.white,
            ),
            const SizedBox(height: 12),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white24,
                listTileTheme: const ListTileThemeData(
                  textColor: Colors.white70,
                ),
              ),
              child: const _FaqList(),
            ),
          ],
        ),
      ),
    );

    // ================ PAGE ASSEMBLY ================
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
              servicesPreview,
              stats, // <- overflow-safe now
              about,
              portfolioStrip,
              testimonials,
              partners,
              awards,
              ctaBanner,
              newsletter,
              faq,
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===================================================================
/// HERO SLIDER
/// ===================================================================
class _HeroSlider extends StatefulWidget {
  final List<String> images;
  final String title;
  final String subtitle;
  final String body;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const _HeroSlider({
    required this.images,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  State<_HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<_HeroSlider> {
  final _ctrl = PageController();
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoplay();
  }

  void _startAutoplay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_ctrl.hasClients || widget.images.length <= 1) return;
      final next = (_index + 1) % widget.images.length;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isNarrow = w < 720;

        // Responsive hero height (safe clamps for phones/desktops)
        final heroH = (w * (isNarrow ? 0.9 : 0.45)).clamp(420.0, 680.0);

        final double titleSize = w < 360
            ? 32
            : w < 540
            ? 40
            : w < 900
            ? 56
            : 72;

        return MouseRegion(
          onEnter: (_) => _timer?.cancel(),
          onExit: (_) => _startAutoplay(),
          child: GestureDetector(
            onPanDown: (_) => _timer?.cancel(),
            onPanEnd: (_) => _startAutoplay(),
            child: SizedBox(
              height: heroH,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Slides
                  ClipRect(
                    child: PageView.builder(
                      controller: _ctrl,
                      itemCount: widget.images.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (_, i) => _HeroImage(path: widget.images[i]),
                    ),
                  ),

                  // Overlay for readability (burgundy -> transparent -> dark)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.deepBurgundy.withOpacity(0.55),
                          AppColors.deepBurgundy.withOpacity(0.25),
                          Colors.black.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Align(
                    alignment: isNarrow
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: MaxWidth(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 16 : 24,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: isNarrow
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Builder(
                                builder: (context) {
                                  final shaderWidth = w
                                      .clamp(300, 1200)
                                      .toDouble();
                                  final shaderHeight = (titleSize * 1.25);
                                  return Text(
                                    widget.title,
                                    textAlign: isNarrow
                                        ? TextAlign.center
                                        : TextAlign.start,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          fontSize: titleSize,
                                          height: 1.1,
                                          foreground: Paint()
                                            ..shader =
                                                const LinearGradient(
                                                  colors: [
                                                    Colors.white,
                                                    AppColors.lightGold,
                                                    AppColors.primaryGold,
                                                  ],
                                                ).createShader(
                                                  Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    shaderWidth,
                                                    shaderHeight,
                                                  ),
                                                ),
                                        ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.subtitle,
                                textAlign: isNarrow
                                    ? TextAlign.center
                                    : TextAlign.start,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(color: AppColors.lightGold),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.body,
                                textAlign: isNarrow
                                    ? TextAlign.center
                                    : TextAlign.start,
                                softWrap: true,
                                maxLines: isNarrow ? 3 : 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(color: Colors.white70),
                              ),
                              const SizedBox(height: 26),
                              Wrap(
                                alignment: isNarrow
                                    ? WrapAlignment.center
                                    : WrapAlignment.start,
                                spacing: 16,
                                runSpacing: 12,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryGold,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: widget.onPrimary,
                                    child: const Text('Discover Our Services'),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: widget.onSecondary,
                                    child: const Text('Get a Quote'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Indicators
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.images.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: i == _index ? 22 : 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              i == _index ? 0.95 : 0.55,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String path;
  const _HeroImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');

    final img = isNetwork
        ? Image.network(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          );

    return Stack(
      fit: StackFit.expand,
      children: [
        img,
        // subtle vignette on edges
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0x33000000)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() => Container(
    color: const Color(0xFF2D2D2D),
    alignment: Alignment.center,
    child: const Icon(
      Icons.image_not_supported_outlined,
      size: 40,
      color: Colors.white70,
    ),
  );
}

// ===================== LOCAL WIDGETS =====================

// mini service card
class _ServiceMiniCard extends StatelessWidget {
  final String emoji, title, desc;
  const _ServiceMiniCard({
    required this.emoji,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x11000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.deepBurgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ===================== PORTFOLIO CAROUSEL (scroll + autoplay + arrows) =====================
class _HorizontalCards extends StatefulWidget {
  final List<_EventCard> cards;
  final VoidCallback onMore;
  const _HorizontalCards({required this.cards, required this.onMore});

  @override
  State<_HorizontalCards> createState() => _HorizontalCardsState();
}

class _HorizontalCardsState extends State<_HorizontalCards> {
  final _scrollCtrl = ScrollController();
  Timer? _timer;
  double _step = 360; // updated in build from layout

  @override
  void initState() {
    super.initState();
    _startAutoplay();
  }

  void _startAutoplay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _autoStep());
  }

  void _pauseAutoplay() => _timer?.cancel();
  void _resumeAutoplay() => _startAutoplay();

  void _autoStep() {
    if (!_scrollCtrl.hasClients) return;
    final max = _scrollCtrl.position.maxScrollExtent;
    var next = _scrollCtrl.offset + _step;
    if (next > max) next = 0; // loop
    _scrollCtrl.animateTo(
      next,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollBy(double delta) {
    if (!_scrollCtrl.hasClients) return;
    _pauseAutoplay();
    final max = _scrollCtrl.position.maxScrollExtent;
    final target = (_scrollCtrl.offset + delta).clamp(0.0, max);
    _scrollCtrl
        .animateTo(
          target,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        )
        .whenComplete(_resumeAutoplay);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final cardW = w < 400
            ? w - 32
            : w < 800
            ? (w / 1.3)
            : 420.0;
        _step = cardW + 14; // keep in sync with separator

        final arrowSize = 36.0;

        return MouseRegion(
          onEnter: (_) => _pauseAutoplay(),
          onExit: (_) => _resumeAutoplay(),
          child: GestureDetector(
            onPanDown: (_) => _pauseAutoplay(),
            onPanEnd: (_) => _resumeAutoplay(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: ListView.separated(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, i) =>
                            SizedBox(width: cardW, child: widget.cards[i]),
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemCount: widget.cards.length,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: widget.onMore,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryGold,
                      ),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Explore Portfolio'),
                    ),
                  ],
                ),
                // left arrow
                Positioned(
                  left: 4,
                  child: _ArrowButton(
                    size: arrowSize,
                    isLeft: true,
                    onTap: () => _scrollBy(-_step),
                  ),
                ),
                // right arrow
                Positioned(
                  right: 4,
                  child: _ArrowButton(
                    size: arrowSize,
                    isLeft: false,
                    onTap: () => _scrollBy(_step),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final double size;
  final bool isLeft;
  final VoidCallback onTap;
  const _ArrowButton({
    required this.size,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            isLeft ? Icons.chevron_left : Icons.chevron_right,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String tag, emoji, date, title, location;
  const _EventCard({
    required this.tag,
    required this.emoji,
    required this.date,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.pearl,
        border: Border.all(color: const Color(0xFFE7E7E7), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x12000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Tag(tag),
          const SizedBox(height: 10),
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          Text(
            date,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.deepBurgundy,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ===================== UPDATED TESTIMONIALS (autoplay) =====================
class _TestimonialsCarousel extends StatefulWidget {
  const _TestimonialsCarousel();

  @override
  State<_TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<_TestimonialsCarousel> {
  final _ctrl = PageController(viewportFraction: 0.92);
  int _index = 0;
  Timer? _timer;
  int _len = 0;

  @override
  void initState() {
    super.initState();
    _startAutoplay();
  }

  void _startAutoplay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_ctrl.hasClients || _len <= 1) return;
      final next = (_index + 1) % _len;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 6 testimonials
    final items = const [
      _TestimonialCard(
        initials: 'A&H',
        quote:
            'Hamari Mehndi se Walima tak sab kuch bohat khoobsurati se manage hua — décor, timing, sab perfect!',
        author: 'Ayesha & Hamza',
        meta: 'Shaadi Events, 2024 (Islamabad)',
      ),
      _TestimonialCard(
        initials: 'MK',
        quote:
            'Our annual summit was flawlessly executed — staging, AV and hospitality were world-class.',
        author: 'Mr. Khan',
        meta: 'CEO, Leading Financial Group',
      ),
      _TestimonialCard(
        initials: 'SA',
        quote:
            'Family celebration with grace and warmth. Team was responsive round-the-clock.',
        author: 'Sara Ali',
        meta: 'Private Event, Rawalpindi',
      ),
      _TestimonialCard(
        initials: 'MF',
        quote:
            'Walima décor aur guest flow outstanding tha. Vendor coordination bilkul seamless.',
        author: 'Malik Family',
        meta: 'Walima, Islamabad Club',
      ),
      _TestimonialCard(
        initials: 'ZH',
        quote:
            'Town-hall production, screen content aur sound sab top-notch. On-time aur on-brand delivery.',
        author: 'Zainab H.',
        meta: 'HR Director, ZenTech',
      ),
      _TestimonialCard(
        initials: 'U&H',
        quote:
            'Engagement setup at Monal was magical — floral styling aur lighting ne ambience bana diya.',
        author: 'Umair & Hira',
        meta: 'Engagement, Pir Sohawa',
      ),
    ];

    _len = items.length;

    return MouseRegion(
      onEnter: (_) => _timer?.cancel(), // pause on hover
      onExit: (_) => _startAutoplay(), // resume
      child: Column(
        children: [
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _ctrl,
              itemCount: items.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: items[i],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              items.length,
              (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i == _index ? Colors.white : Colors.white38,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== UPDATED TESTIMONIAL CARD =====================
class _TestimonialCard extends StatelessWidget {
  final String initials, quote, author, meta;
  const _TestimonialCard({
    required this.initials,
    required this.quote,
    required this.author,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.11),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.35),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote (clamped to avoid overflow inside fixed-height carousel)
          Text(
            '"$quote"',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: t.bodyLarge!.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryGold,
                radius: 18,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleSmall!.copyWith(color: Colors.white),
                    ),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelMedium!.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// partners row (Islamabad/Rawalpindi venues)
class _PartnersRow extends StatelessWidget {
  const _PartnersRow();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.titleSmall!.copyWith(color: AppColors.textSecondary);

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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items
            .map(
              (e) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warmWhite,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFEAEAEA), width: 2),
                ),
                child: Text(e, style: style, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AwardChip extends StatelessWidget {
  final String text;
  const _AwardChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ===================== NEWSLETTER BAR (Firestore + Circular Success Toast) =====================
class _NewsletterBar extends StatefulWidget {
  const _NewsletterBar();

  @override
  State<_NewsletterBar> createState() => _NewsletterBarState();
}

class _NewsletterBarState extends State<_NewsletterBar> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validate(String? v) {
    v = v?.trim() ?? '';
    if (v.isEmpty) return 'Email required';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
    if (!ok) return 'Enter a valid email';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final email = _controller.text.trim().toLowerCase();

    try {
      final docId = email.replaceAll('/', '_'); // safe ID
      await FirebaseFirestore.instance.collection('subscribers').doc(docId).set(
        {'email': email, 'createdAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );

      if (!mounted) return;
      _controller.clear();
      await _showSuccessToast(); // circular success UI
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Subscription failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // Circular, on-brand success toast (tick only — no text)
  Future<void> _showSuccessToast() async {
    if (!mounted) return;
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (ctx) => IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Opacity(
              opacity: value.clamp(0.0, 1.0).toDouble(),
              child: Transform.scale(scale: 0.9 + 0.1 * value, child: child),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, _) => Container(
                    width: 140 * t,
                    height: 140 * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGold.withOpacity(
                        0.14 * (1 - (t * 0.8)),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: goldGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [
                      BoxShadow(blurRadius: 28, color: Color(0x33000000)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    await Future.delayed(const Duration(milliseconds: 1400));
    entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'Stay in the loop — Pakistan',
          style: t.titleLarge!.copyWith(
            color: AppColors.deepBurgundy,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Trends, seasonal ideas & exclusive offers across Islamabad/Rawalpindi.',
          style: t.bodyMedium!.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: TextFormField(
                  controller: _controller,
                  validator: _validate,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'you@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _busy ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Subscribe'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// FAQ
class _FaqList extends StatelessWidget {
  const _FaqList();

  @override
  Widget build(BuildContext context) {
    final items = const [
      (
        'How far in advance should we book?',
        'Peak wedding season in Pakistan is Nov–Mar. Book 6–12 months ahead for prime weekend dates.',
      ),
      (
        'What included in planning packages?',
        'Vendor curation & contracts, timelines, design, rehearsals, on-day management and post-event wrap.',
      ),
      (
        'Do you handle destination events (North)?',
        'Yes — Bhurban, Murree, Nathia Gali and beyond. We manage venue scouting, travel, permits and local vendors.',
      ),
      (
        'Can we use our preferred vendors?',
        'Absolutely. We integrate your partners and manage them to our quality standards.',
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
