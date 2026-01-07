/*
=== FLUTTER CONCEPTS ===

// Widget - Everything in Flutter is a widget (buttons, text, layouts, containers, etc.)
//   Think of widgets like Roblox GUI objects (TextLabel, TextButton, Frame, etc.)

// StatelessWidget - A widget that never changes (immutable)
//   Like a static TextLabel that just displays text
//   Example: Logo, static text, icons

// StatefulWidget - A widget that can change over time (has mutable state)
//   Like a TextLabel that updates when player's health changes
//   Example: Counter, forms, animations, anything that updates

// BuildContext (context) - Info about where this widget is in the widget tree
//   Like knowing a GUI object's Parent or hierarchy in Roblox
//   Used to access theme, navigation, screen size, etc.

// Consumer<ThemeProvider> - Listens to a provider for changes (like .Changed in Roblox)
//   Automatically rebuilds the widget when the provider calls notifyListeners()
//   Parameters: (context, provider, child)
//     - context: Widget tree info
//     - provider: Your provider instance (e.g., ThemeProvider)
//     - child: Optional widget that doesn't rebuild (optimization)

// ChangeNotifier - Base class for creating observable objects
//   Like creating a ModuleScript with .Changed events
//   Call notifyListeners() to tell all Consumers to update

// ChangeNotifierProvider - Makes a provider available to entire widget tree
//   Like storing something in _G but better and more organized
//   Wraps your app so all child widgets can access the provider

=== PROVIDER PATTERN (STATE MANAGEMENT) ===

// How it works:
// 1. Create a class that extends ChangeNotifier
// 2. Add properties and methods
// 3. Call notifyListeners() when data changes
// 4. Wrap app with ChangeNotifierProvider
// 5. Use Consumer to listen and rebuild UI

// Example flow:
void main() {
  runApp(
    ChangeNotifierProvider(              // 2️⃣ Make provider available everywhere
      create: (context) => ThemeProvider(), // 3️⃣ Create instance
      child: const MyApp(),               // 4️⃣ Your app
    ),
  );
}

// In any widget:
Consumer<ThemeProvider>(                  // 5️⃣ Listen for changes
  builder: (context, theme, child) {
    return Text(theme.isDarkMode ? 'Dark' : 'Light');
  },
)

// When ThemeProvider calls notifyListeners(), Consumer rebuilds automatically!

=== DART KEYWORDS & VARIABLES ===

// const - Value set at compile time, never changes
//   Like: local MAX_PLAYERS = 10 (convention in Roblox)
const String APP_NAME = "MyApp";
const int MAX_RETRIES = 3;
// APP_NAME = "New"; // ❌ ERROR! Cannot change const

// final - Value set once at runtime, then locked forever
//   No direct Roblox equivalent (just don't reassign the variable)
final userId = getCurrentUser();        // Set when code runs
final screenWidth = getScreenSize();
// userId = "new"; // ❌ ERROR! Cannot reassign final

// var - Can change anytime (normal variable)
//   Like: local counter = 0 in Roblox
var counter = 0;
counter = 5;      // ✅ OK
counter = 10;     // ✅ OK

// dynamic - Any type allowed (avoid if possible, bad practice)
dynamic anything = "text";
anything = 123;   // ✅ Allowed but not recommended

// static - Belongs to the class itself, not instances
//   Like Module.property vs self.property in Roblox
class Config {
  static const String VERSION = "1.0.0";  // Shared by all
  String userName = "John";               // Each instance has own copy
}
// Access: Config.VERSION (no instance needed)
// Access: instance.userName (need instance)

// static const - A constant that belongs to the class
//   Perfect for configuration values, keys, constants
class ThemeProvider {
  static const String _themeKey = 'isDarkMode';  // Shared constant
}

=== PRIVATE VS PUBLIC ===

// _ (underscore prefix) - Makes variable/function PRIVATE to this file
//   Like "local" in Roblox ModuleScripts
String _privateVariable = "secret";       // Only this file can use
String publicVariable = "everyone";       // Any file can import and use

class MyClass {
  String _privateProp = "hidden";         // Private property
  String publicProp = "visible";          // Public property

  void _privateMethod() {}                // Private method
  void publicMethod() {}                  // Public method
}

=== GETTERS & SETTERS ===

// Getter - Read-only access to private variables (like a property)
class ThemeProvider {
  ThemeData _themeData = lightMode;       // Private

  ThemeData get themeData => _themeData;  // Public getter (read-only)
}
// Usage: theme.themeData (looks like property, but it's a getter)

// Setter - Control how variables are modified
class ThemeProvider {
  ThemeData _themeData = lightMode;

  set themeData(ThemeData value) {        // Setter with validation
    _themeData = value;
    notifyListeners();                    // Notify when changed!
  }
}
// Usage: theme.themeData = darkMode; (calls setter automatically)

// Roblox equivalent:
local Module = {}
function Module:getTheme() return self._theme end  -- Getter
function Module:setTheme(value)                    -- Setter
    self._theme = value
    self:notifyListeners()
end

=== ASYNC PROGRAMMING ===

// async - Marks function as asynchronous (does work that takes time)
//   Like functions that use DataStore, HTTP requests, or task.wait()
Future<String> loadData() async { }

// await - Wait for async operation to finish before continuing
//   Like task.wait() but MUCH smarter (doesn't block everything)
final data = await loadData();            // Waits here, then continues
print(data);                              // Runs AFTER data is loaded

// Future<T> - Represents a value that will be available later
//   Like Promises in JavaScript or callbacks in Roblox
Future<void> - Returns nothing (just does work)
Future<String> - Returns a String later
Future<int> - Returns an int later
Future<bool> - Returns a bool later

// Without await (WRONG!):
void loadTheme() {
  final prefs = SharedPreferences.getInstance();  // ❌ Returns Future, not data!
  final isDark = prefs.getBool('isDarkMode');     // ❌ Error! prefs isn't ready!
}

// With await (CORRECT!):
Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance(); // ✅ Wait for it
  final isDark = prefs.getBool('isDarkMode') ?? false; // ✅ Now it works!
}

// Roblox comparison:
Dart: await Future.delayed(Duration(seconds: 2))
Lua:  task.wait(2)

Dart: final data = await fetchFromAPI()
Lua:  local data = HttpService:GetAsync(url)

=== FUNCTION SYNTAX ===

// void - Function returns nothing
void printHello() {
  print("Hello");
}

// String - Function returns a String
String getName() {
  return "John";
}

// Future<void> - Async function that returns nothing
Future<void> saveData() async {
  await storage.save();
  print("Saved!");
}

// Future<String> - Async function that returns a String
Future<String> loadUserName() async {
  await Future.delayed(Duration(seconds: 1));
  return "John";
}

// Arrow functions (short syntax for simple functions)
void sayHi() => print("Hi!");
// Same as: void sayHi() { print("Hi!"); }

int add(int a, int b) => a + b;
// Same as: int add(int a, int b) { return a + b; }

// Named parameters (can call in any order)
void greet({required String name, int age = 0}) {
  print("Hello $name, age $age");
}
greet(name: "John", age: 25);
greet(age: 30, name: "Jane");     // Order doesn't matter!

// Positional parameters (must be in order)
void greet(String name, int age) {
  print("Hello $name, age $age");
}
greet("John", 25);                // Must be in order

=== PARAMETER NAMING WITH UNDERSCORES ===

// _ and __ - Convention for unused parameters
//   Tells other developers "I know this exists but I'm not using it"

// Full version (all parameters named):
builder: (context, themeProvider, child) => Widget()

// Short version (only using themeProvider):
builder: (_, theme, __) => Widget()
         ↑    ↑     ↑
         |    |     └── child (not using)
         |    └──────── themeProvider (USING THIS!)
         └───────────── context (not using)

// Common patterns:
builder: (_, theme, __) => Widget()      // Only need provider
builder: (context, _, __) => Widget()    // Only need context
builder: (context, theme, _) => Widget() // Need context and provider
builder: (context, theme, child) => Widget() // Need all three

=== CLASSES & CONSTRUCTORS ===

// Class - Like a ModuleScript with metatables in Roblox
class ThemeProvider extends ChangeNotifier {
  // Properties
  bool isDarkMode = false;

  // Method
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

// Constructor - Creates new instance (like Module.new() in Roblox)
class Person {
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Named constructor
  Person.guest() : name = "Guest", age = 0;
}

// Usage:
Person person1 = Person("John", 25);
Person person2 = Person.guest();

// super.key - Pass parameter to parent class (Flutter requirement)
class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // Pass key to StatelessWidget
}

// Roblox equivalent:
local Module = {}
Module.__index = Module

function Module.new(name, age)
    local self = setmetatable({}, Module)
    self.name = name
    self.age = age
    return self
end

=== OPERATORS & SHORTCUTS ===

// Null safety operators
String? name;                     // Can be null
String name = "John";             // Cannot be null

final result = name ?? "Guest";   // If name is null, use "Guest"
final length = name?.length;      // Safe access (returns null if name is null)
name ??= "Default";               // Assign only if null

// Ternary operator (like "and"/"or" in Lua)
String message = isDark ? 'Dark Mode' : 'Light Mode';
// Same as: if (isDark) { message = 'Dark Mode'; } else { message = 'Light Mode'; }

// String interpolation (embed variables in strings)
String name = "John";
String greeting = 'Hello, $name!';           // Hello, John!
String calc = 'Result: ${2 + 2}';            // Result: 4
String access = 'Length: ${name.length}';    // Length: 4

// Roblox equivalent:
local name = "John"
local greeting = "Hello, " .. name .. "!"
local calc = "Result: " .. tostring(2 + 2)

=== MAIN ENTRY POINT ===

// void main() - Where your app starts (required!)
//   Like the main script that runs first in Roblox
void main() {
  runApp(const MyApp());  // Start Flutter app
}

// runApp() - Flutter function that launches your app
//   Takes a widget and displays it on screen

// Full example with provider:
void main() {
  runApp(                                   // 1️⃣ Start app
    ChangeNotifierProvider(                 // 2️⃣ Provide state management
      create: (context) => ThemeProvider(), // 3️⃣ Create provider instance
      child: const MyApp(),                 // 4️⃣ Your actual app
    ),
  );
}

=== PUBSPEC.YAML - PROJECT CONFIGURATION FILE ===

// pubspec.yaml - Your project's blueprint (like a config file)
//   Defines: app name, version, dependencies (packages), assets (images/fonts)
//   Like a combination of Roblox's module list + game settings

// Basic structure:
name: my_app                      # App name
description: A new Flutter app    # What it does
version: 1.0.0+1                 # Version (1.0.0) + build number (+1)

environment:
  sdk: '>=3.0.0 <4.0.0'          # Required Dart version

dependencies:                     # Packages your app needs
  flutter:
    sdk: flutter
  provider: ^6.0.0               # State management
  shared_preferences: ^2.0.0     # Save data locally
  http: ^1.0.0                   # API calls

dev_dependencies:                 # Only for development (not in final app)
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0          # Code quality checker

flutter:
  uses-material-design: true

  assets:                         # Images, fonts, files
    - assets/images/
    - assets/icons/

  fonts:                          # Custom fonts
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf

// Version numbers explained:
provider: ^6.0.0    # ^6.0.0 means "6.0.0 or higher, but less than 7.0.0"
http: 1.0.0         # Exact version only
dio: '>=5.0.0 <6.0.0'  # Range: any 5.x.x version

// Common commands:
flutter pub get       # Install all dependencies (run after editing pubspec.yaml!)
flutter pub upgrade   # Update all packages
flutter pub add provider     # Add a new package
flutter pub remove provider  # Remove a package

// Roblox comparison:
Dart:  Add package to pubspec.yaml → flutter pub get → import 'package:name/name.dart';
Lua:   Put ModuleScript in game → require(script.Module)

=== IMAGES & ASSETS ===

// Three ways to use images:

// 1. LOCAL IMAGES (bundled with app) - NEED pubspec.yaml ✅
// Step 1: Create folder structure
my_app/
├── assets/
│   └── images/
│       ├── logo.png
│       └── bike.png

// Step 2: Add to pubspec.yaml
flutter:
  assets:
    - assets/images/              # All images in folder
    - assets/images/logo.png      # Or specify individual files

// Step 3: Run command
flutter pub get

// Step 4: Use in code
Image.asset('assets/images/logo.png')
Image.asset('assets/images/bike.png', width: 200, height: 200)

// 2. NETWORK IMAGES (from internet) - NO pubspec.yaml needed ❌
Image.network('https://example.com/image.png')
Image.network(
  'https://example.com/bike.png',
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();  // Show loading
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);            // Show error icon
  },
)

// 3. OTHER IMAGE SOURCES - NO pubspec.yaml needed ❌
Image.memory(imageBytes)           // From bytes/API
Image.file(File('/path/to/image')) // From device storage

// BoxFit options (how image fits in space):
fit: BoxFit.cover      // Fill space (may crop)
fit: BoxFit.contain    // Show entire image (may have empty space)
fit: BoxFit.fill       // Stretch to fill (distorts image)
fit: BoxFit.none       // Don't scale
fit: BoxFit.scaleDown  // Scale down if too big

// Complete example:
Image.asset(
  'assets/images/bike.png',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.broken_image);
  },
)

// Dynamic image path:
String bikeName = 'sport';
Image.asset('assets/images/$bikeName.png')

// Best practice for your app:
// - Essential images (logo, placeholders) → assets + pubspec.yaml
// - Vehicle images that change often → Image.network()

// Roblox comparison:
Roblox: local img = ReplicatedStorage.Assets.Images.Logo
        imageLabel.Image = "rbxassetid://123456"

Flutter: Image.asset('assets/images/logo.png')
         Image.network('https://example.com/logo.png')

=== COMPARISON TABLE: ROBLOX vs FLUTTER ===

Roblox Lua              | Flutter/Dart
------------------------|----------------------------------
local Module = {}       | class ClassName
Module.__index          | extends / implements
Module.new()            | Constructor
self.property           | this.property (or just property)
function Module:method()| void methodName()
local (inside module)   | private (_variableName)
Module.property         | static property
ModuleScript            | .dart file
require()               | import 'package:name/name.dart';
.Changed:Connect()      | Consumer / addListener
Fire callbacks          | notifyListeners()
task.wait()             | await Future.delayed()
HttpService:GetAsync()  | await http.get()
Promises/callbacks      | Future<T>
DataStore               | SharedPreferences / Database
GUI objects             | Widgets
Frame/TextLabel         | Container/Text
UIListLayout            | Column/Row/ListView
"and"/"or"              | ? : (ternary)
.. (concatenation)      | String interpolation ($var)
No equivalent           | final (set once)
UPPERCASE convention    | const / static const
table = {key = value}   | Class with defined properties

=== USEFUL PATTERNS ===

// Null-aware operators
final name = getName() ?? 'Guest';        // Default if null
user?.updateProfile();                     // Call only if not null
value ??= getDefault();                    // Assign only if null

// Collection operations
final numbers = [1, 2, 3, 4, 5];
final doubled = numbers.map((n) => n * 2).toList();  // [2, 4, 6, 8, 10]
final evens = numbers.where((n) => n % 2 == 0).toList(); // [2, 4]

// Spread operator
final list1 = [1, 2, 3];
final list2 = [4, 5, 6];
final combined = [...list1, ...list2];    // [1, 2, 3, 4, 5, 6]

// Cascade notation (chain operations)
final paint = Paint()
  ..color = Colors.red
  ..strokeWidth = 5.0
  ..style = PaintingStyle.stroke;

// Switch expressions (Dart 3.0+)
String message = switch (value) {
  0 => 'Zero',
  1 => 'One',
  _ => 'Other'
};

=== IMPORTANT REMINDERS ===

✅ Always run `flutter pub get` after editing pubspec.yaml
✅ Use const for widgets that never change (optimization)
✅ Use final for variables that are set once
✅ Use _ prefix for private variables/methods
✅ Call notifyListeners() after changing provider data
✅ Wrap app with ChangeNotifierProvider to use Consumer
✅ Use await with async functions
✅ Add assets to pubspec.yaml to use Image.asset()
✅ YAML is space-sensitive! Use 2 spaces, not tabs
✅ String interpolation: 'Hello $name' or 'Result: ${2+2}'

❌ Don't use Image.asset() without adding to pubspec.yaml
❌ Don't forget async keyword when using await
❌ Don't use var when you can use final (performance)
❌ Don't modify pubspec.lock (auto-generated)
❌ Don't forget to call notifyListeners() in providers
❌ Don't use dynamic unless absolutely necessary

=== COMMON PACKAGES ===

provider: ^6.0.0              # State management (for ThemeProvider)
shared_preferences: ^2.0.0    # Save simple data (theme preference)
http: ^1.0.0                  # Make API calls
dio: ^5.0.0                   # Better HTTP client
google_fonts: ^6.0.0          # Use Google Fonts
flutter_svg: ^2.0.0           # SVG images
hive: ^2.0.0                  # Local database
sqflite: ^2.0.0               # SQLite database
firebase_core: ^2.0.0         # Firebase
path_provider: ^2.0.0         # Get file paths
image_picker: ^1.0.0          # Pick images from gallery

// Find packages at: https://pub.dev

================================================================================
END OF REFERENCE GUIDE
================================================================================
*/