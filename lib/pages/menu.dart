import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/footer.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(),
          _MenuPackagesSection(),
          _ExtraSelectionSection(),
          _ContactManagementSection(),
          _RulesSection(),
          SizedBox(height: 32),
          Footer(),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGold, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Text(
                          '♔',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'MIRABELLA EVENTS',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'MEMORIES HANDCRAFTED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'OUR CATERING MENU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuPackagesSection extends StatelessWidget {
  const _MenuPackagesSection();

  @override
  Widget build(BuildContext context) {
    final menuPackages = [
      _MenuPackage(
        title: 'MENU 1',
        price: 'RS. 1980',
        items: [
          'CHICKEN QORMA',
          'CHANNAY',
          'RUSSIAN SALAD + FRESH SALAD',
          'KACHUMMAR SALAD + RED BEANS SALAD',
          'NAAN + PURI',
          'HALWA SUJI',
          'GREEN TEA',
          'DRINKS + MINERAL WATER',
        ],
      ),
      _MenuPackage(
        title: 'MENU 2',
        price: 'RS. 2380',
        items: [
          'CHICKEN QORMA',
          'CHICKEN BIRYANI / PULAO',
          'CHICKEN BOTTI',
          'MIX VEGETABLE SALAD',
          'RUSSIAN SALAD + FRESH SALAD',
          'KACHUMMAR SALAD + RED BEANS SALAD',
          'NAAN',
          'RAITA',
          'KHEER + TRIFLE',
          'GREEN TEA',
          'DRINKS + MINERAL WATER',
        ],
      ),
      _MenuPackage(
        title: 'MENU 3',
        price: 'RS. 2480',
        items: [
          'CHICKEN QORMA',
          'CHICKEN BIRYANI / PULAO',
          'CHICKEN BOTTI',
          'SEEKH KABAB',
          'RUSSIAN SALAD + FRESH SALAD',
          'KACHUMMAR SALAD + RED BEANS SALAD',
          'NAAN',
          'RAITA',
          'KHEER + TRIFLE',
          'GREEN TEA',
          'DRINKS + MINERAL WATER',
        ],
      ),
      _MenuPackage(
        title: 'MENU 4',
        price: 'RS. 3180',
        items: [
          'MUTTON QORMA',
          'CHICKEN BIRYANI / PULAO',
          'CHICKEN BOTTI',
          'FISH + CHIPS',
          'RUSSIAN SALAD + FRESH SALADS',
          'KACHUMMAR SALAD + RED BEANS SALAD',
          'NAAN',
          'RAITA',
          'KHEER + TRIFLE',
          'GREEN TEA',
          'DRINKS + MINERAL WATER',
        ],
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'MENU PACKAGES',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBurgundy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Choose from our carefully crafted menu packages',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          // Images Gallery Section
          const _MenuImagesSection(),
          const SizedBox(height: 80),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 1200) {
                // Desktop: 4 columns
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: menuPackages
                      .map(
                        (package) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _MenuCard(package: package),
                          ),
                        ),
                      )
                      .toList(),
                );
              } else if (constraints.maxWidth > 768) {
                // Tablet: 2x2 grid
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _MenuCard(package: menuPackages[0]),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _MenuCard(package: menuPackages[1]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _MenuCard(package: menuPackages[2]),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _MenuCard(package: menuPackages[3]),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Mobile: single column
                return Column(
                  children: menuPackages
                      .map(
                        (package) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _MenuCard(package: package),
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MenuImagesSection extends StatelessWidget {
  const _MenuImagesSection();

  @override
  Widget build(BuildContext context) {
    final menuImages = [
      _MenuImageData(
        imagePath: 'assets/sol1.png',
        title: 'HALL 1 - ELEGANT DINING',
        description: 'Perfect for intimate gatherings and family celebrations',
      ),
      _MenuImageData(
        imagePath: 'assets/sol2.png',
        title: 'HALL 1 - GRAND FEAST',
        description: 'Ideal for weddings and large corporate events',
      ),
      _MenuImageData(
        imagePath: 'assets/sol3.png',
        title: 'HALL 2 - PREMIUM SELECTION',
        description: 'Gourmet experience with premium ingredients',
      ),
      _MenuImageData(
        imagePath: 'assets/sol4.png',
        title: 'HALL 2 - ROYAL EXPERIENCE',
        description: 'Our finest offering for the most special occasions',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          // Desktop: 4 columns
          return Row(
            children: menuImages
                .map(
                  (imageData) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _MenuImageCard(imageData: imageData),
                    ),
                  ),
                )
                .toList(),
          );
        } else if (constraints.maxWidth > 768) {
          // Tablet: 2x2 grid
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _MenuImageCard(imageData: menuImages[0]),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _MenuImageCard(imageData: menuImages[1]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _MenuImageCard(imageData: menuImages[2]),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _MenuImageCard(imageData: menuImages[3]),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Mobile: single column
          return Column(
            children: menuImages
                .map(
                  (imageData) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _MenuImageCard(imageData: imageData),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }
}

class _MenuImageData {
  final String imagePath;
  final String title;
  final String description;

  _MenuImageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class _MenuImageCard extends StatelessWidget {
  final _MenuImageData imageData;

  const _MenuImageCard({required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryGold.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                imageData.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGold.withOpacity(0.2),
                        AppColors.primaryGold.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 80,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Text Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(
                  imageData.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepBurgundy,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  imageData.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuPackage {
  final String title;
  final String price;
  final List<String> items;

  _MenuPackage({required this.title, required this.price, required this.items});
}

class _MenuCard extends StatelessWidget {
  final _MenuPackage package;

  const _MenuCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Text(
              package.title,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              package.price,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // Items
            ...package.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGold,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtraSelectionSection extends StatelessWidget {
  const _ExtraSelectionSection();

  @override
  Widget build(BuildContext context) {
    final extraItems = [
      ('CHICKEN BOTTI, SEEKH KABAB, CHICKEN ROAST', 'RS. 250'),
      ('FISH, MUTTON ROAST ROLL', 'RS. 700'),
      ('MIX VEGETABLE, PALAK PANEER', 'RS. 150'),
      ('GAJAR HALWA, GULAB JAMUN, KULFA', 'RS. 150 (SWEET BAR - RS. 200)'),
      ('ADDITIONAL 2 SALADS', 'RS. 50'),
      ('LIVE TANDOOR', 'RS. 5000'),
      ('CHICKEN CHILI DRY', 'RS. 200'),
      ('BEEF CHILI DRY', 'RS. 300'),
      ('2 PACKED CHOWMEIN', 'RS. 200'),
      ('CHICKEN KARAHI MF/KARAHI CHICKEN', 'RS. 300'),
      ('CHICKEN MALAI BOTI/CHICKEN TIKKA', 'RS. 200'),
      ('CHICKEN TIKKA / BEEF HANDI', 'RS. 250'),
      ('SAYIL', 'RS. 400'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            'EXTRA SELECTION MENU',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBurgundy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Enhance your package with additional items',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: extraItems
                  .map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.$1,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.deepBurgundy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactManagementSection extends StatelessWidget {
  const _ContactManagementSection();

  @override
  Widget build(BuildContext context) {
    final contacts = [
      ('Rena Tanveer', '03055354747'),
      ('Mustafa Sayed', '03367389099'),
      ('Aqib Khan', '03432241224'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'MANAGEMENT',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBurgundy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Contact our management team for bookings and inquiries',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 768) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: contacts
                      .map(
                        (contact) =>
                            _ContactCard(name: contact.$1, phone: contact.$2),
                      )
                      .toList(),
                );
              } else {
                return Column(
                  children: contacts
                      .map(
                        (contact) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _ContactCard(
                            name: contact.$1,
                            phone: contact.$2,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String name;
  final String phone;

  const _ContactCard({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryGold, Color(0xFFE6B800)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.person, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    final rules = [
      'AC/HEATING CHARGES - 15,000/HOUR',
      'MENU PRICES ARE SUBJECT TO CHANGE DEPENDING ON TOTAL NUMBER OF GUESTS',
      'LUNCH TIMINGS 1PM-4PM/DINNER TIMINGS 7PM-10PM',
      'ANY DAMAGE TO THE PROPERTY DURING THE EVENT WILL BE PAID BY THE CLIENT',
      'BOOKING IS DONE ON FIRST COME SERVE BASIS',
      'EXTRA TIME WILL BE CHARGED @ 10,000 PER HOUR FOR LIGHTING ETC',
      '*TERMS AND CONDITIONS APPLY',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      color: Colors.grey[50],
      child: Column(
        children: [
          const Text(
            'OTHER CHARGES & RULES',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBurgundy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Important information regarding our services',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: rules
                  .map(
                    (rule) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGold.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryGold,
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              rule,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.deepBurgundy,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
