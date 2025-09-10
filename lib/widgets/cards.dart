import 'package:flutter/material.dart';
import '../theme.dart';

class AboutCard extends StatelessWidget {
  final String icon;
  final String title;
  final String body;
  const AboutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp text scale so long words don’t blow up the layout
    final mq = MediaQuery.of(context);
    final tScale = MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3);
    final t = Theme.of(context).textTheme;

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(tScale.toDouble())),
      child: LayoutBuilder(
        builder: (context, c) {
          final isPhone = c.maxWidth < 420;
          final pad = isPhone ? 20.0 : 28.0;
          final iconSize = isPhone ? 34.0 : 40.0;

          return Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: AppColors.pearl,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightGold, width: 3),
              boxShadow: const [
                BoxShadow(blurRadius: 24, color: Color(0x14000000)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.lightGold, width: 3),
                  ),
                  child: Text(icon, style: TextStyle(fontSize: iconSize)),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleLarge!.copyWith(color: AppColors.deepBurgundy),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: t.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ===================== SERVICE CARD (images + price range + CTA) =====================
class ServiceCard extends StatelessWidget {
  // Header image (choose one) or fallback emoji
  final String? imageAsset; // e.g. 'assets/images/services/wedding.jpg'
  final String? imageUrl; // e.g. 'https://...'
  final String? icon; // fallback emoji

  // Content
  final String title;
  final String desc;
  final List<String> bullets;

  // Price: either free-form text OR a range
  final String? price; // e.g. 'PKR 500k+'
  final String? priceFrom; // e.g. 'PKR 800k'
  final String? priceTo; // e.g. 'PKR 3.5M'

  // CTA
  final String ctaText;
  final VoidCallback? onPressed;

  const ServiceCard({
    super.key,
    this.imageAsset,
    this.imageUrl,
    this.icon,
    required this.title,
    required this.desc,
    required this.bullets,
    this.price,
    this.priceFrom,
    this.priceTo,
    this.ctaText = 'Book this service',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tScale = MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3);
    final t = Theme.of(context).textTheme;

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(tScale.toDouble())),
      child: LayoutBuilder(
        builder: (context, c) {
          final isPhone = c.maxWidth < 420;
          final headerH = isPhone ? 160.0 : 200.0; // compact on phones
          final pad = isPhone ? 20.0 : 24.0;

          final bool hasAsset =
              imageAsset != null && imageAsset!.trim().isNotEmpty;
          final bool hasUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

          // ----- Header (image or gradient + emoji) -----
          Widget header;
          if (hasAsset || hasUrl) {
            header = ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(17),
              ),
              child: SizedBox(
                height: headerH,
                width: double.infinity,
                child: hasAsset
                    ? Image.asset(imageAsset!, fit: BoxFit.cover)
                    : Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) =>
                            progress == null
                            ? child
                            : Container(
                                color: const Color(0x11000000),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                        errorBuilder: (ctx, err, st) => Container(
                          color: const Color(0x11000000),
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
              ),
            );
          } else {
            header = Container(
              height: headerH,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: royalGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(17),
                ),
              ),
              child: Text(
                icon ?? '🎯',
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            );
          }

          // ----- Body -----
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEFEFEF), width: 3),
              boxShadow: const [
                BoxShadow(blurRadius: 24, color: Color(0x14000000)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleLarge!.copyWith(
                          color: AppColors.deepBurgundy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(desc, softWrap: true, style: t.bodyLarge),
                      const SizedBox(height: 10),

                      // Bullets
                      ...bullets.map(
                        (b) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: AppColors.primaryGold,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  b,
                                  softWrap: true,
                                  style: t.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Price
                      if ((priceFrom != null && priceTo != null) ||
                          (price != null && price!.isNotEmpty)) ...[
                        const SizedBox(height: 12),
                        Text(
                          priceFrom != null && priceTo != null
                              ? 'From $priceFrom to $priceTo'
                              : price!,
                          softWrap: true,
                          style: t.titleMedium!.copyWith(
                            color: AppColors.primaryGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],

                      // CTA
                      if (onPressed != null) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: onPressed,
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(ctaText),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String badge;
  final String date;
  final String title;
  final String location;
  final String tag;
  const EventCard({
    super.key,
    required this.badge,
    required this.date,
    required this.title,
    required this.location,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tScale = MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3);
    final t = Theme.of(context).textTheme;

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(tScale.toDouble())),
      child: LayoutBuilder(
        builder: (context, c) {
          final isPhone = c.maxWidth < 420;
          final headerH = isPhone ? 160.0 : 200.0;
          final pad = isPhone ? 16.0 : 20.0;

          return Container(
            decoration: BoxDecoration(
              color: AppColors.pearl,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0F0F0), width: 3),
              boxShadow: const [
                BoxShadow(blurRadius: 24, color: Color(0x14000000)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: headerH,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: royalGradient,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(17),
                        ),
                      ),
                      child: const Text(
                        '🏛️',
                        style: TextStyle(fontSize: 56, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: goldGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(pad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📅 '),
                          Flexible(
                            child: Text(
                              date,
                              softWrap: true,
                              style: t.bodyLarge!.copyWith(
                                color: AppColors.primaryGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleLarge!.copyWith(
                          color: AppColors.deepBurgundy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text('📍 '),
                          Expanded(
                            child: Text(
                              location,
                              softWrap: true,
                              style: t.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tag,
                              softWrap: true,
                              style: t.bodyLarge!.copyWith(
                                color: AppColors.forestGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 88),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Inquire',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final String emoji;
  final String name;
  final String role;
  final String bio;
  const TeamCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.role,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tScale = MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.3);
    final t = Theme.of(context).textTheme;

    return MediaQuery(
      data: mq.copyWith(textScaler: TextScaler.linear(tScale.toDouble())),
      child: LayoutBuilder(
        builder: (context, c) {
          final isPhone = c.maxWidth < 420;
          final avatar = isPhone ? 96.0 : 120.0;
          final pad = isPhone ? 20.0 : 24.0;

          return Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: AppColors.pearl,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.lightGold, width: 3),
              boxShadow: const [
                BoxShadow(blurRadius: 24, color: Color(0x14000000)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: avatar,
                  height: avatar,
                  decoration: BoxDecoration(
                    gradient: goldGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    boxShadow: const [
                      BoxShadow(blurRadius: 18, color: Color(0x14000000)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: isPhone ? 40 : 48, height: 1.0),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleLarge!.copyWith(color: AppColors.deepBurgundy),
                ),
                const SizedBox(height: 6),
                Text(
                  role.toUpperCase(),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: t.bodyMedium!.copyWith(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: t.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
