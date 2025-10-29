import 'package:flutter/material.dart';
import '../theme.dart';

class MaxWidth extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  const MaxWidth({super.key, this.maxWidth = 1200, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? titleColor;
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(title, style: t.displayMedium!.copyWith(color: titleColor)),
        const SizedBox(height: 12),
        Container(
          width: 120,
          height: 5,
          decoration: BoxDecoration(
            gradient: goldGradient,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 16),
        Text(subtitle, style: t.bodyLarge, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool outlined;
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          gradient: outlined ? null : goldGradient,
          borderRadius: BorderRadius.circular(12),
          border: outlined ? Border.all(color: Colors.white, width: 2) : null,
          color: outlined ? Colors.transparent : null,
        ),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: outlined ? Colors.white : Colors.white,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );

    return MouseRegion(cursor: SystemMouseCursors.click, child: btn);
  }
}

class StatCounter extends StatelessWidget {
  final int target;
  final String label;
  const StatCounter({super.key, required this.target, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: target.toDouble()),
            duration: const Duration(milliseconds: 2000),
            builder: (_, value, __) => Text(
              target == 99 ? '${value.toInt()}%' : value.toInt().toString(),
              style: t.displayMedium!.copyWith(color: AppColors.primaryGold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: t.bodyLarge!.copyWith(
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
