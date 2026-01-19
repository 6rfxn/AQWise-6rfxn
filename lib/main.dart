import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:irfan/l10n/app_localizations.dart';
import 'package:irfan/pages/main_page.dart';
import 'package:irfan/provider/theme_provider.dart';
import 'package:irfan/provider/locale_provider.dart';
import 'package:irfan/provider/tajweed_provider.dart';
import 'package:irfan/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize providers
  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();
  final tajweedProvider = TajweedProvider();
  
  await Future.wait([
    themeProvider.load(),
    localeProvider.load(),
    tajweedProvider.load(),
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: tajweedProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // disable banner
          title: 'irfan',
          // Localization configuration
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('id'),
            Locale('ms'),
          ],
          theme: lightMode,
          darkTheme: darkMode,
          themeMode: themeProvider.themeMode,
          home: const MainPage(),
        );
      },
    );
  }
}
