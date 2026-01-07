# Flutter App Localization Guide

This guide explains how to implement multi-language support in Flutter apps using the built-in localization system with ARB (Application Resource Bundle) files.

## Setup

### 1. Add Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true  # Enable code generation
```

### 2. Create l10n Configuration

Create `l10n.yaml` in project root:
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### 3. Create ARB Files

Create `lib/l10n/` folder with language files:

**`lib/l10n/app_en.arb`** (English - Template):
```json
{
  "@@locale": "en",
  "appTitle": "My App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome!",
  "@welcomeMessage": {
    "description": "Welcome message shown to users"
  },
  "settings": "Settings",
  "language": "Language",
  "theme": "Theme",
  "darkMode": "Dark Mode",
  "lightMode": "Light Mode"
}
```

**`lib/l10n/app_ar.arb`** (Arabic):
```json
{
  "@@locale": "ar",
  "appTitle": "تطبيقي",
  "welcomeMessage": "مرحبا!",
  "settings": "الإعدادات",
  "language": "اللغة",
  "theme": "المظهر",
  "darkMode": "الوضع الداكن",
  "lightMode": "الوضع الفاتح"
}
```

**Other common languages:**
- `app_es.arb` - Spanish (Español)
- `app_fr.arb` - French (Français)
- `app_zh.arb` - Chinese (中文)
- `app_ja.arb` - Japanese (日本語)
- `app_ms.arb` - Malay (Bahasa Melayu)

### 4. Configure MaterialApp

Update `main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Supported locales
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('es'), // Spanish
        Locale('fr'), // French
        // Add more languages here
      ],
      
      // Optional: Set locale resolution fallback
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if current locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // Fallback to English
        return supportedLocales.first;
      },
      
      title: 'My App',
      home: const HomePage(),
    );
  }
}
```

### 5. Generate Localization Files

Run command to generate localization classes:
```bash
flutter pub get
flutter gen-l10n  # Or just restart app - auto-generates
```

## Usage in Code

### Basic Usage
```dart
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Text(l10n.welcomeMessage),
        Text(l10n.appTitle),
        ElevatedButton(
          onPressed: () {},
          child: Text(l10n.settings),
        ),
      ],
    );
  }
}
```

### With Null Safety Check
```dart
final l10n = AppLocalizations.of(context);
if (l10n != null) {
  Text(l10n.welcomeMessage);
}
```

### In AppBar
```dart
AppBar(
  title: Text(AppLocalizations.of(context)!.appTitle),
)
```

## Advanced Features

### 1. Parameterized Messages

**In ARB file:**
```json
{
  "greeting": "Hello, {name}!",
  "@greeting": {
    "description": "Greeting message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  },
  "itemCount": "{count} items",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  }
}
```

**Usage:**
```dart
Text(l10n.greeting('John'))  // "Hello, John!"
Text(l10n.itemCount(5))      // "5 items"
```

### 2. Pluralization

**In ARB file:**
```json
{
  "messageCount": "{count, plural, =0{No messages} =1{1 message} other{{count} messages}}",
  "@messageCount": {
    "description": "Number of messages",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

**Usage:**
```dart
Text(l10n.messageCount(0))  // "No messages"
Text(l10n.messageCount(1))  // "1 message"
Text(l10n.messageCount(5))  // "5 messages"
```

### 3. Date/Time Formatting

**In ARB file:**
```json
{
  "currentDate": "Today is {date}",
  "@currentDate": {
    "description": "Current date",
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMMd"
      }
    }
  }
}
```

**Usage:**
```dart
Text(l10n.currentDate(DateTime.now()))
```

## Switching Language Manually

### Method 1: Using Locale in MaterialApp
```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: HomePage(onLanguageChange: _changeLanguage),
    );
  }
}
```

### Method 2: Using Provider (Recommended)

**Create LocaleProvider:**
```dart
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
```

**Setup in main.dart:**
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (_, localeProvider, __) => MaterialApp(
        locale: localeProvider.locale,
        // ... rest of config
      ),
    );
  }
}
```

**Language Switcher Widget:**
```dart
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return DropdownButton<String>(
      value: localeProvider.locale.languageCode,
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
        DropdownMenuItem(value: 'es', child: Text('Español')),
      ],
      onChanged: (languageCode) {
        if (languageCode != null) {
          localeProvider.setLocale(Locale(languageCode));
        }
      },
    );
  }
}
```

## Right-to-Left (RTL) Support

### Automatic RTL Detection

Flutter automatically handles RTL for languages like Arabic and Hebrew:
```dart
MaterialApp(
  // No special config needed - Flutter handles it automatically
  localizationsDelegates: [...],
  supportedLocales: const [
    Locale('en'), // LTR
    Locale('ar'), // RTL - automatic!
  ],
)
```

### Manual RTL Control
```dart
Directionality(
  textDirection: TextDirection.rtl,  // or TextDirection.ltr
  child: YourWidget(),
)
```

### Check Current Direction
```dart
bool isRTL = Directionality.of(context) == TextDirection.rtl;
```

## Persisting Language Preference

**Using SharedPreferences:**
```dart
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}
```

**Initialize on app start:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();
  
  runApp(
    ChangeNotifierProvider.value(
      value: localeProvider,
      child: const MyApp(),
    ),
  );
}
```

## Common Language Codes

| Language | Code | RTL |
|----------|------|-----|
| English | `en` | No |
| Arabic | `ar` | Yes |
| Spanish | `es` | No |
| French | `fr` | No |
| German | `de` | No |
| Chinese (Simplified) | `zh` | No |
| Japanese | `ja` | No |
| Korean | `ko` | No |
| Portuguese | `pt` | No |
| Russian | `ru` | No |
| Hindi | `hi` | No |
| Malay | `ms` | No |
| Indonesian | `id` | No |
| Turkish | `tr` | No |
| Italian | `it` | No |
| Hebrew | `he` | Yes |
| Urdu | `ur` | Yes |

## Best Practices

1. ✅ Always use `app_en.arb` as the template
2. ✅ Add `@` descriptions for all strings
3. ✅ Use meaningful key names (e.g., `loginButton` not `btn1`)
4. ✅ Run `flutter pub get` after adding new strings
5. ✅ Test with different languages, especially RTL
6. ✅ Keep translations consistent across files
7. ✅ Use parameters for dynamic content
8. ✅ Provide context in descriptions for translators

## Troubleshooting

**Localization not working:**
```bash
flutter clean
flutter pub get
flutter run
```

**Strings not updating:**
- Make sure `flutter: generate: true` is in `pubspec.yaml`
- Run `flutter gen-l10n`
- Restart the app

**Import errors:**
- Check that files are generated in `.dart_tool/flutter_gen/gen_l10n/`
- Verify import path: `import 'l10n/app_localizations.dart';`

## Resources

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Intl Package](https://pub.dev/packages/intl)

---

**Quick Start Checklist:**
- [ ] Add dependencies to `pubspec.yaml`
- [ ] Create `l10n.yaml`
- [ ] Create ARB files in `lib/l10n/`
- [ ] Configure `MaterialApp` with delegates
- [ ] Run `flutter pub get`
- [ ] Import and use `AppLocalizations.of(context)`