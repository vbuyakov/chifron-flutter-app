import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chifron/config/env_config.dart';
import 'package:chifron/screens/settings_screen.dart';
import 'package:chifron/widgets/donate_kofi_button.dart';


class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final double statusBarHeight = MediaQuery.paddingOf(context).top;

    return Drawer(
            child: Column(
              children: [
                Expanded(child: 
                      ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: statusBarHeight + 32,
                        color: Colors.black.withOpacity(0.85),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.cyanAccent),
                        title: Text(loc.settings,
                            style: GoogleFonts.orbitron(color: Colors.cyanAccent)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                      )
                    ],
                  ),
                ),
                if (EnvConfig.enableDonateKofi)
                      Container(
                        padding: EdgeInsets.only(bottom: 48),
                        child: 
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: DonateKofiButton()
                        )
                      ),
              ],
            )
          );
  }


}