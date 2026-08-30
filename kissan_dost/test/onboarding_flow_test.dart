import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kissan_dost/app/app.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
  }

  testWidgets('welcome screen navigates to language selection',
      (WidgetTester tester) async {
    await pumpApp(tester);
    expect(find.text('Kisan Dost'), findsWidgets);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your preferred language'), findsWidgets);
  });

  testWidgets('selecting Urdu updates UI text and uses RTL',
      (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('language-card-ur')));
    await tester.pumpAndSettle();

    expect(find.text('اپنی پسندیدہ زبان منتخب کریں'), findsWidgets);
    expect(find.text('جاری رکھیں'), findsOneWidget);

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });

  testWidgets('full onboarding flow stores farmer and crops on home',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('language-card-en')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Ali');
    await tester.enterText(find.byType(TextField).last, 'Faisalabad');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Select your crops'), findsWidgets);
    await tester.tap(find.text('Wheat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cotton'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('Ali'), findsWidgets);
    expect(find.text('Faisalabad'), findsOneWidget);
    expect(find.text('Wheat'), findsWidgets);
    expect(find.text('Cotton'), findsWidgets);
    expect(find.text('Ask Kisan Dost'), findsOneWidget);
  });

  testWidgets('home edit profile navigates to farmer details',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-card-en')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Ali');
    await tester.enterText(find.byType(TextField).last, 'Faisalabad');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wheat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit profile'));
    await tester.pumpAndSettle();

    expect(find.text('Farmer Information'), findsWidgets);
  });
}
