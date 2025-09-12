import 'package:flutter/material.dart';
import '../widgets/common.dart';
// Removed: import '../widgets/cards.dart'; // no longer needed, we use custom card here
import '../theme.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    // Enhanced responsive design with screen size detection
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isVerySmall = width < 360;
    final isSmall = width < 600;
    final isMedium = width < 900;
    final isTablet = width >= 600 && width < 900;

    // Clamp text scale more aggressively for mobile
    final textScale = MediaQuery.textScaleFactorOf(context);
    final clampedScale = isVerySmall
        ? textScale.clamp(0.8, 1.0) // More aggressive clamping
        : isSmall
        ? textScale.clamp(0.85, 1.1) // Reduced max scale
        : textScale.clamp(0.9, 1.2); // Reduced max scale

    final clamped = MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(clampedScale.toDouble()));

    // Responsive padding
    final horizontalPadding = isVerySmall
        ? 12.0
        : isSmall
        ? 16.0
        : isMedium
        ? 24.0
        : 32.0;

    final verticalPadding = isSmall ? 40.0 : 60.0;
    final sectionSpacing = isSmall ? 16.0 : 24.0;

    // (category, badge, date, title, location, tag, image)
    final events = <(String, String, String, String, String, String, String)>[
      // Weddings
      (
        'wedding',
        'Featured',
        'September 15, 2024',
        'The Williams Estate Wedding',
        'Rosewood Manor, English Countryside',
        'Classical Garden Ceremony',
        'assets/portfolio/wedding_1.jpeg',
      ),
      (
        'wedding',
        'Luxury',
        'Jan 20, 2025',
        'Royal Palace Wedding',
        'Château Elegance, French Riviera',
        'Destination Wedding',
        'assets/portfolio/wedding_2.jpeg',
      ),
      (
        'wedding',
        'Intimate',
        'Nov 11, 2024',
        'Nikkah by the Lake',
        'Shakarparian Park, Islamabad',
        'Sunset Ceremony',
        'assets/portfolio/wedding_3.jpeg',
      ),
      (
        'wedding',
        'Signature',
        'Mar 02, 2025',
        'Baraat at Islamabad Club',
        'Islamabad Club',
        'Traditional Grandeur',
        'assets/portfolio/wedding_4.jpg',
      ),

      // Corporate
      (
        'corporate',
        'Executive',
        'Oct 8, 2024',
        'Heritage Bank Annual Gala',
        'Grand Ballroom, Metropolitan Hotel',
        'Executive Business Event',
        'assets/portfolio/corp_1.jpeg',
      ),
      (
        'corporate',
        'Innovation',
        'Apr 5, 2025',
        'Product Launch Spectacular',
        'Innovation Center, Tech District',
        'Corporate Launch',
        'assets/portfolio/corp_2.jpg',
      ),
      (
        'corporate',
        'Townhall',
        'Feb 12, 2025',
        'ZenTech Global Town Hall',
        'Bahria Auditorium, Rawalpindi',
        'Employee Experience',
        'assets/portfolio/corp_3.jpg',
      ),
      (
        'corporate',
        'Summit',
        'Aug 22, 2024',
        'Leaders Strategy Summit',
        'Jinnah Convention Centre, Islamabad',
        'C-Suite Program',
        'assets/portfolio/corp_4.jpg',
      ),

      // Social
      (
        'social',
        'Milestone',
        'Nov 22, 2024',
        'Golden Anniversary Celebration',
        'Historic Mansion, Uptown District',
        '50 Years of Love',
        'assets/portfolio/social_1.jpg',
      ),
      (
        'social',
        'Elegant',
        'Mar 10, 2025',
        'Spring Garden Party',
        'Botanical Gardens Estate',
        'Outdoor Celebration',
        'assets/portfolio/social_2.jpg',
      ),
      (
        'social',
        'Chic',
        'May 18, 2025',
        'Bridal Shower Brunch',
        'Private Lawn, F-6 Islamabad',
        'All-White Theme',
        'assets/portfolio/social_3.jpg',
      ),
      (
        'social',
        'VIP',
        'Jul 14, 2024',
        'Celebrity Birthday Soirée',
        'Serena Rooftop',
        'Red-Carpet Night',
        'assets/portfolio/social_4.jpg',
      ),

      // Galas
      (
        'gala',
        'Premium',
        'Dec 31, 2024',
        'New Year\'s Excellence Gala',
        'Metropolitan Museum of Art',
        'Black Tie Sophistication',
        'assets/portfolio/gala_1.jpg',
      ),
      (
        'gala',
        'Charity',
        'Sep 7, 2024',
        'Hearts for Hope Charity Ball',
        'Serena Hotel, Islamabad',
        'Fundraising Gala',
        'assets/portfolio/gala_2.jpg',
      ),
      (
        'gala',
        'Cultural',
        'Oct 28, 2024',
        'Qawwali Heritage Night',
        'Shakarparian Open-Air',
        'Sufi Evenings',
        'assets/portfolio/gala_3.jpg',
      ),
      (
        'gala',
        'Royal',
        'Jan 10, 2025',
        'Winter Masquerade',
        'Pearl Continental, Bhurban',
        'Formal Ball',
        'assets/portfolio/gala_4.jpg',
      ),

      // Ceremonies
      (
        'ceremony',
        'Distinguished',
        'Feb 14, 2025',
        'Excellence Awards Ceremony',
        'Chamber of Commerce Hall',
        'Recognition Event',
        'assets/portfolio/ceremony_1.jpeg',
      ),
      (
        'ceremony',
        'Academic',
        'Jun 1, 2025',
        'Graduate Honors Convocation',
        'Convention Centre',
        'University Ceremony',
        'assets/portfolio/ceremony_2.jpeg',
      ),
      (
        'ceremony',
        'Cultural',
        'Oct 18, 2024',
        'Mehfil-e-Mushaira',
        'Pnca Open-Air Theatre',
        'Literary Evening',
        'assets/portfolio/ceremony_3.jpeg',
      ),
      (
        'ceremony',
        'Exclusive',
        'Aug 28, 2024',
        'Private Investiture',
        'Ambassador\'s Residence',
        'Formal Protocol',
        'assets/portfolio/ceremony_4.jpeg',
      ),

      // More Weddings / Destination
      (
        'wedding',
        'Destination',
        'May 25, 2025',
        'Mountain Top Vows',
        'PC Bhurban',
        'Kashmiri Florals',
        'assets/portfolio/wedding_5.jpeg',
      ),
      (
        'wedding',
        'Boutique',
        'Apr 12, 2025',
        'Courtyard Nikah',
        'Heritage Haveli, Pindi',
        'Minimal Luxe',
        'assets/portfolio/wedding_6.jpeg',
      ),
      (
        'corporate',
        'Expo',
        'Mar 22, 2025',
        'FutureTech Expo Booth + AV',
        'Pak-China Center',
        'Brand Experience',
        'assets/portfolio/corp_5.jpg',
      ),
      (
        'social',
        'Family',
        'Feb 2, 2025',
        'Baby Welcome Dinner',
        'Private Residence, F-8',
        'Warm + Intimate',
        'assets/portfolio/social_5.jpg',
      ),
    ];

    final filters = const [
      ('all', 'All Events'),
      ('wedding', 'Weddings'),
      ('corporate', 'Corporate'),
      ('social', 'Social'),
      ('gala', 'Galas'),
      ('ceremony', 'Ceremonies'),
    ];

    final shown = events
        .where((e) => filter == 'all' || e.$1 == filter)
        .toList();

    return MediaQuery(
      data: clamped,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: MaxWidth(
            child: Column(
              children: [
                SectionHeader(
                  title: 'Portfolio of Excellence',
                  subtitle: 'A curated showcase of our finest celebrations',
                ),
                SizedBox(height: sectionSpacing),

                // Responsive Filters
                _ResponsiveFilters(
                  filters: filters,
                  currentFilter: filter,
                  onFilterChanged: (newFilter) =>
                      setState(() => filter = newFilter),
                  isSmall: isSmall,
                ),

                SizedBox(height: sectionSpacing),

                // Responsive grid
                _ResponsivePortfolioGrid(
                  events: shown,
                  width: width,
                  isVerySmall: isVerySmall,
                  isSmall: isSmall,
                  isMedium: isMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Responsive filter widget that handles overflow gracefully
class _ResponsiveFilters extends StatelessWidget {
  final List<(String, String)> filters;
  final String currentFilter;
  final Function(String) onFilterChanged;
  final bool isSmall;

  const _ResponsiveFilters({
    required this.filters,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      // Use horizontal scrollable list for mobile
      return SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final f = filters[index];
            return _FilterChip(
              label: f.$2,
              isSelected: currentFilter == f.$1,
              onTap: () => onFilterChanged(f.$1),
              isCompact: true,
            );
          },
        ),
      );
    } else {
      // Use wrap for larger screens
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: filters
            .map(
              (f) => _FilterChip(
                label: f.$2,
                isSelected: currentFilter == f.$1,
                onTap: () => onFilterChanged(f.$1),
                isCompact: false,
              ),
            )
            .toList(),
      );
    }
  }
}

/// Custom filter chip with responsive design
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCompact;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12 : 16,
          vertical: isCompact ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : Colors.transparent,
          border: Border.all(color: AppColors.primaryGold, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryGold,
            fontWeight: FontWeight.w700,
            fontSize: isCompact ? 13 : 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Responsive grid that adapts to screen size
class _ResponsivePortfolioGrid extends StatelessWidget {
  final List<(String, String, String, String, String, String, String)> events;
  final double width;
  final bool isVerySmall;
  final bool isSmall;
  final bool isMedium;

  const _ResponsivePortfolioGrid({
    required this.events,
    required this.width,
    required this.isVerySmall,
    required this.isSmall,
    required this.isMedium,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive grid parameters - FIXED: Better aspect ratios to prevent overflow
    double maxExtent;
    double aspectRatio;
    double spacing;

    if (isVerySmall) {
      maxExtent = width - 32; // Single column with margin
      aspectRatio = 0.75; // FIXED: Reduced from 0.85 to give more height
      spacing = 16;
    } else if (isSmall) {
      maxExtent = width * 0.9; // Mostly single column
      aspectRatio = 0.78; // FIXED: Reduced from 0.9 to give more height
      spacing = 18;
    } else if (isMedium) {
      maxExtent = 380;
      aspectRatio = 0.80; // FIXED: Reduced from 0.92 to give more height
      spacing = 20;
    } else {
      maxExtent = 420;
      aspectRatio = 0.82; // FIXED: Reduced from 0.95 to give more height
      spacing = 24;
    }

    return GridView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxExtent,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (_, i) {
        final e = events[i];
        return _PortfolioCard(
          badge: e.$2,
          date: e.$3,
          title: e.$4,
          location: e.$5,
          tag: e.$6,
          image: e.$7,
          isCompact: isVerySmall,
          isSmall: isSmall,
        );
      },
    );
  }
}

/// Enhanced card with mobile-optimized layout - FIXED OVERFLOW ISSUES
class _PortfolioCard extends StatelessWidget {
  final String badge;
  final String date;
  final String title;
  final String location;
  final String tag;
  final String image;
  final bool isCompact;
  final bool isSmall;

  const _PortfolioCard({
    required this.badge,
    required this.date,
    required this.title,
    required this.location,
    required this.tag,
    required this.image,
    this.isCompact = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    // FIXED: More aggressive responsive values to prevent overflow
    final cardPadding = isCompact
        ? 8.0 // Reduced from 10.0
        : isSmall
        ? 10.0 // Reduced from 12.0
        : 12.0; // Reduced from 14.0
    final borderRadius = isCompact ? 12.0 : 16.0;
    final badgeFontSize = isCompact
        ? 8.0 // Reduced from 9.0
        : isSmall
        ? 9.0 // Reduced from 10.0
        : 10.0; // Reduced from 11.0
    final iconSize = isCompact ? 12.0 : 14.0; // Reduced sizes
    final spacing = isCompact
        ? 4.0 // Reduced from 6.0
        : isSmall
        ? 6.0 // Reduced from 8.0
        : 8.0; // Reduced from 10.0

    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearl,
        border: Border.all(color: const Color(0xFFE7E7E7), width: 2),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Color(0x12000000))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image header with responsive aspect ratio
          AspectRatio(
            aspectRatio: isCompact
                ? 16 / 9
                : 16 / 8, // FIXED: Shorter image to save space
            child: _SmartImage(path: image),
          ),

          // FIXED: Body with better constrained layout using Flexible
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge chip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 6 : 8, // Reduced padding
                      vertical: isCompact ? 3 : 4, // Reduced padding
                    ),
                    decoration: BoxDecoration(
                      gradient: goldGradient,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ), // Thinner border
                    ),
                    child: Text(
                      badge.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: badgeFontSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4, // Reduced letter spacing
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: spacing),

                  // FIXED: Title with better constraints
                  Flexible(
                    flex: 2, // Give more space priority to title
                    child: Text(
                      title,
                      maxLines: isCompact
                          ? 1
                          : 2, // Reduced max lines for compact
                      overflow: TextOverflow.ellipsis,
                      style: (isCompact ? t.bodyLarge : t.titleMedium)!
                          .copyWith(
                            color: AppColors.deepBurgundy,
                            fontWeight: FontWeight.w700,
                            height: 1.1, // Tighter line height
                          ),
                    ),
                  ),
                  SizedBox(height: spacing * 0.5),

                  // FIXED: Location with constrained height
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.place,
                          size: iconSize,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: spacing * 0.5),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1, // Always 1 line to save space
                            overflow: TextOverflow.ellipsis,
                            style: (isCompact ? t.bodySmall : t.bodyMedium)!
                                .copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: isCompact
                                      ? 10
                                      : null, // Smaller font for compact
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacing * 0.5),

                  // FIXED: Tag with flex constraint
                  Flexible(
                    flex: 1,
                    child: Text(
                      tag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: (isCompact ? t.labelSmall : t.labelLarge)!
                          .copyWith(
                            color: AppColors.primaryGold,
                            fontWeight: FontWeight.w700,
                            fontSize: isCompact ? 10 : null, // Smaller font
                          ),
                    ),
                  ),
                  SizedBox(height: spacing),

                  // FIXED: Date row - also constrained
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: iconSize,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: spacing * 0.5),
                        Expanded(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: (isCompact ? t.bodySmall : t.bodySmall)!
                                .copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: isCompact
                                      ? 9
                                      : 11, // Smaller font sizes
                                ),
                          ),
                        ),
                      ],
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

/// Enhanced image widget with better error handling and loading states
class _SmartImage extends StatelessWidget {
  final String path;
  const _SmartImage({required this.path});

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => _fallback(),
        loadingBuilder: (c, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFF5F5F5),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGold,
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
  }

  Widget _fallback() => Container(
    color: const Color(0xFFEFEFEF),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          'Image not available',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    ),
  );
}
