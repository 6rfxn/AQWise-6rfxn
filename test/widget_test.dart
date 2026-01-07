import 'package:flutter_test/flutter_test.dart';
import 'package:irfan/main.dart';

// testWidgets (flutter_test)
void main() {
  testWidgets('Irfan App', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
