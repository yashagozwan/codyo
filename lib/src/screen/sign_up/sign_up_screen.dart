import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/view_model/sign_up_view_model.dart';
import 'package:codyo/src/widget/elevated_button_pro.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'asset/svg/sign_up.svg',
                  height: 200,
                ),
                const SizedBox(
                  height: 32,
                ),
                const TextPro(
                  'Please Sign Up for continue',
                  color: Colors.black54,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name can't be empty";
                    }

                    return null;
                  },
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

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone can't be empty";
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

                    if (value.length < 6) {
                      return 'Password min 5 characters length';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final button = ElevatedButtonPro(
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) return;
                        final user = User(
                          name: _name.text,
                          email: _email.text,
                          phone: _phone.text,
                          password: _password.text,
                        );

                        final result =
                            await ref.read(signUpViewModel).signUp(user);

                        if (mounted && result) {
                          Navigator.pop(context);
                        }
                      },
                      child: const TextPro('Sign Up'),
                    );

                    final viewModel = ref.watch(signUpViewModel);

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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextPro("Already have account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(signUpViewModel).cleaning();
                      },
                      child: const TextPro(
                        "Sign In",
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
