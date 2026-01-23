import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_home_page.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool _accepted = false;

  static const Color primaryBlue = Color(0xFF001F54);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          /// Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _Title('Privacy Policy'),
                      _SubText('Last updated: December 22, 2025'),
                      _Section(
                        'Introduction',
                        'This Privacy Policy describes Our policies and procedures on the collection, '
                            'use and disclosure of Your information when You use the Service and tells You '
                            'about Your privacy rights and how the law protects You.',
                      ),
                      _Section(
                        'Definitions',
                        '• Application refers to Emotion Eye\n'
                            '• Company refers to Emotion Eye\n'
                            '• Country refers to Gujarat, India\n'
                            '• Device means any device such as a phone or tablet\n'
                            '• Personal Data means identifiable information\n'
                            '• Service refers to the Application\n'
                            '• Usage Data refers to automatically collected data',
                      ),
                      _Section(
                        'Data We Collect',
                        '• Usage Data (device information, diagnostics)\n'
                            '• Camera images for emotion detection (with permission)',
                      ),
                      _Section(
                        'How We Use Data',
                        'We use collected data to:\n'
                            '• Provide and maintain the service\n'
                            '• Improve user experience\n'
                            '• Enable emotion detection features\n'
                            '• Send app-related notifications',
                      ),
                      _Section(
                        'Camera & Permissions',
                        'Emotion Eye uses the device camera only after your permission. '
                            'Captured images are used solely for emotion analysis and are not '
                            'sold or shared for advertising purposes.',
                      ),
                      _Section(
                        'Data Sharing',
                        'We may share data:\n'
                            '• With service providers\n'
                            '• During business transfers\n'
                            '• With affiliates\n'
                            '• When legally required\n'
                            '• With your explicit consent',
                      ),
                      _Section(
                        'Data Retention',
                        'Personal Data is retained only as long as necessary to fulfill the purposes '
                            'outlined in this policy or comply with legal obligations.',
                      ),
                      _Section(
                        'Data Security',
                        'We take reasonable security measures to protect your data, but no electronic '
                            'storage or transmission method is 100% secure.',
                      ),
                      _Section(
                        'Children’s Privacy',
                        'Emotion Eye does not knowingly collect data from children under 13. '
                            'If such data is discovered, it will be removed promptly.',
                      ),
                      _Section(
                        'External Links',
                        'Our Service may contain links to third-party websites. '
                            'We are not responsible for their privacy practices.',
                      ),
                      _Section(
                        'Policy Updates',
                        'This Privacy Policy may be updated periodically. Continued use of the app '
                            'implies acceptance of any changes.',
                      ),
                      _Section(
                        'Contact Us',
                        'Email: darshanvaru2003@gmail.com',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Acceptance area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _accepted,
                      activeColor: primaryBlue,
                      onChanged: (v) => setState(() => _accepted = v ?? false),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'I have read and agree to the Privacy Policy.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('privacy_accepted', false);

                            SystemNavigator.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _accepted ? _confirm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            disabledBackgroundColor:
                                primaryBlue.withValues(alpha: 0.4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_accepted', true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MainHomePage(pageNumber: 0),
      ),
    );
  }
}

/* ------------------ UI Helpers ------------------ */

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SubText extends StatelessWidget {
  final String text;

  const _SubText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001F54),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
