import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/di/locator.dart';
import 'package:media_content_library_app/const/storage/user_session.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final UserSession _userSession = getIt.get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _userSession.getToken(),
        _userSession.getName(),
        _userSession.getId(),
        _userSession.getEmail(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String? token = snapshot.data?[0];
          String? name = snapshot.data?[1];
          String? id = snapshot.data?[2];
          String? email = snapshot.data?[3];

          if (token?.isNotEmpty == true) {
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(name ?? ""),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(email ?? ""),
                ),
                ListTile(
                  onTap: () async{
                   await _userSession.logout();
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
                    context.push("/sign-up");
                  },
                  title: Text("Sign in"),
                )
              ],
            );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
