// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ auth
import 'firebase_options.dart';

import 'theme.dart';
import 'widgets/nav_bar.dart';
import 'pages/home.dart';
import 'pages/heritage.dart';
import 'pages/services.dart';
import 'pages/process.dart';
import 'pages/team.dart';
import 'pages/portfolio.dart';
import 'pages/contact.dart';

// OPTIONAL: If you move AdminPanelPage to its own file, import it instead.
import 'package:cloud_firestore/cloud_firestore.dart'; // used in AdminPanelPage below

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RoyalEventsApp());
}

class RoyalEventsApp extends StatelessWidget {
  const RoyalEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirabella Events',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const HomePage();
            break;
          case '/heritage':
            page = const HeritagePage();
            break;
          case '/services':
            page = const ServicesPage();
            break;
          case '/process':
            page = const ProcessPage();
            break;
          case '/team':
            page = const TeamPage();
            break;
          case '/portfolio':
            page = const PortfolioPage();
            break;
          case '/contact':
            page = const ContactPage();
            break;
          case '/admin': // ✅ new route
            page = const AdminPanelPage();
            break;
          default:
            page = const HomePage();
        }
        return MaterialPageRoute(
          builder: (_) => Shell(child: page, routeName: settings.name ?? '/'),
        );
      },
      initialRoute: '/',
    );
  }
}

class Shell extends StatefulWidget {
  final Widget child;
  final String routeName;
  const Shell({super.key, required this.child, required this.routeName});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  late final ScrollController _scrollCtrl;
  bool _showFab = false;

  // 🔐 Secret taps
  int _logoTapCount = 0;
  DateTime _firstTapAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _scrollCtrl.addListener(() {
      if (!_scrollCtrl.hasClients) return;
      final shouldShow = _scrollCtrl.offset > 400;
      if (shouldShow != _showFab) setState(() => _showFab = shouldShow);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // 👆 Count 5 logo taps within 4 seconds
  void _handleLogoTap() async {
    final now = DateTime.now();
    if (now.difference(_firstTapAt) > const Duration(seconds: 4)) {
      _firstTapAt = now;
      _logoTapCount = 0;
    }
    _logoTapCount++;

    if (_logoTapCount >= 5) {
      _logoTapCount = 0;
      _firstTapAt = DateTime.fromMillisecondsSinceEpoch(0);
      await _openAdminGate();
    }
  }

  Future<void> _openAdminGate() async {
    // Step 1: Email + Password auth (Firebase)
    final cred = await _showEmailPasswordDialog();
    if (cred == null) return; // cancelled or failed

    // Step 2: "OTP" code (fake-OTP UI) — real code check is local 🔐
    final ok = await _showOtpDialog();
    if (ok != true) return;

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/admin');
  }

  Future<UserCredential?> _showEmailPasswordDialog() async {
    // FIXED: Add responsive design
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 600;

    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool busy = false;
    UserCredential? result;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return AlertDialog(
              title: Text(
                'Admin Sign In',
                style: TextStyle(
                  fontSize: isSmall ? 18 : 20, // FIXED: Responsive font
                ),
                maxLines: 1, // FIXED: Prevent overflow
                overflow: TextOverflow.ellipsis,
              ),
              content: ConstrainedBox(
                // FIXED: Constrain dialog content
                constraints: BoxConstraints(
                  maxWidth: isSmall ? 280 : 400,
                  maxHeight: isSmall ? 200 : 300,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'admin@example.com',
                          labelStyle: TextStyle(
                            fontSize: isSmall ? 12 : 14, // FIXED: Smaller label
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isSmall
                                ? 10
                                : 12, // FIXED: Responsive padding
                            vertical: isSmall ? 10 : 12,
                          ),
                        ),
                        validator: (v) {
                          final s = (v ?? '').trim();
                          if (s.isEmpty) return 'Required';
                          final ok = RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(s);
                          return ok ? null : 'Enter a valid email';
                        },
                      ),
                      SizedBox(
                        height: isSmall ? 8 : 10,
                      ), // FIXED: Responsive spacing
                      TextFormField(
                        controller: passCtrl,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: isSmall ? 12 : 14, // FIXED: Smaller label
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isSmall
                                ? 10
                                : 12, // FIXED: Responsive padding
                            vertical: isSmall ? 10 : 12,
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: busy ? null : () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setS(() => busy = true);
                          try {
                            result = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                  email: emailCtrl.text.trim(),
                                  password: passCtrl.text.trim(),
                                );
                            // success -> close
                            // ignore: use_build_context_synchronously
                            Navigator.pop(ctx);
                          } on FirebaseAuthException catch (e) {
                            setS(() => busy = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.message ?? 'Auth failed'),
                                backgroundColor: Colors.red.shade700,
                              ),
                            );
                          } catch (e) {
                            setS(() => busy = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Auth error: $e'),
                                backgroundColor: Colors.red.shade700,
                              ),
                            );
                          }
                        },
                  child: busy
                      ? SizedBox(
                          width: isSmall
                              ? 16
                              : 18, // FIXED: Responsive loading indicator
                          height: isSmall ? 16 : 18,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: isSmall
                                ? 14
                                : 16, // FIXED: Responsive font
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    return result;
  }

