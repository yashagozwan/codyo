import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/screen/home/home_screen.dart';
import 'package:codyo/src/screen/profile_update/widget/button_resource.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/view_model/home_view_model.dart';
import 'package:codyo/src/view_model/profile_update_view_model.dart';
import 'package:codyo/src/widget/elevated_button_pro.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends ConsumerStatefulWidget {
  final User user;
  const ProfileUpdateScreen({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ProfileUpdateScreen> createState() {
    return _ProfileUpdateScreenState();
  }
}

class _ProfileUpdateScreenState extends ConsumerState<ProfileUpdateScreen> {
  late User user;
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _imagePicker = ImagePicker();

  Future<void> _initial() async {
    user = widget.user;
    _name.text = user.name;
    _phone.text = user.phone;
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        titleTextStyle: const TextStyle(color: Colors.black54),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(profileUpdateViewModel).setXFile(null);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const TextPro('Update Profile'),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 18),
              Center(
                child: Stack(
                  children: [
                    _imagePreview(),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _showChooseResource,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final viewModel = ref.watch(profileUpdateViewModel);
                  final button = ElevatedButtonPro(
                    onPressed: () async {
                      user.name = _name.text;
                      user.phone = _phone.text;

                      final result = await ref
                          .read(profileUpdateViewModel)
                          .updateUser(user);

                      if (result && mounted) {
                        Navigator.pop(context);
                        ref.read(homeViewModel).setSelectedIndex(3);
                        Navigator.pushReplacement(
                          context,
                          ScreenRoute(
                            screen: const HomeScreen(),
                          ),
                        );

                        ref.read(profileUpdateViewModel).setXFile(null);
                      }
                    },
                    child: const TextPro('Save'),
                  );

                  switch (viewModel.stateAction) {
                    case StateAction.idle:
                      return button;
                    case StateAction.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case StateAction.error:
                      return button;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePreview() {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(profileUpdateViewModel);
        if (viewModel.xFile != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(130 / 2),
            child: Image.file(
              File(viewModel.xFile!.path),
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.circular(130 / 2),
            child: CachedNetworkImage(
              imageUrl: user.avatarUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  void _startFromGallery(BuildContext context) async {
    final result = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (result != null && mounted) {
      ref.read(profileUpdateViewModel).setXFile(result);
      Navigator.pop(context);
    }
  }

  void _startFromCamera(BuildContext context) async {
    final result = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (result != null && mounted) {
      ref.read(profileUpdateViewModel).setXFile(result);
      Navigator.pop(context);
    }
  }

  void _showChooseResource() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const TextPro(
            'Resource ?',
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ButtonResource(
                  onPressed: () => _startFromCamera(context),
                  backgroundColor: Colors.blue.shade100,
                  borderColor: Colors.blue.shade500,
                  text: const TextPro(
                    'Camera',
                    color: Colors.blue,
                  ),
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                  ),
                  splashColor: Colors.blue.shade700.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ButtonResource(
                  onPressed: () => _startFromGallery(context),
                  backgroundColor: Colors.green.shade100,
                  borderColor: Colors.green.shade500,
                  text: const TextPro(
                    'Gallery',
                    color: Colors.green,
                  ),
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                  ),
                  splashColor: Colors.green.shade700.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
