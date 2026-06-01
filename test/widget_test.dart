import 'package:flutter_test/flutter_test.dart';

import 'package:yes_no_app/main.dart';

void main() {
  testWidgets('renders chat mode selector', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Choose chat type'), findsOneWidget);
    expect(find.text('Yes or no'), findsOneWidget);
    expect(find.text('Jokes'), findsWidgets);
  });
}
