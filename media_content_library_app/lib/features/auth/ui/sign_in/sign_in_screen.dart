import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/auth/notifier/sign_in/sign_in_notifier.dart';
import 'package:media_content_library_app/features/auth/notifier/sign_in/sign_in_state_model.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final SignInProvider _provider = SignInProvider(() {
    return SignInNotifier();
  });
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _password;
  String? _email;

  @override
  Widget build(BuildContext context) {
    ref.listen(_provider, (oldState, newState) async {
      if (newState.isSuccess &&
          newState.signInModel?.token?.isNotEmpty == true) {
        await Future.delayed(Duration(seconds: 1));
        if (context.mounted) {
          context.go("/settings");
        }
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Sign in")),
      body: _signInBody(),
    );
  }

  Widget _signInBody() {
    SignInStateModel signInStateModel = ref.watch(_provider);
    if (signInStateModel.initialState) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your email *",
                  ),
                  onSaved: (String? email) {
                    _email = email;
                  },
                  validator: (String? email) {
                    if (email == null || email.trim().isEmpty == true) {
                      return "Please Enter Your Name";
                    }
                    final RegExp emailRegExp = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                    );
                    if (!emailRegExp.hasMatch(email)) {
                      return "Please Enter valid Email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your password (min 8 digits) *",
                  ),
                  onSaved: (String? password) {
                    _password = password;
                  },
                  validator: (String? password) {
                    if (password == null || password.trim().isEmpty == true) {
                      return "Please Enter Your Name";
                    } else if (password.length < 8) {
                      return "Please enter min 8 characters for password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      _formKey.currentState?.save();
                      ref
                          .read(_provider.notifier)
                          .signIn(email: _email!, password: _password!);
                    }
                  },
                  child: Text("Sign in"),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (signInStateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (signInStateModel.isSuccess) {
      return Center(child: Text("Login Success"));
    } else if (signInStateModel.isFailed) {
      return Center(
        child: TryAgainWidget(
          onTryAgain: () {
            ref.read(_provider.notifier).tryAgain();
          },
          errorMessage: signInStateModel.errorMessage,
        ),
      );
    }
    return SizedBox.shrink();
  }
}
