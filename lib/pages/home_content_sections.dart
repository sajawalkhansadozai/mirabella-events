// lib/pages/home_content_sections.dart
part of 'home.dart';

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
