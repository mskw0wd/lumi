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

  testWidgets('focus spaces shows General first', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('bottom-bar-projects')));
    await tester.pumpAndSettle();

    final generalCard = find.byKey(const Key('space-card-general'));
    final icvrCard = find.byKey(const Key('space-card-icvr'));

    expect(generalCard, findsOneWidget);
    expect(icvrCard, findsOneWidget);
    expect(
      tester.getTopLeft(generalCard).dy,
      lessThan(tester.getTopLeft(icvrCard).dy),
    );
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
    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.textContaining('12 tasks', findRichText: true), findsOneWidget);
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

  testWidgets('empty quick add title does not create task', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: LumiApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Text Task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('quick-add-field')), '   ');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('quick-add-field')), findsOneWidget);
    expect(find.textContaining('11 tasks', findRichText: true), findsOneWidget);
  });

  testWidgets(
    'toggling inbox task updates source of truth and focus spaces counters',
    (WidgetTester tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(const ProviderScope(child: LumiApp()));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('11 tasks', findRichText: true),
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
          find.textContaining('10 tasks', findRichText: true),
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

  testWidgets('completing Lumi task updates Lumi counters and progress', (
    WidgetTester tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const ProviderScope(child: LumiApp()));
      await tester.pumpAndSettle();

      final lumiCheckbox = find.byKey(
        const Key('inbox-task-checkbox-lumi-qa-checklist'),
      );
      await tester.scrollUntilVisible(lumiCheckbox, 240);
      await tester.pumpAndSettle();
      await tester.tap(lumiCheckbox);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('inbox-task-row-lumi-qa-checklist')),
        findsNothing,
      );

      await tester.tap(find.byKey(const Key('bottom-bar-projects')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('space-progress-lumi')), findsOneWidget);
      expect(
        tester.getSemantics(find.byKey(const Key('space-progress-lumi'))).value,
        '2/2',
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('space-open-count-lumi')),
          matching: find.text('0'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('space-due-today-count-lumi')),
          matching: find.text('0'),
        ),
        findsOneWidget,
      );
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

  test('space with zero tasks derives safe zero counters', () {
    final container = ProviderContainer(
      overrides: [
        lumiSpacesProvider.overrideWith(
          (ref) => const [
            LumiSpace(id: 'empty-space', name: 'Empty Space', isPinned: false),
          ],
        ),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(lumiSpaceSummariesProvider).single;

    expect(summary.id, 'empty-space');
    expect(summary.totalTasks, 0);
    expect(summary.completedTasks, 0);
    expect(summary.openTasks, 0);
    expect(summary.dueTodayTasks, 0);
    expect(summary.overdueTasks, 0);
  });

  test('General summary maps default tasks and stays first', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final summaries = container.read(lumiSpaceSummariesProvider);
    final generalSummary = summaries.first;

    expect(generalSummary.id, lumiGeneralSpaceId);
    expect(generalSummary.name, lumiGeneralSpaceName);
    expect(generalSummary.totalTasks, 4);
    expect(generalSummary.completedTasks, 0);
    expect(generalSummary.openTasks, 4);
    expect(generalSummary.dueTodayTasks, 4);
    expect(generalSummary.overdueTasks, 0);
  });

  test('createTask supports project linkage and updates Lumi summary', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final taskStore = container.read(lumiTasksProvider.notifier);
    final focusDate = DateTime(2026, 3, 16);

    final createdTask = taskStore.createTask(
      title: 'Ship Lumi onboarding polish',
      projectId: 'lumi',
      dueDate: focusDate,
    );

    expect(createdTask, isNotNull);
    final task = createdTask!;
    expect(task.projectId, 'lumi');
    expect(task.isCompleted, isFalse);

    final lumiSummary = container
        .read(lumiSpaceSummariesProvider)
        .firstWhere((summary) => summary.id == 'lumi');

    expect(lumiSummary.totalTasks, 3);
    expect(lumiSummary.completedTasks, 1);
    expect(lumiSummary.openTasks, 2);
    expect(lumiSummary.dueTodayTasks, 2);
    expect(lumiSummary.overdueTasks, 0);
  });

  test('createTask without explicit space updates General summary', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final taskStore = container.read(lumiTasksProvider.notifier);
    final focusDate = DateTime(2026, 3, 16);

    final createdTask = taskStore.createTask(
      title: 'Capture QA follow-up',
      dueDate: focusDate,
    );

    expect(createdTask, isNotNull);
    final task = createdTask!;
    expect(task.projectId, lumiGeneralSpaceId);

    final generalSummary = container
        .read(lumiSpaceSummariesProvider)
        .firstWhere((summary) => summary.id == lumiGeneralSpaceId);

    expect(generalSummary.totalTasks, 5);
    expect(generalSummary.completedTasks, 0);
    expect(generalSummary.openTasks, 5);
    expect(generalSummary.dueTodayTasks, 5);
    expect(generalSummary.overdueTasks, 0);
  });

  test('newly created task follows normal completion lifecycle', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final taskStore = container.read(lumiTasksProvider.notifier);
    final focusDate = DateTime(2026, 3, 16);

    final createdTask = taskStore.createTask(
      title: 'Buy milk',
      dueDate: focusDate,
    );

    expect(createdTask, isNotNull);
    final task = createdTask!;
    expect(
      container.read(inboxTaskItemsProvider).any((item) => item.id == task.id),
      isTrue,
    );

    taskStore.toggleCompletion(task.id);

    final storedTask = container
        .read(lumiTasksProvider)
        .firstWhere((item) => item.id == task.id);
    expect(storedTask.isCompleted, isTrue);
    expect(storedTask.completedAt, isNotNull);
    expect(
      container.read(inboxTaskItemsProvider).any((item) => item.id == task.id),
      isFalse,
    );
  });

  test('completing General task updates General summary counters', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final taskStore = container.read(lumiTasksProvider.notifier);

    taskStore.toggleCompletion('inbox-api-pagination');

    final generalSummary = container
        .read(lumiSpaceSummariesProvider)
        .firstWhere((summary) => summary.id == lumiGeneralSpaceId);

    expect(generalSummary.totalTasks, 4);
    expect(generalSummary.completedTasks, 1);
    expect(generalSummary.openTasks, 3);
    expect(generalSummary.dueTodayTasks, 3);
    expect(generalSummary.overdueTasks, 0);
  });
}
