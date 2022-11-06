import 'dart:io';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/screen/product_create/widget/resource_button.dart';
import 'package:codyo/src/screen/product_create/widget/upload_loading.dart';
import 'package:codyo/src/util/finite_state.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/home_view_model.dart';
import 'package:codyo/src/view_model/product_create_view_model.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'choose_image_resource.dart';

class CreateStructure extends ConsumerStatefulWidget {
  final Position position;
  const CreateStructure({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  ConsumerState<CreateStructure> createState() {
    return _CreateStructureState();
  }
}

class _CreateStructureState extends ConsumerState<CreateStructure> {
  late final Position _position;
  final _formKey = GlobalKey<FormState>();
  final _price = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _imagePicker = ImagePicker();

  Future<void> _initial() async {
    final viewModel = ref.read(productCreateViewModel);
    _position = widget.position;
    _price.text = viewModel.price == 0 ? '' : viewModel.price.toString();
    _title.text = viewModel.title;
    _description.text = viewModel.description;
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          _previewImage(),
          const SizedBox(height: 16),
          _forms(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveAction,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.publish),
                SizedBox(width: 16),
                Text('Publish'),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _saveAction() async {
    final viewModel = ref.read(productCreateViewModel);
    if (viewModel.xFile == null) {
      Util.showToastError('Please choose image first');
      return;
    }

    if (_price.text.isEmpty) {
      Util.showToastError('Please input price');
      return;
    }

    if (_title.text.isEmpty) {
      Util.showToastError('Please input title');
      return;
    }

    if (_description.text.isEmpty) {
      Util.showToastError('Please input description');
      return;
    }
    _confirmPublishProduct();
  }

  void _confirmPublishProduct() {
    final viewModel = ref.read(productCreateViewModel);
    final viewModelHome = ref.read(homeViewModel);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Publish This ?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final viewModelWatcher = ref.watch(productCreateViewModel);

                  if (viewModelWatcher.xFile == null) {
                    return const SizedBox.shrink();
                  }

                  final productPreview = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(viewModel.xFile!.path),
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextPro(
                                viewModel.title,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                viewModel.description,
                                style: const TextStyle(height: 1.3),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              TextPro(
                                Util.currencyFormatter(viewModel.price),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  switch (viewModelWatcher.stateAction) {
                    case StateAction.idle:
                      return productPreview;
                    case StateAction.loading:
                      return const UploadLoading();
                    case StateAction.error:
                      return productPreview;
                  }
                },
              )
            ],
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
                final viewModelWatcher = ref.watch(productCreateViewModel);
                final button = TextButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final product = Product(
                      title: _title.text,
                      description: _description.text,
                      price: int.parse(_price.text),
                      latitude: _position.latitude,
                      longitude: _position.longitude,
                    );

                    await viewModel.createProduct(product);

                    Util.showToastSuccess('Product is published');
                    viewModel.setXFile(null);
                    viewModel.setPrice(0);
                    viewModel.setTitle('');
                    viewModel.setDescription('');
                    viewModelHome.setSelectedIndex(0);
                    if (mounted) {
                      Navigator.pop(context);
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

  Widget _forms() {
    return Form(
      key: _formKey,
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
                  fontWeight: FontWeight.w300,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    ref.read(productCreateViewModel).setPrice(int.parse(value));
                  },
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
                  fontWeight: FontWeight.w300,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: (value) {
                    ref.read(productCreateViewModel).setTitle(value);
                  },
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
                  fontWeight: FontWeight.w300,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(height: 1.3),
                  onChanged: (value) {
                    ref.read(productCreateViewModel).setDescription(value);
                  },
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

  Widget _previewImage() {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(productCreateViewModel);
        if (viewModel.xFile != null) {
          return DottedBorder(
            dashPattern: const [6, 12],
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade400,
            borderType: BorderType.RRect,
            radius: const Radius.circular(14),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(viewModel.xFile!.path),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey.shade200.withOpacity(0.5),
                      onTap: _showAlertDialog,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return ChooseImageResource(
            onPressed: _showAlertDialog,
          );
        }
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
      ref.read(productCreateViewModel).setXFile(result);
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
      ref.read(productCreateViewModel).setXFile(result);
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
}
