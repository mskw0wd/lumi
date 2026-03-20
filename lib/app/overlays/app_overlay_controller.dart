import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppOverlayKind { quickAdd, calendar, projectPicker, voice }

@immutable
class AppOverlayEntry {
  const AppOverlayEntry({required this.kind});

  final AppOverlayKind kind;
}

final appOverlayControllerProvider =
    NotifierProvider<AppOverlayController, AppOverlayEntry?>(
      AppOverlayController.new,
    );

class AppOverlayController extends Notifier<AppOverlayEntry?> {
  @override
  AppOverlayEntry? build() => null;

  void showQuickAdd() {
    state = const AppOverlayEntry(kind: AppOverlayKind.quickAdd);
  }

  void showCalendar() {
    state = const AppOverlayEntry(kind: AppOverlayKind.calendar);
  }

  void showProjectPicker() {
    state = const AppOverlayEntry(kind: AppOverlayKind.projectPicker);
  }

  void showVoice() {
    state = const AppOverlayEntry(kind: AppOverlayKind.voice);
  }

  void dismiss() {
    state = null;
  }
}
