// lib/pages/home_hero_section.dart
part of 'home.dart';

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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w < 360
                                            ? 16
                                            : w < 540
                                            ? 20
                                            : w < 900
                                            ? 32
                                            : 44,
                                        vertical: w < 360
                                            ? 10
                                            : w < 540
                                            ? 12
                                            : w < 900
                                            ? 16
                                            : 22,
                                      ),
                                      textStyle: TextStyle(
                                        fontSize: w < 360
                                            ? 14
                                            : w < 540
                                            ? 16
                                            : w < 900
                                            ? 20
                                            : 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          w < 540 ? 12 : 14,
                                        ),
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w < 360
                                            ? 16
                                            : w < 540
                                            ? 20
                                            : w < 900
                                            ? 32
                                            : 44,
                                        vertical: w < 360
                                            ? 10
                                            : w < 540
                                            ? 12
                                            : w < 900
                                            ? 16
                                            : 22,
                                      ),
                                      textStyle: TextStyle(
                                        fontSize: w < 360
                                            ? 14
                                            : w < 540
                                            ? 16
                                            : w < 900
                                            ? 20
                                            : 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          w < 540 ? 12 : 14,
                                        ),
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
