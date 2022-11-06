import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/screen/profile/widget/build_profile.dart';
import 'package:codyo/src/screen/profile_update/profile_update_screen.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/view_model/profile_view_model.dart';
import 'package:codyo/src/widget/cool_loading.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Lottie.asset('asset/lottie/user_v2.json'),
        iconTheme: const IconThemeData(color: Colors.black54),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        title: const TextPro('Profile'),
        elevation: 0.5,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              if (user != null) {
                Navigator.push(
                  context,
                  ScreenRoute(
                    screen: ProfileUpdateScreen(user: user!),
                  ),
                );
              }
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: FutureBuilder<User?>(
        future: ref.read(profileViewModel).getUserById(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data;
            return BuildProfile(user: user!);
          } else {
            return const CoolLoading();
          }
        },
      ),
    );
  }
}
