// lib/pages/home.dart
import 'dart:async'; // for autoplay timer
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:eventmanagement/widgets/cards.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/footer.dart';
import 'home_price_calculator.dart';

// parts (keep these files in the same folder)
part 'home_hero_section.dart';
part 'home_content_sections.dart';

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

    // Key to scroll to the calculator section
    final calculatorKey = GlobalKey();

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
      onSecondary: () {
        final ctx = calculatorKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
            alignment: 0.1,
          );
        }
      },
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
                    ? 0.65
                    : w < 480
                    ? 0.70
                    : w < 700
                    ? 0.75
                    : 0.85;

                final spacing = w < 420 ? 16.0 : 24.0;

                return GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: w < 600 ? 8 : 0),
                  shrinkWrap: true,
                  crossAxisCount: cols,
                  childAspectRatio: ratio,
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

    // ================ PRICE CALCULATOR ================
    final priceCalculator = Container(
      key: calculatorKey,
      color: AppColors.pearl,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: MaxWidth(child: PriceCalculator()),
    );

    // ================ CTA BANNER ================
    final ctaBanner = Container(
      decoration: BoxDecoration(gradient: goldGradient),
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: MaxWidth(
        child: Column(
          children: [
            const Text(
              'Ready to Plan Your Perfect Event?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Get in touch with our expert team today',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Contact Us Now'),
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
              priceCalculator,
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
