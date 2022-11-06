import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:codyo/src/model/product_model.dart';
import 'package:codyo/src/model/user_model.dart';
import 'package:codyo/src/util/util.dart';
import 'package:codyo/src/view_model/product_detail_view_model.dart';
import 'package:codyo/src/widget/text_pro.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' show Lottie, LottieBuilder;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() {
    return _ProductDetailScreenState();
  }
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late Product product;

  Future<void> _initial() async {
    product = widget.product;

    Future(() async {
      final viewModel = ref.read(productDetailViewModel);
      viewModel.getUserById(product.userId);
    });
  }

  @override
  void initState() {
    super.initState();
    _initial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Lottie.asset('asset/lottie/back_v2.json'),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        title: const Text('Product Detail'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _showImage(),
            const SizedBox(height: 16),
            _showPrice(),
            const SizedBox(height: 16),
            _showTextContent(),
            const SizedBox(height: 16),
            _showOwner(),
            const SizedBox(height: 16),
            _showMap(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.watch(productDetailViewModel);
            if (viewModel.user == null) return const SizedBox.shrink();
            final user = viewModel.user!;
            final whatsAppButton = ElevatedButton(
              onPressed: () => _callWhatsApp(user),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16 * 2,
                ),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.whatsapp),
                  SizedBox(width: 4),
                  TextPro('Whatsapp'),
                ],
              ),
            );

            final callButton = ElevatedButton(
              onPressed: () => _callPhone(user),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16 * 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.call),
                  SizedBox(width: 8),
                  TextPro('Call'),
                ],
              ),
            );

            if (viewModel.user != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  callButton,
                  const SizedBox(width: 8),
                  Expanded(child: whatsAppButton),
                ],
              );
            }

            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: whatsAppButton,
            );
          },
        ),
      ),
    );
  }

  Widget _showImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            width: MediaQuery.of(context).size.width,
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {},
                child: Transform.scale(
                  scale: 1.3,
                  child: Lottie.asset('asset/lottie/favorite_v1.json'),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _showPrice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextPro(
            'Price',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black54,
          ),
          const Divider(),
          TextPro(
            Util.currencyFormatter(product.price),
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _showTextContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextPro(
            product.title,
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black54,
          ),
          const Divider(),
          const TextPro(
            'Description',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.black54,
          ),
          const SizedBox(height: 4),
          TextPro(
            product.description,
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
          const Divider(),
          const TextPro(
            'Published At',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.black54,
          ),
          TextPro(
            Util.dateFormatterFull(product.createdAt),
            fontWeight: FontWeight.w300,
            height: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _showOwner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(productDetailViewModel);
          if (viewModel.user == null) return const SizedBox.shrink();
          final user = viewModel.user!;
          return Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: user.avatarUrl,
                  width: 50,
                  height: 50,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextPro(
                    'Seller',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  TextPro(
                    user.name,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 4),
                  TextPro(
                    'Join Date ${Util.dateFormatter(user.createdAt)}',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _showMap() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TextPro(
            'Item Posted At',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.black54,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(product.latitude, product.longitude),
                  zoom: 17,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(
                      product.id.toString(),
                    ),
                    position: LatLng(
                      product.latitude,
                      product.longitude,
                    ),
                    infoWindow: InfoWindow(
                      title: product.title,
                    ),
                  ),
                },
                circles: {
                  Circle(
                    circleId: CircleId(
                      product.id.toString(),
                    ),
                    center: LatLng(
                      product.latitude,
                      product.longitude,
                    ),
                    fillColor: Colors.blue.shade200.withOpacity(0.3),
                    radius: 100,
                    strokeWidth: 1,
                    strokeColor: Colors.blue.shade500,
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callWhatsApp(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const TextPro(
            'Continue with Whatsapp?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: DottedBorder(
            color: Colors.grey.shade300,
            radius: const Radius.circular(14),
            borderType: BorderType.RRect,
            padding: const EdgeInsets.all(8),
            dashPattern: const [6, 12],
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Transform.scale(
                scale: 1.2,
                child: Lottie.asset('asset/lottie/chat_v1.json'),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                const countryCode = '+62';
                final phone = countryCode + user.phone.substring(0);
                final whatsAppUrl =
                    'whatsapp://send?phone=$phone&text=Saya minat ${product.title} nya.';
                launchUrl(Uri.parse(whatsAppUrl));
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _callPhone(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const TextPro(
            'Call This Phone Number?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(14),
            dashPattern: const [6, 12],
            color: Colors.grey.shade300,
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: LottieBuilder.asset('asset/lottie/call.json'),
            ),
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                const countryCode = '+62';
                final callUrl = 'tel:$countryCode${user.phone.substring(1)}';
                launchUrl(Uri.parse(callUrl));
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
