import 'package:flutter/material.dart';
import 'package:flauth/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'security_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'dev@liujiacai.net',
      query: 'subject=Flauth Feedback',
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.hasData
              ? l10n.version(snapshot.data!.version, snapshot.data!.buildNumber)
              : l10n.loading;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Icon(Icons.lock_outline, size: 80, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Flauth',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  version,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 32),
              Text(l10n.appDescription, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.security),
                title: Text(l10n.securitySettings),
                subtitle: Text(l10n.setupPinBiometrics),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SecurityScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.code),
                title: Text(l10n.github),
                subtitle: Text(l10n.githubUrl),
                onTap: () => _launchUrl('https://github.com/jiacai2050/flauth'),
                trailing: const Icon(Icons.open_in_new, size: 16),
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(l10n.feedbackAndSupport),
                subtitle: const Text('dev@liujiacai.net'),
                onTap: _launchEmail,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  '© ${DateTime.now().year} Jiacai Liu',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
