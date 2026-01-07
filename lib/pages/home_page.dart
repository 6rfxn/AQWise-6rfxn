import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irfan/l10n/app_localizations.dart';
import '../provider/theme_provider.dart';
import '../provider/locale_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // show func
  void _showDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = Localizations.localeOf(context);

    final languages = {
      'en': l10n?.english ?? 'English',
      'id': l10n?.bahasa ?? 'Bahasa Indonesia',
      'ms': l10n?.bahasaMelayu ?? 'Bahasa Melayu',
    };

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n?.language ?? 'Language'),
        children: languages.entries.map((entry) {
          return SimpleDialogOption(
            onPressed: () {
              localeProvider.setLocale(Locale(entry.key));
              Navigator.pop(ctx);
            },
            child: Row(
              children: [
                Icon(
                  currentLocale.languageCode == entry.key
                      ? Icons.circle
                      : Icons.circle_outlined,
                  color: currentLocale.languageCode == entry.key
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 16),
                Text(entry.value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context);
    final currentLanguage = currentLocale.languageCode; // (en)

    return Consumer<ThemeProvider>(
      builder: (_, theme, _) => Scaffold(
        appBar: AppBar(
          title: Text(l10n?.myQuran ?? 'MyQuran'),
          centerTitle: true
        ),
        drawer: Drawer(
          child: ListView(
     //       padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                /*
                decoration: const BoxDecoration(
                    color: Color(0xFF0A84FF)
                ),
                 */
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    l10n?.settings ?? 'Settings',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Theme toggle
              Consumer<ThemeProvider>(
                builder: (_, theme, _) {
                  final l10nTheme = AppLocalizations.of(context);
                  return ListTile(
                    leading: Icon(
                      theme.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: Text(l10nTheme?.theme ?? 'Theme'),
                    subtitle: Text(
                      theme.isDarkMode 
                          ? (l10nTheme?.darkMode ?? 'Dark Mode')
                          : (l10nTheme?.lightMode ?? 'Light Mode')
                    ),
                    trailing: Switch(
                      value: theme.isDarkMode,
                      onChanged: theme.setDarkMode,
                    ),
                  );
                },
              ),
              // Language selection
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n?.language ?? 'Language'),
                subtitle: Text(currentLanguage),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showDialog(context),
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n!.welcomeMessage,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.appInDevelopment,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
