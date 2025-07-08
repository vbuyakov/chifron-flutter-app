import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:chifron/screens/number_game_screen.dart';
import 'package:chifron/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chifron/providers/statistics_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chifron/config/env_config.dart';
import 'package:chifron/widgets/donate_kofi_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

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
    final loc = AppLocalizations.of(context)!;
    return Consumer<StatisticsProvider>(
      builder: (context, statistics, child) {
        final correct = statistics.totalCorrect;
        final wrong = statistics.totalWrong;
        final percent = statistics.overallPercent;

        return Scaffold(
          extendBodyBehindAppBar: true,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                  ),
                  child: Center(
                    child: Text(
                      loc.menuPlaceholder,
                      style: GoogleFonts.orbitron(
                        color: Colors.cyanAccent,
                        fontSize: 22,
                      ),
                    ),
                  ),
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
                ),
                if (EnvConfig.enableDonateKofi)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final url = EnvConfig.donateUrlKofi;
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Image.asset(
                          'assets/kofi5.png',
                          height: 36,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(loc.appTitle),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            backgroundColor: Colors.black.withOpacity(0.85),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 160, 32, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.score,
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: GoogleFonts.orbitron(
                      color: Colors.lightGreenAccent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.greenAccent, size: 32),
                      const SizedBox(width: 8),
                      Text('$correct',
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 28)),
                      const SizedBox(width: 32),
                      Icon(Icons.close, color: Colors.redAccent, size: 32),
                      const SizedBox(width: 8),
                      Text('$wrong',
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 28)),
                    ],
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        textStyle: GoogleFonts.orbitron(
                            fontSize: 28, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const NumberGameScreen()),
                        );
                      },
                      child: Center(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(loc.playNumbers),
                          const SizedBox(width: 8),
                          Icon(Icons.rocket_launch_outlined,
                              color: Colors.black, size: 30),
                        ],
                      ))),
                  const SizedBox(height: 18),
                  Spacer(),
                  DonateKofiButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
