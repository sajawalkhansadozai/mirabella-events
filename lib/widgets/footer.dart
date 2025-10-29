import 'package:flutter/material.dart';
import '../theme.dart';
import 'common.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final t = Theme.of(context).textTheme;

    // Clamp extreme text scaling to avoid layout explosions
    final clampedMQ = mq.copyWith(
      textScaler: TextScaler.linear(
        MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3).toDouble(),
      ),
    );

    Widget linksCol(String title, List<_FooterLink> links) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            softWrap: true,
            style: t.titleLarge!.copyWith(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...links.map(
            (l) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: InkWell(
                onTap: l.onTap,
                child: Text(
                  l.label,
                  softWrap: true,
                  style: t.bodyLarge!.copyWith(color: const Color(0xFFBDC3C7)),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final brandCol = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mirabella Events',
          softWrap: true,
          style: t.titleLarge!.copyWith(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'For over three decades, Mirabella Events has been the premier choice for '
          'discerning clients seeking extraordinary celebrations.',
          softWrap: true,
          style: t.bodyLarge!.copyWith(color: const Color(0xFFBDC3C7)),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _SocialBubble('📘', 'Facebook'),
            _SocialBubble('📷', 'Instagram'),
            _SocialBubble('🐦', 'Twitter/X'),
            _SocialBubble('💼', 'LinkedIn'),
            _SocialBubble('📌', 'Pinterest'),
            _SocialBubble('📺', 'YouTube'),
          ],
        ),
      ],
    );

    final servicesCol = linksCol('Our Services', [
      _FooterLink(
        'Luxury Wedding Planning',
        () => Navigator.pushNamed(context, '/services'),
      ),
      _FooterLink(
        'Corporate Events',
        () => Navigator.pushNamed(context, '/services'),
      ),
      _FooterLink(
        'Social Celebrations',
        () => Navigator.pushNamed(context, '/services'),
      ),
      _FooterLink(
        'Award Ceremonies',
        () => Navigator.pushNamed(context, '/services'),
      ),
      _FooterLink(
        'Exclusive Galas',
        () => Navigator.pushNamed(context, '/services'),
      ),
      _FooterLink(
        'Milestone Events',
        () => Navigator.pushNamed(context, '/services'),
      ),
      _FooterLink(
        'Venue Consultation',
        () => Navigator.pushNamed(context, '/contact'),
      ),
      _FooterLink(
        'Event Design Services',
        () => Navigator.pushNamed(context, '/contact'),
      ),
    ]);

    final companyCol = linksCol('Company', [
      _FooterLink(
        'About Our Heritage',
        () => Navigator.pushNamed(context, '/heritage'),
      ),
      _FooterLink('Meet Our Team', () => Navigator.pushNamed(context, '/team')),
      _FooterLink(
        'Event Portfolio',
        () => Navigator.pushNamed(context, '/portfolio'),
      ),
      _FooterLink(
        'Client Testimonials',
        () => Navigator.pushNamed(context, '/portfolio'),
      ),
      _FooterLink(
        'Awards & Recognition',
        () => Navigator.pushNamed(context, '/heritage'),
      ),
      _FooterLink(
        'Career Opportunities',
        () => Navigator.pushNamed(context, '/contact'),
      ),
      _FooterLink(
        'Press & Media',
        () => Navigator.pushNamed(context, '/contact'),
      ),
      _FooterLink(
        'Vendor Partnerships',
        () => Navigator.pushNamed(context, '/contact'),
      ),
    ]);

    final resourcesCol = linksCol('Resources', [
      _FooterLink(
        'Planning Guide',
        () => Navigator.pushNamed(context, '/process'),
      ),
      _FooterLink(
        'Venue Directory',
        () => Navigator.pushNamed(context, '/contact'),
      ),
      _FooterLink(
        'Vendor Network',
        () => Navigator.pushNamed(context, '/contact'),
      ),
      _FooterLink('Event FAQ', () => Navigator.pushNamed(context, '/contact')),
      _FooterLink(
        'Budget Calculator',
        () => Navigator.pushNamed(context, '/contact'),
      ),
      _FooterLink(
        'Style Gallery',
        () => Navigator.pushNamed(context, '/portfolio'),
      ),
      _FooterLink('Newsletter', () => Navigator.pushNamed(context, '/contact')),
      _FooterLink(
        'Client Portal',
        () => Navigator.pushNamed(context, '/contact'),
      ),
    ]);

    return MediaQuery(
      data: clampedMQ,
      child: Container(
        color: AppColors.graphite,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        child: Column(
          children: [
            MaxWidth(
              maxWidth: 1200,
              child: LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  // Decide columns by width
                  final cols = w >= 1100
                      ? 4
                      : w >= 700
                      ? 2
                      : 1;
                  const gap = 32.0;
                  final itemWidth = (w - gap * (cols - 1)) / cols;

                  // Use a Wrap so tile height grows with content (no fixed aspect ratio)
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      SizedBox(width: itemWidth, child: brandCol),
                      SizedBox(width: itemWidth, child: servicesCol),
                      SizedBox(width: itemWidth, child: companyCol),
                      SizedBox(width: itemWidth, child: resourcesCol),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 36),
            const Divider(color: Color(0xFF495057), thickness: 2),
            const SizedBox(height: 20),
            MaxWidth(
              child: Text(
                '© ${DateTime.now().year} Mirabella Events. All Rights Reserved. '
                '| Privacy Policy | Terms of Service | Accessibility',
                textAlign: TextAlign.center,
                softWrap: true,
                style: t.bodyMedium!.copyWith(color: const Color(0xFF95A5A6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialBubble extends StatelessWidget {
  final String emoji;
  final String label;
  const _SocialBubble(this.emoji, this.label);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: goldGradient,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(blurRadius: 16, color: Color(0x33000000)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}

class _FooterLink {
  final String label;
  final VoidCallback onTap;
  _FooterLink(this.label, this.onTap);
}
