import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kissan_dost/app/app.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.text('Kissan Dost'), findsWidgets);
  });
}
