// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports (relative)
import '../controllers/user_dashboard_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/category_section.dart';
import 'widgets/deal_cards_section.dart';
import 'widgets/expiry_banner_section.dart';
import 'widgets/home_appbar.dart';
import 'widgets/hot_deals_section.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const HomeAppBar(),
          CategorySection(categories: controller.categories),
          SliverToBoxAdapter(
            child: Image.asset(AppImages.promoBanner, fit: BoxFit.fitWidth),
          ),

          DealCardsSection(deals: controller.deals),
          const SliverToBoxAdapter(child: AppSpacers.h24),
          const ExpiryBannerSection(),
          const HotDealsSection(),
          const HotDealsSection(),
          const HotDealsSection(),
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(),
      // Temporary test button to add items to cart
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addDemoItemToCart,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_shopping_cart, color: AppColors.white),
      ),
    );
  }
}
