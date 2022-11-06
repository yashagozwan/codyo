import 'package:codyo/src/model/sign_in_model.dart';
import 'package:codyo/src/screen/home/home_screen.dart';
import 'package:codyo/src/screen/sign_up/sign_up_screen.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/view_model/sign_in_view_model.dart';
import 'package:codyo/src/widget/elevated_button_pro.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'asset/svg/sign_in.svg',
                  height: 200,
                ),
                const SizedBox(height: 32),
                const TextPro(
                  'Please Sign In to your account',
                  color: Colors.black54,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can't be empty";
                    }

                    if (!EmailValidator.validate(value)) {
                      return 'Please input a valid email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password can't be empty";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final viewModel = ref.watch(signInViewModel);

                    final button = ElevatedButtonPro(
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;

                        final signIn = SignIn(
                          email: _email.text,
                          password: _password.text,
                        );

                        final result =
                            await ref.read(signInViewModel).signIn(signIn);

                        if (result && mounted) {
                          Navigator.pushReplacement(
                            context,
                            ScreenRoute(
                              screen: const HomeScreen(),
                            ),
                          );
                        }
                      },
                      child: const TextPro('Sign In'),
                    );

                    switch (viewModel.stateAction) {
                      case StateAction.idle:
                        return button;
                      case StateAction.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case StateAction.error:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            button,
                            const SizedBox(height: 16),
                            TextPro(
                              viewModel.errorMessage,
                              color: Colors.red,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextPro("Don't have account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          ScreenRoute(
                            screen: const SignUpScreen(),
                          ),
                        );

                        ref.read(signInViewModel).cleaning();
                      },
                      child: const TextPro(
                        "Sign Up",
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
