import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:chifron/config/env_config.dart';
import 'package:chifron/providers/locale_provider.dart';
import 'package:chifron/providers/settings_provider.dart';
import 'package:chifron/providers/statistics_provider.dart';
import 'package:chifron/providers/learn_number_provider.dart';
import 'package:chifron/screens/settings_screen.dart';
import 'package:chifron/screens/start_screen.dart';

void main() async {
  // Initialize environment configuration
  await EnvConfig.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
        ChangeNotifierProvider(create: (_) => LearnNumberProvider()),
      ],
      child: const ChifronRoot(),
    ),
  );
}

class ChifronRoot extends StatelessWidget {
  const ChifronRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChifronApp();
  }
}

class ChifronApp extends StatelessWidget {
  const ChifronApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark();
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: 'Chifron',
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.orbitronTextTheme(baseTheme.textTheme),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black.withOpacity(0.85),
          elevation: 8,
          titleTextStyle: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: Colors.cyanAccent,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('uk'),
        Locale('pt'),
        Locale('es'),
        Locale('de'),
        Locale('it'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
