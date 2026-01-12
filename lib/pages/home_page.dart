import 'package:flutter/material.dart';
import 'package:irfan/l10n/app_localizations.dart';
import 'tajweed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final txtColor = isDarkMode ? Colors.white : theme.colorScheme.onSurface;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0F1C) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150 + statusBarHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(90),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        l10n!.welcomeMessage,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.appInDevelopment,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Explore',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: txtColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _card(
                        icon: Icons.menu_book,
                        title: 'Tajweed',
                        desc: 'Learn the rules of Tajweed',
                        isDarkMode: isDarkMode,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TajweedPage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final cardColor = isDarkMode 
        ? Colors.white.withValues(alpha: 0.08) 
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDarkMode 
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final txtColor = isDarkMode ? Colors.white : theme.colorScheme.onSurface;
    final subColor = isDarkMode 
        ? Colors.white.withValues(alpha: 0.6) 
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final icoColor = isDarkMode 
        ? Colors.white.withValues(alpha: 0.4) 
        : theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            _icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 13,
                      color: subColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: icoColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.2),
            theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: theme.colorScheme.primary, size: 28),
    );
  }
}
