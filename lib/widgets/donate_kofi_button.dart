import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chifron/config/env_config.dart';

class DonateKofiButton extends StatelessWidget {
  final String label;
  const DonateKofiButton({
    super.key,
    this.label = '',
  });
  
  Future<void> launchKofi(BuildContext context) async {
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
    return SizedBox(
        width: double.infinity,
        child: GestureDetector(
          onTap: () => launchKofi(context),
          child: Center(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                if (label.isNotEmpty) Text(label),
                if (label.isNotEmpty) const SizedBox(width: 10),
                Image.asset(
                  'assets/kofi5.png',
                  height: 36,
                ),
              ]))
            )
        );
  }
}

