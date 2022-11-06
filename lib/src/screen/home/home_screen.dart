import 'package:codyo/src/screen/product_create/product_create_screen.dart';
import 'package:codyo/src/screen/product_favorite/product_favorite_screen.dart';
import 'package:codyo/src/screen/product_list/product_list_screen.dart';
import 'package:codyo/src/screen/profile/profile_screen.dart';
import 'package:codyo/src/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final screens = const [
    ProductListScreen(),
    ProductCreateScreen(),
    ProductFavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(homeViewModel);
          return screens[viewModel.selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(homeViewModel).selectedIndex,
        onTap: (value) {
          final viewModel = ref.read(homeViewModel);
          viewModel.setSelectedIndex(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
