import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumi/app/shell/lumi_app_shell.dart';
import 'package:lumi/features/inbox/presentation/inbox_page.dart';
import 'package:lumi/features/projects/presentation/projects_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: InboxPage.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return LumiAppShell(currentLocation: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: InboxPage.routePath,
            name: InboxPage.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage<void>(child: InboxPage()),
          ),
          GoRoute(
            path: ProjectsPage.routePath,
            name: ProjectsPage.routeName,
            pageBuilder: (context, state) =>
                const NoTransitionPage<void>(child: ProjectsPage()),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
