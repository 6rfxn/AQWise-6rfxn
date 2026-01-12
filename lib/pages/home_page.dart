import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:irfan/l10n/app_localizations.dart';
import '../provider/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<ThemeProvider>(
      builder: (_, theme, _) => Scaffold(
        appBar: AppBar(
          title: Text(l10n?.myQuran ?? 'MyQuran'),
          centerTitle: true,
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
