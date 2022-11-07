import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/screen/product_me/product_me_screen.dart';
import 'package:codyo/src/screen/product_me_sold/product_me_sold_screen.dart';
import 'package:codyo/src/screen/profile/widget/box_info_product.dart';
import 'package:codyo/src/screen/sign_in/sign_in_screen.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/home_view_model.dart';
import 'package:codyo/src/view_model/profile_view_model.dart';
import 'package:codyo/src/widget/elevated_button_pro.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class BuildProfile extends ConsumerStatefulWidget {
  final User user;

  const BuildProfile({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<BuildProfile> createState() => _BuildProfileState();
}

class _BuildProfileState extends ConsumerState<BuildProfile> {
  Future<void> _initial() async {
    Future(() async {
      ref.read(profileViewModel).getProductById();
      ref.read(profileViewModel).getSoldProductById();
    });
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(130 / 2),
              child: CachedNetworkImage(
                imageUrl: widget.user.avatarUrl,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextPro(
            widget.user.name,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextPro(
            widget.user.email,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextPro(
                'Join Date • ${Util.dateFormatter(widget.user.createdAt)}',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: BoxInfoProduct(
                    splashColor: Colors.red.withOpacity(0.1),
                    onPressed: () {
                      Navigator.push(
                        context,
                        ScreenRoute(
                          screen: const ProductMeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    content: Column(
                      children: [
                        const TextPro('Item Not Sold'),
                        const SizedBox(height: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            final viewModel = ref.watch(profileViewModel);
                            final products = viewModel.notSoldProducts;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextPro(
                                products.length.toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: BoxInfoProduct(
                    onPressed: () {
                      Navigator.push(
                        context,
                        ScreenRoute(
                          screen: const ProductMeSoldScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.green.withOpacity(0.1),
                    icon: const Icon(
                      Icons.outbox,
                      color: Colors.white,
                    ),
                    color: Colors.green,
                    content: Column(
                      children: [
                        const TextPro('Item sold'),
                        const SizedBox(height: 8),
                        Consumer(
                          builder: (context, ref, child) {
                            final viewModel = ref.watch(profileViewModel);
                            final products = viewModel.soldProducts;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextPro(
                                products.length.toString(),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _personalInfo(),
          _signOutButton(),
        ],
      ),
    );
  }

  Widget _signOutButton() {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          child: ElevatedButtonPro(
            onPressed: () async {
              final viewModel = ref.read(profileViewModel);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const TextPro(
                      'Logout?',
                      textAlign: TextAlign.center,
                    ),
                    content: DottedBorder(
                      borderType: BorderType.RRect,
                      color: Colors.grey.shade300,
                      padding: const EdgeInsets.all(8),
                      dashPattern: const [6, 12],
                      radius: const Radius.circular(14),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey.shade100,
                        ),
                        child: Opacity(
                          opacity: 0.3,
                          child: Lottie.asset(
                            'asset/lottie/sign_out.json',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    actions: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const TextPro('No'),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          final result = await viewModel.signOut();
                          if (result && mounted) {
                            Navigator.pushReplacement(
                              context,
                              ScreenRoute(
                                screen: const SignInScreen(),
                              ),
                            );

                            ref.read(homeViewModel).setSelectedIndex(0);
                          }
                        },
                        child: const TextPro('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Sign Out'),
          ),
        );
      },
    );
  }

  Widget _personalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextPro(
            'Personal Information',
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextPro(
                      'Name:',
                      color: Colors.black54,
                    ),
                    TextPro(
                      widget.user.name,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextPro(
                      'Email:',
                      color: Colors.black54,
                    ),
                    TextPro(
                      widget.user.email,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextPro(
                      'Phone:',
                      color: Colors.black54,
                    ),
                    TextPro(
                      widget.user.phone,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
