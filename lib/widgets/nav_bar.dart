import 'package:flutter/material.dart';
import '../theme.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute; // ✅ highlight active route
  final void Function(String route) onNavigate;
  final VoidCallback? onLogoTap; // ✅ secret tap handler

  const TopNavBar({
    super.key,
    required this.onNavigate,
    this.onLogoTap,
    this.currentRoute = '/',
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;

    final items = const <(String, String)>[
      ('Home', '/'),
      ('Heritage', '/heritage'),
      ('Services', '/services'),
      ('Process', '/process'),
      ('Team', '/team'),
      ('Portfolio', '/portfolio'),
      ('Contact', '/contact'),
    ];

    Widget brand = InkWell(
      onTap: onLogoTap, // ✅ counts secret taps
      borderRadius: BorderRadius.circular(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '♔',
            style: TextStyle(color: AppColors.primaryGold, fontSize: 24),
          ),
          const SizedBox(width: 8),
          Text(
            'Mirabella Events',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.deepBurgundy,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.95),
        border: const Border(
          bottom: BorderSide(width: 4, color: Colors.transparent),
        ),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x14000000))],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              brand,
              const Spacer(),
              if (isWide)
                Row(
                  children: [
                    for (final it in items)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _NavButton(
                          label: it.$1,
                          active: _isActive(currentRoute, it.$2),
                          onTap: () => onNavigate(it.$2),
                        ),
                      ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => onNavigate('/contact'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text('Get In Touch'),
                      ),
                    ),
                  ],
                )
              else
                PopupMenuButton<String>(
                  onSelected: onNavigate,
                  itemBuilder: (context) => items
                      .map(
                        (e) => PopupMenuItem(
                          value: e.$2,
                          child: Row(
                            children: [
                              if (_isActive(currentRoute, e.$2))
                                const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: AppColors.primaryGold,
                                ),
                              if (_isActive(currentRoute, e.$2))
                                const SizedBox(width: 6),
                              Text(e.$1),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isActive(String current, String route) {
    return current == route || (current.isEmpty && route == '/');
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: active
            ? AppColors.primaryGold
            : AppColors.deepBurgundy,
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            height: 2,
            width: active ? 26 : 0,
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
