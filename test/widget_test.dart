import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumi/app/app.dart';
import 'package:lumi/features/tasks/application/lumi_task_store.dart';

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

  testWidgets('text task action opens quick add composer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inbox-page-title')), findsOneWidget);

    await tester.tap(find.byTooltip('Add Text Task'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quick-add-field')), findsOneWidget);
    expect(find.text('What would you like to do?'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('quick-add-composer')),
        matching: find.text('Project'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('quick-add-composer')),
        matching: find.text('Today'),
      ),
      findsOneWidget,
    );
    expect(tester.testTextInput.hasAnyClients, isTrue);
    expect(find.byKey(const Key('inbox-page-title')), findsOneWidget);
  });

  testWidgets('quick add composer submits and closes on plus tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Text Task'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('quick-add-field')),
      'Buy milk',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('quick-add-submit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quick-add-field')), findsNothing);
    expect(find.byKey(const Key('inbox-page-title')), findsOneWidget);
  });

  testWidgets('project chip opens project picker foundation overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Text Task'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('quick-add-composer')),
        matching: find.text('Project'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Project picker foundation'), findsOneWidget);
  });

  testWidgets('today chip opens calendar foundation overlay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Text Task'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('quick-add-composer')),
        matching: find.text('Today'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Calendar foundation'), findsOneWidget);
  });

  testWidgets(
    'toggling inbox task updates source of truth and focus spaces counters',
    (WidgetTester tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(const ProviderScope(child: LumiApp()));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('7 tasks', findRichText: true),
          findsOneWidget,
        );

        final onboardingCheckbox = find.byKey(
          const Key('inbox-task-checkbox-icvr-onboarding'),
        );

        await tester.ensureVisible(onboardingCheckbox);
        await tester.pumpAndSettle();
        await tester.tap(onboardingCheckbox);
        await tester.pumpAndSettle();

        expect(
          find.byKey(const Key('inbox-task-row-icvr-onboarding')),
          findsNothing,
        );
        expect(
          find.textContaining('6 tasks', findRichText: true),
          findsOneWidget,
        );

        await tester.tap(find.byKey(const Key('bottom-bar-projects')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('space-progress-icvr')), findsOneWidget);
        expect(
          tester
              .getSemantics(find.byKey(const Key('space-progress-icvr')))
              .value,
          '2/3',
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('space-open-count-icvr')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const Key('space-due-today-count-icvr')),
            matching: find.text('0'),
          ),
          findsOneWidget,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('completing overdue task removes overdue block', (
    WidgetTester tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const ProviderScope(child: LumiApp()));
      await tester.pumpAndSettle();

      final overdueCheckbox = find.byKey(
        const Key('inbox-task-checkbox-icvr-demo-notes'),
      );
      await tester.ensureVisible(overdueCheckbox);
      await tester.pumpAndSettle();
      await tester.tap(overdueCheckbox);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('bottom-bar-projects')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('space-progress-icvr')), findsOneWidget);
      expect(
        tester.getSemantics(find.byKey(const Key('space-progress-icvr'))).value,
        '2/3',
      );
      expect(find.byKey(const Key('space-overdue-icvr')), findsNothing);
    } finally {
      semantics.dispose();
    }
  });

  test('toggling same task twice restores derived focus progress', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final taskStore = container.read(lumiTasksProvider.notifier);

    taskStore.toggleCompletion('icvr-onboarding');
    var icvrSummary = container
        .read(lumiSpaceSummariesProvider)
        .firstWhere((summary) => summary.id == 'icvr');
    expect(icvrSummary.completedTasks, 2);
    expect(icvrSummary.openTasks, 1);
    expect(icvrSummary.dueTodayTasks, 0);

    taskStore.toggleCompletion('icvr-onboarding');
    icvrSummary = container
        .read(lumiSpaceSummariesProvider)
        .firstWhere((summary) => summary.id == 'icvr');
    expect(icvrSummary.completedTasks, 1);
    expect(icvrSummary.openTasks, 2);
    expect(icvrSummary.dueTodayTasks, 1);
  });
}
