import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/auth/notifier/sign_up/sign_up_notifier.dart';
import 'package:media_content_library_app/features/auth/notifier/sign_up/sign_up_state_model.dart';
import 'package:media_content_library_app/features/auth/notifier/sign_up_otp/otp_notifier.dart';
import 'package:media_content_library_app/features/auth/notifier/sign_up_otp/otp_state_model.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? _name;
  String? _password;
  String? _email;
  final OTPProvider _otpProvider = OTPProvider(() => OtpNotifier());
  final SignupProvider _signupProvider = SignupProvider(() => SignUpNotifier());
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    OtpStateModel otpStateModel = ref.watch(_otpProvider);
    SignUpStateModel signUpStateModel = ref.watch(_signupProvider);
    ref.listen(_signupProvider, (oldState,newState) async{
      if(newState.isSuccess && newState.signUpModel?.token?.isNotEmpty== true){
        await Future.delayed(Duration(seconds: 1));
        if(context.mounted) {
          context.go("/settings");
        }
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (otpStateModel.isInitialState)
            Center(
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
                          labelText: "Enter your name *",
                        ),
                        onSaved: (String? name) {
                          _name = name;
                        },
                        validator: (String? name) {
                          if (name == null || name.trim().isEmpty == true) {
                            return "Please Enter Your Name";
                          } else if (name.length < 3) {
                            return "Please enter min 3 characters for name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter your password (min 8 digits) *",
                        ),
                        onSaved: (String? password) {
                          _password = password;
                        },
                        validator: (String? password) {
                          if (password == null ||
                              password.trim().isEmpty == true) {
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
                                .read(_otpProvider.notifier)
                                .requestOTP(email: _email!);
                          }
                        },
                        child: Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (otpStateModel.isLoading || signUpStateModel.isLoading)
            Center(child: CircularProgressIndicator()),
          if (otpStateModel.isFailed)
            Center(
              child: TryAgainWidget(
                errorMessage: otpStateModel.errorMessage,
                onTryAgain: () {
                  ref.read(_otpProvider.notifier).tryAgain();
                },
              ),
            ),
          if (signUpStateModel.isFailed)
            Center(
              child: TryAgainWidget(
                errorMessage: signUpStateModel.errorMessage,
                onTryAgain: () {
                  ref.read(_signupProvider.notifier).tryAgain();
                },
              ),
            ),
          if (otpStateModel.isSuccess && signUpStateModel.isInitialState)
            Center(
              child: Container(
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: "Enter 6 digits of OTP",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        if (_otpController.text.trim().length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Enter 6 digits OTP"),
                            ),
                          );
                        } else {
                          ref
                              .read(_signupProvider.notifier)
                              .signUp(
                                email: _email!,
                                name: _name!,
                                password: _password!,
                                otp: _otpController.text,
                              );
                        }
                      },
                      child: Text("Sing up"),
                    ),
                  ],
                ),
              ),
            ),
          if(signUpStateModel.isSuccess)
            Center(
              child: Text("Signup Success"),
            )
        ],
      ),
    );
  }
}
