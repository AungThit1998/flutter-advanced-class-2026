import "package:go_router/go_router.dart";
import "package:media_content_library_app/features/audio/ui/screen/audio_screen.dart";
import "package:media_content_library_app/features/blog/ui/screens/blog_screen.dart";
import "package:media_content_library_app/features/home/ui/screens/home.dart";
import "package:media_content_library_app/features/pdf/ui/screen/pdf_screen.dart";
import "package:media_content_library_app/features/settings/ui/screen/setting_screen.dart";
import "package:media_content_library_app/features/video/ui/screen/video_screen.dart";

GoRouter myRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/",
              name: "home",
              builder: (context, state) {
                return BlogScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/audio",
              name: "audio",
              builder: (context, state) {
                return AudioScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/video",
              name: "video",
              builder: (context, state) {
                return VideoScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/pdf",
              name: "pdf",
              builder: (context, state) {
                return PdfScreen();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/settings",
              name: "settings",
              builder: (context, state) {
                return SettingScreen();
              },
            ),
          ],
        ),
      ],
      builder: (context, state, shell) {
        return Home(shell: shell);
      },
    ),
  ],
);
