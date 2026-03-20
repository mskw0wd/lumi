import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumi/app/app.dart';

void main() {
  testWidgets('shell routes between inbox and projects', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inbox-page-title')), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom-bar-projects')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('projects-page-title')), findsOneWidget);
  });

  testWidgets('text task action opens overlay without changing route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inbox-page-title')), findsOneWidget);

    await tester.tap(find.byTooltip('Add Text Task'));
    await tester.pumpAndSettle();

    expect(find.text('Quick add foundation'), findsOneWidget);
    expect(find.byKey(const Key('inbox-page-title')), findsOneWidget);
  });
}
