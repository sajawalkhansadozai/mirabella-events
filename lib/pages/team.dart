// lib/pages/team.dart
import 'package:flutter/material.dart';
import '../widgets/common.dart';
import '../theme.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Clamp text scale so very large accessibility sizes don't overflow
    final mq = MediaQuery.of(context);
    final clamped = mq.copyWith(
      textScaler: TextScaler.linear(
        MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3),
      ),
    );

    // ✅ Two members (PNG shown here; use .jpg if your file is JPG)
    final members = const [
      _Member(
        imageAsset: 'assets/images/team/mustafa.png',
        name: 'Mustafa',
        role: 'Founder & Lead Planner',
        bio:
            'Client-first planning, vendor management and end-to-end show calling.',
      ),
      _Member(
        imageAsset: 'assets/images/team/aqib.png',
        name: 'Aqib Khan',
        role: 'Operations & Production',
        bio:
            'Logistics, AV & staging execution — from load-in to flawless showtime.',
      ),
    ];

    // ===== HERO (responsive) =====
    final hero = Container(
      decoration: BoxDecoration(gradient: royalGradient),
      padding: const EdgeInsets.symmetric(vertical: 56),
      width: double.infinity,
      child: MaxWidth(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final titleSize = w < 380
                ? 28.0
                : w < 640
                ? 34.0
                : 42.0;

            return Column(
              children: [
                Text(
                  'Meet Our Distinguished Team',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: titleSize,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Seasoned professionals dedicated to bringing your vision to life',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.white70),
                ),
              ],
            );
          },
        ),
      ),
    );

    // ===== VALUES =====
    final values = MaxWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: const [
            SectionHeader(
              title: 'Our Values',
              subtitle: 'The habits that make our work feel effortless on-site',
            ),
            SizedBox(height: 8),
            _ChipRow(
              items: [
                'Courtesy',
                'Precision',
                'Creativity',
                'Reliability',
                'Discretion',
                'Accountability',
                'Hospitality',
                'Safety first',
              ],
            ),
          ],
        ),
      ),
    );

    // ===== TEAM GRID (responsive & overflow-proof) =====
    final grid = Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: MaxWidth(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final cols = w > 900 ? 2 : (w > 600 ? 2 : 1); // 1 col on phones
            const gap = 24.0;
            final cardWidth = cols == 1 ? w : (w - gap * (cols - 1)) / cols;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: members
                  .map(
                    (m) => ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 260),
                      child: SizedBox(
                        width: cardWidth,
                        child: _TeamMemberCard(
                          member: m,
                          onContact: () => Navigator.pushNamed(
                            context,
                            '/contact',
                            arguments: {
                              'attention': m.name,
                              'context': 'Team page',
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );

    // ===== BEHIND THE SCENES =====
    final behindScenes = Container(
      color: AppColors.pearl,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: MaxWidth(
        child: Column(
          children: const [
            SectionHeader(
              title: 'Behind the Scenes Roles',
              subtitle: 'It takes a village to deliver a flawless show',
            ),
            SizedBox(height: 8),
            _ChipRow(
              items: [
                'Show-caller',
                'Stage manager',
                'Lighting engineer',
                'Sound engineer',
                'Runners',
                'Guest relations',
                'Security liaison',
                'Backline tech',
                'Floor manager',
                'Content ops',
                'Catering liaison',
              ],
            ),
          ],
        ),
      ),
    );

    // ===== CTA =====
    final cta = Container(
      decoration: BoxDecoration(gradient: goldGradient),
      padding: const EdgeInsets.symmetric(vertical: 44),
      child: MaxWidth(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Text(
              'Want to collaborate with our team?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              icon: const Icon(Icons.mail),
              label: const Text('Get in touch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
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

    return MediaQuery(
      data: clamped,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [hero, values, grid, behindScenes, cta],
        ),
      ),
    );
  }
}

/* ======================= Local models + widgets ======================= */

class _Member {
  final String imageAsset; // JPG or PNG — use exact filename
  final String name;
  final String role;
  final String bio;
  const _Member({
    required this.imageAsset,
    required this.name,
    required this.role,
    required this.bio,
  });
}

class _TeamMemberCard extends StatelessWidget {
  final _Member member;
  final VoidCallback onContact;
  const _TeamMemberCard({required this.member, required this.onContact});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, c) {
        // 🔺 2x taller image area (previously 0.56 * width)
        // Clamp wide enough so faces show clearly, but still safe on mobile.
        final imgH = (c.maxWidth * 0.56 * 2).clamp(320.0, 640.0);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEFEFEF), width: 2),
            boxShadow: const [
              BoxShadow(blurRadius: 16, color: Color(0x11000000)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bigger, centered image so the face isn't cropped out at the top.
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  height: imgH,
                  width: double.infinity,
                  child: Image.asset(
                    member.imageAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center, // 🔺 center focus
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0x11000000),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.image_not_supported, size: 28),
                          SizedBox(height: 6),
                          Text('Photo unavailable'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleLarge!.copyWith(
                        color: AppColors.deepBurgundy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.role.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelLarge!.copyWith(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(member.bio, style: t.bodyMedium, softWrap: true),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: onContact,
                        icon: const Icon(Icons.person_add_alt_1),
                        label: const Text('Contact'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primaryGold,
                            width: 2,
                          ),
                          foregroundColor: AppColors.primaryGold,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<String> items;
  const _ChipRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final cols = w > 1200
            ? 6
            : w > 900
            ? 5
            : w > 700
            ? 4
            : w > 500
            ? 3
            : 2;
        const gap = 10.0;
        final itemW = (w - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map(
                (txt) => SizedBox(
                  width: itemW,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warmWhite,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: const Color(0xFFEAEAEA),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      txt,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
