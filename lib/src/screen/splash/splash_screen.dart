import 'package:codyo/src/screen/home/home_screen.dart';
import 'package:codyo/src/screen/sign_in/sign_in_screen.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/view_model/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> _redirect() async {
    final viewModel = ref.read(splashViewModel);
    final userId = await viewModel.getUserId();
    await Future.delayed(const Duration(milliseconds: 3000));
    if (userId != null && mounted) {
      Navigator.pushReplacement(
        context,
        ScreenRoute(
          screen: const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        ScreenRoute(
          screen: const SignInScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    _redirect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'asset/svg/codyo.svg',
        ),
      ),
    );
  }
}
