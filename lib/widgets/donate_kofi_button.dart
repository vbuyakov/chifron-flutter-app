import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chifron/config/env_config.dart';

class DonateKofiButton extends StatelessWidget {
  const DonateKofiButton({super.key});

  Future<void> _launchKofi(BuildContext context) async {
    final url = EnvConfig.donateUrlKofi;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch donate link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!EnvConfig.enableDonateKofi) return const SizedBox.shrink();
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
        width: double.infinity,
        child: Center(
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text(loc.helpToProject),
              const SizedBox(width: 8),
              Image.asset(
                'assets/kofi5.png',
                height: 30,
              ),
            ])));
  }
}
