import 'package:flutter_riverpod/flutter_riverpod.dart';

const lumiGeneralSpaceId = 'general';
const lumiGeneralSpaceName = 'General';

final lumiTasksProvider = NotifierProvider<LumiTaskStore, List<LumiTask>>(
  LumiTaskStore.new,
);

final lumiSpacesProvider = Provider<List<LumiSpace>>((ref) => _demoSpaces);

final lumiSpacesByIdProvider = Provider<Map<String, LumiSpace>>((ref) {
  final spaces = ref.watch(lumiSpacesProvider);
  return {for (final space in spaces) space.id: space};
});

final lumiFocusDateProvider = Provider<DateTime>((ref) {
  return DateTime(2026, 3, 16);
});

final inboxTaskItemsProvider = Provider<List<LumiInboxTaskItem>>((ref) {
  final tasks = ref.watch(lumiTasksProvider);
  final spacesById = ref.watch(lumiSpacesByIdProvider);

  return tasks
      .where((task) => !task.isCompleted)
      .map((task) {
        final resolvedSpaceId = _resolveSpaceId(task.projectId);
        final resolvedSpaceName =
            spacesById[resolvedSpaceId]?.name ?? lumiGeneralSpaceName;

        return LumiInboxTaskItem(
          id: task.id,
          title: task.title,
          subtitle: resolvedSpaceName,
          isCompleted: task.isCompleted,
        );
      })
      .toList(growable: false);
});

final lumiSpaceSummariesProvider = Provider<List<LumiSpaceSummary>>((ref) {
  final spaces = ref.watch(lumiSpacesProvider);
  final tasks = ref.watch(lumiTasksProvider);
  final focusDate = ref.watch(lumiFocusDateProvider);

  return spaces
      .map((space) {
        final spaceTasks = tasks
            .where((task) => _resolveSpaceId(task.projectId) == space.id)
            .toList(growable: false);
        final totalTasks = spaceTasks.length;
        final completedTasks = spaceTasks
            .where((task) => task.isCompleted)
            .length;
        final openTasks = spaceTasks.where((task) => !task.isCompleted).length;
        final dueTodayTasks = spaceTasks
            .where((task) => _isDueToday(task, focusDate))
            .length;
        final overdueTasks = spaceTasks
            .where((task) => _isOverdue(task, focusDate))
            .length;

        return LumiSpaceSummary(
          id: space.id,
          name: space.name,
          isPinned: space.isPinned,
          totalTasks: totalTasks,
          completedTasks: completedTasks,
          openTasks: openTasks,
          dueTodayTasks: dueTodayTasks,
          overdueTasks: overdueTasks,
        );
      })
      .toList(growable: false);
});

final focusSpacesHeroStatsProvider = Provider<FocusSpacesHeroStats>((ref) {
  final summaries = ref.watch(lumiSpaceSummariesProvider);
  final totalTasks = summaries.fold<int>(
    0,
    (sum, summary) => sum + summary.totalTasks,
  );
  final spacesNeedingAttention = summaries
      .where((summary) => summary.dueTodayTasks > 0 || summary.overdueTasks > 0)
      .length;

  return FocusSpacesHeroStats(
    totalTasks: totalTasks,
    spacesNeedingAttention: spacesNeedingAttention,
  );
});

class LumiTaskStore extends Notifier<List<LumiTask>> {
  int _createdTaskCount = 0;

  @override
  List<LumiTask> build() {
    _createdTaskCount = 0;
    return _buildDemoTasks();
  }

  void toggleCompletion(String taskId) {
    final now = DateTime.now();
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            isCompleted: !task.isCompleted,
            completedAt: task.isCompleted ? null : now,
          )
        else
          task,
    ];
  }

  LumiTask? createTask({
    required String title,
    String? projectId,
    DateTime? dueDate,
  }) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    final task = LumiTask(
      id: 'task-${now.microsecondsSinceEpoch}-${_createdTaskCount++}',
      title: trimmedTitle,
      isCompleted: false,
      projectId: _resolveSpaceId(projectId),
      dueDate: dueDate,
      createdAt: now,
      completedAt: null,
    );

    state = [task, ...state];
    return task;
  }
}

class LumiTask {
  const LumiTask({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.projectId,
    required this.dueDate,
    required this.createdAt,
    required this.completedAt,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final String? projectId;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;

  LumiTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    Object? projectId = _sentinel,
    Object? dueDate = _sentinel,
    DateTime? createdAt,
    Object? completedAt = _sentinel,
  }) {
    return LumiTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      projectId: identical(projectId, _sentinel)
          ? this.projectId
          : projectId as String?,
      dueDate: identical(dueDate, _sentinel)
          ? this.dueDate
          : dueDate as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      completedAt: identical(completedAt, _sentinel)
          ? this.completedAt
          : completedAt as DateTime?,
    );
  }
}

class LumiSpace {
  const LumiSpace({
    required this.id,
    required this.name,
    required this.isPinned,
  });

  final String id;
  final String name;
  final bool isPinned;
}

class LumiSpaceSummary {
  const LumiSpaceSummary({
    required this.id,
    required this.name,
    required this.isPinned,
    required this.totalTasks,
    required this.completedTasks,
    required this.openTasks,
    required this.dueTodayTasks,
    required this.overdueTasks,
  });

  final String id;
  final String name;
  final bool isPinned;
  final int totalTasks;
  final int completedTasks;
  final int openTasks;
  final int dueTodayTasks;
  final int overdueTasks;
}

class FocusSpacesHeroStats {
  const FocusSpacesHeroStats({
    required this.totalTasks,
    required this.spacesNeedingAttention,
  });

