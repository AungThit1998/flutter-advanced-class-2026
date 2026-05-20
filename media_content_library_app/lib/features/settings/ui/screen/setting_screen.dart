import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/features/settings/notifier/profile_notifier.dart';
import 'package:media_content_library_app/features/settings/notifier/profile_state_model.dart';

import '../../../../const/di/locator.dart';
import '../../../../const/storage/user_session.dart';


class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  final ProfileProvider _provider = ProfileProvider(() => ProfileNotifier());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(_provider.notifier).checkAuth();
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(_provider.notifier).checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProfileStateModel stateModel = ref.watch(_provider);
    if (stateModel.token?.isNotEmpty == true) {
      return Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(stateModel.name ?? ""),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(stateModel.email ?? ""),
          ),
          ListTile(
            onTap: () async{
              await ref.read(_provider.notifier).logout();
              if(context.mounted) {
                context.go("/");
              }
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ListTile(
            onTap: (){
              context.push("/sign-up");
            },
            title: Text("Sign up"),
          ),
          Divider(),
          ListTile(
            onTap: (){
              context.push("/sign-in");
            },
            title: Text("Sign in"),
          )
        ],
      );
    }
  }
}
