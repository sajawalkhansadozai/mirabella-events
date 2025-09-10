import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore
import 'package:flutter/material.dart';
import '../widgets/common.dart';
import '../theme.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final message = TextEditingController();

  String eventType = '';
  DateTime? date;
  String guests = '';
  String budget = '';
  bool _busy = false;

  @override
  void dispose() {
    name..dispose();
    email..dispose();
    phone..dispose();
    message..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: More aggressive text scale clamping with responsive design
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isVerySmall = width < 360;
    final isSmall = width < 600;
    final isMedium = width < 900;

    // FIXED: More aggressive clamping based on screen size
    final clampedScale = isVerySmall
        ? mq.textScaler.scale(1).clamp(0.8, 1.0)
        : isSmall
        ? mq.textScaler.scale(1).clamp(0.85, 1.1)
        : mq.textScaler.scale(1).clamp(0.9, 1.2);

    final clamped = mq.copyWith(textScaler: TextScaler.linear(clampedScale));

    // FIXED: Responsive padding
    final horizontalPadding = isVerySmall
        ? 12.0
        : isSmall
        ? 16.0
        : 24.0;
    final verticalPadding = isSmall ? 40.0 : 60.0;

    return MediaQuery(
      data: clamped,
      child: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, c) {
            final isWide = c.maxWidth >= 980; // 2 cols on desktops/tablets
            final padBottomForKeyboard = MediaQuery.of(
              context,
            ).viewInsets.bottom;

            return SingleChildScrollView(
              // Add bottom inset so focused fields aren't covered by the keyboard
              padding: EdgeInsets.only(bottom: 16 + padBottomForKeyboard),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: MaxWidth(
                  child: Column(
                    children: [
                      const SectionHeader(
                        title: 'Begin Your Extraordinary Journey',
                        subtitle:
                            'Share your vision — we will craft a timeless celebration',
                      ),
                      SizedBox(
                        height: isSmall ? 20 : 28,
                      ), // FIXED: Responsive spacing
                      // ===== Responsive 1–2 column layout =====
                      Wrap(
                        spacing: isWide ? 40 : 0,
                        runSpacing: isSmall
                            ? 32
                            : 40, // FIXED: Responsive spacing
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          // Left column — contact info
                          SizedBox(
                            width: isWide ? (c.maxWidth - 40) / 2 : c.maxWidth,
                            child: Column(
                              children: [
                                _InfoTile(
                                  icon: '📧',
                                  title: 'Email',
                                  lines: const ['bookings@mirabellaevents.com'],
                                  isSmall: isSmall,
                                  isVerySmall: isVerySmall,
                                ),
                                SizedBox(
                                  height: isSmall ? 12 : 16,
                                ), // FIXED: Responsive spacing
                                _InfoTile(
                                  icon: '📞',
                                  title: 'Phone',
                                  lines: const [
                                    '+92 336 789 9999',
                                    '+92 343 221 1224',
                                  ],
                                  isSmall: isSmall,
                                  isVerySmall: isVerySmall,
                                ),
                                SizedBox(height: isSmall ? 12 : 16),
                                _InfoTile(
                                  icon: '📍',
                                  title: 'Address',
                                  lines: const [
                                    'E-18 Mirabella Complex',
                                    'Gulshan-e-Sehat',
                                  ],
                                  isSmall: isSmall,
                                  isVerySmall: isVerySmall,
                                ),
                                SizedBox(height: isSmall ? 12 : 16),
                                _InfoTile(
                                  icon: '🕐',
                                  title: 'Business Hours',
                                  lines: const [
                                    'Mon–Sat: 10:00–19:00',
                                    'Sun: By appointment',
                                  ],
                                  isSmall: isSmall,
                                  isVerySmall: isVerySmall,
                                ),
                              ],
                            ),
                          ),

                          // Right column — form
                          SizedBox(
                            width: isWide ? (c.maxWidth - 40) / 2 : c.maxWidth,
                            child: Container(
                              padding: EdgeInsets.all(
                                isVerySmall
                                    ? 16
                                    : isSmall
                                    ? 18
                                    : 20, // FIXED: Responsive padding
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.12),
                                borderRadius: BorderRadius.circular(
                                  isSmall ? 16 : 20,
                                ),
                                border: Border.all(
                                  color: AppColors.primaryGold.withOpacity(.4),
                                  width: 3,
                                ),
                              ),
                              child: Form(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // FIXED: Prevent expansion
                                  children: [
                                    _Input(
                                      label: 'Full Name *',
                                      controller: name,
                                      validator: _req,
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [AutofillHints.name],
                                      isSmall: isSmall,
                                    ),
                                    _Input(
                                      label: 'Email Address *',
                                      controller: email,
                                      validator: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [
                                        AutofillHints.email,
                                      ],
                                      isSmall: isSmall,
                                    ),
                                    _Input(
                                      label: 'Phone Number *',
                                      controller: phone,
                                      validator: _phone,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [
                                        AutofillHints.telephoneNumber,
                                      ],
                                      isSmall: isSmall,
                                    ),
                                    _Dropdown(
                                      label: 'Event Type *',
                                      value: eventType.isEmpty
                                          ? null
                                          : eventType,
                                      items: const [
                                        'Luxury Wedding',
                                        'Corporate Event',
                                        'Social Celebration',
                                        'Exclusive Gala',
                                        'Award Ceremony',
                                        'Milestone Event',
                                        'Other',
                                      ],
                                      onChanged: (v) =>
                                          setState(() => eventType = v ?? ''),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Required'
                                          : null,
                                      isSmall: isSmall,
                                    ),
                                    _DatePicker(
                                      label: 'Preferred Date',
                                      value: date,
                                      onPick: () async {
                                        final now = DateTime.now();
                                        final picked = await showDatePicker(
                                          context: context,
                                          firstDate: now,
                                          lastDate: DateTime(now.year + 3),
                                          initialDate: now,
                                          helpText: 'Select event date',
                                        );
                                        if (!mounted) return;
                                        setState(() => date = picked);
                                      },
                                      isSmall: isSmall,
                                    ),
                                    _Dropdown(
                                      label: 'Expected Guest Count',
                                      value: guests.isEmpty ? null : guests,
                                      items: const [
                                        'Intimate (Under 50)',
                                        'Medium (50–150)',
                                        'Large (150–300)',
                                        'Grand (300–500)',
                                        'Spectacular (500+)',
                                      ],
                                      onChanged: (v) =>
                                          setState(() => guests = v ?? ''),
                                      isSmall: isSmall,
                                    ),
                                    // ✅ Budget options in PKR
                                    _Dropdown(
                                      label: 'Estimated Budget (PKR)',
                                      value: budget.isEmpty ? null : budget,
                                      items: const [
                                        'Premium (PKR 1,000,000 – 2,500,000)',
                                        'Luxury (PKR 2,500,000 – 5,000,000)',
                                        'Ultra-Luxury (PKR 5,000,000 – 10,000,000)',
                                        'Bespoke (PKR 10,000,000+)',
                                      ],
                                      onChanged: (v) =>
                                          setState(() => budget = v ?? ''),
                                      isSmall: isSmall,
                                    ),
                                    _MultiInput(
                                      label:
                                          'Event Vision & Special Requirements *',
                                      controller: message,
                                      validator: _req,
                                      isSmall: isSmall,
                                      isVerySmall: isVerySmall,
                                    ),
                                    SizedBox(
                                      height: isSmall ? 8 : 10,
                                    ), // FIXED: Responsive spacing
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryGold,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmall
                                                ? 14
                                                : 16, // FIXED: Responsive padding
                                            horizontal: isSmall ? 12 : 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: _busy ? null : _submit,
                                        child: _busy
                                            ? SizedBox(
                                                width: isSmall
                                                    ? 18
                                                    : 20, // FIXED: Responsive size
                                                height: isSmall ? 18 : 20,
                                                child:
                                                    const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                            Colors.white,
                                                          ),
                                                    ),
                                              )
                                            : Text(
                                                isVerySmall
                                                    ? 'Submit Inquiry'
                                                    : 'Submit Your Inquiry', // FIXED: Shorter text for tiny screens
                                                style: TextStyle(
                                                  fontSize: isSmall
                                                      ? 14
                                                      : 16, // FIXED: Responsive font
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===== validators =====
  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _email(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    final r = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return r.hasMatch(v) ? null : 'Enter a valid email';
  }

  String? _phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'This field is required';
    final r = RegExp(r'^[+]?[\d\s()-]{6,}$');
    return r.hasMatch(v) ? null : 'Enter a valid phone';
  }

  // ===== submit =====
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);

    try {
      final data = <String, dynamic>{
        'name': name.text.trim(),
        'email': email.text.trim().toLowerCase(),
        'phone': phone.text.trim(),
        'message': message.text.trim(),
        'eventType': eventType.isEmpty ? null : eventType,
        'guests': guests.isEmpty ? null : guests,
        'budgetRangePKR': budget.isEmpty ? null : budget,
        'currency': 'PKR',
        'eventDate': date == null ? null : Timestamp.fromDate(date!),
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'contact_form',
        'status': 'new',
      };
      // Remove null/empty to keep docs tidy
      data.removeWhere(
        (k, v) => v == null || (v is String && v.trim().isEmpty),
      );

      await FirebaseFirestore.instance.collection('bookings').add(data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Inquiry received! We will get back to you soon.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primaryGold,
        ),
      );

      // Reset form
      name.clear();
      email.clear();
      phone.clear();
      message.clear();
      setState(() {
        eventType = '';
        date = null;
        guests = '';
        budget = '';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/* ======================= FIXED Local widgets with overflow protection ======================= */

class _InfoTile extends StatelessWidget {
  final String icon, title;
  final List<String> lines;
  final bool isSmall;
  final bool isVerySmall;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.lines,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: isVerySmall
              ? 48
              : isSmall
              ? 52
              : 56, // FIXED: Responsive size
          height: isVerySmall
              ? 48
              : isSmall
              ? 52
              : 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: goldGradient,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isSmall ? 2 : 3,
            ), // FIXED: Thinner border on mobile
          ),
          child: Text(
            icon,
            style: TextStyle(
              fontSize: isVerySmall
                  ? 18
                  : isSmall
                  ? 20
                  : 22,
            ), // FIXED: Responsive font
          ),
        ),
        SizedBox(width: isSmall ? 10 : 14), // FIXED: Less spacing on mobile
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // FIXED: Prevent expansion
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: (isVerySmall ? t.titleMedium : t.titleLarge)!.copyWith(
                  color: AppColors.primaryGold,
                  fontSize: isVerySmall
                      ? 16
                      : null, // FIXED: Smaller font for tiny screens
                  height: 1.2, // FIXED: Tighter line height
                ),
              ),
              SizedBox(height: isSmall ? 4 : 6), // FIXED: Less spacing
              for (final l in lines)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: isSmall ? 1 : 2,
                  ), // FIXED: Less spacing
                  child: Text(
                    l,
                    softWrap: true,
                    maxLines: isVerySmall
                        ? 1
                        : 2, // FIXED: Fewer lines on tiny screens
                    overflow: TextOverflow.ellipsis,
                    style: (isVerySmall ? t.bodyMedium : t.bodyLarge)!.copyWith(
                      height: 1.3, // FIXED: Tighter line height
                      fontSize: isVerySmall ? 13 : null, // FIXED: Smaller font
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final bool isSmall;

  const _Input({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isSmall ? 12 : 16,
      ), // FIXED: Less spacing on mobile
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        decoration: _decoration(label, isSmall),
        style: TextStyle(
          fontSize: isSmall ? 14 : 16, // FIXED: Responsive font size
          height: 1.3, // FIXED: Tighter line height
        ),
      ),
    );
  }
}

class _MultiInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isSmall;
  final bool isVerySmall;

  const _MultiInput({
    required this.label,
    required this.controller,
    this.validator,
    required this.isSmall,
    required this.isVerySmall,
  });

  @override
  Widget build(BuildContext context) {
    // FIXED: More aggressive minLines reduction for smaller screens
    final minLines = isVerySmall
        ? 3
        : isSmall
        ? 4
        : 5;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isSmall ? 12 : 16,
      ), // FIXED: Less spacing
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: isVerySmall
            ? 6
            : isSmall
            ? 8
            : 10, // FIXED: Responsive max lines
        validator: validator,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        decoration: _decoration(label, isSmall),
        style: TextStyle(
          fontSize: isSmall ? 14 : 16, // FIXED: Responsive font size
          height: 1.3, // FIXED: Tighter line height
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool isSmall;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isSmall ? 12 : 16,
      ), // FIXED: Less spacing
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // FIXED: Prevent overflow
                  style: TextStyle(
                    fontSize: isSmall ? 13 : 14, // FIXED: Responsive font
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: validator,
        decoration: _decoration(label, isSmall),
        style: TextStyle(
          fontSize: isSmall ? 14 : 16, // FIXED: Responsive font size
          height: 1.3, // FIXED: Tighter line height
        ),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final bool isSmall;

  const _DatePicker({
    required this.label,
    required this.value,
    required this.onPick,
    required this.isSmall,
  });

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? 'Select date'
        : value!.toString().split(' ').first;
    return Padding(
      padding: EdgeInsets.only(
        bottom: isSmall ? 12 : 16,
      ), // FIXED: Less spacing
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: _decoration(label, isSmall),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // FIXED: Prevent overflow
            style: TextStyle(
              fontSize: isSmall ? 14 : 16, // FIXED: Responsive font size
              height: 1.3, // FIXED: Tighter line height
            ),
          ),
        ),
      ),
    );
  }
}

// FIXED: Responsive decoration function
InputDecoration _decoration(String label, bool isSmall) {
  return InputDecoration(
    labelText: label.toUpperCase(),
    labelStyle: TextStyle(
      letterSpacing: isSmall
          ? 0.8
          : 1.0, // FIXED: Less letter spacing on mobile
      fontSize: isSmall ? 11 : 12, // FIXED: Smaller label font
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(.3), width: 3),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.primaryGold, width: 3),
    ),
    filled: true,
    fillColor: Colors.white.withOpacity(.1),
    isDense: true, // tighter for small screens
    contentPadding: EdgeInsets.symmetric(
      horizontal: isSmall ? 10 : 12, // FIXED: Less padding on mobile
      vertical: isSmall ? 10 : 12,
    ),
  );
}
