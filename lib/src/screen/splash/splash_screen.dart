import 'package:codyo/src/screen/home/home_screen.dart';
import 'package:codyo/src/screen/sign_in/sign_in_screen.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/view_model/splash_view_model.dart';
import 'package:codyo/src/widget/text_pro.dart';
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
      backgroundColor: Colors.grey.shade100,
      body: TweenAnimationBuilder<double>(
        curve: Curves.ease,
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 3000),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: SvgPicture.asset(
                            'asset/svg/codyo.svg',
                            key: const Key('splash_logo_app'),
                          ),
                        ),
                        const SizedBox(width: 18),
                        const TextPro(
                          'CODYO',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          key: Key('splash_title'),
                        ),
                      ],
                    ),
                  ),
                  const TextPro(
                    '#BuyAndSell',
                    color: Colors.black45,
                    key: Key('splash_hash_tag'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