  Future<bool?> _showOtpDialog() async {
    // FIXED: Add responsive design
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 600;

    final codeCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool ok = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Enter OTP',
            style: TextStyle(
              fontSize: isSmall ? 18 : 20, // FIXED: Responsive font
            ),
            maxLines: 1, // FIXED: Prevent overflow
            overflow: TextOverflow.ellipsis,
          ),
          content: ConstrainedBox(
            // FIXED: Constrain dialog content
            constraints: BoxConstraints(
              maxWidth: isSmall ? 280 : 400,
              maxHeight: isSmall ? 180 : 250,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'We have emailed a one-time code to your inbox.\nPlease enter the OTP to proceed.',
                    style: TextStyle(
                      fontSize: isSmall
                          ? 12
                          : 13, // FIXED: Smaller font for small screens
                      height: 1.3, // FIXED: Tighter line height
                    ),
                    maxLines: 3, // FIXED: Limit lines
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: isSmall ? 8 : 10,
                  ), // FIXED: Responsive spacing
                  TextFormField(
                    controller: codeCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                    ),
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      hintText: '6-digit code',
                      labelStyle: TextStyle(
                        fontSize: isSmall ? 12 : 14, // FIXED: Smaller label
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmall
                            ? 10
                            : 12, // FIXED: Responsive padding
                        vertical: isSmall ? 10 : 12,
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                // 🔐 Real check: fixed code "2303"
                if (codeCtrl.text.trim() == '2303') {
                  ok = true;
                  Navigator.pop(ctx, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Invalid OTP'),
                      backgroundColor: Colors.red.shade700,
                    ),
                  );
                }
              },
              child: Text(
                'Verify',
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                ),
              ),
            ),
          ],
        );
      },
    );

    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        currentRoute: widget.routeName,
        onNavigate: (route) {
          if (widget.routeName != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        onLogoTap: _handleLogoTap, // ✅ hook secret taps
      ),
      body: PrimaryScrollController(
        controller: _scrollCtrl,
        child: widget.child,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            tooltip: 'Back to top',
            onPressed: _scrollToTop,
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }
}

/// ========================= FIXED Admin Panel =========================
/// Enhanced UI for listing Firestore leads (bookings) and newsletter subscribers
class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Add responsive design
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 600;
    final isVerySmall = mq.size.width < 360;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                isSmall ? 6 : 8,
              ), // FIXED: Responsive padding
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.admin_panel_settings,
                color: theme.colorScheme.onPrimary,
                size: isSmall ? 20 : 24, // FIXED: Responsive icon size
              ),
            ),
            SizedBox(width: isSmall ? 8 : 12), // FIXED: Responsive spacing
            Flexible(
              // FIXED: Prevent overflow
              child: Text(
                isVerySmall
                    ? 'Admin'
                    : 'Admin Dashboard', // FIXED: Shorter text for tiny screens
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isSmall ? 18 : 20, // FIXED: Responsive font
                ),
                maxLines: 1, // FIXED: Prevent overflow
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.onPrimary,
          indicatorWeight: 3,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.7),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
          ),
          tabs: [
            Tab(
              icon: Icon(
                Icons.assignment_ind,
                size: isSmall ? 20 : 24,
              ), // FIXED: Responsive icon
              text: 'Leads',
            ),
            Tab(
              icon: Icon(
                Icons.mark_email_read,
                size: isSmall ? 20 : 24,
              ), // FIXED: Responsive icon
              text: isVerySmall
                  ? 'Subs'
                  : 'Subscribers', // FIXED: Shorter text for tiny screens
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: isSmall ? 12 : 16,
            ), // FIXED: Responsive margin
            child: IconButton.outlined(
              tooltip: 'Sign out',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: isSmall ? 18 : 20, // FIXED: Responsive font
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to sign out?',
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: isSmall
                                ? 14
                                : 16, // FIXED: Responsive font
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: isSmall
                                ? 14
                                : 16, // FIXED: Responsive font
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                }
              },
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.1),
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              icon: Icon(
                Icons.logout,
                size: isSmall ? 20 : 24,
              ), // FIXED: Responsive icon
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_EnhancedLeadsTab(), _EnhancedSubscribersTab()],
      ),
    );
  }
}

