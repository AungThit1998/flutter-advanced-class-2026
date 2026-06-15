import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:media_content_library_app/const/apis/api_const.dart";
import "package:media_content_library_app/features/audio/ui/screen/audio_detail_screen.dart";
import "package:media_content_library_app/features/audio/ui/screen/audio_screen.dart";
import "package:media_content_library_app/features/auth/ui/sign_in/sign_in_screen.dart";
import "package:media_content_library_app/features/auth/ui/sign_up/sign_up_screen.dart";
import "package:media_content_library_app/features/blog/ui/screens/blog_detail_screen.dart";
import "package:media_content_library_app/features/blog/ui/screens/blog_screen.dart";
import "package:media_content_library_app/features/home/ui/screens/home.dart";
import "package:media_content_library_app/features/pdf/ui/screen/pdf_detail_screen.dart";
import "package:media_content_library_app/features/pdf/ui/screen/pdf_screen.dart";
import "package:media_content_library_app/features/settings/ui/screen/setting_screen.dart";
import "package:media_content_library_app/features/video/ui/screen/video_detail_screen.dart";
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
    GoRoute(
      path: "/detail/:type/:id",
      builder: (context, state) {
        String? type = state.pathParameters['type'];
        String? id = state.pathParameters['id'];
        if (type == ApiConst.blog) {
          return BlogDetailScreen(type: type, id: id);
        } else if (type == ApiConst.audio) {
          return AudioDetailScreen(id: id);
        } else if (type == ApiConst.video) {
          return VideoDetailScreen(id: id);
        } else if (type == ApiConst.pdf) {
          return PdfDetailScreen(id: id);
        }
        return SizedBox();
      },
    ),
    GoRoute(
      path: "/sign-up",
      builder: (context, state) {
        return SignUpScreen();
      },
    ),
    GoRoute(
      path: "/sign-in",
      builder: (context, state) {
        return SignInScreen();
      },
    ),
  ],
);
