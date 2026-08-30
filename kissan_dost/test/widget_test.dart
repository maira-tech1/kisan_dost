import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kissan_dost/app/app.dart';

void main() {
  testWidgets('App renders welcome screen with app name',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
    expect(find.text('Kisan Dost'), findsWidgets);
  });
}
