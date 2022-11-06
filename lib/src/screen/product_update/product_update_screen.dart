import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/screen/product_create/widget/resource_button.dart';
import 'package:codyo/src/screen/product_me/product_me_screen.dart';
import 'package:codyo/src/screen/product_update/widget/edit_image_button.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/screen_route.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_update_view_model.dart';
import 'package:codyo/src/widget/elevated_button_pro.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class ProductUpdateScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductUpdateScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductUpdateScreen> createState() {
    return _ProductUpdateScreenState();
  }
}

class _ProductUpdateScreenState extends ConsumerState<ProductUpdateScreen> {
  late final Product _product;
  final _imagePicker = ImagePicker();
  final _price = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();

  Future<void> _initial() async {
    final viewModel = ref.read(productUpdateViewModel);
    _product = widget.product;

    _price.text = _product.price.toString();
    _title.text = _product.title;
    _description.text = _product.description;

    Future(() async {
      viewModel.setXFile(null);
    });
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  void dispose() {
    super.dispose();
    _price.dispose();
    _title.dispose();
    _description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        title: const TextPro('Edit Item'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _imagePreview(),
          const SizedBox(height: 16),
          _buildForms(),
          const SizedBox(height: 16),
          ElevatedButtonPro(
            onPressed: _confirmEditProduct,
            child: const Text('Save'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _imagePreview() {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(productUpdateViewModel);

        if (viewModel.xFile != null) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(viewModel.xFile!.path),
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: EditImageButton(
                    onPressed: _showAlertDialog,
                  ),
                ),
              ),
            ],
          );
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: _product.imageUrl,
                width: MediaQuery.of(context).size.width,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: EditImageButton(
                  onPressed: _showAlertDialog,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startCamera(BuildContext context) async {
    final result = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 500,
      maxWidth: 500,
    );

    if (result != null && mounted) {
      ref.read(productUpdateViewModel).setXFile(result);
      Navigator.pop(context);
    }
  }

  void _startGallery(BuildContext context) async {
    final result = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
    );

    if (result != null && mounted) {
      ref.read(productUpdateViewModel).setXFile(result);
      Navigator.pop(context);
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ResourceButton(
                onPressed: () => _startCamera(context),
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                title: 'Camera',
              ),
              const SizedBox(height: 16),
              ResourceButton(
                onPressed: () => _startGallery(context),
                icon: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                title: 'Gallery',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForms() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextPro(
                  'Price',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    prefixText: 'Rp ',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextPro(
                  'Title',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _title,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: 'Write title here...',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextPro(
                  'Description',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(height: 1.3),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: 'Write description here...',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmEditProduct() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Update This Item ?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Consumer(
            builder: (context, ref, child) {
              final viewModelWatcher = ref.watch(productUpdateViewModel);

              switch (viewModelWatcher.stateAction) {
                case StateAction.idle:
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Opacity(
                      opacity: 0.5,
                      child: Lottie.asset(
                        'asset/lottie/edit.json',
                        height: 100,
                      ),
                    ),
                  );
                case StateAction.loading:
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Opacity(
                      opacity: 0.5,
                      child: Lottie.asset(
                        'asset/lottie/edit_v2.json',
                        height: 100,
                      ),
                    ),
                  );
                case StateAction.error:
                  return const SizedBox.shrink();
              }
            },
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const TextPro('No'),
            ),
            Consumer(
              builder: (context, ref, child) {
                final viewModelWatcher = ref.watch(productUpdateViewModel);
                final button = TextButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    _product.price = int.parse(_price.text);
                    _product.title = _title.text;
                    _product.description = _description.text;
                    await viewModelWatcher.updateProduct(_product);
                    Util.showToastSuccess('Product is Edited');
                    if (mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        ScreenRoute(
                          screen: const ProductMeScreen(),
                        ),
                      );
                    }
                  },
                  child: const TextPro('Yes'),
                );

                switch (viewModelWatcher.stateAction) {
                  case StateAction.idle:
                    return button;
                  case StateAction.loading:
                    return Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    );
                  case StateAction.error:
                    return button;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