class _EnhancedLeadsTab extends StatefulWidget {
  const _EnhancedLeadsTab();

  @override
  State<_EnhancedLeadsTab> createState() => _EnhancedLeadsTabState();
}

class _EnhancedLeadsTabState extends State<_EnhancedLeadsTab> {
  String _searchQuery = '';
  String _filterType = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Add responsive design
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 600;
    final isVerySmall = mq.size.width < 360;

    final theme = Theme.of(context);
    final query = FirebaseFirestore.instance
        .collection('bookings')
        .orderBy('createdAt', descending: true);

    return Column(
      children: [
        // Search and Filter Bar
        Container(
          padding: EdgeInsets.all(
            isSmall ? 12 : 16,
          ), // FIXED: Responsive padding
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: Column(
            // FIXED: Stack vertically on small screens
            children: [
              TextField(
                controller: _searchController,
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                ),
                decoration: InputDecoration(
                  hintText: isVerySmall
                      ? 'Search...'
                      : 'Search by name, email, or phone...', // FIXED: Shorter hint for tiny screens
                  hintStyle: TextStyle(
                    fontSize: isSmall ? 13 : 14, // FIXED: Smaller hint font
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: isSmall ? 20 : 24,
                  ), // FIXED: Responsive icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 10 : 12, // FIXED: Responsive padding
                    vertical: isSmall ? 10 : 12,
                  ),
                ),
                onChanged: (value) =>
                    setState(() => _searchQuery = value.toLowerCase()),
              ),
              if (isSmall) ...[
                // FIXED: Stack vertically on small screens
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filterType,
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
                        color: theme.colorScheme.onSurface,
                      ),
                      items:
                          ['All', 'Wedding', 'Corporate', 'Birthday', 'Other']
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged: (value) =>
                          setState(() => _filterType = value ?? 'All'),
                    ),
                  ),
                ),
              ] else ...[
                // FIXED: Keep horizontal layout for larger screens
                SizedBox(height: 12),
                Row(
                  children: [
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterType,
                        items:
                            ['All', 'Wedding', 'Corporate', 'Birthday', 'Other']
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) =>
                            setState(() => _filterType = value ?? 'All'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Leads List
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: query.snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snap.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: isSmall ? 48 : 64, // FIXED: Responsive icon size
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(
                        height: isSmall ? 12 : 16,
                      ), // FIXED: Responsive spacing
                      Text(
                        'Error loading data',
                        style: (isSmall
                            ? theme.textTheme.titleMedium
                            : theme
                                  .textTheme
                                  .headlineSmall)!, // FIXED: Responsive text
                        textAlign: TextAlign.center,
                        maxLines: 2, // FIXED: Prevent overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${snap.error}',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: isSmall
                              ? 12
                              : 14, // FIXED: Smaller error text
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3, // FIXED: Limit error text lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }

              final docs = snap.data?.docs ?? [];

              // Apply filters
              final filteredDocs = docs.where((doc) {
                final data = doc.data();
                final name = (data['name'] ?? '').toString().toLowerCase();
                final email = (data['email'] ?? '').toString().toLowerCase();
                final phone = (data['phone'] ?? '').toString().toLowerCase();
                final type = (data['eventType'] ?? '').toString();

                final matchesSearch =
                    _searchQuery.isEmpty ||
                    name.contains(_searchQuery) ||
                    email.contains(_searchQuery) ||
                    phone.contains(_searchQuery);

                final matchesFilter =
                    _filterType == 'All' || type == _filterType;

                return matchesSearch && matchesFilter;
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isSmall ? 16 : 24,
                    ), // FIXED: Responsive padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: isSmall ? 48 : 64, // FIXED: Responsive icon
                          color: theme.colorScheme.outline,
                        ),
                        SizedBox(
                          height: isSmall ? 12 : 16,
                        ), // FIXED: Responsive spacing
                        Text(
                          docs.isEmpty ? 'No leads yet' : 'No results found',
                          style: (isSmall
                              ? theme.textTheme.titleMedium
                              : theme
                                    .textTheme
                                    .headlineSmall)!, // FIXED: Responsive text
                          textAlign: TextAlign.center,
                          maxLines: 1, // FIXED: Prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: isSmall ? 6 : 8,
                        ), // FIXED: Responsive spacing
                        Text(
                          docs.isEmpty
                              ? 'Leads will appear here when customers submit booking forms'
                              : 'Try adjusting your search or filter criteria',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: isSmall
                                ? 12
                                : 14, // FIXED: Smaller font on mobile
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3, // FIXED: Limit lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(
                  isSmall ? 12 : 16,
                ), // FIXED: Responsive padding
                itemCount: filteredDocs.length,
                separatorBuilder: (_, __) => SizedBox(
                  height: isSmall ? 8 : 12,
                ), // FIXED: Responsive spacing
                itemBuilder: (_, i) => _LeadCard(
                  doc: filteredDocs[i],
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LeadCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final bool isSmall;
  final bool isVerySmall;

  const _LeadCard({
    required this.doc,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  State<_LeadCard> createState() => _LeadCardState();
}

class _LeadCardState extends State<_LeadCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = widget.doc.data();

    final name = data['name'] ?? '—';
    final email = data['email'] ?? '—';
    final phone = data['phone'] ?? '—';
    final type = data['eventType'] ?? '—';
    final guests = data['guests']?.toString() ?? '—';
    final budget = data['budgetRangePKR'] ?? data['budget'] ?? '—';
    final eventDate = data['eventDate'];
    final message = data['message']?.toString() ?? '';
    final createdAt = data['createdAt'];

    String timeAgo = '—';
    if (createdAt is Timestamp) {
      final date = createdAt.toDate();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 0) {
        timeAgo = '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        timeAgo = '${diff.inMinutes}m ago';
      } else {
        timeAgo = 'Just now';
      }
    }

    String eventDateStr = '—';
    if (eventDate is Timestamp) {
      final date = eventDate.toDate();
      eventDateStr = '${date.day}/${date.month}/${date.year}';
    }

    // Event type color coding
    Color getEventTypeColor() {
      switch (type.toLowerCase()) {
        case 'wedding':
          return Colors.pink;
        case 'corporate':
          return Colors.blue;
        case 'birthday':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Card(
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: EdgeInsets.all(
            widget.isSmall ? 12 : 16,
          ), // FIXED: Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
            children: [
              // Header Row
              Row(
                children: [
                  Flexible(
                    // FIXED: Prevent overflow
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.isSmall
                            ? 6
                            : 8, // FIXED: Responsive padding
                        vertical: widget.isSmall ? 3 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: getEventTypeColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: getEventTypeColor().withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: getEventTypeColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: widget.isSmall
                              ? 11
                              : 12, // FIXED: Responsive font
                        ),
                        maxLines: 1, // FIXED: Prevent overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: widget.isSmall
                          ? 11
                          : 12, // FIXED: Responsive font
                    ),
                    maxLines: 1, // FIXED: Prevent overflow
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: widget.isSmall ? 6 : 8,
                  ), // FIXED: Responsive spacing
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: widget.isSmall ? 20 : 24, // FIXED: Responsive icon
                  ),
                ],
              ),

              SizedBox(
                height: widget.isSmall ? 8 : 12,
              ), // FIXED: Responsive spacing
              // Client Name
              Text(
                name,
                style:
                    (widget.isSmall
                            ? theme.textTheme.titleSmall
                            : theme.textTheme.titleMedium)
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2, // FIXED: Tighter line height
                        ),
                maxLines: widget.isVerySmall
                    ? 1
                    : 2, // FIXED: Limit lines on tiny screens
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(
                height: widget.isSmall ? 6 : 8,
              ), // FIXED: Responsive spacing
              // Quick Info
              Wrap(
                // FIXED: Use Wrap to prevent overflow
                spacing: widget.isSmall ? 12 : 16,
                runSpacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        size: widget.isSmall
                            ? 14
                            : 16, // FIXED: Responsive icon
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(
                        width: widget.isSmall ? 3 : 4,
                      ), // FIXED: Responsive spacing
                      Flexible(
                        child: Text(
                          '$guests guests',
                          style: TextStyle(
                            fontSize: widget.isSmall
                                ? 12
                                : 14, // FIXED: Responsive font
                          ),
                          maxLines: 1, // FIXED: Prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        size: widget.isSmall
                            ? 14
                            : 16, // FIXED: Responsive icon
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(
                        width: widget.isSmall ? 3 : 4,
                      ), // FIXED: Responsive spacing
                      Flexible(
                        child: Text(
                          budget,
                          style: TextStyle(
                            fontSize: widget.isSmall
                                ? 12
                                : 14, // FIXED: Responsive font
                          ),
                          maxLines: 1, // FIXED: Prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expanded Details
              if (_isExpanded) ...[
                SizedBox(
                  height: widget.isSmall ? 12 : 16,
                ), // FIXED: Responsive spacing
                const Divider(),
                SizedBox(
                  height: widget.isSmall ? 12 : 16,
                ), // FIXED: Responsive spacing

                _DetailRow(
                  icon: Icons.email,
                  label: 'Email',
                  value: email,
                  onTap: () => _launchUrl('mailto:$email'),
                  isSmall: widget.isSmall,
                ),
                SizedBox(
                  height: widget.isSmall ? 8 : 12,
                ), // FIXED: Responsive spacing

                _DetailRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: phone,
                  onTap: () => _launchUrl('tel:$phone'),
                  isSmall: widget.isSmall,
                ),
                SizedBox(
                  height: widget.isSmall ? 8 : 12,
                ), // FIXED: Responsive spacing

                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Event Date',
                  value: eventDateStr,
                  isSmall: widget.isSmall,
                ),

                if (message.isNotEmpty) ...[
                  SizedBox(
                    height: widget.isSmall ? 12 : 16,
                  ), // FIXED: Responsive spacing
                  Text(
                    'Message:',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: widget.isSmall
                          ? 12
                          : 14, // FIXED: Responsive font
                    ),
                  ),
                  SizedBox(
                    height: widget.isSmall ? 3 : 4,
                  ), // FIXED: Responsive spacing
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      widget.isSmall ? 10 : 12,
                    ), // FIXED: Responsive padding
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: widget.isSmall
                            ? 12
                            : 14, // FIXED: Responsive font
                        height: 1.3, // FIXED: Tighter line height
                      ),
                      maxLines: widget.isVerySmall
                          ? 4
                          : 6, // FIXED: Limit lines
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) {
    // Add url_launcher functionality here if needed
    // For now, just show a snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Open: $url')));
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isSmall;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 3 : 4,
        ), // FIXED: Responsive padding
        child: Row(
          children: [
            Icon(
              icon,
              size: isSmall ? 18 : 20, // FIXED: Responsive icon
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: isSmall ? 10 : 12), // FIXED: Responsive spacing
            Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: isSmall ? 13 : 14, // FIXED: Responsive font
              ),
            ),
            SizedBox(width: isSmall ? 6 : 8), // FIXED: Responsive spacing
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onTap != null ? theme.colorScheme.primary : null,
                  fontSize: isSmall ? 13 : 14, // FIXED: Responsive font
                ),
                maxLines: 2, // FIXED: Limit lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.open_in_new,
                size: isSmall ? 14 : 16, // FIXED: Responsive icon
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _EnhancedSubscribersTab extends StatefulWidget {
  const _EnhancedSubscribersTab();

  @override
  State<_EnhancedSubscribersTab> createState() =>
      _EnhancedSubscribersTabState();
}

class _EnhancedSubscribersTabState extends State<_EnhancedSubscribersTab> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Add responsive design
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 600;
    final isVerySmall = mq.size.width < 360;

    final theme = Theme.of(context);
    final query = FirebaseFirestore.instance
        .collection('subscribers')
        .orderBy('createdAt', descending: true);

    return Column(
      children: [
        // Search Bar
        Container(
          padding: EdgeInsets.all(
            isSmall ? 12 : 16,
          ), // FIXED: Responsive padding
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
              fontSize: isSmall ? 14 : 16, // FIXED: Responsive font
            ),
            decoration: InputDecoration(
              hintText: isVerySmall
                  ? 'Search...'
                  : 'Search subscribers...', // FIXED: Shorter hint
              hintStyle: TextStyle(
                fontSize: isSmall ? 13 : 14, // FIXED: Smaller hint font
              ),
              prefixIcon: Icon(
                Icons.search,
                size: isSmall ? 20 : 24,
              ), // FIXED: Responsive icon
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmall ? 10 : 12, // FIXED: Responsive padding
                vertical: isSmall ? 10 : 12,
              ),
            ),
            onChanged: (value) =>
                setState(() => _searchQuery = value.toLowerCase()),
          ),
        ),

        // Subscribers List
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: query.snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snap.hasError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isSmall ? 16 : 24,
                    ), // FIXED: Responsive padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: isSmall ? 48 : 64, // FIXED: Responsive icon
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(
                          height: isSmall ? 12 : 16,
                        ), // FIXED: Responsive spacing
                        Text(
                          'Error loading data',
                          style: (isSmall
                              ? theme.textTheme.titleMedium
                              : theme
                                    .textTheme
                                    .headlineSmall)!, // FIXED: Responsive text
                          textAlign: TextAlign.center,
                          maxLines: 2, // FIXED: Prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${snap.error}',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: isSmall
                                ? 12
                                : 14, // FIXED: Smaller error text
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3, // FIXED: Limit error text lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final docs = snap.data?.docs ?? [];

              // Apply search filter
              final filteredDocs = docs.where((doc) {
                final email = (doc.data()['email'] ?? '')
                    .toString()
                    .toLowerCase();
                return _searchQuery.isEmpty || email.contains(_searchQuery);
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isSmall ? 16 : 24,
                    ), // FIXED: Responsive padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: isSmall ? 48 : 64, // FIXED: Responsive icon
                          color: theme.colorScheme.outline,
                        ),
                        SizedBox(
                          height: isSmall ? 12 : 16,
                        ), // FIXED: Responsive spacing
                        Text(
                          docs.isEmpty
                              ? 'No subscribers yet'
                              : 'No results found',
                          style: (isSmall
                              ? theme.textTheme.titleMedium
                              : theme
                                    .textTheme
                                    .headlineSmall)!, // FIXED: Responsive text
                          textAlign: TextAlign.center,
                          maxLines: 1, // FIXED: Prevent overflow
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: isSmall ? 6 : 8,
                        ), // FIXED: Responsive spacing
                        Text(
                          docs.isEmpty
                              ? 'Newsletter subscribers will appear here'
                              : 'Try adjusting your search criteria',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: isSmall ? 12 : 14, // FIXED: Smaller font
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2, // FIXED: Limit lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(
                  isSmall ? 12 : 16,
                ), // FIXED: Responsive padding
                itemCount: filteredDocs.length,
                separatorBuilder: (_, __) => SizedBox(
                  height: isSmall ? 8 : 12,
                ), // FIXED: Responsive spacing
                itemBuilder: (_, i) => _SubscriberCard(
                  doc: filteredDocs[i],
                  isSmall: isSmall,
                  isVerySmall: isVerySmall,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SubscriberCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final bool isSmall;
  final bool isVerySmall;

  const _SubscriberCard({
    required this.doc,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = doc.data();

    final email = data['email'] ?? '—';
    final createdAt = data['createdAt'];

    String timeAgo = '—';
    String fullDate = '—';
    if (createdAt is Timestamp) {
      final date = createdAt.toDate();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 0) {
        timeAgo = '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        timeAgo = '${diff.inMinutes}m ago';
      } else {
        timeAgo = 'Just now';
      }

      fullDate =
          '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }

    return Card(
      elevation: 1,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 16, // FIXED: Responsive padding
          vertical: isSmall ? 6 : 8,
        ),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          radius: isSmall ? 18 : 20, // FIXED: Responsive avatar size
          child: Icon(
            Icons.mark_email_read,
            color: theme.colorScheme.onPrimaryContainer,
            size: isSmall ? 18 : 20, // FIXED: Responsive icon size
          ),
        ),
        title: Text(
          email,
          style:
              (isSmall
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.titleMedium)
                  ?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.2, // FIXED: Tighter line height
                  ),
          maxLines: isVerySmall ? 1 : 2, // FIXED: Limit lines on tiny screens
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
          children: [
            SizedBox(height: isSmall ? 3 : 4), // FIXED: Responsive spacing
            Text(
              fullDate,
              style: TextStyle(
                fontSize: isSmall ? 11 : 12, // FIXED: Responsive font
              ),
              maxLines: 1, // FIXED: Prevent overflow
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmall ? 2 : 2),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 5 : 6, // FIXED: Responsive padding
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Subscribed $timeAgo',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmall ? 10 : 11, // FIXED: Responsive font
                ),
                maxLines: 1, // FIXED: Prevent overflow
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          tooltip: 'Send email',
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Open: mailto:$email')));
          },
          icon: Icon(
            Icons.email,
            color: theme.colorScheme.primary,
            size: isSmall ? 20 : 24, // FIXED: Responsive icon
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
