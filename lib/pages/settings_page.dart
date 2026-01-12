import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irfan/l10n/app_localizations.dart';
import '../provider/theme_provider.dart';
import '../provider/locale_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settings ?? 'Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _themeOption(context),
          _langOption(context, l10n, locale),
        ],
      ),
    );
  }

  Widget _themeOption(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, theme, _) {
        final l10n = AppLocalizations.of(context);
        return ListTile(
          leading: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          title: Text(l10n?.theme ?? 'Theme'),
          subtitle: Text(
            theme.isDarkMode
                ? (l10n?.darkMode ?? 'Dark Mode')
                : (l10n?.lightMode ?? 'Light Mode'),
          ),
          trailing: Switch(
            value: theme.isDarkMode,
            onChanged: theme.setDarkMode,
          ),
        );
      },
    );
  }

  Widget _langOption(BuildContext context, AppLocalizations? l10n, Locale locale) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n?.language ?? 'Language'),
      subtitle: Text(locale.languageCode),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLangDialog(context, l10n, locale),
    );
  }

  void _showLangDialog(BuildContext context, AppLocalizations? l10n, Locale locale) {
    final languages = {
      'en': l10n?.english ?? 'English',
      'id': l10n?.bahasa ?? 'Bahasa Indonesia',
      'ms': l10n?.bahasaMelayu ?? 'Bahasa Melayu',
    };

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n?.language ?? 'Language'),
        children: languages.entries.map((e) {
          final isSelected = locale.languageCode == e.key;
          return SimpleDialogOption(
            onPressed: () {
              context.read<LocaleProvider>().setLocale(Locale(e.key));
              Navigator.pop(ctx);
            },
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.circle : Icons.circle_outlined,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                const SizedBox(width: 16),
                Text(e.value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}