  final int totalTasks;
  final int spacesNeedingAttention;
}

class LumiInboxTaskItem {
  const LumiInboxTaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String subtitle;
  final bool isCompleted;
}

const _demoSpaces = <LumiSpace>[
  LumiSpace(
    id: lumiGeneralSpaceId,
    name: lumiGeneralSpaceName,
    isPinned: false,
  ),
  LumiSpace(id: 'icvr', name: 'ICVR', isPinned: true),
  LumiSpace(id: 'lumi', name: 'Lumi', isPinned: true),
  LumiSpace(id: 'coinask', name: 'Coinask', isPinned: false),
  LumiSpace(id: 'project-name', name: 'Project name', isPinned: true),
  LumiSpace(id: 'fatra', name: 'Fatra', isPinned: false),
];

const _sentinel = Object();

List<LumiTask> _buildDemoTasks() {
  final focusDate = DateTime(2026, 3, 16);

  return [
    LumiTask(
      id: 'icvr-onboarding',
      title: 'Refine onboarding flow',
      isCompleted: false,
      projectId: 'icvr',
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 10, 9),
      completedAt: null,
    ),
    LumiTask(
      id: 'coinask-empty-states',
      title: 'Sync with design on empty states',
      isCompleted: false,
      projectId: 'coinask',
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 10, 11),
      completedAt: null,
    ),
    LumiTask(
      id: 'inbox-api-pagination',
      title: 'Review API pagination edge cases',
      isCompleted: false,
      projectId: lumiGeneralSpaceId,
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 11, 10),
      completedAt: null,
    ),
    LumiTask(
      id: 'icvr-demo-notes',
      title: 'Prepare sprint demo notes',
      isCompleted: false,
      projectId: 'icvr',
      dueDate: DateTime(2026, 3, 14),
      createdAt: DateTime(2026, 3, 11, 16),
      completedAt: null,
    ),
    LumiTask(
      id: 'lumi-qa-checklist',
      title: 'Update QA checklist for release',
      isCompleted: false,
      projectId: 'lumi',
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 12, 9),
      completedAt: null,
    ),
    LumiTask(
      id: 'coinask-timezone',
      title: 'Fix calendar timezone mismatch',
      isCompleted: false,
      projectId: 'coinask',
      dueDate: DateTime(2026, 3, 15),
      createdAt: DateTime(2026, 3, 12, 14),
      completedAt: null,
    ),
    LumiTask(
      id: 'inbox-priorities',
      title: 'Plan priorities for tomorrow',
      isCompleted: false,
      projectId: lumiGeneralSpaceId,
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 12, 18),
      completedAt: null,
    ),
    LumiTask(
      id: 'project-header-transition',
      title: 'Polish compact header transition',
      isCompleted: false,
      projectId: 'project-name',
      dueDate: null,
      createdAt: DateTime(2026, 3, 13, 10),
      completedAt: null,
    ),
    LumiTask(
      id: 'lumi-notification-permission',
      title: 'Review notification permission UX',
      isCompleted: true,
      projectId: 'lumi',
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 13, 12),
      completedAt: DateTime(2026, 3, 14, 9, 30),
    ),
    LumiTask(
      id: 'fatra-empty-copy',
      title: 'Clean empty-state copy variants',
      isCompleted: false,
      projectId: 'fatra',
      dueDate: null,
      createdAt: DateTime(2026, 3, 13, 15),
      completedAt: null,
    ),
    LumiTask(
      id: 'inbox-keyboard-motion',
      title: 'Verify keyboard attachment motion',
      isCompleted: false,
      projectId: lumiGeneralSpaceId,
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 14, 9),
      completedAt: null,
    ),
    LumiTask(
      id: 'icvr-onboarding-success',
      title: 'Update onboarding success messaging',
      isCompleted: true,
      projectId: 'icvr',
      dueDate: null,
      createdAt: DateTime(2026, 3, 14, 12),
      completedAt: DateTime(2026, 3, 15, 11),
    ),
    LumiTask(
      id: 'project-chip-sync',
      title: 'Sync project chips with latest tokens',
      isCompleted: true,
      projectId: 'project-name',
      dueDate: null,
      createdAt: DateTime(2026, 3, 14, 17),
      completedAt: DateTime(2026, 3, 15, 14),
    ),
    LumiTask(
      id: 'inbox-release-notes',
      title: 'Prepare release note structure',
      isCompleted: false,
      projectId: lumiGeneralSpaceId,
      dueDate: focusDate,
      createdAt: DateTime(2026, 3, 15, 10),
      completedAt: null,
    ),
    LumiTask(
      id: 'fatra-today-rhythm',
      title: 'Validate Today header rhythm',
      isCompleted: true,
      projectId: 'fatra',
      dueDate: null,
      createdAt: DateTime(2026, 3, 15, 16),
      completedAt: DateTime(2026, 3, 15, 18, 20),
    ),
  ];
}

const _legacyDefaultSpaceIds = {'inbox', 'default', 'general-space'};

String _resolveSpaceId(String? projectId) {
  if (projectId == null || _legacyDefaultSpaceIds.contains(projectId)) {
    return lumiGeneralSpaceId;
  }

  return projectId;
}

bool _isDueToday(LumiTask task, DateTime focusDate) {
  if (task.isCompleted || task.dueDate == null) {
    return false;
  }

  return _isSameDay(task.dueDate!, focusDate);
}

bool _isOverdue(LumiTask task, DateTime focusDate) {
  if (task.isCompleted || task.dueDate == null) {
    return false;
  }

  return _dateOnly(task.dueDate!).isBefore(_dateOnly(focusDate));
}

bool _isSameDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}
